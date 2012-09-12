Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903Ab2ILRry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:47:54 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55671 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2ILRrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:47:52 -0400
Message-ID: <1347472190.27058.5.camel@footlong>
Subject: [PATCH 1/1] drivers/char/tpm: remove tasklet and cleanup
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, key@linux.vnet.ibm.com, jmorris@namei.org,
        adlai@us.ibm.com, adlai@linux.vnet.ibm.com
Date: Wed, 12 Sep 2012 12:49:50 -0500
In-Reply-To: <1345670263.25124.7.camel@footlong>
References: <1345670263.25124.7.camel@footlong>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091217-7606-0000-0000-00000399BF65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removed the tasklet and moved the wait queue into the
private structure.  It also cleaned up the response CRQ path.

Signed-off-by: Ashley Lai <adlai@us.ibm.com>
---
James,

This patch is based on your "next" branch.
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git

Thanks,
Ashley Lai
---
 drivers/char/tpm/tpm_ibmvtpm.c | 81 +++++++++++++++---------------------------
 drivers/char/tpm/tpm_ibmvtpm.h |  5 ++-
 2 files changed, 30 insertions(+), 56 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index efc4ab3..88a95ea 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -38,8 +38,6 @@ static struct vio_device_id tpm_ibmvtpm_device_table[] __devinitdata = {
 };
 MODULE_DEVICE_TABLE(vio, tpm_ibmvtpm_device_table);
 
-DECLARE_WAIT_QUEUE_HEAD(wq);
-
 /**
  * ibmvtpm_send_crq - Send a CRQ request
  * @vdev:	vio device struct
@@ -83,6 +81,7 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct ibmvtpm_dev *ibmvtpm;
 	u16 len;
+	int sig;
 
 	ibmvtpm = (struct ibmvtpm_dev *)chip->vendor.data;
 
@@ -91,22 +90,23 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		return 0;
 	}
 
-	wait_event_interruptible(wq, ibmvtpm->crq_res.len != 0);
+	sig = wait_event_interruptible(ibmvtpm->wq, ibmvtpm->res_len != 0);
+	if (sig)
+		return -EINTR;
+
+	len = ibmvtpm->res_len;
 
-	if (count < ibmvtpm->crq_res.len) {
+	if (count < len) {
 		dev_err(ibmvtpm->dev,
 			"Invalid size in recv: count=%ld, crq_size=%d\n",
-			count, ibmvtpm->crq_res.len);
+			count, len);
 		return -EIO;
 	}
 
 	spin_lock(&ibmvtpm->rtce_lock);
-	memcpy((void *)buf, (void *)ibmvtpm->rtce_buf, ibmvtpm->crq_res.len);
-	memset(ibmvtpm->rtce_buf, 0, ibmvtpm->crq_res.len);
-	ibmvtpm->crq_res.valid = 0;
-	ibmvtpm->crq_res.msg = 0;
-	len = ibmvtpm->crq_res.len;
-	ibmvtpm->crq_res.len = 0;
+	memcpy((void *)buf, (void *)ibmvtpm->rtce_buf, len);
+	memset(ibmvtpm->rtce_buf, 0, len);
+	ibmvtpm->res_len = 0;
 	spin_unlock(&ibmvtpm->rtce_lock);
 	return len;
 }
@@ -273,7 +273,6 @@ static int __devexit tpm_ibmvtpm_remove(struct vio_dev *vdev)
 	int rc = 0;
 
 	free_irq(vdev->irq, ibmvtpm);
-	tasklet_kill(&ibmvtpm->tasklet);
 
 	do {
 		if (rc)
@@ -372,7 +371,6 @@ static int ibmvtpm_reset_crq(struct ibmvtpm_dev *ibmvtpm)
 static int tpm_ibmvtpm_resume(struct device *dev)
 {
 	struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(dev);
-	unsigned long flags;
 	int rc = 0;
 
 	do {
@@ -387,10 +385,11 @@ static int tpm_ibmvtpm_resume(struct device *dev)
 		return rc;
 	}
 
-	spin_lock_irqsave(&ibmvtpm->lock, flags);
-	vio_disable_interrupts(ibmvtpm->vdev);
-	tasklet_schedule(&ibmvtpm->tasklet);
-	spin_unlock_irqrestore(&ibmvtpm->lock, flags);
+	rc = vio_enable_interrupts(ibmvtpm->vdev);
+	if (rc) {
+		dev_err(dev, "Error vio_enable_interrupts rc=%d\n", rc);
+		return rc;
+	}
 
 	rc = ibmvtpm_crq_send_init(ibmvtpm);
 	if (rc)
@@ -467,7 +466,7 @@ static struct ibmvtpm_crq *ibmvtpm_crq_get_next(struct ibmvtpm_dev *ibmvtpm)
 	if (crq->valid & VTPM_MSG_RES) {
 		if (++crq_q->index == crq_q->num_entry)
 			crq_q->index = 0;
-		rmb();
+		smp_rmb();
 	} else
 		crq = NULL;
 	return crq;
@@ -535,11 +534,9 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
 			ibmvtpm->vtpm_version = crq->data;
 			return;
 		case VTPM_TPM_COMMAND_RES:
-			ibmvtpm->crq_res.valid = crq->valid;
-			ibmvtpm->crq_res.msg = crq->msg;
-			ibmvtpm->crq_res.len = crq->len;
-			ibmvtpm->crq_res.data = crq->data;
-			wake_up_interruptible(&wq);
+			/* len of the data in rtce buffer */
+			ibmvtpm->res_len = crq->len;
+			wake_up_interruptible(&ibmvtpm->wq);
 			return;
 		default:
 			return;
@@ -559,38 +556,19 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
 static irqreturn_t ibmvtpm_interrupt(int irq, void *vtpm_instance)
 {
 	struct ibmvtpm_dev *ibmvtpm = (struct ibmvtpm_dev *) vtpm_instance;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ibmvtpm->lock, flags);
-	vio_disable_interrupts(ibmvtpm->vdev);
-	tasklet_schedule(&ibmvtpm->tasklet);
-	spin_unlock_irqrestore(&ibmvtpm->lock, flags);
-
-	return IRQ_HANDLED;
-}
-
-/**
- * ibmvtpm_tasklet - Interrupt handler tasklet
- * @data:	ibm vtpm device struct
- *
- * Returns:
- *	Nothing
- **/
-static void ibmvtpm_tasklet(void *data)
-{
-	struct ibmvtpm_dev *ibmvtpm = data;
 	struct ibmvtpm_crq *crq;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ibmvtpm->lock, flags);
+	/* while loop is needed for initial setup (get version and
+	 * get rtce_size). There should be only one tpm request at any
+	 * given time.
+	 */
 	while ((crq = ibmvtpm_crq_get_next(ibmvtpm)) != NULL) {
 		ibmvtpm_crq_process(crq, ibmvtpm);
 		crq->valid = 0;
-		wmb();
+		smp_wmb();
 	}
 
-	vio_enable_interrupts(ibmvtpm->vdev);
-	spin_unlock_irqrestore(&ibmvtpm->lock, flags);
+	return IRQ_HANDLED;
 }
 
 /**
@@ -650,9 +628,6 @@ static int __devinit tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 		goto reg_crq_cleanup;
 	}
 
-	tasklet_init(&ibmvtpm->tasklet, (void *)ibmvtpm_tasklet,
-		     (unsigned long)ibmvtpm);
-
 	rc = request_irq(vio_dev->irq, ibmvtpm_interrupt, 0,
 			 tpm_ibmvtpm_driver_name, ibmvtpm);
 	if (rc) {
@@ -666,13 +641,14 @@ static int __devinit tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 		goto init_irq_cleanup;
 	}
 
+	init_waitqueue_head(&ibmvtpm->wq);
+
 	crq_q->index = 0;
 
 	ibmvtpm->dev = dev;
 	ibmvtpm->vdev = vio_dev;
 	chip->vendor.data = (void *)ibmvtpm;
 
-	spin_lock_init(&ibmvtpm->lock);
 	spin_lock_init(&ibmvtpm->rtce_lock);
 
 	rc = ibmvtpm_crq_send_init(ibmvtpm);
@@ -689,7 +665,6 @@ static int __devinit tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 
 	return rc;
 init_irq_cleanup:
-	tasklet_kill(&ibmvtpm->tasklet);
 	do {
 		rc1 = plpar_hcall_norets(H_FREE_CRQ, vio_dev->unit_address);
 	} while (rc1 == H_BUSY || H_IS_LONG_BUSY(rc1));
diff --git a/drivers/char/tpm/tpm_ibmvtpm.h b/drivers/char/tpm/tpm_ibmvtpm.h
index 4296eb4..bd82a79 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.h
+++ b/drivers/char/tpm/tpm_ibmvtpm.h
@@ -38,13 +38,12 @@ struct ibmvtpm_dev {
 	struct vio_dev *vdev;
 	struct ibmvtpm_crq_queue crq_queue;
 	dma_addr_t crq_dma_handle;
-	spinlock_t lock;
-	struct tasklet_struct tasklet;
 	u32 rtce_size;
 	void __iomem *rtce_buf;
 	dma_addr_t rtce_dma_handle;
 	spinlock_t rtce_lock;
-	struct ibmvtpm_crq crq_res;
+	wait_queue_head_t wq;
+	u16 res_len;
 	u32 vtpm_version;
 };
 
-- 
1.7.11.2


