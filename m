Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab0HDVUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:20:08 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57593 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab0HDVS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:18:56 -0400
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCHv3 09/16] pps: don't disable interrupts when using spin locks
Date: Thu,  5 Aug 2010 01:06:46 +0400
Message-Id: <cde2add660f3354fcfe7a677ec6b5c57ba0d09aa.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
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
index d5f18ce..8c557c4 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -172,7 +172,6 @@ EXPORT_SYMBOL(pps_unregister_source);
 void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 		void *data)
 {
-	unsigned long flags;
 	int captured = 0;
 	struct pps_ktime ts_real;
 
@@ -186,7 +185,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 
 	timespec_to_pps_ktime(&ts_real, ts->ts_real);
 
-	spin_lock_irqsave(&pps->lock, flags);
+	spin_lock(&pps->lock);
 
 	/* Must call the echo function? */
 	if ((pps->params.mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)))
@@ -233,7 +232,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 		kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
 	}
 
-	spin_unlock_irqrestore(&pps->lock, flags);
+	spin_unlock(&pps->lock);
 }
 EXPORT_SYMBOL(pps_event);
 
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 81adb33..4f02718 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -73,12 +73,12 @@ static long pps_cdev_ioctl(struct file *file,
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
@@ -109,7 +109,7 @@ static long pps_cdev_ioctl(struct file *file,
 			return -EINVAL;
 		}
 
-		spin_lock_irq(&pps->lock);
+		spin_lock(&pps->lock);
 
 		/* Save the new parameters */
 		pps->params = params;
@@ -125,7 +125,7 @@ static long pps_cdev_ioctl(struct file *file,
 			pps->params.mode |= PPS_CANWAIT;
 		pps->params.api_version = PPS_API_VERS;
 
-		spin_unlock_irq(&pps->lock);
+		spin_unlock(&pps->lock);
 
 		break;
 
@@ -180,7 +180,7 @@ static long pps_cdev_ioctl(struct file *file,
 		}
 
 		/* Return the fetched timestamp */
-		spin_lock_irq(&pps->lock);
+		spin_lock(&pps->lock);
 
 		fdata.info.assert_sequence = pps->assert_sequence;
 		fdata.info.clear_sequence = pps->clear_sequence;
@@ -188,7 +188,7 @@ static long pps_cdev_ioctl(struct file *file,
 		fdata.info.clear_tu = pps->clear_tu;
 		fdata.info.current_mode = pps->current_mode;
 
-		spin_unlock_irq(&pps->lock);
+		spin_unlock(&pps->lock);
 
 		err = copy_to_user(uarg, &fdata, sizeof(struct pps_fdata));
 		if (err)
@@ -238,9 +238,9 @@ static void pps_device_destruct(struct device *dev)
 
 	/* release id here to protect others from using it while it's
 	 * still in use */
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	kfree(dev);
 }
@@ -258,9 +258,9 @@ int pps_register_cdev(struct pps_device *pps)
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
@@ -300,9 +300,9 @@ del_cdev:
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
1.7.1

