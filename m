Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1EJVUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:20:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48044 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1EJVUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qxpHiR2q7nQOYmw1/KUppu36NBSphfjpIkpyzAeGJRUAvg28Gc8UrKJS/kYJuN2Ywy
         huE/O5RBUS+tZql0Jd0C08m5RY3ugVz9u01aYz9cVtWng4v7MyzpDQtZ4Zn4LfxNBc0+
         DylaHs8bBPTQM6/Iy63GlgguOhWs3Tq2TBliE=
Date: Tue, 10 May 2011 23:20:38 +0200
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@linux.intel.com, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [PATCH] gma500: Add option to disable LVDS
Message-ID: <20110510212038.GA3279@patrik-macbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the option to load the driver without LVDS support. Some platforms with the gma500 have nothing hooked up to LVDS but only uses SDVO. LVDS is still detected and added as an encoder which causes SDVO mode-setting to fail.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 46ab028..f1c9f07 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -39,15 +39,18 @@ int drm_psb_debug;
 static int drm_psb_trap_pagefaults;
 
 int drm_psb_no_fb;
+int drm_psb_no_lvds;
 
 static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
 
 MODULE_PARM_DESC(debug, "Enable debug output");
 MODULE_PARM_DESC(no_fb, "Disable FBdev");
 MODULE_PARM_DESC(trap_pagefaults, "Error and reset on MMU pagefaults");
+MODULE_PARM_DESC(no_lvds, "Disable LVDS");
 module_param_named(debug, drm_psb_debug, int, 0600);
 module_param_named(no_fb, drm_psb_no_fb, int, 0600);
 module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
+module_param_named(no_lvds, drm_psb_no_lvds, int, 0600);
 
 
 static struct pci_device_id pciidlist[] = {
@@ -663,7 +666,9 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 		drm_kms_helper_poll_init(dev);
 	}
 
-	ret = psb_backlight_init(dev);
+	if (!drm_psb_no_lvds)
+		ret = psb_backlight_init(dev);
+
 	if (ret)
 		return ret;
 #if 0
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index e19a454..4593c80 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -671,6 +671,7 @@ extern int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern int drm_psb_debug;
 extern int drm_psb_no_fb;
 extern int drm_idle_check_interval;
+extern int drm_psb_no_lvds;
 
 #define PSB_DEBUG_GENERAL(_fmt, _arg...) \
 	PSB_DEBUG(PSB_D_GENERAL, _fmt, ##_arg)
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index ae097cd..7c00952 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -719,7 +719,8 @@ static void psb_setup_outputs(struct drm_device *dev)
 		else
 			DRM_ERROR("DSI is not supported\n");
 	} else {
-		psb_intel_lvds_init(dev, &dev_priv->mode_dev);
+		if (!drm_psb_no_lvds)
+			psb_intel_lvds_init(dev, &dev_priv->mode_dev);
 		psb_intel_sdvo_init(dev, SDVOB);
 	}
 
