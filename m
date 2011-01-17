Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1AQUZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 15:25:50 -0500
Received: from flmx07.ccur.com ([173.221.59.12]:7526 "EHLO flmx07.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab1AQUZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 15:25:49 -0500
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2011 15:25:49 EST
From: "Shaffer, Scott" <scott.shaffer@ccur.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "'mingo@elte.hu'" <mingo@elte.hu>
Date: Mon, 17 Jan 2011 15:20:21 -0500
Subject: [PATCH] fix bad delta time values in /proc/timer_list
Thread-Topic: [PATCH] fix bad delta time values in /proc/timer_list
Thread-Index: Acu2g/c6AKEa9YFOSXS7V3XiKwdSpA==
Message-ID: <653CEFD4210E904494F3E2FB9F6A479716464979C7@FLMX07.iccur.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

elapsed times printed from /proc/timer_list are incorrect for the
CLOCK_REALTIME timer list.

print_timer() is passed monotonic nsecs as current time, but should
be passed monotonic nsecs + hrtimer_clock_base.offset for the
timer list it is printing.

This patch fixes CLOCK_REALTIME timer lists, and does not break
CLOCK_MONOTONIC timer lists.


This shows a thread's timer that is <10ms:

xunil2.ccur.com # grep -A 9 "cpu: 1" /proc/timer_list
cpu: 1
 clock 0:
  .base:       f67031d0
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1294953310697580572 nsecs
active timers:
 #0: <f518ff3c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, pthread_sleep2/7067
 # expires at 1295021767185712301-1295021767185712301 nsecs [in 1294953310698070434 to 1294953310698070434 nsecs]


With the patch below, that thread's timer looks like:

 #0: <f37d7f3c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, pthread_sleep2/9403
 # expires at 1295022944770566772-1295022944770566772 nsecs [in 5305914 to 5305914 nsecs]


Signed-off-by: Scott Shaffer <scott.shaffer@ccur.com>

--- a/kernel/time/timer_list.c	2011-01-04 19:50:19.000000000 -0500
+++ b/kernel/time/timer_list.c	2011-01-14 14:09:03.000000000 -0500
@@ -102,7 +102,8 @@ next_one:
 		tmp = *timer;
 		raw_spin_unlock_irqrestore(&base->cpu_base->lock, flags);
 
-		print_timer(m, timer, &tmp, i, now);
+		print_timer(m, timer, &tmp, i,
+			(now + ktime_to_ns(base->offset)));
 		next++;
 		goto next_one;
 	}
