Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab1ELRLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:11:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53198 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab1ELRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:11:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SRCup1MSlqIRXKFiaDONCNgEkMcahqqWuaP3rN6VC8/VlC/e4WRIyix+oYzENBGuCx
         B3PWTP6t4UaRvjAnOEkIrninpJaRWPp4nxvOlVAXgKod9d55xzIFGyH5SPufehRrFjFm
         mfwvF+l2U23qa0cYcrU/DcMPqbxrux0jHwoG8=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: linux-pm@lists.linux-foundation.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>
Subject: [PATCH 4/4] DaVinci: vpfe: support for pm_loss
Date: Thu, 12 May 2011 19:11:05 +0200
Message-Id: <1305220265-9020-5-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
---
 drivers/media/video/davinci/vpfe_capture.c |   45 ++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 353eada..21fa9bf 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -74,6 +74,8 @@
 #include <media/v4l2-common.h>
 #include <linux/io.h>
 #include <media/davinci/vpfe_capture.h>
+#include <linux/pm.h>
+#include <linux/pm_loss.h>
 #include "ccdc_hw_device.h"
 
 static int debug;
@@ -2051,6 +2053,46 @@ static int __devexit vpfe_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_LOSS
+static int vpfe_capture_power_changed(struct device *dev,
+				      enum sys_power_state s)
+{
+	int ret;
+	struct vpfe_device *vpfe_dev = dev_get_drvdata(dev);
+	struct vpfe_subdev_info *sdinfo = vpfe_dev->current_subdev;
+
+	if (!sdinfo)
+		return -EINVAL;
+
+	if (!vpfe_dev->started) {
+		pr_debug_pm_loss("vpfe_capture_power_changed(%d) "
+				 "BUT NOTHING TO DO\n", s);
+		return 0;
+	}
+
+	sdinfo = vpfe_dev->current_subdev;
+
+	switch (s) {
+	case SYS_PWR_GOOD:
+		pr_debug_pm_loss("vpfe_capture_power_changed(%d)\n", s);
+		ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
+						 sdinfo->grp_id,
+						 video, s_stream, 1);
+		break;
+	case SYS_PWR_FAILING:
+		pr_debug_pm_loss("vpfe_capture_power_changed(%d)\n", s);
+		ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
+						 sdinfo->grp_id,
+						 video, s_stream, 0);
+		break;
+	default:
+		BUG();
+		ret = -ENODEV;
+	}
+	return ret;
+}
+#endif /* CONFIG_PM_LOSS */
+
 static int vpfe_suspend(struct device *dev)
 {
 	return 0;
@@ -2064,6 +2106,9 @@ static int vpfe_resume(struct device *dev)
 static const struct dev_pm_ops vpfe_dev_pm_ops = {
 	.suspend = vpfe_suspend,
 	.resume = vpfe_resume,
+#ifdef CONFIG_PM_LOSS
+	.power_changed = vpfe_capture_power_changed,
+#endif
 };
 
 static struct platform_driver vpfe_driver = {
-- 
1.7.0.4

