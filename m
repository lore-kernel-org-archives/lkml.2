Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab0HXXGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:06:01 -0400
Received: from kroah.org ([198.145.64.141]:32918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933754Ab0HXXDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:55 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:11 2010
Message-Id: <20100824224511.131172570@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [113/114] mutex: Improve the scalability of optimistic spinning
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tim Chen <tim.c.chen@linux.intel.com>

commit 9d0f4dcc5c4d1c5dd01172172684a45b5f49d740 upstream.

There is a scalability issue for current implementation of optimistic
mutex spin in the kernel.  It is found on a 8 node 64 core Nehalem-EX
system (HT mode).

The intention of the optimistic mutex spin is to busy wait and spin on a
mutex if the owner of the mutex is running, in the hope that the mutex
will be released soon and be acquired, without the thread trying to
acquire mutex going to sleep. However, when we have a large number of
threads, contending for the mutex, we could have the mutex grabbed by
other thread, and then another ……, and we will keep spinning, wasting cpu
cycles and adding to the contention.  One possible fix is to quit
spinning and put the current thread on wait-list if mutex lock switch to
a new owner while we spin, indicating heavy contention (see the patch
included).

I did some testing on a 8 socket Nehalem-EX system with a total of 64
cores. Using Ingo's test-mutex program that creates/delete files with 256
threads (http://lkml.org/lkml/2006/1/8/50) , I see the following speed up
after putting in the mutex spin fix:

 ./mutex-test V 256 10
                 Ops/sec
 2.6.34          62864
 With fix        197200

Repeating the test with Aim7 fserver workload, again there is a speed up
with the fix:

                 Jobs/min
 2.6.34          91657
 With fix        149325

To look at the impact on the distribution of mutex acquisition time, I
collected the mutex acquisition time on Aim7 fserver workload with some
instrumentation.  The average acquisition time is reduced by 48% and
number of contentions reduced by 32%.

                 #contentions    Time to acquire mutex (cycles)
 2.6.34          72973           44765791
 With fix        49210           23067129

The histogram of mutex acquisition time is listed below.  The acquisition
time is in 2^bin cycles.  We see that without the fix, the acquisition
time is mostly around 2^26 cycles.  With the fix, we the distribution get
spread out a lot more towards the lower cycles, starting from 2^13.
However, there is an increase of the tail distribution with the fix at
2^28 and 2^29 cycles.  It seems a small price to pay for the reduced
average acquisition time and also getting the cpu to do useful work.

 Mutex acquisition time distribution (acq time = 2^bin cycles):
         2.6.34                  With Fix
 bin     #occurrence     %       #occurrence     %
 11      2               0.00%   120             0.24%
 12      10              0.01%   790             1.61%
 13      14              0.02%   2058            4.18%
 14      86              0.12%   3378            6.86%
 15      393             0.54%   4831            9.82%
 16      710             0.97%   4893            9.94%
 17      815             1.12%   4667            9.48%
 18      790             1.08%   5147            10.46%
 19      580             0.80%   6250            12.70%
 20      429             0.59%   6870            13.96%
 21      311             0.43%   1809            3.68%
 22      255             0.35%   2305            4.68%
 23      317             0.44%   916             1.86%
 24      610             0.84%   233             0.47%
 25      3128            4.29%   95              0.19%
 26      63902           87.69%  122             0.25%
 27      619             0.85%   286             0.58%
 28      0               0.00%   3536            7.19%
 29      0               0.00%   903             1.83%
 30      0               0.00%   0               0.00%

I've done similar experiments with 2.6.35 kernel on smaller boxes as
well.  One is on a dual-socket Westmere box (12 cores total, with HT).
Another experiment is on an old dual-socket Core 2 box (4 cores total, no
HT)

On the 12-core Westmere box, I see a 250% increase for Ingo's mutex-test
program with my mutex patch but no significant difference in aim7's
fserver workload.

On the 4-core Core 2 box, I see the difference with the patch for both
mutex-test and aim7 fserver are negligible.

So far, it seems like the patch has not caused regression on smaller
systems.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1282168827.9542.72.camel@schen9-DESK>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3694,8 +3694,16 @@ int mutex_spin_on_owner(struct mutex *lo
 		/*
 		 * Owner changed, break to re-assess state.
 		 */
-		if (lock->owner != owner)
+		if (lock->owner != owner) {
+			/*
+			 * If the lock has switched to a different owner,
+			 * we likely have heavy contention. Return 0 to quit
+			 * optimistic spinning and not contend further:
+			 */
+			if (lock->owner)
+				return 0;
 			break;
+		}
 
 		/*
 		 * Is that owner really running on that cpu?


