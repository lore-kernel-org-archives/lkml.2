Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1CNR7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:59:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:62432 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab1CNR7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:59:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,317,1297065600"; 
   d="scan'208";a="402422930"
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Dave Airlie <airlied@linux.ie>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@linux.intel.com>, Keith Packard <keithp@keithp.com>,
        Len Brown <lenb@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] ACPI/Intel: Rework Opregion support
Date: Mon, 14 Mar 2011 17:59:26 +0000
Message-Id: <1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298404994-2907-1-git-send-email-mjg@redhat.com>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

The Integrated Graphics Device opregion specification defines a mechanism
for the OS and system firmware to collaborate on various graphics-related
functionality. This is currently implemented in the i915 driver but isn't
strictly limited to these devices. Move it to a more generic location and
remove the i915 dependency, while simultaneously reworking i915 to make
use of the new driver.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Keith Packard <keithp@keithp.com>
Cc: Len Brown <lenb@kernel.org>
[ickle: rebase onto drm-core-next]
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---

Note: neither the opregion_dev interface or the alse_set_* properly report
failures. As such we have a slight change in behaviour on Ironlake+
platforms and an uncorrected bug for earlier chipsets.
-Chris

---
 drivers/acpi/Kconfig                  |    8 +
 drivers/acpi/Makefile                 |    1 +
 drivers/acpi/acpi_igd_opregion.c      |  411 ++++++++++++++++++++++++++
 drivers/gpu/drm/Kconfig               |    1 +
 drivers/gpu/drm/i915/Makefile         |    1 -
 drivers/gpu/drm/i915/i915_debugfs.c   |    2 +-
 drivers/gpu/drm/i915/i915_dma.c       |   13 +-
 drivers/gpu/drm/i915/i915_drv.c       |    6 +-
 drivers/gpu/drm/i915/i915_drv.h       |   34 +--
 drivers/gpu/drm/i915/i915_irq.c       |    7 +-
 drivers/gpu/drm/i915/intel_bios.c     |    8 +-
 drivers/gpu/drm/i915/intel_lvds.c     |    2 +-
 drivers/gpu/drm/i915/intel_opregion.c |  516 ---------------------------------
 drivers/gpu/drm/i915/intel_panel.c    |    4 +-
 include/acpi/acpi_igd_opregion.h      |  105 +++++++
 15 files changed, 552 insertions(+), 567 deletions(-)
 create mode 100644 drivers/acpi/acpi_igd_opregion.c
 delete mode 100644 drivers/gpu/drm/i915/intel_opregion.c
 create mode 100644 include/acpi/acpi_igd_opregion.h

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 2aa042a..7ace174 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -383,4 +383,12 @@ config ACPI_HED
 
 source "drivers/acpi/apei/Kconfig"
 
+config ACPI_IGD_OPREGION
+       tristate "ACPI Integrated Graphics Device OpRegion support"
+       help
+         This driver adds support for the Intel ACPI Integrated Graphics
+	 Device OpRegion specification, allowing communication between
+	 the firmware and graphics driver on mobile systems with Intel
+	 graphics
+
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index d113fa5..dcade4b 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_ACPI_SBS)		+= sbs.o
 obj-$(CONFIG_ACPI_POWER_METER)	+= power_meter.o
 obj-$(CONFIG_ACPI_HED)		+= hed.o
 obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
+obj-$(CONFIG_ACPI_IGD_OPREGION)	+= acpi_igd_opregion.o
 
 # processor has its own "processor." module_param namespace
 processor-y			:= processor_driver.o processor_throttling.o
diff --git a/drivers/acpi/acpi_igd_opregion.c b/drivers/acpi/acpi_igd_opregion.c
new file mode 100644
index 0000000..0015ca8
--- /dev/null
+++ b/drivers/acpi/acpi_igd_opregion.c
@@ -0,0 +1,411 @@
+/*
+ * Copyright 2008 Intel Corporation <hong.liu@intel.com>
+ * Copyright 2008 Red Hat <mjg@redhat.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining
+ * a copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial
+ * portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NON-INFRINGEMENT.  IN NO EVENT SHALL INTEL AND/OR ITS SUPPLIERS BE
+ * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <linux/acpi.h>
+#include <linux/acpi_io.h>
+#include <acpi/video.h>
+#include <acpi/acpi_igd_opregion.h>
+#include <drm/drmP.h>
+
+#define PCI_ASLE 0xe4
+#define PCI_ASLS 0xfc
+
+#define OPREGION_HEADER_OFFSET 0
+#define OPREGION_ACPI_OFFSET   0x100
+#define   ACPI_CLID 0x01ac /* current lid state indicator */
+#define   ACPI_CDCK 0x01b0 /* current docking state indicator */
+#define OPREGION_SWSCI_OFFSET  0x200
+#define OPREGION_ASLE_OFFSET   0x300
+#define OPREGION_VBT_OFFSET    0x400
+
+#define OPREGION_SIGNATURE "IntelGraphicsMem"
+#define MBOX_ACPI      (1<<0)
+#define MBOX_SWSCI     (1<<1)
+#define MBOX_ASLE      (1<<2)
+
+/* ASLE irq request bits */
+#define ASLE_SET_ALS_ILLUM     (1 << 0)
+#define ASLE_SET_BACKLIGHT     (1 << 1)
+#define ASLE_SET_PFIT          (1 << 2)
+#define ASLE_SET_PWM_FREQ      (1 << 3)
+#define ASLE_REQ_MSK           0xf
+
+/* response bits of ASLE irq request */
+#define ASLE_ALS_ILLUM_FAILED	(1<<10)
+#define ASLE_BACKLIGHT_FAILED	(1<<12)
+#define ASLE_PFIT_FAILED	(1<<14)
+#define ASLE_PWM_FREQ_FAILED	(1<<16)
+
+/* ASLE backlight brightness to set */
+#define ASLE_BCLP_VALID                (1<<31)
+#define ASLE_BCLP_MSK          (~(1<<31))
+
+/* ASLE panel fitting request */
+#define ASLE_PFIT_VALID         (1<<31)
+#define ASLE_PFIT_CENTER (1<<0)
+#define ASLE_PFIT_STRETCH_TEXT (1<<1)
+#define ASLE_PFIT_STRETCH_GFX (1<<2)
+
+/* PWM frequency and minimum brightness */
+#define ASLE_PFMB_BRIGHTNESS_MASK (0xff)
+#define ASLE_PFMB_BRIGHTNESS_VALID (1<<8)
+#define ASLE_PFMB_PWM_MASK (0x7ffffe00)
+#define ASLE_PFMB_PWM_VALID (1<<31)
+
+#define ASLE_CBLV_VALID         (1<<31)
+
+#define ACPI_OTHER_OUTPUT (0<<8)
+#define ACPI_VGA_OUTPUT (1<<8)
+#define ACPI_TV_OUTPUT (2<<8)
+#define ACPI_DIGITAL_OUTPUT (3<<8)
+#define ACPI_LVDS_OUTPUT (4<<8)
+
+#ifdef CONFIG_ACPI
+static u32 asle_set_backlight(struct opregion_dev *dev, u32 bclp)
+{
+	struct opregion_asle *asle = dev->opregion.asle;
+	u32 max = dev->max_backlight;
+
+	if (!(bclp & ASLE_BCLP_VALID))
+		return ASLE_BACKLIGHT_FAILED;
+
+	bclp &= ASLE_BCLP_MSK;
+	if (bclp > 255)
+		return ASLE_BACKLIGHT_FAILED;
+
+	if (dev->set_backlight)
+		dev->set_backlight(dev->drm_dev, bclp * max / 255);
+
+	asle->cblv = (bclp*0x64)/0xff | ASLE_CBLV_VALID;
+
+	return 0;
+}
+
+static u32 asle_set_als_illum(struct opregion_dev *dev, u32 alsi)
+{
+	if (dev->set_als_illum)
+		dev->set_als_illum(dev->drm_dev, alsi);
+	return 0;
+}
+
+static u32 asle_set_pwm_freq(struct opregion_dev *dev, u32 pfmb)
+{
+	if (pfmb & ASLE_PFMB_PWM_VALID) {
+		if (dev->set_pwm_freq)
+			dev->set_pwm_freq(dev->drm_dev, pfmb);
+	}
+	return 0;
+}
+
+static u32 asle_set_pfit(struct opregion_dev *dev, u32 pfit)
+{
+	if (!(pfit & ASLE_PFIT_VALID))
+		return ASLE_PFIT_FAILED;
+
+	if (dev->set_pfit)
+		dev->set_pfit(dev->drm_dev, pfit);
+
+	return 0;
+}
+
+void igd_opregion_intr(struct opregion_dev *dev)
+{
+	struct opregion_asle *asle = dev->opregion.asle;
+	u32 asle_stat = 0;
+	u32 asle_req;
+
+	if (!asle)
+		return;
+
+	asle_req = asle->aslc & ASLE_REQ_MSK;
+
+	if (!asle_req) {
+		DRM_DEBUG_DRIVER("non asle set request??\n");
+		return;
+	}
+
+	if (asle_req & ASLE_SET_ALS_ILLUM)
+		asle_stat |= asle_set_als_illum(dev, asle->alsi);
+
+	if (asle_req & ASLE_SET_BACKLIGHT)
+		asle_stat |= asle_set_backlight(dev, asle->bclp);
+
+	if (asle_req & ASLE_SET_PFIT)
+		asle_stat |= asle_set_pfit(dev, asle->pfit);
+
+	if (asle_req & ASLE_SET_PWM_FREQ)
+		asle_stat |= asle_set_pwm_freq(dev, asle->pfmb);
+
+	asle->aslc = asle_stat;
+}
+EXPORT_SYMBOL(igd_opregion_intr);
+
+#define ASLE_ALS_EN    (1<<0)
+#define ASLE_BLC_EN    (1<<1)
+#define ASLE_PFIT_EN   (1<<2)
+#define ASLE_PFMB_EN   (1<<3)
+
+void igd_opregion_enable_asle(struct opregion_dev *dev)
+{
+	struct opregion_asle *asle = dev->opregion.asle;
+
+	if (asle && dev->enable_asle) {
+		dev->enable_asle(dev->drm_dev);
+
+		asle->tche = ASLE_ALS_EN | ASLE_BLC_EN | ASLE_PFIT_EN |
+			ASLE_PFMB_EN;
+		asle->ardy = 1;
+	}
+}
+EXPORT_SYMBOL(igd_opregion_enable_asle);
+
+#define ACPI_EV_DISPLAY_SWITCH (1<<0)
+#define ACPI_EV_LID            (1<<1)
+#define ACPI_EV_DOCK           (1<<2)
+
+static struct igd_opregion *system_opregion;
+
+static int igd_opregion_video_event(struct notifier_block *nb,
+				      unsigned long val, void *data)
+{
+	/* The only video events relevant to opregion are 0x80. These indicate
+	   either a docking event, lid switch or display switch request. In
+	   Linux, these are handled by the dock, button and video drivers.
+	   We might want to fix the video driver to be opregion-aware in
+	   future, but right now we just indicate to the firmware that the
+	   request has been handled */
+
+	struct opregion_acpi *acpi;
+
+	if (!system_opregion)
+		return NOTIFY_DONE;
+
+	acpi = system_opregion->acpi;
+	acpi->csts = 0;
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block igd_opregion_notifier = {
+	.notifier_call = igd_opregion_video_event,
+};
+
+/*
+ * Initialise the DIDL field in opregion. This passes a list of devices to
+ * the firmware. Values are defined by section B.4.2 of the ACPI specification
+ * (version 3)
+ */
+
+static void igd_didl_outputs(struct opregion_dev *dev)
+{
+	struct igd_opregion *opregion = &dev->opregion;
+	struct drm_connector *connector;
+	acpi_handle handle;
+	struct acpi_device *acpi_dev, *acpi_cdev, *acpi_video_bus = NULL;
+	unsigned long long device_id;
+	acpi_status status;
+	int i = 0;
+
+	handle = DEVICE_ACPI_HANDLE(&dev->drm_dev->pdev->dev);
+	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev)))
+		return;
+
+	if (acpi_is_video_device(acpi_dev))
+		acpi_video_bus = acpi_dev;
+	else {
+		list_for_each_entry(acpi_cdev, &acpi_dev->children, node) {
+			if (acpi_is_video_device(acpi_cdev)) {
+				acpi_video_bus = acpi_cdev;
+				break;
+			}
+		}
+	}
+
+	if (!acpi_video_bus) {
+		printk(KERN_WARNING "No ACPI video bus found\n");
+		return;
+	}
+
+	list_for_each_entry(acpi_cdev, &acpi_video_bus->children, node) {
+		if (i >= 8) {
+			dev_printk(KERN_ERR, &dev->drm_dev->pdev->dev,
+				   "More than 8 outputs detected\n");
+			return;
+		}
+		status =
+			acpi_evaluate_integer(acpi_cdev->handle, "_ADR",
+						NULL, &device_id);
+		if (ACPI_SUCCESS(status)) {
+			if (!device_id)
+				goto blind_set;
+			opregion->acpi->didl[i] = (u32)(device_id & 0x0f0f);
+			i++;
+		}
+	}
+
+end:
+	/* If fewer than 8 outputs, the list must be null terminated */
+	if (i < 8)
+		opregion->acpi->didl[i] = 0;
+	return;
+
+blind_set:
+	i = 0;
+	list_for_each_entry(connector, &dev->drm_dev->mode_config.connector_list, head) {
+		int output_type = ACPI_OTHER_OUTPUT;
+		if (i >= 8) {
+			dev_printk(KERN_ERR, &dev->drm_dev->pdev->dev,
+				   "More than 8 outputs detected\n");
+			return;
+		}
+		switch (connector->connector_type) {
+		case DRM_MODE_CONNECTOR_VGA:
+		case DRM_MODE_CONNECTOR_DVIA:
+			output_type = ACPI_VGA_OUTPUT;
+			break;
+		case DRM_MODE_CONNECTOR_Composite:
+		case DRM_MODE_CONNECTOR_SVIDEO:
+		case DRM_MODE_CONNECTOR_Component:
+		case DRM_MODE_CONNECTOR_9PinDIN:
+			output_type = ACPI_TV_OUTPUT;
+			break;
+		case DRM_MODE_CONNECTOR_DVII:
+		case DRM_MODE_CONNECTOR_DVID:
+		case DRM_MODE_CONNECTOR_DisplayPort:
+		case DRM_MODE_CONNECTOR_HDMIA:
+		case DRM_MODE_CONNECTOR_HDMIB:
+			output_type = ACPI_DIGITAL_OUTPUT;
+			break;
+		case DRM_MODE_CONNECTOR_LVDS:
+			output_type = ACPI_LVDS_OUTPUT;
+			break;
+		}
+		opregion->acpi->didl[i] |= (1<<31) | output_type | i;
+		i++;
+	}
+	goto end;
+}
+
+void igd_opregion_init(struct opregion_dev *dev)
+{
+	struct igd_opregion *opregion = &dev->opregion;
+
+	if (!opregion->header)
+		return;
+
+	if (opregion->acpi) {
+		if (drm_core_check_feature(dev->drm_dev, DRIVER_MODESET))
+			igd_didl_outputs(dev);
+
+		/* Notify BIOS we are ready to handle ACPI video ext notifs.
+		 * Right now, all the events are handled by the ACPI video module.
+		 * We don't actually need to do anything with them. */
+		opregion->acpi->csts = 0;
+		opregion->acpi->drdy = 1;
+
+		system_opregion = opregion;
+		register_acpi_notifier(&igd_opregion_notifier);
+	}
+
+	if (opregion->asle)
+		dev->enable_asle(dev->drm_dev);
+}
+EXPORT_SYMBOL(igd_opregion_init);
+
+void igd_opregion_fini(struct opregion_dev *dev)
+{
+	struct igd_opregion *opregion = &dev->opregion;
+
+	if (!opregion->header)
+		return;
+
+	if (opregion->acpi) {
+		opregion->acpi->drdy = 0;
+
+		system_opregion = NULL;
+		unregister_acpi_notifier(&igd_opregion_notifier);
+	}
+
+	/* just clear all opregion memory pointers now */
+	iounmap(opregion->header);
+	opregion->header = NULL;
+	opregion->acpi = NULL;
+	opregion->swsci = NULL;
+	opregion->asle = NULL;
+	opregion->vbt = NULL;
+}
+EXPORT_SYMBOL(igd_opregion_fini);
+#endif
+
+int igd_opregion_setup(struct opregion_dev *dev)
+{
+	struct igd_opregion *opregion = &dev->opregion;
+	void *base;
+	u32 asls, mboxes;
+	int err = 0;
+
+	pci_read_config_dword(dev->drm_dev->pdev, PCI_ASLS, &asls);
+	DRM_DEBUG_DRIVER("graphic opregion physical addr: 0x%x\n", asls);
+	if (asls == 0) {
+		DRM_DEBUG_DRIVER("ACPI OpRegion not supported!\n");
+		return -ENOTSUPP;
+	}
+
+	base = acpi_os_ioremap(asls, OPREGION_SIZE);
+	if (!base)
+		return -ENOMEM;
+
+	if (memcmp(base, OPREGION_SIGNATURE, 16)) {
+		DRM_DEBUG_DRIVER("opregion signature mismatch\n");
+		err = -EINVAL;
+		goto err_out;
+	}
+	opregion->header = base;
+	opregion->vbt = base + OPREGION_VBT_OFFSET;
+
+	mboxes = opregion->header->mboxes;
+	if (mboxes & MBOX_ACPI) {
+		DRM_DEBUG_DRIVER("Public ACPI methods supported\n");
+		opregion->acpi = base + OPREGION_ACPI_OFFSET;
+	}
+
+	if (mboxes & MBOX_SWSCI) {
+		DRM_DEBUG_DRIVER("SWSCI supported\n");
+		opregion->swsci = base + OPREGION_SWSCI_OFFSET;
+	}
+	if (mboxes & MBOX_ASLE) {
+		DRM_DEBUG_DRIVER("ASLE supported\n");
+		opregion->asle = base + OPREGION_ASLE_OFFSET;
+	}
+
+	return 0;
+
+err_out:
+	iounmap(base);
+	return err;
+}
+EXPORT_SYMBOL(igd_opregion_setup);
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index a6feb78c..501f4dc 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -99,6 +99,7 @@ config DRM_I915
 	select INPUT if ACPI
 	select ACPI_VIDEO if ACPI
 	select ACPI_BUTTON if ACPI
+	select ACPI_IGD_OPREGION if ACPI
 	help
 	  Choose this option if you have a system that has "Intel Graphics
 	  Media Accelerator" or "HD Graphics" integrated graphics,
diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 0ae6a7c..776c362 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -28,7 +28,6 @@ i915-y := i915_drv.o i915_dma.o i915_irq.o i915_mem.o \
 	  intel_dvo.o \
 	  intel_ringbuffer.o \
 	  intel_overlay.o \
-	  intel_opregion.o \
 	  dvo_ch7xxx.o \
 	  dvo_ch7017.o \
 	  dvo_ivch.o \
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 09e0327..e67ff81 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1129,7 +1129,7 @@ static int i915_opregion(struct seq_file *m, void *unused)
 	struct drm_info_node *node = (struct drm_info_node *) m->private;
 	struct drm_device *dev = node->minor->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct intel_opregion *opregion = &dev_priv->opregion;
+	struct igd_opregion *opregion = &dev_priv->opregion_dev.opregion;
 	int ret;
 
 	ret = mutex_lock_interruptible(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 7273037..ff057a8 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1990,7 +1990,14 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	/* Try to make sure MCHBAR is enabled before poking at it */
 	intel_setup_mchbar(dev);
 	intel_setup_gmbus(dev);
-	intel_opregion_setup(dev);
+
+	if (IS_MOBILE(dev)) {
+		dev_priv->opregion_dev.max_backlight = intel_panel_get_max_backlight(dev);
+		dev_priv->opregion_dev.set_backlight = intel_panel_set_backlight;
+	}
+	dev_priv->opregion_dev.enable_asle = intel_enable_asle;
+	dev_priv->opregion_dev.drm_dev = dev;
+	igd_opregion_setup(&dev_priv->opregion_dev);
 
 	/* Make sure the bios did its job and set up vital registers */
 	intel_setup_bios(dev);
@@ -2049,7 +2056,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	}
 
 	/* Must be done after probing outputs */
-	intel_opregion_init(dev);
+	igd_opregion_init(&dev_priv->opregion_dev);
 	acpi_video_register();
 
 	setup_timer(&dev_priv->hangcheck_timer, i915_hangcheck_elapsed,
@@ -2138,7 +2145,7 @@ int i915_driver_unload(struct drm_device *dev)
 	if (dev->pdev->msi_enabled)
 		pci_disable_msi(dev->pdev);
 
-	intel_opregion_fini(dev);
+	igd_opregion_fini(&dev_priv->opregion_dev);
 
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		/* Flush any outstanding unpin_work. */
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index c34a8dd..cf66ca8 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -316,7 +316,7 @@ static int i915_drm_freeze(struct drm_device *dev)
 
 	i915_save_state(dev);
 
-	intel_opregion_fini(dev);
+	igd_opregion_fini(&dev_priv->opregion_dev);
 
 	/* Modeset on resume, not lid events */
 	dev_priv->modeset_on_lid = 0;
@@ -366,7 +366,7 @@ static int i915_drm_thaw(struct drm_device *dev)
 	}
 
 	i915_restore_state(dev);
-	intel_opregion_setup(dev);
+	igd_opregion_setup(&dev_priv->opregion_dev);
 
 	/* KMS EnterVT equivalent */
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
@@ -386,7 +386,7 @@ static int i915_drm_thaw(struct drm_device *dev)
 			ironlake_enable_rc6(dev);
 	}
 
-	intel_opregion_init(dev);
+	igd_opregion_init(&dev_priv->opregion_dev);
 
 	dev_priv->modeset_on_lid = 0;
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 4496505..4d2475b 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -36,6 +36,7 @@
 #include <linux/io-mapping.h>
 #include <linux/i2c.h>
 #include <drm/intel-gtt.h>
+#include <acpi/acpi_igd_opregion.h>
 
 /* General customization:
  */
@@ -102,21 +103,6 @@ struct mem_block {
 	struct drm_file *file_priv; /* NULL: free, -1: heap, other: real files */
 };
 
-struct opregion_header;
-struct opregion_acpi;
-struct opregion_swsci;
-struct opregion_asle;
-
-struct intel_opregion {
-	struct opregion_header *header;
-	struct opregion_acpi *acpi;
-	struct opregion_swsci *swsci;
-	struct opregion_asle *asle;
-	void *vbt;
-	u32 __iomem *lid_state;
-};
-#define OPREGION_SIZE            (8*1024)
-
 struct intel_overlay;
 struct intel_overlay_error_state;
 
@@ -322,7 +308,7 @@ typedef struct drm_i915_private {
 	int cfb_plane;
 	int cfb_y;
 
-	struct intel_opregion opregion;
+	struct opregion_dev opregion_dev;
 
 	/* overlay */
 	struct intel_overlay *overlay;
@@ -1237,22 +1223,6 @@ extern inline bool intel_gmbus_is_forced_bit(struct i2c_adapter *adapter)
 }
 extern void intel_i2c_reset(struct drm_device *dev);
 
-/* intel_opregion.c */
-extern int intel_opregion_setup(struct drm_device *dev);
-#ifdef CONFIG_ACPI
-extern void intel_opregion_init(struct drm_device *dev);
-extern void intel_opregion_fini(struct drm_device *dev);
-extern void intel_opregion_asle_intr(struct drm_device *dev);
-extern void intel_opregion_gse_intr(struct drm_device *dev);
-extern void intel_opregion_enable_asle(struct drm_device *dev);
-#else
-static inline void intel_opregion_init(struct drm_device *dev) { return; }
-static inline void intel_opregion_fini(struct drm_device *dev) { return; }
-static inline void intel_opregion_asle_intr(struct drm_device *dev) { return; }
-static inline void intel_opregion_gse_intr(struct drm_device *dev) { return; }
-static inline void intel_opregion_enable_asle(struct drm_device *dev) { return; }
-#endif
-
 /* intel_acpi.c */
 #ifdef CONFIG_ACPI
 extern void intel_register_dsm_handler(void);
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 188b497..8d9f406 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -496,7 +496,7 @@ static irqreturn_t ironlake_irq_handler(struct drm_device *dev)
 		notify_ring(dev, &dev_priv->ring[BCS]);
 
 	if (de_iir & DE_GSE)
-		intel_opregion_gse_intr(dev);
+		igd_opregion_intr(&dev_priv->opregion_dev);
 
 	if (de_iir & DE_PLANEA_FLIP_DONE) {
 		intel_prepare_page_flip(dev, 0);
@@ -1203,9 +1203,8 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 				blc_event = true;
 		}
 
-
 		if (blc_event || (iir & I915_ASLE_INTERRUPT))
-			intel_opregion_asle_intr(dev);
+			igd_opregion_intr(&dev_priv->opregion_dev);
 
 		/* With MSI, interrupts are only generated when iir
 		 * transitions from zero to nonzero.  If another bit got
@@ -1762,7 +1761,7 @@ int i915_driver_irq_postinstall(struct drm_device *dev)
 		I915_WRITE(PORT_HOTPLUG_EN, hotplug_en);
 	}
 
-	intel_opregion_enable_asle(dev);
+	igd_opregion_enable_asle(&dev_priv->opregion_dev);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index fb5b4d4..5123cf9 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -611,15 +611,15 @@ intel_parse_bios(struct drm_device *dev)
 
 	init_vbt_defaults(dev_priv);
 
-	/* XXX Should this validation be moved to intel_opregion.c? */
-	if (dev_priv->opregion.vbt) {
-		struct vbt_header *vbt = dev_priv->opregion.vbt;
+	/* XXX Should this validation be moved to acpi_igd_opregion.c? */
+	if (dev_priv->opregion_dev.opregion.vbt) {
+		struct vbt_header *vbt = dev_priv->opregion_dev.opregion.vbt;
 		if (memcmp(vbt->signature, "$VBT", 4) == 0) {
 			DRM_DEBUG_DRIVER("Using VBT from OpRegion: %20s\n",
 					 vbt->signature);
 			bdb = (struct bdb_header *)((char *)vbt + vbt->bdb_offset);
 		} else
-			dev_priv->opregion.vbt = NULL;
+			dev_priv->opregion_dev.opregion.vbt = NULL;
 	}
 
 	if (bdb == NULL) {
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 1a311ad..a499e867e 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -828,7 +828,7 @@ static bool lvds_is_present_in_vbt(struct drm_device *dev,
 		 * additional data.  Trust that if the VBT was written into
 		 * the OpRegion then they have validated the LVDS's existence.
 		 */
-		if (dev_priv->opregion.vbt)
+		if (dev_priv->opregion_dev.opregion.vbt)
 			return true;
 	}
 
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
deleted file mode 100644
index d2c7104..0000000
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ /dev/null
@@ -1,516 +0,0 @@
-/*
- * Copyright 2008 Intel Corporation <hong.liu@intel.com>
- * Copyright 2008 Red Hat <mjg@redhat.com>
- *
- * Permission is hereby granted, free of charge, to any person obtaining
- * a copy of this software and associated documentation files (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sub license, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so, subject to
- * the following conditions:
- *
- * The above copyright notice and this permission notice (including the
- * next paragraph) shall be included in all copies or substantial
- * portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NON-INFRINGEMENT.  IN NO EVENT SHALL INTEL AND/OR ITS SUPPLIERS BE
- * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#include <linux/acpi.h>
-#include <linux/acpi_io.h>
-#include <acpi/video.h>
-
-#include "drmP.h"
-#include "i915_drm.h"
-#include "i915_drv.h"
-#include "intel_drv.h"
-
-#define PCI_ASLE 0xe4
-#define PCI_ASLS 0xfc
-
-#define OPREGION_HEADER_OFFSET 0
-#define OPREGION_ACPI_OFFSET   0x100
-#define   ACPI_CLID 0x01ac /* current lid state indicator */
-#define   ACPI_CDCK 0x01b0 /* current docking state indicator */
-#define OPREGION_SWSCI_OFFSET  0x200
-#define OPREGION_ASLE_OFFSET   0x300
-#define OPREGION_VBT_OFFSET    0x400
-
-#define OPREGION_SIGNATURE "IntelGraphicsMem"
-#define MBOX_ACPI      (1<<0)
-#define MBOX_SWSCI     (1<<1)
-#define MBOX_ASLE      (1<<2)
-
-struct opregion_header {
-       u8 signature[16];
-       u32 size;
-       u32 opregion_ver;
-       u8 bios_ver[32];
-       u8 vbios_ver[16];
-       u8 driver_ver[16];
-       u32 mboxes;
-       u8 reserved[164];
-} __attribute__((packed));
-
-/* OpRegion mailbox #1: public ACPI methods */
-struct opregion_acpi {
-       u32 drdy;       /* driver readiness */
-       u32 csts;       /* notification status */
-       u32 cevt;       /* current event */
-       u8 rsvd1[20];
-       u32 didl[8];    /* supported display devices ID list */
-       u32 cpdl[8];    /* currently presented display list */
-       u32 cadl[8];    /* currently active display list */
-       u32 nadl[8];    /* next active devices list */
-       u32 aslp;       /* ASL sleep time-out */
-       u32 tidx;       /* toggle table index */
-       u32 chpd;       /* current hotplug enable indicator */
-       u32 clid;       /* current lid state*/
-       u32 cdck;       /* current docking state */
-       u32 sxsw;       /* Sx state resume */
-       u32 evts;       /* ASL supported events */
-       u32 cnot;       /* current OS notification */
-       u32 nrdy;       /* driver status */
-       u8 rsvd2[60];
-} __attribute__((packed));
-
-/* OpRegion mailbox #2: SWSCI */
-struct opregion_swsci {
-       u32 scic;       /* SWSCI command|status|data */
-       u32 parm;       /* command parameters */
-       u32 dslp;       /* driver sleep time-out */
-       u8 rsvd[244];
-} __attribute__((packed));
-
-/* OpRegion mailbox #3: ASLE */
-struct opregion_asle {
-       u32 ardy;       /* driver readiness */
-       u32 aslc;       /* ASLE interrupt command */
-       u32 tche;       /* technology enabled indicator */
-       u32 alsi;       /* current ALS illuminance reading */
-       u32 bclp;       /* backlight brightness to set */
-       u32 pfit;       /* panel fitting state */
-       u32 cblv;       /* current brightness level */
-       u16 bclm[20];   /* backlight level duty cycle mapping table */
-       u32 cpfm;       /* current panel fitting mode */
-       u32 epfm;       /* enabled panel fitting modes */
-       u8 plut[74];    /* panel LUT and identifier */
-       u32 pfmb;       /* PWM freq and min brightness */
-       u8 rsvd[102];
-} __attribute__((packed));
-
-/* ASLE irq request bits */
-#define ASLE_SET_ALS_ILLUM     (1 << 0)
-#define ASLE_SET_BACKLIGHT     (1 << 1)
-#define ASLE_SET_PFIT          (1 << 2)
-#define ASLE_SET_PWM_FREQ      (1 << 3)
-#define ASLE_REQ_MSK           0xf
-
-/* response bits of ASLE irq request */
-#define ASLE_ALS_ILLUM_FAILED	(1<<10)
-#define ASLE_BACKLIGHT_FAILED	(1<<12)
-#define ASLE_PFIT_FAILED	(1<<14)
-#define ASLE_PWM_FREQ_FAILED	(1<<16)
-
-/* ASLE backlight brightness to set */
-#define ASLE_BCLP_VALID                (1<<31)
-#define ASLE_BCLP_MSK          (~(1<<31))
-
-/* ASLE panel fitting request */
-#define ASLE_PFIT_VALID         (1<<31)
-#define ASLE_PFIT_CENTER (1<<0)
-#define ASLE_PFIT_STRETCH_TEXT (1<<1)
-#define ASLE_PFIT_STRETCH_GFX (1<<2)
-
-/* PWM frequency and minimum brightness */
-#define ASLE_PFMB_BRIGHTNESS_MASK (0xff)
-#define ASLE_PFMB_BRIGHTNESS_VALID (1<<8)
-#define ASLE_PFMB_PWM_MASK (0x7ffffe00)
-#define ASLE_PFMB_PWM_VALID (1<<31)
-
-#define ASLE_CBLV_VALID         (1<<31)
-
-#define ACPI_OTHER_OUTPUT (0<<8)
-#define ACPI_VGA_OUTPUT (1<<8)
-#define ACPI_TV_OUTPUT (2<<8)
-#define ACPI_DIGITAL_OUTPUT (3<<8)
-#define ACPI_LVDS_OUTPUT (4<<8)
-
-#ifdef CONFIG_ACPI
-static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct opregion_asle *asle = dev_priv->opregion.asle;
-	u32 max;
-
-	if (!(bclp & ASLE_BCLP_VALID))
-		return ASLE_BACKLIGHT_FAILED;
-
-	bclp &= ASLE_BCLP_MSK;
-	if (bclp > 255)
-		return ASLE_BACKLIGHT_FAILED;
-
-	max = intel_panel_get_max_backlight(dev);
-	intel_panel_set_backlight(dev, bclp * max / 255);
-	asle->cblv = (bclp*0x64)/0xff | ASLE_CBLV_VALID;
-
-	return 0;
-}
-
-static u32 asle_set_als_illum(struct drm_device *dev, u32 alsi)
-{
-	/* alsi is the current ALS reading in lux. 0 indicates below sensor
-	   range, 0xffff indicates above sensor range. 1-0xfffe are valid */
-	return 0;
-}
-
-static u32 asle_set_pwm_freq(struct drm_device *dev, u32 pfmb)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	if (pfmb & ASLE_PFMB_PWM_VALID) {
-		u32 blc_pwm_ctl = I915_READ(BLC_PWM_CTL);
-		u32 pwm = pfmb & ASLE_PFMB_PWM_MASK;
-		blc_pwm_ctl &= BACKLIGHT_DUTY_CYCLE_MASK;
-		pwm = pwm >> 9;
-		/* FIXME - what do we do with the PWM? */
-	}
-	return 0;
-}
-
-static u32 asle_set_pfit(struct drm_device *dev, u32 pfit)
-{
-	/* Panel fitting is currently controlled by the X code, so this is a
-	   noop until modesetting support works fully */
-	if (!(pfit & ASLE_PFIT_VALID))
-		return ASLE_PFIT_FAILED;
-	return 0;
-}
-
-void intel_opregion_asle_intr(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct opregion_asle *asle = dev_priv->opregion.asle;
-	u32 asle_stat = 0;
-	u32 asle_req;
-
-	if (!asle)
-		return;
-
-	asle_req = asle->aslc & ASLE_REQ_MSK;
-
-	if (!asle_req) {
-		DRM_DEBUG_DRIVER("non asle set request??\n");
-		return;
-	}
-
-	if (asle_req & ASLE_SET_ALS_ILLUM)
-		asle_stat |= asle_set_als_illum(dev, asle->alsi);
-
-	if (asle_req & ASLE_SET_BACKLIGHT)
-		asle_stat |= asle_set_backlight(dev, asle->bclp);
-
-	if (asle_req & ASLE_SET_PFIT)
-		asle_stat |= asle_set_pfit(dev, asle->pfit);
-
-	if (asle_req & ASLE_SET_PWM_FREQ)
-		asle_stat |= asle_set_pwm_freq(dev, asle->pfmb);
-
-	asle->aslc = asle_stat;
-}
-
-/* Only present on Ironlake+ */
-void intel_opregion_gse_intr(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct opregion_asle *asle = dev_priv->opregion.asle;
-	u32 asle_stat = 0;
-	u32 asle_req;
-
-	if (!asle)
-		return;
-
-	asle_req = asle->aslc & ASLE_REQ_MSK;
-
-	if (!asle_req) {
-		DRM_DEBUG_DRIVER("non asle set request??\n");
-		return;
-	}
-
-	if (asle_req & ASLE_SET_ALS_ILLUM) {
-		DRM_DEBUG_DRIVER("Illum is not supported\n");
-		asle_stat |= ASLE_ALS_ILLUM_FAILED;
-	}
-
-	if (asle_req & ASLE_SET_BACKLIGHT)
-		asle_stat |= asle_set_backlight(dev, asle->bclp);
-
-	if (asle_req & ASLE_SET_PFIT) {
-		DRM_DEBUG_DRIVER("Pfit is not supported\n");
-		asle_stat |= ASLE_PFIT_FAILED;
-	}
-
-	if (asle_req & ASLE_SET_PWM_FREQ) {
-		DRM_DEBUG_DRIVER("PWM freq is not supported\n");
-		asle_stat |= ASLE_PWM_FREQ_FAILED;
-	}
-
-	asle->aslc = asle_stat;
-}
-#define ASLE_ALS_EN    (1<<0)
-#define ASLE_BLC_EN    (1<<1)
-#define ASLE_PFIT_EN   (1<<2)
-#define ASLE_PFMB_EN   (1<<3)
-
-void intel_opregion_enable_asle(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct opregion_asle *asle = dev_priv->opregion.asle;
-
-	if (asle) {
-		if (IS_MOBILE(dev))
-			intel_enable_asle(dev);
-
-		asle->tche = ASLE_ALS_EN | ASLE_BLC_EN | ASLE_PFIT_EN |
-			ASLE_PFMB_EN;
-		asle->ardy = 1;
-	}
-}
-
-#define ACPI_EV_DISPLAY_SWITCH (1<<0)
-#define ACPI_EV_LID            (1<<1)
-#define ACPI_EV_DOCK           (1<<2)
-
-static struct intel_opregion *system_opregion;
-
-static int intel_opregion_video_event(struct notifier_block *nb,
-				      unsigned long val, void *data)
-{
-	/* The only video events relevant to opregion are 0x80. These indicate
-	   either a docking event, lid switch or display switch request. In
-	   Linux, these are handled by the dock, button and video drivers.
-	   We might want to fix the video driver to be opregion-aware in
-	   future, but right now we just indicate to the firmware that the
-	   request has been handled */
-
-	struct opregion_acpi *acpi;
-
-	if (!system_opregion)
-		return NOTIFY_DONE;
-
-	acpi = system_opregion->acpi;
-	acpi->csts = 0;
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block intel_opregion_notifier = {
-	.notifier_call = intel_opregion_video_event,
-};
-
-/*
- * Initialise the DIDL field in opregion. This passes a list of devices to
- * the firmware. Values are defined by section B.4.2 of the ACPI specification
- * (version 3)
- */
-
-static void intel_didl_outputs(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct intel_opregion *opregion = &dev_priv->opregion;
-	struct drm_connector *connector;
-	acpi_handle handle;
-	struct acpi_device *acpi_dev, *acpi_cdev, *acpi_video_bus = NULL;
-	unsigned long long device_id;
-	acpi_status status;
-	int i = 0;
-
-	handle = DEVICE_ACPI_HANDLE(&dev->pdev->dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev)))
-		return;
-
-	if (acpi_is_video_device(acpi_dev))
-		acpi_video_bus = acpi_dev;
-	else {
-		list_for_each_entry(acpi_cdev, &acpi_dev->children, node) {
-			if (acpi_is_video_device(acpi_cdev)) {
-				acpi_video_bus = acpi_cdev;
-				break;
-			}
-		}
-	}
-
-	if (!acpi_video_bus) {
-		printk(KERN_WARNING "No ACPI video bus found\n");
-		return;
-	}
-
-	list_for_each_entry(acpi_cdev, &acpi_video_bus->children, node) {
-		if (i >= 8) {
-			dev_printk (KERN_ERR, &dev->pdev->dev,
-				    "More than 8 outputs detected\n");
-			return;
-		}
-		status =
-			acpi_evaluate_integer(acpi_cdev->handle, "_ADR",
-						NULL, &device_id);
-		if (ACPI_SUCCESS(status)) {
-			if (!device_id)
-				goto blind_set;
-			opregion->acpi->didl[i] = (u32)(device_id & 0x0f0f);
-			i++;
-		}
-	}
-
-end:
-	/* If fewer than 8 outputs, the list must be null terminated */
-	if (i < 8)
-		opregion->acpi->didl[i] = 0;
-	return;
-
-blind_set:
-	i = 0;
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-		int output_type = ACPI_OTHER_OUTPUT;
-		if (i >= 8) {
-			dev_printk (KERN_ERR, &dev->pdev->dev,
-				    "More than 8 outputs detected\n");
-			return;
-		}
-		switch (connector->connector_type) {
-		case DRM_MODE_CONNECTOR_VGA:
-		case DRM_MODE_CONNECTOR_DVIA:
-			output_type = ACPI_VGA_OUTPUT;
-			break;
-		case DRM_MODE_CONNECTOR_Composite:
-		case DRM_MODE_CONNECTOR_SVIDEO:
-		case DRM_MODE_CONNECTOR_Component:
-		case DRM_MODE_CONNECTOR_9PinDIN:
-			output_type = ACPI_TV_OUTPUT;
-			break;
-		case DRM_MODE_CONNECTOR_DVII:
-		case DRM_MODE_CONNECTOR_DVID:
-		case DRM_MODE_CONNECTOR_DisplayPort:
-		case DRM_MODE_CONNECTOR_HDMIA:
-		case DRM_MODE_CONNECTOR_HDMIB:
-			output_type = ACPI_DIGITAL_OUTPUT;
-			break;
-		case DRM_MODE_CONNECTOR_LVDS:
-			output_type = ACPI_LVDS_OUTPUT;
-			break;
-		}
-		opregion->acpi->didl[i] |= (1<<31) | output_type | i;
-		i++;
-	}
-	goto end;
-}
-
-void intel_opregion_init(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct intel_opregion *opregion = &dev_priv->opregion;
-
-	if (!opregion->header)
-		return;
-
-	if (opregion->acpi) {
-		if (drm_core_check_feature(dev, DRIVER_MODESET))
-			intel_didl_outputs(dev);
-
-		/* Notify BIOS we are ready to handle ACPI video ext notifs.
-		 * Right now, all the events are handled by the ACPI video module.
-		 * We don't actually need to do anything with them. */
-		opregion->acpi->csts = 0;
-		opregion->acpi->drdy = 1;
-
-		system_opregion = opregion;
-		register_acpi_notifier(&intel_opregion_notifier);
-	}
-
-	if (opregion->asle)
-		intel_opregion_enable_asle(dev);
-}
-
-void intel_opregion_fini(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct intel_opregion *opregion = &dev_priv->opregion;
-
-	if (!opregion->header)
-		return;
-
-	if (opregion->acpi) {
-		opregion->acpi->drdy = 0;
-
-		system_opregion = NULL;
-		unregister_acpi_notifier(&intel_opregion_notifier);
-	}
-
-	/* just clear all opregion memory pointers now */
-	iounmap(opregion->header);
-	opregion->header = NULL;
-	opregion->acpi = NULL;
-	opregion->swsci = NULL;
-	opregion->asle = NULL;
-	opregion->vbt = NULL;
-}
-#endif
-
-int intel_opregion_setup(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct intel_opregion *opregion = &dev_priv->opregion;
-	void *base;
-	u32 asls, mboxes;
-	int err = 0;
-
-	pci_read_config_dword(dev->pdev, PCI_ASLS, &asls);
-	DRM_DEBUG_DRIVER("graphic opregion physical addr: 0x%x\n", asls);
-	if (asls == 0) {
-		DRM_DEBUG_DRIVER("ACPI OpRegion not supported!\n");
-		return -ENOTSUPP;
-	}
-
-	base = acpi_os_ioremap(asls, OPREGION_SIZE);
-	if (!base)
-		return -ENOMEM;
-
-	if (memcmp(base, OPREGION_SIGNATURE, 16)) {
-		DRM_DEBUG_DRIVER("opregion signature mismatch\n");
-		err = -EINVAL;
-		goto err_out;
-	}
-	opregion->header = base;
-	opregion->vbt = base + OPREGION_VBT_OFFSET;
-
-	opregion->lid_state = base + ACPI_CLID;
-
-	mboxes = opregion->header->mboxes;
-	if (mboxes & MBOX_ACPI) {
-		DRM_DEBUG_DRIVER("Public ACPI methods supported\n");
-		opregion->acpi = base + OPREGION_ACPI_OFFSET;
-	}
-
-	if (mboxes & MBOX_SWSCI) {
-		DRM_DEBUG_DRIVER("SWSCI supported\n");
-		opregion->swsci = base + OPREGION_SWSCI_OFFSET;
-	}
-	if (mboxes & MBOX_ASLE) {
-		DRM_DEBUG_DRIVER("ASLE supported\n");
-		opregion->asle = base + OPREGION_ASLE_OFFSET;
-	}
-
-	return 0;
-
-err_out:
-	iounmap(base);
-	return err;
-}
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 4e5ff59..51565bb 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -261,8 +261,8 @@ intel_panel_detect(struct drm_device *dev)
 	 * appears to be either the BIOS or Linux ACPI fault */
 #if 0
 	/* Assume that the BIOS does not lie through the OpRegion... */
-	if (dev_priv->opregion.lid_state)
-		return ioread32(dev_priv->opregion.lid_state) & 0x1 ?
+	if (dev_priv->opregion_dev.opregion.acpi)
+		return ioread32(&dev_priv->opregion_dev.opregion.acpi->clid) & 0x1 ?
 			connector_status_connected :
 			connector_status_disconnected;
 #endif
diff --git a/include/acpi/acpi_igd_opregion.h b/include/acpi/acpi_igd_opregion.h
new file mode 100644
index 0000000..36fefd2
--- /dev/null
+++ b/include/acpi/acpi_igd_opregion.h
@@ -0,0 +1,105 @@
+#ifndef __ACPI_IGD_OPREGION_H__
+#define __ACPI_IGD_OPREGION_H__
+
+#include <drm/drmP.h>
+
+#define OPREGION_SIZE            (8*1024)
+
+struct opregion_header {
+	u8 signature[16];
+	u32 size;
+	u32 opregion_ver;
+	u8 bios_ver[32];
+	u8 vbios_ver[16];
+	u8 driver_ver[16];
+	u32 mboxes;
+	u8 reserved[164];
+} __packed;
+
+/* OpRegion mailbox #1: public ACPI methods */
+struct opregion_acpi {
+	u32 drdy;       /* driver readiness */
+	u32 csts;       /* notification status */
+	u32 cevt;       /* current event */
+	u8 rsvd1[20];
+	u32 didl[8];    /* supported display devices ID list */
+	u32 cpdl[8];    /* currently presented display list */
+	u32 cadl[8];    /* currently active display list */
+	u32 nadl[8];    /* next active devices list */
+	u32 aslp;       /* ASL sleep time-out */
+	u32 tidx;       /* toggle table index */
+	u32 chpd;       /* current hotplug enable indicator */
+	u32 clid;       /* current lid state*/
+	u32 cdck;       /* current docking state */
+	u32 sxsw;       /* Sx state resume */
+	u32 evts;       /* ASL supported events */
+	u32 cnot;       /* current OS notification */
+	u32 nrdy;       /* driver status */
+	u8 rsvd2[60];
+} __packed;
+
+/* OpRegion mailbox #2: SWSCI */
+struct opregion_swsci {
+	u32 scic;       /* SWSCI command|status|data */
+	u32 parm;       /* command parameters */
+	u32 dslp;       /* driver sleep time-out */
+	u8 rsvd[244];
+} __packed;
+
+/* OpRegion mailbox #3: ASLE */
+struct opregion_asle {
+	u32 ardy;       /* driver readiness */
+	u32 aslc;       /* ASLE interrupt command */
+	u32 tche;       /* technology enabled indicator */
+	u32 alsi;       /* current ALS illuminance reading */
+	u32 bclp;       /* backlight brightness to set */
+	u32 pfit;       /* panel fitting state */
+	u32 cblv;       /* current brightness level */
+	u16 bclm[20];   /* backlight level duty cycle mapping table */
+	u32 cpfm;       /* current panel fitting mode */
+	u32 epfm;       /* enabled panel fitting modes */
+	u8 plut[74];    /* panel LUT and identifier */
+	u32 pfmb;       /* PWM freq and min brightness */
+	u8 rsvd[102];
+} __packed;
+
+struct igd_opregion {
+	struct opregion_header *header;
+	struct opregion_acpi *acpi;
+	struct opregion_swsci *swsci;
+	struct opregion_asle *asle;
+	void *vbt;
+};
+
+struct opregion_dev {
+	struct drm_device *drm_dev;
+	u32 max_backlight;
+	void (*set_backlight)(struct drm_device *dev, u32 value);
+	void (*set_als_illum)(struct drm_device *dev, u32 alsi);
+	void (*set_pwm_freq)(struct drm_device *dev, u32 pfmb);
+	void (*set_pfit)(struct drm_device *dev, u32 pfit);
+	void (*enable_asle)(struct drm_device *drm_dev);
+	struct igd_opregion opregion;
+};
+
+#if (defined CONFIG_ACPI_IGD_OPREGION || defined CONFIG_ACPI_IGD_OPREGION_MODULE)
+
+int igd_opregion_setup(struct opregion_dev *dev);
+void igd_opregion_init(struct opregion_dev *dev);
+void igd_opregion_fini(struct opregion_dev *dev);
+void igd_opregion_intr(struct opregion_dev *dev);
+void igd_opregion_enable_asle(struct opregion_dev *dev);
+
+#else
+
+static inline int igd_opregion_setup(struct opregion_dev *dev)
+{
+	return 0;
+}
+
+static inline void igd_opregion_init(struct opregion_dev *dev) {};
+static inline void igd_opregion_fini(struct opregion_dev *dev) {};
+static inline void igd_opregion_intr(struct opregion_dev *dev) {};
+static inline void igd_opregion_enable_asle(struct opregion_dev *dev) {};
+#endif
+#endif
-- 
1.7.4.1

