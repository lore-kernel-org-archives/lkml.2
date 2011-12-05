Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1LELhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:37:13 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:40817 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab1LELhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:37:09 -0500
Date: Mon, 5 Dec 2011 12:36:27 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.2-rc5
Message-ID: <20111205123627.366bf0f8@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 11120511-3548-0000-0000-000000504D70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Carsten Otte (1):
      [S390] fix page change underindication in pgste_update_all

Holger Dengler (1):
      [S390] ap: Setup timer for sending messages after reset.

Martin Schwidefsky (3):
      [S390] ptrace inferior call interactions with TIF_SYSCALL
      [S390] add missing .set function for NT_S390_LAST_BREAK regset
      [S390] remove reset of system call restart on psw changes

Michael Holzheu (1):
      [S390] kdump: Replace is_kdump_kernel() with OLDMEM_BASE check

Sebastian Ott (4):
      [S390] hibernate: directly trigger subchannel evaluation
      [S390] cio: disallow driver io for known to be broken paths
      [S390] cio: provide fake irb for transport mode IO
      [S390] cio: fix chsc_chp_vary

 arch/s390/include/asm/pgtable.h |    8 ++--
 arch/s390/kernel/ptrace.c       |   30 +++++++-----
 arch/s390/kernel/setup.c        |    2 +-
 arch/s390/kernel/signal.c       |    8 +--
 drivers/s390/cio/chsc.c         |    7 +--
 drivers/s390/cio/cio.h          |    5 ++
 drivers/s390/cio/css.c          |  104 ++++++++++++++++++++++-----------------
 drivers/s390/cio/device.c       |    4 +-
 drivers/s390/cio/device_fsm.c   |   30 ++++++++---
 drivers/s390/cio/device_ops.c   |   20 ++++++--
 drivers/s390/cio/io_sch.h       |    5 ++-
 drivers/s390/crypto/ap_bus.c    |    2 +
 12 files changed, 137 insertions(+), 88 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 524d23b..4f289ff 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -599,10 +599,10 @@ static inline pgste_t pgste_update_all(pte_t *ptep, pgste_t pgste)
 	skey = page_get_storage_key(address);
 	bits = skey & (_PAGE_CHANGED | _PAGE_REFERENCED);
 	/* Clear page changed & referenced bit in the storage key */
-	if (bits) {
-		skey ^= bits;
-		page_set_storage_key(address, skey, 1);
-	}
+	if (bits & _PAGE_CHANGED)
+		page_set_storage_key(address, skey ^ bits, 1);
+	else if (bits)
+		page_reset_referenced(address);
 	/* Transfer page changed & referenced bit to guest bits in pgste */
 	pgste_val(pgste) |= bits << 48;		/* RCP_GR_BIT & RCP_GC_BIT */
 	/* Get host changed & referenced bits from pgste */
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 450931a..573bc29 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -296,13 +296,6 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
 		     ((data & PSW_MASK_EA) && !(data & PSW_MASK_BA))))
 			/* Invalid psw mask. */
 			return -EINVAL;
-		if (addr == (addr_t) &dummy->regs.psw.addr)
-			/*
-			 * The debugger changed the instruction address,
-			 * reset system call restart, see signal.c:do_signal
-			 */
-			task_thread_info(child)->system_call = 0;
-
 		*(addr_t *)((addr_t) &task_pt_regs(child)->psw + addr) = data;
 
 	} else if (addr < (addr_t) (&dummy->regs.orig_gpr2)) {
@@ -614,11 +607,6 @@ static int __poke_user_compat(struct task_struct *child,
 			/* Transfer 31 bit amode bit to psw mask. */
 			regs->psw.mask = (regs->psw.mask & ~PSW_MASK_BA) |
 				(__u64)(tmp & PSW32_ADDR_AMODE);
-			/*
-			 * The debugger changed the instruction address,
-			 * reset system call restart, see signal.c:do_signal
-			 */
-			task_thread_info(child)->system_call = 0;
 		} else {
 			/* gpr 0-15 */
 			*(__u32*)((addr_t) &regs->psw + addr*2 + 4) = tmp;
@@ -905,6 +893,14 @@ static int s390_last_break_get(struct task_struct *target,
 	return 0;
 }
 
+static int s390_last_break_set(struct task_struct *target,
+			       const struct user_regset *regset,
+			       unsigned int pos, unsigned int count,
+			       const void *kbuf, const void __user *ubuf)
+{
+	return 0;
+}
+
 #endif
 
 static int s390_system_call_get(struct task_struct *target,
@@ -951,6 +947,7 @@ static const struct user_regset s390_regsets[] = {
 		.size = sizeof(long),
 		.align = sizeof(long),
 		.get = s390_last_break_get,
+		.set = s390_last_break_set,
 	},
 #endif
 	[REGSET_SYSTEM_CALL] = {
@@ -1116,6 +1113,14 @@ static int s390_compat_last_break_get(struct task_struct *target,
 	return 0;
 }
 
+static int s390_compat_last_break_set(struct task_struct *target,
+				      const struct user_regset *regset,
+				      unsigned int pos, unsigned int count,
+				      const void *kbuf, const void __user *ubuf)
+{
+	return 0;
+}
+
 static const struct user_regset s390_compat_regsets[] = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
@@ -1139,6 +1144,7 @@ static const struct user_regset s390_compat_regsets[] = {
 		.size = sizeof(long),
 		.align = sizeof(long),
 		.get = s390_compat_last_break_get,
+		.set = s390_compat_last_break_set,
 	},
 	[REGSET_SYSTEM_CALL] = {
 		.core_note_type = NT_S390_SYSTEM_CALL,
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index e58a462..e54c4ff 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -579,7 +579,7 @@ static unsigned long __init find_crash_base(unsigned long crash_size,
 		*msg = "first memory chunk must be at least crashkernel size";
 		return 0;
 	}
-	if (is_kdump_kernel() && (crash_size == OLDMEM_SIZE))
+	if (OLDMEM_BASE && crash_size == OLDMEM_SIZE)
 		return OLDMEM_BASE;
 
 	for (i = MEMORY_CHUNKS - 1; i >= 0; i--) {
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 05a85bc..7f6f9f3 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -460,9 +460,9 @@ void do_signal(struct pt_regs *regs)
 						     regs->svc_code >> 16);
 				break;
 			}
-			/* No longer in a system call */
-			clear_thread_flag(TIF_SYSCALL);
 		}
+		/* No longer in a system call */
+		clear_thread_flag(TIF_SYSCALL);
 
 		if ((is_compat_task() ?
 		     handle_signal32(signr, &ka, &info, oldset, regs) :
@@ -486,6 +486,7 @@ void do_signal(struct pt_regs *regs)
 	}
 
 	/* No handlers present - check for system call restart */
+	clear_thread_flag(TIF_SYSCALL);
 	if (current_thread_info()->system_call) {
 		regs->svc_code = current_thread_info()->system_call;
 		switch (regs->gprs[2]) {
@@ -500,9 +501,6 @@ void do_signal(struct pt_regs *regs)
 			regs->gprs[2] = regs->orig_gpr2;
 			set_thread_flag(TIF_SYSCALL);
 			break;
-		default:
-			clear_thread_flag(TIF_SYSCALL);
-			break;
 		}
 	}
 
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 75c3f1f..a84631a 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -529,10 +529,7 @@ __s390_vary_chpid_on(struct subchannel_id schid, void *data)
 int chsc_chp_vary(struct chp_id chpid, int on)
 {
 	struct channel_path *chp = chpid_to_chp(chpid);
-	struct chp_link link;
 
-	memset(&link, 0, sizeof(struct chp_link));
-	link.chpid = chpid;
 	/* Wait until previous actions have settled. */
 	css_wait_for_slow_path();
 	/*
@@ -542,10 +539,10 @@ int chsc_chp_vary(struct chp_id chpid, int on)
 		/* Try to update the channel path descritor. */
 		chsc_determine_base_channel_path_desc(chpid, &chp->desc);
 		for_each_subchannel_staged(s390_subchannel_vary_chpid_on,
-					   __s390_vary_chpid_on, &link);
+					   __s390_vary_chpid_on, &chpid);
 	} else
 		for_each_subchannel_staged(s390_subchannel_vary_chpid_off,
-					   NULL, &link);
+					   NULL, &chpid);
 
 	return 0;
 }
diff --git a/drivers/s390/cio/cio.h b/drivers/s390/cio/cio.h
index 155a82b..4a1ff5c 100644
--- a/drivers/s390/cio/cio.h
+++ b/drivers/s390/cio/cio.h
@@ -68,8 +68,13 @@ struct schib {
 	__u8 mda[4];		 /* model dependent area */
 } __attribute__ ((packed,aligned(4)));
 
+/*
+ * When rescheduled, todo's with higher values will overwrite those
+ * with lower values.
+ */
 enum sch_todo {
 	SCH_TODO_NOTHING,
+	SCH_TODO_EVAL,
 	SCH_TODO_UNREG,
 };
 
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 92d7324..21908e6 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -195,51 +195,6 @@ void css_sch_device_unregister(struct subchannel *sch)
 }
 EXPORT_SYMBOL_GPL(css_sch_device_unregister);
 
-static void css_sch_todo(struct work_struct *work)
-{
-	struct subchannel *sch;
-	enum sch_todo todo;
-
-	sch = container_of(work, struct subchannel, todo_work);
-	/* Find out todo. */
-	spin_lock_irq(sch->lock);
-	todo = sch->todo;
-	CIO_MSG_EVENT(4, "sch_todo: sch=0.%x.%04x, todo=%d\n", sch->schid.ssid,
-		      sch->schid.sch_no, todo);
-	sch->todo = SCH_TODO_NOTHING;
-	spin_unlock_irq(sch->lock);
-	/* Perform todo. */
-	if (todo == SCH_TODO_UNREG)
-		css_sch_device_unregister(sch);
-	/* Release workqueue ref. */
-	put_device(&sch->dev);
-}
-
-/**
- * css_sched_sch_todo - schedule a subchannel operation
- * @sch: subchannel
- * @todo: todo
- *
- * Schedule the operation identified by @todo to be performed on the slow path
- * workqueue. Do nothing if another operation with higher priority is already
- * scheduled. Needs to be called with subchannel lock held.
- */
-void css_sched_sch_todo(struct subchannel *sch, enum sch_todo todo)
-{
-	CIO_MSG_EVENT(4, "sch_todo: sched sch=0.%x.%04x todo=%d\n",
-		      sch->schid.ssid, sch->schid.sch_no, todo);
-	if (sch->todo >= todo)
-		return;
-	/* Get workqueue ref. */
-	if (!get_device(&sch->dev))
-		return;
-	sch->todo = todo;
-	if (!queue_work(cio_work_q, &sch->todo_work)) {
-		/* Already queued, release workqueue ref. */
-		put_device(&sch->dev);
-	}
-}
-
 static void ssd_from_pmcw(struct chsc_ssd_info *ssd, struct pmcw *pmcw)
 {
 	int i;
@@ -466,6 +421,65 @@ static void css_evaluate_subchannel(struct subchannel_id schid, int slow)
 		css_schedule_eval(schid);
 }
 
+/**
+ * css_sched_sch_todo - schedule a subchannel operation
+ * @sch: subchannel
+ * @todo: todo
+ *
+ * Schedule the operation identified by @todo to be performed on the slow path
+ * workqueue. Do nothing if another operation with higher priority is already
+ * scheduled. Needs to be called with subchannel lock held.
+ */
+void css_sched_sch_todo(struct subchannel *sch, enum sch_todo todo)
+{
+	CIO_MSG_EVENT(4, "sch_todo: sched sch=0.%x.%04x todo=%d\n",
+		      sch->schid.ssid, sch->schid.sch_no, todo);
+	if (sch->todo >= todo)
+		return;
+	/* Get workqueue ref. */
+	if (!get_device(&sch->dev))
+		return;
+	sch->todo = todo;
+	if (!queue_work(cio_work_q, &sch->todo_work)) {
+		/* Already queued, release workqueue ref. */
+		put_device(&sch->dev);
+	}
+}
+
+static void css_sch_todo(struct work_struct *work)
+{
+	struct subchannel *sch;
+	enum sch_todo todo;
+	int ret;
+
+	sch = container_of(work, struct subchannel, todo_work);
+	/* Find out todo. */
+	spin_lock_irq(sch->lock);
+	todo = sch->todo;
+	CIO_MSG_EVENT(4, "sch_todo: sch=0.%x.%04x, todo=%d\n", sch->schid.ssid,
+		      sch->schid.sch_no, todo);
+	sch->todo = SCH_TODO_NOTHING;
+	spin_unlock_irq(sch->lock);
+	/* Perform todo. */
+	switch (todo) {
+	case SCH_TODO_NOTHING:
+		break;
+	case SCH_TODO_EVAL:
+		ret = css_evaluate_known_subchannel(sch, 1);
+		if (ret == -EAGAIN) {
+			spin_lock_irq(sch->lock);
+			css_sched_sch_todo(sch, todo);
+			spin_unlock_irq(sch->lock);
+		}
+		break;
+	case SCH_TODO_UNREG:
+		css_sch_device_unregister(sch);
+		break;
+	}
+	/* Release workqueue ref. */
+	put_device(&sch->dev);
+}
+
 static struct idset *slow_subchannel_set;
 static spinlock_t slow_subchannel_lock;
 static wait_queue_head_t css_eval_wq;
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index d734f4a..4726985 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1868,9 +1868,9 @@ static void __ccw_device_pm_restore(struct ccw_device *cdev)
 	 */
 	cdev->private->flags.resuming = 1;
 	cdev->private->path_new_mask = LPM_ANYPATH;
-	css_schedule_eval(sch->schid);
+	css_sched_sch_todo(sch, SCH_TODO_EVAL);
 	spin_unlock_irq(sch->lock);
-	css_complete_work();
+	css_wait_for_slow_path();
 
 	/* cdev may have been moved to a different subchannel. */
 	sch = to_subchannel(cdev->dev.parent);
diff --git a/drivers/s390/cio/device_fsm.c b/drivers/s390/cio/device_fsm.c
index 52c233f..1b85351 100644
--- a/drivers/s390/cio/device_fsm.c
+++ b/drivers/s390/cio/device_fsm.c
@@ -496,8 +496,26 @@ static void ccw_device_reset_path_events(struct ccw_device *cdev)
 	cdev->private->pgid_reset_mask = 0;
 }
 
-void
-ccw_device_verify_done(struct ccw_device *cdev, int err)
+static void create_fake_irb(struct irb *irb, int type)
+{
+	memset(irb, 0, sizeof(*irb));
+	if (type == FAKE_CMD_IRB) {
+		struct cmd_scsw *scsw = &irb->scsw.cmd;
+		scsw->cc = 1;
+		scsw->fctl = SCSW_FCTL_START_FUNC;
+		scsw->actl = SCSW_ACTL_START_PEND;
+		scsw->stctl = SCSW_STCTL_STATUS_PEND;
+	} else if (type == FAKE_TM_IRB) {
+		struct tm_scsw *scsw = &irb->scsw.tm;
+		scsw->x = 1;
+		scsw->cc = 1;
+		scsw->fctl = SCSW_FCTL_START_FUNC;
+		scsw->actl = SCSW_ACTL_START_PEND;
+		scsw->stctl = SCSW_STCTL_STATUS_PEND;
+	}
+}
+
+void ccw_device_verify_done(struct ccw_device *cdev, int err)
 {
 	struct subchannel *sch;
 
@@ -520,12 +538,8 @@ callback:
 		ccw_device_done(cdev, DEV_STATE_ONLINE);
 		/* Deliver fake irb to device driver, if needed. */
 		if (cdev->private->flags.fake_irb) {
-			memset(&cdev->private->irb, 0, sizeof(struct irb));
-			cdev->private->irb.scsw.cmd.cc = 1;
-			cdev->private->irb.scsw.cmd.fctl = SCSW_FCTL_START_FUNC;
-			cdev->private->irb.scsw.cmd.actl = SCSW_ACTL_START_PEND;
-			cdev->private->irb.scsw.cmd.stctl =
-				SCSW_STCTL_STATUS_PEND;
+			create_fake_irb(&cdev->private->irb,
+					cdev->private->flags.fake_irb);
 			cdev->private->flags.fake_irb = 0;
 			if (cdev->handler)
 				cdev->handler(cdev, cdev->private->intparm,
diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index f98698d..ec7fb6d 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -198,7 +198,7 @@ int ccw_device_start_key(struct ccw_device *cdev, struct ccw1 *cpa,
 	if (cdev->private->state == DEV_STATE_VERIFY) {
 		/* Remember to fake irb when finished. */
 		if (!cdev->private->flags.fake_irb) {
-			cdev->private->flags.fake_irb = 1;
+			cdev->private->flags.fake_irb = FAKE_CMD_IRB;
 			cdev->private->intparm = intparm;
 			return 0;
 		} else
@@ -213,9 +213,9 @@ int ccw_device_start_key(struct ccw_device *cdev, struct ccw1 *cpa,
 	ret = cio_set_options (sch, flags);
 	if (ret)
 		return ret;
-	/* Adjust requested path mask to excluded varied off paths. */
+	/* Adjust requested path mask to exclude unusable paths. */
 	if (lpm) {
-		lpm &= sch->opm;
+		lpm &= sch->lpm;
 		if (lpm == 0)
 			return -EACCES;
 	}
@@ -605,11 +605,21 @@ int ccw_device_tm_start_key(struct ccw_device *cdev, struct tcw *tcw,
 	sch = to_subchannel(cdev->dev.parent);
 	if (!sch->schib.pmcw.ena)
 		return -EINVAL;
+	if (cdev->private->state == DEV_STATE_VERIFY) {
+		/* Remember to fake irb when finished. */
+		if (!cdev->private->flags.fake_irb) {
+			cdev->private->flags.fake_irb = FAKE_TM_IRB;
+			cdev->private->intparm = intparm;
+			return 0;
+		} else
+			/* There's already a fake I/O around. */
+			return -EBUSY;
+	}
 	if (cdev->private->state != DEV_STATE_ONLINE)
 		return -EIO;
-	/* Adjust requested path mask to excluded varied off paths. */
+	/* Adjust requested path mask to exclude unusable paths. */
 	if (lpm) {
-		lpm &= sch->opm;
+		lpm &= sch->lpm;
 		if (lpm == 0)
 			return -EACCES;
 	}
diff --git a/drivers/s390/cio/io_sch.h b/drivers/s390/cio/io_sch.h
index 2ebb492..76253df 100644
--- a/drivers/s390/cio/io_sch.h
+++ b/drivers/s390/cio/io_sch.h
@@ -111,6 +111,9 @@ enum cdev_todo {
 	CDEV_TODO_UNREG_EVAL,
 };
 
+#define FAKE_CMD_IRB	1
+#define FAKE_TM_IRB	2
+
 struct ccw_device_private {
 	struct ccw_device *cdev;
 	struct subchannel *sch;
@@ -138,7 +141,7 @@ struct ccw_device_private {
 		unsigned int doverify:1;    /* delayed path verification */
 		unsigned int donotify:1;    /* call notify function */
 		unsigned int recog_done:1;  /* dev. recog. complete */
-		unsigned int fake_irb:1;    /* deliver faked irb */
+		unsigned int fake_irb:2;    /* deliver faked irb */
 		unsigned int resuming:1;    /* recognition while resume */
 		unsigned int pgroup:1;	    /* pathgroup is set up */
 		unsigned int mpath:1;	    /* multipathing is set up */
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index ec94f04..96bbe9d 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1552,6 +1552,8 @@ static void ap_reset(struct ap_device *ap_dev)
 	rc = ap_init_queue(ap_dev->qid);
 	if (rc == -ENODEV)
 		ap_dev->unregistered = 1;
+	else
+		__ap_schedule_poll_timer();
 }
 
 static int __ap_poll_device(struct ap_device *ap_dev, unsigned long *flags)

