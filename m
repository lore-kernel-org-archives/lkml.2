Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab2GZVaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:30:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62132 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2GZVaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:30:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Aaditya Kumar <aaditya.kumar@ap.sony.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [ 03/40] mm: fix lost kswapd wakeup in kswapd_stop()
Date: Thu, 26 Jul 2012 14:29:21 -0700
Message-Id: <20120726211411.338731174@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211411.164006056@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2695,7 +2695,10 @@ static void kswapd_try_to_sleep(pg_data_
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


