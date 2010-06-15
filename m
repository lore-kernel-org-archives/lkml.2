Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab0FOTuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:50:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:61492 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0FOTuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:50:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,422,1272870000"; 
   d="scan'208";a="808274736"
Subject: [PATCH  1/1] mutex: prevent optimistic spinning from spinning
 longer than neccessary
From: Tim Chen <tim.c.chen@linux.intel.com>
To: peterz@infradead.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 12:46:32 -0700
Message-ID: <1276631192.2385.244.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
There is a scalability issue for current implementation of optimistic
mutex spin in the kernel.  It is found on a 8 node 64 core Nehalem-EX
system (HT mode).

The intention of the optimistic mutex spin is to busy wait and spin on a 
mutex if the owner of the mutex is running, in the hope that the mutex will 
get released soon and can then be acquired without going to sleep.  However, 
when we have a large number of threads, contending for the mutex, we could 
have the mutex grabbed by other thread, and then another ……, and we will still 
be spinning, wasting cpu cycles and adding to the contention.  One
possible fix is to quit spinning and put the current thread on wait-list
if mutex lock switch to a new owner while we spin, indicating heavy
contention (see the patch included).   

I did some testing on a 8 node Nehalem-EX system with a total of 64
cores. Using Ingo's test-mutex program that creates/delete files with
256 threads (http://lkml.org/lkml/2006/1/8/50) , I see the following
speed up after putting in the mutex spin fix:

./mutex-test V 256 10
		Ops/sec
2.6.34		62864
With fix	197200

Repeating the test with Aim7 fserver workload, again there is a speed up
with the fix:

		Jobs/min
2.6.34 		91657
With fix 	149325

To look at the impact on the distribution of mutex acquisition time, I
collected the mutex acquisition time on Aim7 fserver workload with some
instrumentation.  The average acquisition time is reduced by 48% and
number of contentions reduced by 32%.

		#contentions	Time to acquire mutex (cycles)
2.6.34		72973		44765791
With fix	49210		23067129 

The histogram of mutex acquisition time is listed below.  The
acquisition time is in 2^bin cycles.  We see that without the fix, the
acquisition time is mostly around 2^26 cycles.  With the fix, we the
distribution get spread out a lot more towards the lower cycles,
starting from 2^13.  However, there is an increase of the tail
distribution with the fix at 2^28 and 2^29 cycles.  I think it is a
small price to pay for the reduced average acquisition time and also
getting the cpu to do useful work.

Mutex acquisition time distribution (acq time = 2^bin cycles):
	2.6.34			With Fix
bin     #occurrence     %       #occurrence     %
11      2       	0.00%   120     	0.24%
12      10      	0.01%   790     	1.61%
13      14      	0.02%   2058    	4.18%
14      86      	0.12%   3378    	6.86%
15      393     	0.54%   4831    	9.82%
16      710     	0.97%   4893    	9.94%
17      815     	1.12%   4667    	9.48%
18      790     	1.08%   5147    	10.46%
19      580     	0.80%   6250    	12.70%
20      429     	0.59%   6870    	13.96%
21      311     	0.43%   1809    	3.68%
22      255     	0.35%   2305    	4.68%
23      317     	0.44%   916     	1.86%
24      610     	0.84%   233     	0.47%
25      3128    	4.29%   95      	0.19%
26      63902   	87.69%  122     	0.25%
27      619     	0.85%   286     	0.58%
28      0       	0.00%   3536    	7.19%
29      0       	0.00%   903     	1.83%
30	0		0.00%	0		0.00%

Regards,
Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff -ur linux-2.6.34/kernel/sched.c linux-2.6.34-fix/kernel/sched.c
--- linux-2.6.34/kernel/sched.c	2010-05-16 14:17:36.000000000 -0700
+++ linux-2.6.34-fix/kernel/sched.c	2010-06-04 10:28:33.564777030 -0700
@@ -3815,8 +3815,11 @@
 		/*
 		 * Owner changed, break to re-assess state.
 		 */
-		if (lock->owner != owner)
+		if (lock->owner != owner) {
+			if (lock->owner)
+				return 0;
 			break;
+		}
 
 		/*
 		 * Is that owner really running on that cpu?


