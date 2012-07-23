Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2GWBn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54368 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753478Ab2GWBnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:22 -0400
Message-Id: <20120723010701.016123398@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Aaditya Kumar <aaditya.kumar.30@gmail.com>,
        Aaditya Kumar <aaditya.kumar@ap.sony.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [ 063/108] mm: fix lost kswapd wakeup in kswapd_stop()
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaditya Kumar <aaditya.kumar.30@gmail.com>

commit 1c7e7f6c0703d03af6bcd5ccc11fc15d23e5ecbe upstream.

Offlining memory may block forever, waiting for kswapd() to wake up
because kswapd() does not check the event kthread->should_stop before
sleeping.

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

  === offlining memory (waker) ===
   kswapd_stop()
      kthread_stop()
         kthread->should_stop = 1
         wake_up_process()
         wait_for_completion()

  ===  kswapd_try_to_sleep (sleeper) ===
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
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6615763..66e4310 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2688,7 +2688,10 @@ static void kswapd_try_to_sleep(pg_data_t *pgdat, int order, int classzone_idx)
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


