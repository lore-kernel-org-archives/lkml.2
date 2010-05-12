Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab0ELH6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 03:58:34 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:35449 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab0ELH6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 03:58:32 -0400
Date: Wed, 12 May 2010 09:58:30 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.34-rc7
Message-ID: <20100512095830.66add2ac@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

three last minute bug fixes for s390. Please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Gerald Schaefer (1):
      [S390] ptrace: fix return value of do_syscall_trace_enter()

Martin Schwidefsky (1):
      [S390] correct address of _stext with CONFIG_SHARED_KERNEL=y

Stefan Weinhuber (1):
      [S390] dasd: fix race between tasklet and dasd_sleep_on

 arch/s390/kernel/head31.S |    2 +-
 arch/s390/kernel/head64.S |    2 +-
 arch/s390/kernel/ptrace.c |    5 ++---
 drivers/s390/block/dasd.c |   17 ++++++++++-------
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kernel/head31.S b/arch/s390/kernel/head31.S
index 1bbcc49..b8f8dc1 100644
--- a/arch/s390/kernel/head31.S
+++ b/arch/s390/kernel/head31.S
@@ -82,7 +82,7 @@ startup_continue:
 _ehead:
 
 #ifdef CONFIG_SHARED_KERNEL
-	.org	0x100000
+	.org	0x100000 - 0x11000	# head.o ends at 0x11000
 #endif
 
 #
diff --git a/arch/s390/kernel/head64.S b/arch/s390/kernel/head64.S
index 1f70970..cdef687 100644
--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -80,7 +80,7 @@ startup_continue:
 _ehead:
 
 #ifdef CONFIG_SHARED_KERNEL
-	.org	0x100000
+	.org	0x100000 - 0x11000	# head.o ends at 0x11000
 #endif
 
 #
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 33fdc5a..9f654da 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -640,7 +640,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
-	long ret;
+	long ret = 0;
 
 	/* Do the secure computing check first. */
 	secure_computing(regs->gprs[2]);
@@ -649,7 +649,6 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	 * The sysc_tracesys code in entry.S stored the system
 	 * call number to gprs[2].
 	 */
-	ret = regs->gprs[2];
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    (tracehook_report_syscall_entry(regs) ||
 	     regs->gprs[2] >= NR_syscalls)) {
@@ -671,7 +670,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 				    regs->gprs[2], regs->orig_gpr2,
 				    regs->gprs[3], regs->gprs[4],
 				    regs->gprs[5]);
-	return ret;
+	return ret ?: regs->gprs[2];
 }
 
 asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index acf222f..fa2339c 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -37,6 +37,9 @@
  */
 #define DASD_CHANQ_MAX_SIZE 4
 
+#define DASD_SLEEPON_START_TAG	(void *) 1
+#define DASD_SLEEPON_END_TAG	(void *) 2
+
 /*
  * SECTION: exported variables of dasd.c
  */
@@ -1472,7 +1475,10 @@ void dasd_add_request_tail(struct dasd_ccw_req *cqr)
  */
 static void dasd_wakeup_cb(struct dasd_ccw_req *cqr, void *data)
 {
-	wake_up((wait_queue_head_t *) data);
+	spin_lock_irq(get_ccwdev_lock(cqr->startdev->cdev));
+	cqr->callback_data = DASD_SLEEPON_END_TAG;
+	spin_unlock_irq(get_ccwdev_lock(cqr->startdev->cdev));
+	wake_up(&generic_waitq);
 }
 
 static inline int _wait_for_wakeup(struct dasd_ccw_req *cqr)
@@ -1482,10 +1488,7 @@ static inline int _wait_for_wakeup(struct dasd_ccw_req *cqr)
 
 	device = cqr->startdev;
 	spin_lock_irq(get_ccwdev_lock(device->cdev));
-	rc = ((cqr->status == DASD_CQR_DONE ||
-	       cqr->status == DASD_CQR_NEED_ERP ||
-	       cqr->status == DASD_CQR_TERMINATED) &&
-	      list_empty(&cqr->devlist));
+	rc = (cqr->callback_data == DASD_SLEEPON_END_TAG);
 	spin_unlock_irq(get_ccwdev_lock(device->cdev));
 	return rc;
 }
@@ -1573,7 +1576,7 @@ static int _dasd_sleep_on(struct dasd_ccw_req *maincqr, int interruptible)
 			wait_event(generic_waitq, !(device->stopped));
 
 		cqr->callback = dasd_wakeup_cb;
-		cqr->callback_data = (void *) &generic_waitq;
+		cqr->callback_data = DASD_SLEEPON_START_TAG;
 		dasd_add_request_tail(cqr);
 		if (interruptible) {
 			rc = wait_event_interruptible(
@@ -1652,7 +1655,7 @@ int dasd_sleep_on_immediatly(struct dasd_ccw_req *cqr)
 	}
 
 	cqr->callback = dasd_wakeup_cb;
-	cqr->callback_data = (void *) &generic_waitq;
+	cqr->callback_data = DASD_SLEEPON_START_TAG;
 	cqr->status = DASD_CQR_QUEUED;
 	list_add(&cqr->devlist, &device->ccw_queue);
 
