Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0HWRsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:48:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab0HWRr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:47:59 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present detect
Date: Mon, 23 Aug 2010 19:53:21 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de, jlee@novell.com, Dennis.Jansen@web.de,
        linux-acpi@vger.kernel.org
References: <1282563648-21935-1-git-send-email-jlee@novell.com> <20100823114938.GA19879@srcf.ucam.org>
In-Reply-To: <20100823114938.GA19879@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008231953.22459.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 August 2010 13:49:38 Matthew Garrett wrote:
> On Mon, Aug 23, 2010 at 07:40:48PM +0800, Lee, Chun-Yi wrote:
> > There have some machines not support by i915 drm driver, e.g. MSI U110/U150,
> > there are use poulsbo chip and drm driver not support it because legal issue.
> > Those machines's acpi backlight control actually work fine and don't need apply
> > the intel opregion support.
> > So, add intel drm blacklist to intel_opregion_present, it can enable the acpi
> > brightness interface on Poulsbo/Morrestown.
> 
> I'm still kind of reluctant about this - doing the blacklisting here 
> means that there's no way for a native driver to inhibit registration 
> from occuring until after opregion setup has taken place, and we found 
> that that was necessary on some 915 so I suspect it is on gma500 as 
> well. Perhaps it should just be done as a module option, and then 
> distributions who want to deal with this case could set it by default?
Hm, needing a module option to get a system running is not what the user expects.
By default, the system should run fine and a module option should be added
as a workaround or for debugging only.

What do you think about below patch which introduces:
  - the blacklist based on the previous patch and comments
  - the module param -> as workaround and for trying out
  - let video.ko and i915_opregion share the same func to check
    for opregion support

Should I add a drm/i915 list for this to get another review?

Thanks,

    Thomas

-----------------
drm i915: Better communicate opregion support with video.ko

and add a i915 module parameter to enable/disable opregion code
and add a blacklist where we know opregion currently does not work.

This code is compile tested only on latest 2.6 Linus git tree.
Thorough review or some testing is still needed.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: joeyli.kernel@gmail.com
CC: gregkh@suse.de
CC: Dennis.Jansen@web.de
CC: linux-acpi@vger.kernel.org
CC: mjg@redhat.com

---
 drivers/acpi/video.c                 |   16 +++++--
 drivers/gpu/drm/i915/i915_opregion.c |   77 +++++++++++++++++++++++++++++++--
 include/drm/i915_drm.h               |    1 +
 include/linux/pci_ids.h              |    2 +
 4 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 67dec0c..b91b51e 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -46,6 +46,9 @@
 #include <acpi/acpi_drivers.h>
 #include <linux/suspend.h>
 #include <acpi/video.h>
+#if defined(CONFIG_DRM_I915) || defined(CONFIG_DRM_I915_MODULE)
+#include <drm/i915_drm.h>
+#endif
 
 #define PREFIX "ACPI: "
 
@@ -2557,17 +2560,20 @@ static int __init intel_opregion_present(void)
 {
 #if defined(CONFIG_DRM_I915) || defined(CONFIG_DRM_I915_MODULE)
 	struct pci_dev *dev = NULL;
-	u32 address;
+	int err;
 
 	for_each_pci_dev(dev) {
 		if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
 			continue;
 		if (dev->vendor != PCI_VENDOR_ID_INTEL)
 			continue;
-		pci_read_config_dword(dev, 0xfc, &address);
-		if (!address)
-			continue;
-		return 1;
+		err = intel_opregion_device_support(dev);
+		if (err == 0)
+			return 1;
+		else
+			ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No opregion support"
+					  " on Intel graphics card: %d\n",
+					  err));
 	}
 #endif
 	return 0;
diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
index ea5d3fe..eb49896 100644
--- a/drivers/gpu/drm/i915/i915_opregion.c
+++ b/drivers/gpu/drm/i915/i915_opregion.c
@@ -26,6 +26,8 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/pci_ids.h>
+#include <linux/pci.h>
 #include <acpi/video.h>
 
 #include "drmP.h"
@@ -464,15 +466,43 @@ blind_set:
 	goto end;
 }
 
-int intel_opregion_init(struct drm_device *dev, int resume)
+static int i915_opregion = 1;
+module_param_named(opregion, i915_opregion, int, 0400);
+MODULE_PARM_DESC(opregion, "opregion support (backlight,display output,..) "
+		 "(1=on [default], 0=off, 2=force)");
+
+static const struct pci_device_id intel_opregion_blacklist[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_VGA_0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_VGA_1) },
+	{ }
+};
+
+/* Returns zero if opregion device is supported or an error code if not */
+int intel_opregion_device_support(struct pci_dev *pdev)
 {
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct intel_opregion *opregion = &dev_priv->opregion;
+	struct intel_opregion opregion;
 	void *base;
 	u32 asls, mboxes;
-	int err = 0;
+	int i, err = 0;
+
+	if (i915_opregion == 0)
+		return -ENODEV;
+
+	for (i = 0; intel_opregion_blacklist[i].device != 0; i++) {
+		if (pdev->device == intel_opregion_blacklist[i].device) {
+			if (i915_opregion != 2) {
+				DRM_INFO("opregion support blacklisted for"
+					 " device %s, let video.ko handle it\n",
+					 pci_name(pdev));
+				return -ENOTSUPP;
+			} else {
+				DRM_INFO("Force opregion on blacklisted"
+					 " device %s\n", pci_name(pdev));
+			}
+		}
+	}
 
-	pci_read_config_dword(dev->pdev, PCI_ASLS, &asls);
+	pci_read_config_dword(pdev, PCI_ASLS, &asls);
 	DRM_DEBUG_DRIVER("graphic opregion physical addr: 0x%x\n", asls);
 	if (asls == 0) {
 		DRM_DEBUG_DRIVER("ACPI OpRegion not supported!\n");
@@ -483,6 +513,43 @@ int intel_opregion_init(struct drm_device *dev, int resume)
 	if (!base)
 		return -ENOMEM;
 
+	opregion.header = base;
+	if (memcmp(opregion.header->signature, OPREGION_SIGNATURE, 16)) {
+		DRM_DEBUG_DRIVER("opregion signature mismatch\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	mboxes = opregion.header->mboxes;
+	if (!(mboxes & MBOX_ACPI)) {
+		DRM_DEBUG_DRIVER("Public ACPI methods not supported\n");
+		err = -ENOTSUPP;
+		goto out;
+	}
+
+out:
+	iounmap(opregion.header);
+	return err;
+}
+EXPORT_SYMBOL_GPL(intel_opregion_device_support);
+
+int intel_opregion_init(struct drm_device *dev, int resume)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct intel_opregion *opregion = &dev_priv->opregion;
+	void *base;
+	u32 asls, mboxes;
+	int err = 0;
+
+	err = intel_opregion_device_support(dev->pdev);
+	if (err)
+		return err;
+
+	pci_read_config_dword(dev->pdev, PCI_ASLS, &asls);
+	base = ioremap(asls, OPREGION_SZ);
+	if (!base)
+		return -ENOMEM;
+
 	opregion->header = base;
 	if (memcmp(opregion->header->signature, OPREGION_SIGNATURE, 16)) {
 		DRM_DEBUG_DRIVER("opregion signature mismatch\n");
diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index 8f8b072..3fa5f20 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -40,6 +40,7 @@ extern bool i915_gpu_raise(void);
 extern bool i915_gpu_lower(void);
 extern bool i915_gpu_busy(void);
 extern bool i915_gpu_turbo_disable(void);
+extern int intel_opregion_device_support(struct pci_dev *pdev);
 #endif
 
 /* Each region is a minimum of 16k, and there are at most 255 of them.
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f6a3b2d..2861dd8 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2675,6 +2675,8 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_SCH_VGA_0	0x8108
+#define PCI_DEVICE_ID_INTEL_SCH_VGA_1	0x8109
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
 #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4
