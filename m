Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab0KRQMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:12:37 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:36017 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0KRQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:12:33 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>, Tejun Heo <tj@kernel.org>
Subject: [PATCHv4 09/17] pps: don't disable interrupts when using spin locks
Date: Thu, 18 Nov 2010 19:01:02 +0300
Message-Id: <9e636c291cc28c3dda3762230fa595ec6384dbef.1290087479.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all PPS spin locks are never used in interrupt context so we can
safely replace spin_lock_irq*/spin_unlock_irq* with plain
spin_lock/spin_unlock.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/kapi.c |    5 ++---
 drivers/pps/pps.c  |   24 ++++++++++++------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index ca3b4f8..fe832aa 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -176,7 +176,6 @@ EXPORT_SYMBOL(pps_unregister_source);
 void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 		void *data)
 {
-	unsigned long flags;
 	int captured = 0;
 	struct pps_ktime ts_real;
 
@@ -190,7 +189,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 
 	timespec_to_pps_ktime(&ts_real, ts->ts_real);
 
-	spin_lock_irqsave(&pps->lock, flags);
+	spin_lock(&pps->lock);
 
 	/* Must call the echo function? */
 	if ((pps->params.mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)))
@@ -237,7 +236,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 		kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
 	}
 
-	spin_unlock_irqrestore(&pps->lock, flags);
+	spin_unlock(&pps->lock);
 }
 EXPORT_SYMBOL(pps_event);
 
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index f642558..d3267f3 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -74,12 +74,12 @@ static long pps_cdev_ioctl(struct file *file,
 	case PPS_GETPARAMS:
 		dev_dbg(pps->dev, "PPS_GETPARAMS\n");
 
-		spin_lock_irq(&pps->lock);
+		spin_lock(&pps->lock);
 
 		/* Get the current parameters */
 		params = pps->params;
 
-		spin_unlock_irq(&pps->lock);
+		spin_unlock(&pps->lock);
 
 		err = copy_to_user(uarg, &params, sizeof(struct pps_kparams));
 		if (err)
@@ -110,7 +110,7 @@ static long pps_cdev_ioctl(struct file *file,
 			return -EINVAL;
 		}
 
-		spin_lock_irq(&pps->lock);
+		spin_lock(&pps->lock);
 
 		/* Save the new parameters */
 		pps->params = params;
@@ -126,7 +126,7 @@ static long pps_cdev_ioctl(struct file *file,
 			pps->params.mode |= PPS_CANWAIT;
 		pps->params.api_version = PPS_API_VERS;
 
-		spin_unlock_irq(&pps->lock);
+		spin_unlock(&pps->lock);
 
 		break;
 
@@ -181,7 +181,7 @@ static long pps_cdev_ioctl(struct file *file,
 		}
 
 		/* Return the fetched timestamp */
-		spin_lock_irq(&pps->lock);
+		spin_lock(&pps->lock);
 
 		fdata.info.assert_sequence = pps->assert_sequence;
 		fdata.info.clear_sequence = pps->clear_sequence;
@@ -189,7 +189,7 @@ static long pps_cdev_ioctl(struct file *file,
 		fdata.info.clear_tu = pps->clear_tu;
 		fdata.info.current_mode = pps->current_mode;
 
-		spin_unlock_irq(&pps->lock);
+		spin_unlock(&pps->lock);
 
 		err = copy_to_user(uarg, &fdata, sizeof(struct pps_fdata));
 		if (err)
@@ -239,9 +239,9 @@ static void pps_device_destruct(struct device *dev)
 
 	/* release id here to protect others from using it while it's
 	 * still in use */
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	kfree(dev);
 	kfree(pps);
@@ -260,9 +260,9 @@ int pps_register_cdev(struct pps_device *pps)
 	 * After idr_get_new() calling the new source will be freely available
 	 * into the kernel.
 	 */
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	err = idr_get_new(&pps_idr, pps, &pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	if (err < 0)
 		return err;
@@ -302,9 +302,9 @@ del_cdev:
 	cdev_del(&pps->cdev);
 
 free_idr:
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	return err;
 }
-- 
1.7.2.3

