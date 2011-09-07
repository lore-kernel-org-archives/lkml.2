Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab1IGGHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:07:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:6183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175Ab1IGGFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:05:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208";a="48789689"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 07/12 v2] staging: mei: renaming delayed work field and function to a meaningful name.
Date: Wed,  7 Sep 2011 09:03:13 +0300
Message-Id: <1315375398-29529-8-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
References: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the wd_work and mei_wd_timer() function was not just for watchdog.
mei managing the AMT watchdog going to be replace by the kernel watchdog
interface.

the mei_timer() will still manage the mei driver timeouts.

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/interrupt.c |    6 +++---
 drivers/staging/mei/main.c      |    6 +++---
 drivers/staging/mei/mei_dev.h   |    4 ++--
 drivers/staging/mei/wd.c        |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 62b8001..d1da3aa 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -1393,7 +1393,7 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
  *
  * NOTE: This function is called by timer interrupt work
  */
-void mei_wd_timer(struct work_struct *work)
+void mei_timer(struct work_struct *work)
 {
 	unsigned long timeout;
 	struct mei_cl *cl_pos = NULL;
@@ -1403,7 +1403,7 @@ void mei_wd_timer(struct work_struct *work)
 	struct mei_cl_cb  *cb_next = NULL;
 
 	struct mei_device *dev = container_of(work,
-					struct mei_device, wd_work.work);
+					struct mei_device, timer_work.work);
 
 
 	mutex_lock(&dev->device_lock);
@@ -1495,7 +1495,7 @@ void mei_wd_timer(struct work_struct *work)
 		}
 	}
 out:
-	 schedule_delayed_work(&dev->wd_work, 2 * HZ);
+	 schedule_delayed_work(&dev->timer_work, 2 * HZ);
 	 mutex_unlock(&dev->device_lock);
 }
 
diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index 8d124724..7009937 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -170,7 +170,7 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 		       pdev->irq);
 		goto unmap_memory;
 	}
-	INIT_DELAYED_WORK(&dev->wd_work, mei_wd_timer);
+	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
 	if (mei_hw_init(dev)) {
 		printk(KERN_ERR "mei: Init hw failure.\n");
 		err = -ENODEV;
@@ -178,7 +178,7 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 	}
 	mei_device = pdev;
 	pci_set_drvdata(pdev, dev);
-	schedule_delayed_work(&dev->wd_work, HZ);
+	schedule_delayed_work(&dev->timer_work, HZ);
 
 	mutex_unlock(&mei_mutex);
 
@@ -1154,7 +1154,7 @@ static int mei_pci_resume(struct device *device)
 	/* Start watchdog if stopped in suspend */
 	if (dev->wd_timeout) {
 		dev->wd_due_counter = 1;
-		schedule_delayed_work(&dev->wd_work, HZ);
+		schedule_delayed_work(&dev->timer_work, HZ);
 	}
 	return err;
 }
diff --git a/drivers/staging/mei/mei_dev.h b/drivers/staging/mei/mei_dev.h
index 43d7e1c..6487be1 100644
--- a/drivers/staging/mei/mei_dev.h
+++ b/drivers/staging/mei/mei_dev.h
@@ -209,7 +209,7 @@ struct mei_device {
 	 * lock for the device
 	 */
 	struct mutex device_lock; /* device lock */
-	struct delayed_work wd_work;	/* watch dog deleye work */
+	struct delayed_work timer_work;	/* MEI timer delayed work (timeouts) */
 	bool recvd_msg;
 	/*
 	 * hw states of host and fw(ME)
@@ -336,7 +336,7 @@ void mei_host_client_properties(struct mei_device *dev);
  */
 irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id);
 irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id);
-void mei_wd_timer(struct work_struct *work);
+void mei_timer(struct work_struct *work);
 
 /*
  *  MEI input output function prototype
diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index 6643f7a..68c177b 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -142,7 +142,7 @@ int mei_wd_stop(struct mei_device *dev, bool preserve)
 	int ret;
 	u16 wd_timeout = dev->wd_timeout;
 
-	cancel_delayed_work(&dev->wd_work);
+	cancel_delayed_work(&dev->timer_work);
 	if (dev->wd_cl.state != MEI_FILE_CONNECTED || !dev->wd_timeout)
 		return 0;
 
-- 
1.7.4.1

