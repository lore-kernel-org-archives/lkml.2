Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1EIPXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:23:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37198 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752067Ab1EIPXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:23:42 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 1/2] gma500: sort out the file operations
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 09 May 2011 16:04:32 +0100
Message-ID: <20110509150419.28865.74736.stgit@localhost.localdomain>
In-Reply-To: <20110509150334.28865.25665.stgit@localhost.localdomain>
References: <20110509150334.28865.25665.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Route everything via the proper DRM layer calls. This fixes the crash in
plymouth and is also necessary to begin supporting libkms.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc:stable@kernel.org

---

 drivers/staging/gma500/psb_drv.c |   50 +++++---------------------------------
 1 files changed, 6 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index b0bf1a0..360d582 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -1332,13 +1332,6 @@ static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 	return 0;
 }
 
-/* always available as we are SIGIO'd */
-static unsigned int psb_poll(struct file *filp,
-			     struct poll_table_struct *wait)
-{
-	return POLLIN | POLLRDNORM;
-}
-
 static int psb_driver_open(struct drm_device *dev, struct drm_file *priv)
 {
 	return 0;
@@ -1364,29 +1357,9 @@ static long psb_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		pm_runtime_allow(&dev->pdev->dev);
 		dev_priv->rpm_enabled = 1;
 	}
-	/*
-	 * The driver private ioctls should be thread-safe.
-	 */
-
-	if ((nr >= DRM_COMMAND_BASE) && (nr < DRM_COMMAND_END)
-	     && (nr < DRM_COMMAND_BASE + dev->driver->num_ioctls)) {
-		struct drm_ioctl_desc *ioctl =
-					&psb_ioctls[nr - DRM_COMMAND_BASE];
-
-		if (unlikely(ioctl->cmd != cmd)) {
-			DRM_ERROR(
-				"Invalid drm cmnd %d ioctl->cmd %x, cmd %x\n",
-				nr - DRM_COMMAND_BASE, ioctl->cmd, cmd);
-			return -EINVAL;
-		}
-
-		return drm_ioctl(filp, cmd, arg);
-	}
-	/*
-	 * Not all old drm ioctls are thread-safe.
-	 */
-
 	return drm_ioctl(filp, cmd, arg);
+	
+	/* FIXME: do we need to wrap the other side of this */
 }
 
 
@@ -1403,17 +1376,6 @@ static void psb_remove(struct pci_dev *pdev)
 	drm_put_dev(dev);
 }
 
-static int psb_open(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
-
-static int psb_release(struct inode *inode, struct file *filp)
-{
-	return 0;
-}
-
-
 static const struct dev_pm_ops psb_pm_ops = {
 	.runtime_suspend = psb_runtime_suspend,
 	.runtime_resume = psb_runtime_resume,
@@ -1457,11 +1419,11 @@ static struct drm_driver driver = {
 
 	.fops = {
 		 .owner = THIS_MODULE,
-		 .open = psb_open,
-		 .release = psb_release,
+		 .open = drm_open,
+		 .release = drm_release,
 		 .unlocked_ioctl = psb_unlocked_ioctl,
-		/* .mmap = psb_mmap, */
-		 .poll = psb_poll,
+		 .mmap = drm_mmap,
+		 .poll = drm_poll,
 		 .fasync = drm_fasync,
 		 .read = drm_read,
 		 },

