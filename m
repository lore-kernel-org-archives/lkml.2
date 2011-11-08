Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab1KHWXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:23:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:49050 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1KHWXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:23:51 -0500
Date: Tue, 8 Nov 2011 23:23:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.0.8-rt23
Message-ID: <alpine.LFD.2.02.1111082318130.2694@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.0.8-rt23 release.

Changes from 3.0.8-rt22 to 3.0.8-rt23

  * Cherrypick an ext4 fix which was not sent to stable

  * Add missing idle task comm update (Carsten)

Delta patch against 3.0.8-rt22

  https://tglx.de/~tglx/rt/incr/patch-3.0.8-rt22-rt23.patch.gz

also appended below.


Patch against 3.0.8 can be found here:

  https://tglx.de/~tglx/rt/patch-3.0.8-rt23.patch.gz


The split quilt queue is available at:

  https://tglx.de/~tglx/rt/patches-3.0.8-rt23.tar.gz

Enjoy,

	tglx

--------------->
Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c
+++ linux-2.6/fs/ext4/inode.c
@@ -190,9 +190,6 @@ void ext4_evict_inode(struct inode *inod
 
 	trace_ext4_evict_inode(inode);
 
-	mutex_lock(&inode->i_mutex);
-	ext4_flush_completed_IO(inode);
-	mutex_unlock(&inode->i_mutex);
 	ext4_ioend_wait(inode);
 
 	if (inode->i_nlink) {
Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
@@ -132,6 +132,8 @@ extern struct cred init_cred;
 # define INIT_TIMER_LIST
 #endif
 
+#define INIT_TASK_COMM "swapper"
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -168,7 +170,7 @@ extern struct cred init_cred;
 	.group_leader	= &tsk,						\
 	RCU_INIT_POINTER(.real_cred, &init_cred),			\
 	RCU_INIT_POINTER(.cred, &init_cred),				\
-	.comm		= "swapper",					\
+	.comm		= INIT_TASK_COMM,				\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
 	.files		= &init_files,					\
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/init_task.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -6109,6 +6110,9 @@ void __cpuinit init_idle(struct task_str
 	 */
 	idle->sched_class = &idle_sched_class;
 	ftrace_graph_init_idle_task(idle, cpu);
+#if defined(CONFIG_SMP)
+	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
+#endif
 }
 
 /*
Index: linux-2.6/localversion-rt
===================================================================
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt22
+-rt23
Index: linux-2.6/fs/ext4/ext4.h
===================================================================
--- linux-2.6.orig/fs/ext4/ext4.h
+++ linux-2.6/fs/ext4/ext4.h
@@ -175,6 +175,7 @@ struct mpage_da_data {
  */
 #define	EXT4_IO_END_UNWRITTEN	0x0001
 #define EXT4_IO_END_ERROR	0x0002
+#define EXT4_IO_END_QUEUED	0x0004
 
 struct ext4_io_page {
 	struct page	*p_page;
Index: linux-2.6/fs/ext4/page-io.c
===================================================================
--- linux-2.6.orig/fs/ext4/page-io.c
+++ linux-2.6/fs/ext4/page-io.c
@@ -142,7 +142,23 @@ static void ext4_end_io_work(struct work
 	unsigned long		flags;
 	int			ret;
 
-	mutex_lock(&inode->i_mutex);
+	if (!mutex_trylock(&inode->i_mutex)) {
+		/*
+		 * Requeue the work instead of waiting so that the work
+		 * items queued after this can be processed.
+		 */
+		queue_work(EXT4_SB(inode->i_sb)->dio_unwritten_wq, &io->work);
+		/*
+		 * To prevent the ext4-dio-unwritten thread from keeping
+		 * requeueing end_io requests and occupying cpu for too long,
+		 * yield the cpu if it sees an end_io request that has already
+		 * been requeued.
+		 */
+		if (io->flag & EXT4_IO_END_QUEUED)
+			yield();
+		io->flag |= EXT4_IO_END_QUEUED;
+		return;
+	}
 	ret = ext4_end_io_nolock(io);
 	if (ret < 0) {
 		mutex_unlock(&inode->i_mutex);
