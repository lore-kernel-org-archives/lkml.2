Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1DHIXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 04:23:00 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:36458 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1DHIW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 04:22:57 -0400
Date: Fri, 8 Apr 2011 10:22:49 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.39-rc2
Message-ID: <20110408102249.13a916a6@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Jan Glauber (1):
      [S390] oprofile s390: prevent stack corruption

Martin Schwidefsky (1):
      [S390] compile fix for latest binutils

Michael Holzheu (1):
      [S390] Fix parameter passing for smp_switch_to_cpu()

Peter Oberparleiter (1):
      [S390] cio: prevent purging of CCW devices in the online state

Sebastian Ott (1):
      [S390] qdio: fix init sequence

 arch/s390/kernel/head.S         |    2 +-
 arch/s390/kernel/switch_cpu.S   |    4 +++-
 arch/s390/kernel/switch_cpu64.S |    4 +++-
 arch/s390/oprofile/hwsampler.c  |    6 +-----
 drivers/s390/cio/device.c       |   24 ++++++++++++++++++------
 drivers/s390/cio/qdio_main.c    |   16 ++++++++--------
 6 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/arch/s390/kernel/head.S b/arch/s390/kernel/head.S
index 7061398..fb317bf 100644
--- a/arch/s390/kernel/head.S
+++ b/arch/s390/kernel/head.S
@@ -460,7 +460,7 @@ startup:
 #ifndef CONFIG_MARCH_G5
 	# check capabilities against MARCH_{G5,Z900,Z990,Z9_109,Z10}
 	xc	__LC_STFL_FAC_LIST(8),__LC_STFL_FAC_LIST
-	stfl	__LC_STFL_FAC_LIST	# store facility list
+	.insn	s,0xb2b10000,__LC_STFL_FAC_LIST	# store facility list
 	tm	__LC_STFL_FAC_LIST,0x01	# stfle available ?
 	jz	0f
 	la	%r0,0
diff --git a/arch/s390/kernel/switch_cpu.S b/arch/s390/kernel/switch_cpu.S
index 469f11b..20530dd 100644
--- a/arch/s390/kernel/switch_cpu.S
+++ b/arch/s390/kernel/switch_cpu.S
@@ -46,7 +46,9 @@ smp_restart_cpu:
 	ltr	%r4,%r4			/* New stack ? */
 	jz	1f
 	lr	%r15,%r4
-1:	basr	%r14,%r2
+1:	lr	%r14,%r2		/* r14: Function to call */
+	lr	%r2,%r3			/* r2 : Parameter for function*/
+	basr	%r14,%r14		/* Call function */
 
 .gprregs_addr:
 	.long	.gprregs
diff --git a/arch/s390/kernel/switch_cpu64.S b/arch/s390/kernel/switch_cpu64.S
index d94aacc..5be3f43 100644
--- a/arch/s390/kernel/switch_cpu64.S
+++ b/arch/s390/kernel/switch_cpu64.S
@@ -42,7 +42,9 @@ smp_restart_cpu:
 	ltgr	%r4,%r4			/* New stack ? */
 	jz	1f
 	lgr	%r15,%r4
-1:	basr	%r14,%r2
+1:	lgr	%r14,%r2		/* r14: Function to call */
+	lgr	%r2,%r3			/* r2 : Parameter for function*/
+	basr	%r14,%r14		/* Call function */
 
 	.section .data,"aw",@progbits
 .gprregs:
diff --git a/arch/s390/oprofile/hwsampler.c b/arch/s390/oprofile/hwsampler.c
index 3d48f4d..4952872 100644
--- a/arch/s390/oprofile/hwsampler.c
+++ b/arch/s390/oprofile/hwsampler.c
@@ -517,12 +517,8 @@ stop_exit:
 
 static int check_hardware_prerequisites(void)
 {
-	unsigned long long facility_bits[2];
-
-	memcpy(facility_bits, S390_lowcore.stfle_fac_list, 32);
-	if (!(facility_bits[1] & (1ULL << 59)))
+	if (!test_facility(68))
 		return -EOPNOTSUPP;
-
 	return 0;
 }
 /*
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index df14c51..8e04c00 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -541,15 +541,24 @@ static ssize_t online_store (struct device *dev, struct device_attribute *attr,
 	int force, ret;
 	unsigned long i;
 
-	if (!dev_fsm_final_state(cdev) &&
-	    cdev->private->state != DEV_STATE_DISCONNECTED)
-		return -EAGAIN;
+	/* Prevent conflict between multiple on-/offline processing requests. */
 	if (atomic_cmpxchg(&cdev->private->onoff, 0, 1) != 0)
 		return -EAGAIN;
+	/* Prevent conflict between internal I/Os and on-/offline processing. */
+	if (!dev_fsm_final_state(cdev) &&
+	    cdev->private->state != DEV_STATE_DISCONNECTED) {
+		ret = -EAGAIN;
+		goto out_onoff;
+	}
+	/* Prevent conflict between pending work and on-/offline processing.*/
+	if (work_pending(&cdev->private->todo_work)) {
+		ret = -EAGAIN;
+		goto out_onoff;
+	}
 
 	if (cdev->drv && !try_module_get(cdev->drv->driver.owner)) {
-		atomic_set(&cdev->private->onoff, 0);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_onoff;
 	}
 	if (!strncmp(buf, "force\n", count)) {
 		force = 1;
@@ -574,6 +583,7 @@ static ssize_t online_store (struct device *dev, struct device_attribute *attr,
 out:
 	if (cdev->drv)
 		module_put(cdev->drv->driver.owner);
+out_onoff:
 	atomic_set(&cdev->private->onoff, 0);
 	return (ret < 0) ? ret : count;
 }
@@ -1311,10 +1321,12 @@ static int purge_fn(struct device *dev, void *data)
 
 	spin_lock_irq(cdev->ccwlock);
 	if (is_blacklisted(id->ssid, id->devno) &&
-	    (cdev->private->state == DEV_STATE_OFFLINE)) {
+	    (cdev->private->state == DEV_STATE_OFFLINE) &&
+	    (atomic_cmpxchg(&cdev->private->onoff, 0, 1) == 0)) {
 		CIO_MSG_EVENT(3, "ccw: purging 0.%x.%04x\n", id->ssid,
 			      id->devno);
 		ccw_device_sched_todo(cdev, CDEV_TODO_UNREG);
+		atomic_set(&cdev->private->onoff, 0);
 	}
 	spin_unlock_irq(cdev->ccwlock);
 	/* Abort loop in case of pending signal. */
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 479c665..c532ba9 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1649,26 +1649,26 @@ static int __init init_QDIO(void)
 {
 	int rc;
 
-	rc = qdio_setup_init();
+	rc = qdio_debug_init();
 	if (rc)
 		return rc;
+	rc = qdio_setup_init();
+	if (rc)
+		goto out_debug;
 	rc = tiqdio_allocate_memory();
 	if (rc)
 		goto out_cache;
-	rc = qdio_debug_init();
-	if (rc)
-		goto out_ti;
 	rc = tiqdio_register_thinints();
 	if (rc)
-		goto out_debug;
+		goto out_ti;
 	return 0;
 
-out_debug:
-	qdio_debug_exit();
 out_ti:
 	tiqdio_free_memory();
 out_cache:
 	qdio_setup_exit();
+out_debug:
+	qdio_debug_exit();
 	return rc;
 }
 
@@ -1676,8 +1676,8 @@ static void __exit exit_QDIO(void)
 {
 	tiqdio_unregister_thinints();
 	tiqdio_free_memory();
-	qdio_debug_exit();
 	qdio_setup_exit();
+	qdio_debug_exit();
 }
 
 module_init(init_QDIO);
