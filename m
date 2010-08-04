Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806Ab0HDVOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:14:38 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:53988 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759072Ab0HDVN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:13:59 -0400
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCHv3 06/16] pps: convert printk/pr_* to dev_*
Date: Thu,  5 Aug 2010 01:06:43 +0400
Message-Id: <bce0dd99734cbef7c4785df8ff4198c256407fcd.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now have direct pointers to struct pps_device everywhere it's
easy to use dev_* functions to print messages instead of plain printks.
Where dev_* cannot be used printks are converted to pr_*.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/clients/pps-ktimer.c |    4 ++--
 drivers/pps/kapi.c               |   14 +++++++-------
 drivers/pps/pps.c                |   24 ++++++++++++------------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/pps/clients/pps-ktimer.c b/drivers/pps/clients/pps-ktimer.c
index 64cba1d..9d27239 100644
--- a/drivers/pps/clients/pps-ktimer.c
+++ b/drivers/pps/clients/pps-ktimer.c
@@ -45,7 +45,7 @@ static void pps_ktimer_event(unsigned long ptr)
 	/* First of all we get the time stamp... */
 	pps_get_ts(&ts);
 
-	pr_info("PPS event at %lu\n", jiffies);
+	dev_info(pps->dev, "PPS event at %lu\n", jiffies);
 
 	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
 
@@ -94,7 +94,7 @@ static int __init pps_ktimer_init(void)
 	pps = pps_register_source(&pps_ktimer_info,
 				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
 	if (pps == NULL) {
-		printk(KERN_ERR "cannot register ktimer source\n");
+		pr_err("cannot register ktimer source\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 568223b..eddf41e 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -80,20 +80,20 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 
 	/* Sanity checks */
 	if ((info->mode & default_params) != default_params) {
-		printk(KERN_ERR "pps: %s: unsupported default parameters\n",
+		pr_err("pps: %s: unsupported default parameters\n",
 					info->name);
 		err = -EINVAL;
 		goto pps_register_source_exit;
 	}
 	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
 			info->echo == NULL) {
-		printk(KERN_ERR "pps: %s: echo function is not defined\n",
+		pr_err("pps: %s: echo function is not defined\n",
 					info->name);
 		err = -EINVAL;
 		goto pps_register_source_exit;
 	}
 	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
-		printk(KERN_ERR "pps: %s: unspecified time format\n",
+		pr_err("pps: %s: unspecified time format\n",
 					info->name);
 		err = -EINVAL;
 		goto pps_register_source_exit;
@@ -138,7 +138,7 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 	if (id >= PPS_MAX_SOURCES) {
 		spin_unlock_irq(&pps_idr_lock);
 
-		printk(KERN_ERR "pps: %s: too many PPS sources in the system\n",
+		pr_err("pps: %s: too many PPS sources in the system\n",
 					info->name);
 		err = -EBUSY;
 		goto free_idr;
@@ -150,12 +150,12 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 	/* Create the char device */
 	err = pps_register_cdev(pps);
 	if (err < 0) {
-		printk(KERN_ERR "pps: %s: unable to create char device\n",
+		pr_err("pps: %s: unable to create char device\n",
 					info->name);
 		goto free_idr;
 	}
 
-	pr_info("new PPS source %s at ID %d\n", info->name, id);
+	dev_info(pps->dev, "new PPS source %s\n", info->name);
 
 	return pps;
 
@@ -168,7 +168,7 @@ kfree_pps:
 	kfree(pps);
 
 pps_register_source_exit:
-	printk(KERN_ERR "pps: %s: unable to register source\n", info->name);
+	pr_err("pps: %s: unable to register source\n", info->name);
 
 	return NULL;
 }
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 89f478b..a5ca1c0 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -67,7 +67,7 @@ static long pps_cdev_ioctl(struct file *file,
 
 	switch (cmd) {
 	case PPS_GETPARAMS:
-		pr_debug("PPS_GETPARAMS: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_GETPARAMS\n");
 
 		spin_lock_irq(&pps->lock);
 
@@ -83,7 +83,7 @@ static long pps_cdev_ioctl(struct file *file,
 		break;
 
 	case PPS_SETPARAMS:
-		pr_debug("PPS_SETPARAMS: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_SETPARAMS\n");
 
 		/* Check the capabilities */
 		if (!capable(CAP_SYS_TIME))
@@ -93,14 +93,14 @@ static long pps_cdev_ioctl(struct file *file,
 		if (err)
 			return -EFAULT;
 		if (!(params.mode & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR))) {
-			pr_debug("capture mode unspecified (%x)\n",
+			dev_dbg(pps->dev, "capture mode unspecified (%x)\n",
 								params.mode);
 			return -EINVAL;
 		}
 
 		/* Check for supported capabilities */
 		if ((params.mode & ~pps->info.mode) != 0) {
-			pr_debug("unsupported capabilities (%x)\n",
+			dev_dbg(pps->dev, "unsupported capabilities (%x)\n",
 								params.mode);
 			return -EINVAL;
 		}
@@ -113,7 +113,7 @@ static long pps_cdev_ioctl(struct file *file,
 		/* Restore the read only parameters */
 		if ((params.mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
 			/* section 3.3 of RFC 2783 interpreted */
-			pr_debug("time format unspecified (%x)\n",
+			dev_dbg(pps->dev, "time format unspecified (%x)\n",
 								params.mode);
 			pps->params.mode |= PPS_TSFMT_TSPEC;
 		}
@@ -126,7 +126,7 @@ static long pps_cdev_ioctl(struct file *file,
 		break;
 
 	case PPS_GETCAP:
-		pr_debug("PPS_GETCAP: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_GETCAP\n");
 
 		err = put_user(pps->info.mode, iuarg);
 		if (err)
@@ -138,7 +138,7 @@ static long pps_cdev_ioctl(struct file *file,
 		struct pps_fdata fdata;
 		unsigned int ev;
 
-		pr_debug("PPS_FETCH: source %d\n", pps->id);
+		dev_dbg(pps->dev, "PPS_FETCH\n");
 
 		err = copy_from_user(&fdata, uarg, sizeof(struct pps_fdata));
 		if (err)
@@ -153,7 +153,7 @@ static long pps_cdev_ioctl(struct file *file,
 		else {
 			unsigned long ticks;
 
-			pr_debug("timeout %lld.%09d\n",
+			dev_dbg(pps->dev, "timeout %lld.%09d\n",
 					(long long) fdata.timeout.sec,
 					fdata.timeout.nsec);
 			ticks = fdata.timeout.sec * HZ;
@@ -171,7 +171,7 @@ static long pps_cdev_ioctl(struct file *file,
 
 		/* Check for pending signals */
 		if (err == -ERESTARTSYS) {
-			pr_debug("pending signal caught\n");
+			dev_dbg(pps->dev, "pending signal caught\n");
 			return -EINTR;
 		}
 
@@ -240,7 +240,7 @@ int pps_register_cdev(struct pps_device *pps)
 
 	err = cdev_add(&pps->cdev, devt, 1);
 	if (err) {
-		printk(KERN_ERR "pps: %s: failed to add char device %d:%d\n",
+		pr_err("pps: %s: failed to add char device %d:%d\n",
 				pps->info.name, MAJOR(pps_devt), pps->id);
 		return err;
 	}
@@ -282,14 +282,14 @@ static int __init pps_init(void)
 
 	pps_class = class_create(THIS_MODULE, "pps");
 	if (!pps_class) {
-		printk(KERN_ERR "pps: failed to allocate class\n");
+		pr_err("pps: failed to allocate class\n");
 		return -ENOMEM;
 	}
 	pps_class->dev_attrs = pps_attrs;
 
 	err = alloc_chrdev_region(&pps_devt, 0, PPS_MAX_SOURCES, "pps");
 	if (err < 0) {
-		printk(KERN_ERR "pps: failed to allocate char device region\n");
+		pr_err("pps: failed to allocate char device region\n");
 		goto remove_class;
 	}
 
-- 
1.7.1

