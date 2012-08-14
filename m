Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab2HNVFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:05:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59768 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab2HNVFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:05:19 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Airlie <airlied@linux.ie>,
        Andreas Heider <andreas@meetr.de>
Subject: [PATCH 3/3] apple-gmux: Add display mux support
Date: Tue, 14 Aug 2012 16:04:59 -0500
Message-Id: <1344978299-9878-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344978299-9878-1-git-send-email-seth.forshee@canonical.com>
References: <1344978299-9878-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Heider <andreas@meetr.de>

Add support for the gmux display muxing functionality and register a mux
handler with vga_switcheroo.

Signed-off-by: Andreas Heider <andreas@meetr.de>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/apple-gmux.c |  222 +++++++++++++++++++++++++++++++++++++
 1 file changed, 222 insertions(+)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index 612b6f6..6dc9e80 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -2,6 +2,7 @@
  *  Gmux driver for Apple laptops
  *
  *  Copyright (C) Canonical Ltd. <seth.forshee@canonical.com>
+ *  Copyright (C) 2010-2012 Andreas Heider <andreas@meetr.de>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 as
@@ -19,6 +20,8 @@
 #include <linux/apple_bl.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/vga_switcheroo.h>
 #include <acpi/video.h>
 #include <asm/io.h>
 
@@ -29,8 +32,17 @@ struct apple_gmux_data {
 	struct mutex index_lock;
 
 	struct backlight_device *bdev;
+
+	/* switcheroo data */
+	acpi_handle dhandle;
+	int gpe;
+	enum vga_switcheroo_client_id resume_client_id;
+	enum vga_switcheroo_state power_state;
+	struct completion powerchange_done;
 };
 
+static struct apple_gmux_data *apple_gmux_data;
+
 /*
  * gmux port offsets. Many of these are not yet used, but may be in the
  * future, and it's useful to have them documented here anyhow.
@@ -257,6 +269,144 @@ static const struct backlight_ops gmux_bl_ops = {
 	.update_status = gmux_update_status,
 };
 
+static int gmux_switchto(enum vga_switcheroo_client_id id)
+{
+	if (id == VGA_SWITCHEROO_IGD) {
+		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_DDC, 1);
+		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_DISPLAY, 2);
+		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_EXTERNAL, 2);
+	} else {
+		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_DDC, 2);
+		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_DISPLAY, 3);
+		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_EXTERNAL, 3);
+	}
+
+	return 0;
+}
+
+static int gmux_set_discrete_state(struct apple_gmux_data *gmux_data,
+				   enum vga_switcheroo_state state)
+{
+	INIT_COMPLETION(gmux_data->powerchange_done);
+
+	if (state == VGA_SWITCHEROO_ON) {
+		gmux_write8(gmux_data, GMUX_PORT_DISCRETE_POWER, 1);
+		gmux_write8(gmux_data, GMUX_PORT_DISCRETE_POWER, 3);
+		pr_debug("Discrete card powered up\n");
+	} else {
+		gmux_write8(gmux_data, GMUX_PORT_DISCRETE_POWER, 1);
+		gmux_write8(gmux_data, GMUX_PORT_DISCRETE_POWER, 0);
+		pr_debug("Discrete card powered down\n");
+	}
+
+	gmux_data->power_state = state;
+
+	if (gmux_data->gpe >= 0 &&
+	    !wait_for_completion_interruptible_timeout(&gmux_data->powerchange_done,
+						       msecs_to_jiffies(200)))
+		pr_warn("Timeout waiting for gmux switch to complete\n");
+
+	return 0;
+}
+
+static int gmux_set_power_state(enum vga_switcheroo_client_id id,
+				enum vga_switcheroo_state state)
+{
+	if (id == VGA_SWITCHEROO_IGD)
+		return 0;
+
+	return gmux_set_discrete_state(apple_gmux_data, state);
+}
+
+static int gmux_get_client_id(struct pci_dev *pdev)
+{
+	/*
+	 * Early Macbook Pros with switchable graphics use nvidia
+	 * integrated graphics. Hardcode that the 9400M is integrated.
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL)
+		return VGA_SWITCHEROO_IGD;
+	else if (pdev->vendor == PCI_VENDOR_ID_NVIDIA &&
+		 pdev->device == 0x0863)
+		return VGA_SWITCHEROO_IGD;
+	else
+		return VGA_SWITCHEROO_DIS;
+}
+
+static enum vga_switcheroo_client_id
+gmux_active_client(struct apple_gmux_data *gmux_data)
+{
+	if (gmux_read8(gmux_data, GMUX_PORT_SWITCH_DISPLAY) == 2)
+		return VGA_SWITCHEROO_IGD;
+
+	return VGA_SWITCHEROO_DIS;
+}
+
+static struct vga_switcheroo_handler gmux_handler = {
+	.switchto = gmux_switchto,
+	.power_state = gmux_set_power_state,
+	.get_client_id = gmux_get_client_id,
+};
+
+static inline void gmux_disable_interrupts(struct apple_gmux_data *gmux_data)
+{
+	gmux_write8(gmux_data, GMUX_PORT_INTERRUPT_ENABLE,
+		    GMUX_INTERRUPT_DISABLE);
+}
+
+static inline void gmux_enable_interrupts(struct apple_gmux_data *gmux_data)
+{
+	gmux_write8(gmux_data, GMUX_PORT_INTERRUPT_ENABLE,
+		    GMUX_INTERRUPT_ENABLE);
+}
+
+static inline u8 gmux_interrupt_get_status(struct apple_gmux_data *gmux_data)
+{
+	return gmux_read8(gmux_data, GMUX_PORT_INTERRUPT_STATUS);
+}
+
+static void gmux_clear_interrupts(struct apple_gmux_data *gmux_data)
+{
+	u8 status;
+
+	/* to clear interrupts write back current status */
+	status = gmux_interrupt_get_status(gmux_data);
+	gmux_write8(gmux_data, GMUX_PORT_INTERRUPT_STATUS, status);
+}
+
+static void gmux_notify_handler(acpi_handle device, u32 value, void *context)
+{
+	u8 status;
+	struct pnp_dev *pnp = (struct pnp_dev *)context;
+	struct apple_gmux_data *gmux_data = pnp_get_drvdata(pnp);
+
+	status = gmux_interrupt_get_status(gmux_data);
+	gmux_disable_interrupts(gmux_data);
+	pr_debug("Notify handler called: status %d\n", status);
+
+	gmux_clear_interrupts(gmux_data);
+	gmux_enable_interrupts(gmux_data);
+
+	if (status & GMUX_INTERRUPT_STATUS_POWER)
+		complete(&gmux_data->powerchange_done);
+}
+
+static int gmux_suspend(struct pnp_dev *pnp, pm_message_t state)
+{
+	struct apple_gmux_data *gmux_data = pnp_get_drvdata(pnp);
+	gmux_data->resume_client_id = gmux_active_client(gmux_data);
+	return 0;
+}
+
+static int gmux_resume(struct pnp_dev *pnp)
+{
+	struct apple_gmux_data *gmux_data = pnp_get_drvdata(pnp);
+	gmux_switchto(gmux_data->resume_client_id);
+	if (gmux_data->power_state == VGA_SWITCHEROO_OFF)
+		gmux_set_discrete_state(gmux_data, gmux_data->power_state);
+	return 0;
+}
+
 static int __devinit gmux_probe(struct pnp_dev *pnp,
 				const struct pnp_device_id *id)
 {
@@ -266,6 +416,11 @@ static int __devinit gmux_probe(struct pnp_dev *pnp,
 	struct backlight_device *bdev;
 	u8 ver_major, ver_minor, ver_release;
 	int ret = -ENXIO;
+	acpi_status status;
+	unsigned long long gpe;
+
+	if (apple_gmux_data)
+		return -EBUSY;
 
 	gmux_data = kzalloc(sizeof(*gmux_data), GFP_KERNEL);
 	if (!gmux_data)
@@ -353,8 +508,62 @@ static int __devinit gmux_probe(struct pnp_dev *pnp,
 #endif
 	apple_bl_unregister();
 
+	gmux_data->power_state = VGA_SWITCHEROO_ON;
+
+	gmux_data->dhandle = DEVICE_ACPI_HANDLE(&pnp->dev);
+	if (!gmux_data->dhandle) {
+		pr_err("Cannot find acpi handle for pnp device %s\n",
+		       dev_name(&pnp->dev));
+		ret = -ENODEV;
+		goto err_notify;
+	}
+
+	status = acpi_evaluate_integer(gmux_data->dhandle, "GMGP", NULL, &gpe);
+	if (ACPI_SUCCESS(status)) {
+		gmux_data->gpe = (int)gpe;
+
+		status = acpi_install_notify_handler(gmux_data->dhandle,
+						     ACPI_DEVICE_NOTIFY,
+						     &gmux_notify_handler, pnp);
+		if (ACPI_FAILURE(status)) {
+			pr_err("Install notify handler failed: %s\n",
+			       acpi_format_exception(status));
+			ret = -ENODEV;
+			goto err_notify;
+		}
+
+		status = acpi_enable_gpe(NULL, gmux_data->gpe);
+		if (ACPI_FAILURE(status)) {
+			pr_err("Cannot enable gpe: %s\n",
+			       acpi_format_exception(status));
+			goto err_enable_gpe;
+		}
+	} else {
+		pr_warn("No GPE found for gmux\n");
+		gmux_data->gpe = -1;
+	}
+
+	if (vga_switcheroo_register_handler(&gmux_handler)) {
+		ret = -ENODEV;
+		goto err_register_handler;
+	}
+
+	init_completion(&gmux_data->powerchange_done);
+	apple_gmux_data = gmux_data;
+	gmux_enable_interrupts(gmux_data);
+
 	return 0;
 
+err_register_handler:
+	if (gmux_data->gpe >= 0)
+		acpi_disable_gpe(NULL, gmux_data->gpe);
+err_enable_gpe:
+	if (gmux_data->gpe >= 0)
+		acpi_remove_notify_handler(gmux_data->dhandle,
+					   ACPI_DEVICE_NOTIFY,
+					   &gmux_notify_handler);
+err_notify:
+	backlight_device_unregister(bdev);
 err_release:
 	release_region(gmux_data->iostart, gmux_data->iolen);
 err_free:
@@ -366,8 +575,19 @@ static void __devexit gmux_remove(struct pnp_dev *pnp)
 {
 	struct apple_gmux_data *gmux_data = pnp_get_drvdata(pnp);
 
+	vga_switcheroo_unregister_handler();
+	gmux_disable_interrupts(gmux_data);
+	if (gmux_data->gpe >= 0) {
+		acpi_disable_gpe(NULL, gmux_data->gpe);
+		acpi_remove_notify_handler(gmux_data->dhandle,
+					   ACPI_DEVICE_NOTIFY,
+					   &gmux_notify_handler);
+	}
+
 	backlight_device_unregister(gmux_data->bdev);
+
 	release_region(gmux_data->iostart, gmux_data->iolen);
+	apple_gmux_data = NULL;
 	kfree(gmux_data);
 
 	acpi_video_dmi_demote_vendor();
@@ -387,6 +607,8 @@ static struct pnp_driver gmux_pnp_driver = {
 	.probe		= gmux_probe,
 	.remove		= __devexit_p(gmux_remove),
 	.id_table	= gmux_device_ids,
+	.suspend	= gmux_suspend,
+	.resume		= gmux_resume
 };
 
 static int __init apple_gmux_init(void)
-- 
1.7.9.5

