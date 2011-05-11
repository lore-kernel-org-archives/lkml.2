Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab1EKQJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:09:58 -0400
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:59677 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab1EKQJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:09:55 -0400
X-Greylist: delayed 1112 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 12:09:55 EDT
Message-ID: <4DCAB351.4010204@tu-ilmenau.de>
Date: Wed, 11 May 2011 18:03:29 +0200
From: =?ISO-8859-1?Q?Stephan_B=E4rwolf?= <stephan.baerwolf@tu-ilmenau.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Nikhil Rao <ncrao@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sched: fix/optimise calculation of weight-inverse
Content-Type: multipart/mixed;
 boundary="------------070502010901000108070606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070502010901000108070606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

If the inverse loadweight should be zero, function "calc_delta_mine"
calculates the inverse of "lw->weight" (in 32bit integer ops).

This calculation is actually a little bit impure (because it is
inverting something around "lw-weight"+1), especially when
"lw->weight" becomes smaller. (This could explain some aritmetical
issues for small shares...)

The correct inverse would be 1/lw->weight multiplied by
"WMULT_CONST" for fixcomma-scaling it into integers.
(So WMULT_CONST/lw->weight ...)

For safety it is also important to check if division by zero
could happen...

The old, impure algorithm took two divisions for inverting lw->weight,
the new, more exact one only takes one and an additional unlikely-if.

Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
---
 kernel/sched.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 312f8b9..bb55996 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1307,15 +1307,21 @@ calc_delta_mine(unsigned long delta_exec,
unsigned long weight,
 {
     u64 tmp;
 
+    tmp = (u64)delta_exec * weight;
+
+    // actually we would have to trap - division by zero - but we stay
and pretend the limit of the operation...
+    if (unlikely(lw->weight == 0)) {
+        if (unlikely(tmp == ((u64)0))) return (unsigned long)0;
+        else return (unsigned long)LONG_MAX;
+    }
+
     if (!lw->inv_weight) {
         if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
             lw->inv_weight = 1;
         else
-            lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
-                / (lw->weight+1);
+            lw->inv_weight = WMULT_CONST / lw->weight;
     }
 
-    tmp = (u64)delta_exec * weight;
     /*
      * Check whether we'd overflow the 64-bit multiplication:
      */
-- 
1.7.3.4



--
Dipl.-Inf. Stephan Bärwolf
Ilmenau University of Technology, Integrated Communication Systems Group
Phone: +49 (0)3677 69 2821,  FAX: +49 (0)3677 69 1614
Email: stephan.baerwolf@tu-ilmenau.de,
Web: http://www.tu-ilmenau.de/iks



--------------070502010901000108070606
Content-Type: text/plain;
 name="0001-sched-fix-optimise-calculation-of-weight-inverse.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-sched-fix-optimise-calculation-of-weight-inverse.patch"

>From 46d3b89632aee75643b2ef9ea9ccd3085c631211 Mon Sep 17 00:00:00 2001
From: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
Date: Wed, 11 May 2011 17:36:26 +0200
Subject: [PATCH] sched: fix/optimise calculation of weight-inverse

If the inverse loadweight should be zero, function "calc_delta_mine"
calculates the inverse of "lw->weight" (in 32bit integer ops).

This calculation is actually a little bit impure (because it is
inverting something around "lw-weight"+1), especially when
"lw->weight" becomes smaller. (This could explain some aritmetical
issues for small shares...)

The correct inverse would be 1/lw->weight multiplied by
"WMULT_CONST" for fixcomma-scaling it into integers.
(So WMULT_CONST/lw->weight ...)

For safety it is also important to check if division by zero
could happen...

The old, impure algorithm took two divisions for inverting lw->weight,
the new, more exact one only takes one and an additional unlikely-if.

Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
---
 kernel/sched.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 312f8b9..bb55996 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1307,15 +1307,21 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 {
 	u64 tmp;
 
+	tmp = (u64)delta_exec * weight;
+
+	// actually we would have to trap - division by zero - but we stay and pretend the limit of the operation...
+	if (unlikely(lw->weight == 0)) {
+		if (unlikely(tmp == ((u64)0))) return (unsigned long)0;
+		else return (unsigned long)LONG_MAX;
+	}
+
 	if (!lw->inv_weight) {
 		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
 			lw->inv_weight = 1;
 		else
-			lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
-				/ (lw->weight+1);
+			lw->inv_weight = WMULT_CONST / lw->weight;
 	}
 
-	tmp = (u64)delta_exec * weight;
 	/*
 	 * Check whether we'd overflow the 64-bit multiplication:
 	 */
-- 
1.7.3.4


--------------070502010901000108070606--
