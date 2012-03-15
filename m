Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031304Ab2COPsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:48:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030550Ab2COPr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:47:59 -0400
Date: Thu, 15 Mar 2012 10:47:56 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120315154756.GE9673@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <20120312142126.GA11969@srcf.ucam.org>
 <20120312145701.GA12322@ubuntu-macmini>
 <20120312150717.GA13211@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312150717.GA13211@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 03:07:17PM +0000, Matthew Garrett wrote:
> The alternative is for apple_bl to export its unregister function and 
> have gmux call that - downside is obviously that that results in gmux 
> depending on apple_bl. Maybe some sort of notification list in the 
> backlight core?

I've been think about this, and I'm not sure a notification in the
backlight core makes sense; it seems likely to be limited in use to only
this one use case. Other ideas might be to have an interface to disable
specific backlight devices, or a way to score backlights which leaves
only the "best" device of a given type enabled. Either of these might
affect userspace ABI however.

For now at least if something like this is needed maybe it makes the
most sense to have apple_bl export a function. What about something like
the patch at the end of this message (compile tested only)?

> > We also have the problem of gmux_backlight versus acpi_video. On most
> > machines with a gmux the acpi_video backlight interface is present but
> > just doesn't work. This problem isn't just limited to Apples. I'm of the
> > opinion that we need a more generalized solution for arbitrating between
> > the backlight interfaces present on a given machine, but I haven't had a
> > chance to really think about what that would look like.
> 
> The ACPI code appears to be trapping into system management mode, so 
> figuring out what it's meant to do is going to be awkward. I think 
> having a hook in the ACPI video driver to deregister it in cases where 
> we know it doesn't work is legitimate, but since it presumably works 
> under Windows it'd be nice to figure out what's broken about it.

I've been experimenting with a MBP 8,2. This actually has 2 ACPI
backlights, one associated with the radeon GPU (acpi_video0) and the
other with the Intel (acpi_video1).

Turns out that acpi_video0 does work under Windows, and it also works
under Linux depending on how the OS is booted. Doing a boot camp style
boot gives us working acpi_video0 and apple_bl backlights. acpi_video1
doesn't show up in a legacy boot situation, as evaluating _BCM gives an
error.

Under EFI boot, both acpi_video backlights show up but neither works.
The readback verify in apple_bl's probe fails, so that one doesn't show
up. Only gmux_backlight actually works.

Using rEFIt is an oddball case. A BIOS-compatible boot gives non-working
acpi_video and apple_bl backlights. I guess the Apple bootloader must
enable some extra legacy support that rEFIt does not, but I haven't been
able to find any way for us to enable it after Linux has started.

Seth


diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
index be98d15..9b16d58 100644
--- a/drivers/video/backlight/apple_bl.c
+++ b/drivers/video/backlight/apple_bl.c
@@ -27,6 +27,19 @@
 
 static struct backlight_device *apple_backlight_device;
 
+/*
+ * apple_bl may be disabled by other modules. We need to track the state
+ * of the device to know how to respond to various events.
+ */
+enum {
+	APPLE_BL_STATE_UNUSED,
+	APPLE_BL_STATE_IN_USE,
+	APPLE_BL_STATE_DISABLED,
+};
+
+static int apple_bl_state = APPLE_BL_STATE_UNUSED;
+DEFINE_MUTEX(apple_bl_mutex);
+
 struct hw_data {
 	/* I/O resource to allocate. */
 	unsigned long iostart;
@@ -139,17 +152,46 @@ static const struct hw_data nvidia_chipset_data = {
 	.set_brightness = nvidia_chipset_set_brightness,
 };
 
+static void apple_bl_unregister(void)
+{
+	backlight_device_unregister(apple_backlight_device);
+	release_region(hw_data->iostart, hw_data->iolen);
+	hw_data = NULL;
+}
+
+void apple_bl_disable(void)
+{
+	mutex_lock(&apple_bl_mutex);
+	if (apple_bl_state == APPLE_BL_STATE_IN_USE)
+		apple_bl_unregister();
+	apple_bl_state = APPLE_BL_STATE_DISABLED;
+	mutex_unlock(&apple_bl_mutex);
+}
+EXPORT_SYMBOL_GPL(apple_bl_disable);
+
 static int __devinit apple_bl_add(struct acpi_device *dev)
 {
 	struct backlight_properties props;
 	struct pci_dev *host;
 	int intensity;
+	int ret = -ENODEV;
+
+	mutex_lock(&apple_bl_mutex);
+
+	switch (apple_bl_state) {
+	case APPLE_BL_STATE_IN_USE:
+		ret = -EBUSY;
+		goto out;
+	case APPLE_BL_STATE_DISABLED:
+		printk(KERN_ERR DRIVER "apple_bl disabled, ignoring device\n");
+		goto out;
+	}
 
 	host = pci_get_bus_and_slot(0, 0);
 
 	if (!host) {
 		printk(KERN_ERR DRIVER "unable to find PCI host\n");
-		return -ENODEV;
+		goto out;
 	}
 
 	if (host->vendor == PCI_VENDOR_ID_INTEL)
@@ -161,7 +203,7 @@ static int __devinit apple_bl_add(struct acpi_device *dev)
 
 	if (!hw_data) {
 		printk(KERN_ERR DRIVER "unknown hardware\n");
-		return -ENODEV;
+		goto out;
 	}
 
 	/* Check that the hardware responds - this may not work under EFI */
@@ -171,14 +213,16 @@ static int __devinit apple_bl_add(struct acpi_device *dev)
 	if (!intensity) {
 		hw_data->set_brightness(1);
 		if (!hw_data->backlight_ops.get_brightness(NULL))
-			return -ENODEV;
+			goto out;
 
 		hw_data->set_brightness(0);
 	}
 
 	if (!request_region(hw_data->iostart, hw_data->iolen,
-			    "Apple backlight"))
-		return -ENXIO;
+			    "Apple backlight")) {
+		ret = -ENXIO;
+		goto out;
+	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_PLATFORM;
@@ -188,22 +232,30 @@ static int __devinit apple_bl_add(struct acpi_device *dev)
 
 	if (IS_ERR(apple_backlight_device)) {
 		release_region(hw_data->iostart, hw_data->iolen);
-		return PTR_ERR(apple_backlight_device);
+		ret = PTR_ERR(apple_backlight_device);
+		goto out;
 	}
 
 	apple_backlight_device->props.brightness =
 		hw_data->backlight_ops.get_brightness(apple_backlight_device);
 	backlight_update_status(apple_backlight_device);
 
-	return 0;
+	apple_bl_state = APPLE_BL_STATE_IN_USE;
+	ret = 0;
+
+out:
+	mutex_unlock(&apple_bl_mutex);
+	return ret;
 }
 
 static int __devexit apple_bl_remove(struct acpi_device *dev, int type)
 {
-	backlight_device_unregister(apple_backlight_device);
-
-	release_region(hw_data->iostart, hw_data->iolen);
-	hw_data = NULL;
+	mutex_lock(&apple_bl_mutex);
+	if (apple_bl_state == APPLE_BL_STATE_IN_USE) {
+		apple_bl_unregister();
+		apple_bl_state = APPLE_BL_STATE_UNUSED;
+	}
+	mutex_unlock(&apple_bl_mutex);
 	return 0;
 }
 
diff --git a/include/linux/apple_bl.h b/include/linux/apple_bl.h
new file mode 100644
index 0000000..7a4b6bc
--- /dev/null
+++ b/include/linux/apple_bl.h
@@ -0,0 +1,10 @@
+/*
+ * apple_bl exported symbols
+ */
+
+#ifndef _LINUX_APPLE_BL_H
+#define _LINUX_APPLE_BL_H
+
+extern void apple_bl_disable(void);
+
+#endif
