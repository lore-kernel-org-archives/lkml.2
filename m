Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab2BMLD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 06:03:59 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47510 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2BMLD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 06:03:58 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] percpu: use raw_local_irq_* in _this_cpu op
Date: Mon, 13 Feb 2012 19:03:38 +0800
Message-Id: <1329131018-19107-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make sense to trace irq off or do irq flags
lock proving inside 'this_cpu' operations, so replace local_irq_*
with raw_local_irq_* in 'this_cpu' op.

Also the patch fixes one lockdep warning[1], which is caused
by the added local_irq_save/restore(flags) in this_cpu_inc
called by __debug_atomic_inc: kernel/lockdep.c

[1],
[    0.162841] ------------[ cut here ]------------
[    0.167694] WARNING: at kernel/lockdep.c:3493 check_flags+0xc0/0x1d0()
[    0.174468] Modules linked in:
[    0.177703] Backtrace:
[    0.180328] [<c00171f0>] (dump_backtrace+0x0/0x110) from [<c0412320>] (dump_stack+0x18/0x1c)
[    0.189086]  r6:c051f778 r5:00000da5 r4:00000000 r3:60000093
[    0.195007] [<c0412308>] (dump_stack+0x0/0x1c) from [<c00410e8>] (warn_slowpath_common+0x54/0x6c)
[    0.204223] [<c0041094>] (warn_slowpath_common+0x0/0x6c) from [<c0041124>] (warn_slowpath_null+0x24/0x2c)
[    0.214111]  r8:00000000 r7:00000000 r6:ee069598 r5:60000013 r4:ee082000
[    0.220825] r3:00000009
[    0.223693] [<c0041100>] (warn_slowpath_null+0x0/0x2c) from [<c0088f38>] (check_flags+0xc0/0x1d0)
[    0.232910] [<c0088e78>] (check_flags+0x0/0x1d0) from [<c008d348>] (lock_acquire+0x4c/0x11c)
[    0.241668] [<c008d2fc>] (lock_acquire+0x0/0x11c) from [<c0415aa4>] (_raw_spin_lock+0x3c/0x74)
[    0.250610] [<c0415a68>] (_raw_spin_lock+0x0/0x74) from [<c010a844>] (set_task_comm+0x20/0xc0)
[    0.259521]  r6:ee069588 r5:ee0691c0 r4:ee082000
[    0.264404] [<c010a824>] (set_task_comm+0x0/0xc0) from [<c0060780>] (kthreadd+0x28/0x108)
[    0.272857]  r8:00000000 r7:00000013 r6:c0044a08 r5:ee0691c0 r4:ee082000
[    0.279571] r3:ee083fe0
[    0.282470] [<c0060758>] (kthreadd+0x0/0x108) from [<c0044a08>] (do_exit+0x0/0x6dc)
[    0.290405]  r5:c0060758 r4:00000000
[    0.294189] ---[ end trace 1b75b31a2719ed1c ]---
[    0.299041] possible reason: unannotated irqs-on.
[    0.303955] irq event stamp: 5
[    0.307159] hardirqs last  enabled at (4): [<c001331c>] no_work_pending+0x8/0x2c
[    0.314880] hardirqs last disabled at (5): [<c0089b08>] trace_hardirqs_on_caller+0x60/0x26c
[    0.323547] softirqs last  enabled at (0): [<c003f754>] copy_process+0x33c/0xef4
[    0.331207] softirqs last disabled at (0): [<  (null)>]   (null)
[    0.337585] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 include/linux/percpu.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 6e68d05..5ed1e38 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -294,9 +294,9 @@ do {									\
 #define _this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
 	unsigned long flags;						\
-	local_irq_save(flags);						\
+	raw_local_irq_save(flags);						\
 	*__this_cpu_ptr(&(pcp)) op val;					\
-	local_irq_restore(flags);					\
+	raw_local_irq_restore(flags);					\
 } while (0)
 
 #ifndef this_cpu_write
@@ -395,10 +395,10 @@ do {									\
 ({									\
 	typeof(pcp) ret__;						\
 	unsigned long flags;						\
-	local_irq_save(flags);						\
+	raw_local_irq_save(flags);						\
 	__this_cpu_add(pcp, val);					\
 	ret__ = __this_cpu_read(pcp);					\
-	local_irq_restore(flags);					\
+	raw_local_irq_restore(flags);					\
 	ret__;								\
 })
 
@@ -425,10 +425,10 @@ do {									\
 #define _this_cpu_generic_xchg(pcp, nval)				\
 ({	typeof(pcp) ret__;						\
 	unsigned long flags;						\
-	local_irq_save(flags);						\
+	raw_local_irq_save(flags);						\
 	ret__ = __this_cpu_read(pcp);					\
 	__this_cpu_write(pcp, nval);					\
-	local_irq_restore(flags);					\
+	raw_local_irq_restore(flags);					\
 	ret__;								\
 })
 
@@ -453,11 +453,11 @@ do {									\
 ({									\
 	typeof(pcp) ret__;						\
 	unsigned long flags;						\
-	local_irq_save(flags);						\
+	raw_local_irq_save(flags);						\
 	ret__ = __this_cpu_read(pcp);					\
 	if (ret__ == (oval))						\
 		__this_cpu_write(pcp, nval);				\
-	local_irq_restore(flags);					\
+	raw_local_irq_restore(flags);					\
 	ret__;								\
 })
 
@@ -490,10 +490,10 @@ do {									\
 ({									\
 	int ret__;							\
 	unsigned long flags;						\
-	local_irq_save(flags);						\
+	raw_local_irq_save(flags);						\
 	ret__ = __this_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
 			oval1, oval2, nval1, nval2);			\
-	local_irq_restore(flags);					\
+	raw_local_irq_restore(flags);					\
 	ret__;								\
 })
 
-- 
1.7.9

