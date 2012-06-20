Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab2FTQXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:23:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46753 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2FTQXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:23:33 -0400
MIME-Version: 1.0
Date: Wed, 20 Jun 2012 21:53:31 +0530
Message-ID: <CAEtiSau6dRYVOSD4-QUWkYZ8p7z1ATLHZY9v871VS=o0LduU_Q@mail.gmail.com>
Subject: [PATCH] mm: offlining memory may block forever
From: Aaditya Kumar <aaditya.kumar.30@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, gregkh@linuxfoundation.org,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        tim.bird@am.sony.com, frank.rowand@am.sony.com,
        takuzo.ohara@ap.sony.com, kan.iibuchi@jp.sony.com,
        aaditya.kumar@ap.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offlining memory may block forever, waiting for kswapd() to wake up because
kswapd() does not check the event kthread->should_stop before sleeping.

The proper pattern, from Documentation/memory-barriers.txt, is:
   ---  waker  ---
   event_indicated = 1;
   wake_up_process(event_daemon);

   ---  sleeper  ---
   for (;;) {
      set_current_state(TASK_UNINTERRUPTIBLE);
      if (event_indicated)
         break;
      schedule();
   }

   set_current_state() may be wrapped by:
      prepare_to_wait();

In the kswapd() case, event_indicated is kthread->should_stop.
---  offlining memory (waker)  ---
   kswapd_stop()
      kthread_stop()
         kthread->should_stop = 1
         wake_up_process()
         wait_for_completion()


---  kswapd_try_to_sleep (sleeper)  ---
   kswapd_try_to_sleep()
      prepare_to_wait()
           .
           .
      schedule()
           .
           .
      finish_wait()

   The schedule() needs to be protected by a test of kthread->should_stop,
   which is wrapped by kthread_should_stop().

Reproducer:
   Do heavy file I/O in background.
   Do a memory offline/online in a tight loop


Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>

---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index eeb3bc9..b60691e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2688,7 +2688,10 @@ static void kswapd_try_to_sleep(pg_data_t
*pgdat, int order, int classzone_idx)
 		 * them before going back to sleep.
 		 */
 		set_pgdat_percpu_threshold(pgdat, calculate_normal_threshold);
-		schedule();
+
+		if (!kthread_should_stop())
+			schedule();
+
 		set_pgdat_percpu_threshold(pgdat, calculate_pressure_threshold);
 	} else {
 		if (remaining)
