Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1KONx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 08:53:29 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58800 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab1KONx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 08:53:28 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] virtio-mmio: Devices parameter parsing
Date: Tue, 15 Nov 2011 13:53:05 +0000
Message-Id: <1321365185-2928-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 15 Nov 2011 13:53:22.0081 (UTC) FILETIME=[F0215110:01CCA39D]
X-MC-Unique: 111111513532501201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pAFDrap0023856

This patch adds an option to instantiate guest virtio-mmio devices
basing on a kernel command line (or module) parameter, for example:

	virtio_mmio.devices=0x100@0x100b0000:48,1K@0x1001e000:74

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/virtio/Kconfig       |   25 ++++++
 drivers/virtio/virtio_mmio.c |  170 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 194 insertions(+), 1 deletions(-)

Hi All,

When Sasha asked me if there is any way of instantiating the mmio devices
from kernel command line I answered no and that I believed that the correct
way of doing that would be passing a Device Tree with it. But then someone
else asked me the same so I figured out that I was probably wrong and there
is a need for that...

Here it goes, then. As it's easy to shoot yourself in the foot with that
(just specify bogus base address and watch as your system is going to hell ;-)
it's an option that must be explicitly enabled.

I hope it will be useful in DT-less qemu/KVM use cases.

All comments most welcomed!

Cheers!

Pawel

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 816ed08..61f3a79 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -46,4 +46,29 @@ config VIRTIO_BALLOON
 
  	 If unsure, say N.
 
+config VIRTIO_MMIO_CMDLINE_DEVICES
+	bool "Memory mapped virtio devices parameter parsing"
+	depends on VIRTIO_MMIO
+	---help---
+	 Allow virtio-mmio devices instantiation via the kernel command line
+	 or module parameter. Be aware that using incorrect parameters (base
+	 address in particular) can crash your system - you have been warned.
+
+	 The format for the parameter is as follows:
+
+		[virtio_mmio.]devices=<device>[<delim><device>]
+
+	 where:
+		<device>   := <size>@<baseaddr>:<irq>
+		<delim>    := ',' or ';'
+		<size>     := size (can use standard suffixes like K or M)
+		<baseaddr> := physical base address
+		<irq>      := interrupt number (as passed to request_irq())
+
+	 Example kernel command line parameter:
+
+		virtio_mmio.devices=0x100@0x100b0000:48,1K@0x1001e000:74
+
+	 If unsure, say 'N'.
+
 endmenu
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index acc5e43..1f25bb9 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -6,6 +6,47 @@
  * This module allows virtio devices to be used over a virtual, memory mapped
  * platform device.
  *
+ * The guest device(s) may be instantiated in one of three equivalent ways:
+ *
+ * 1. Static platform device in board's code, eg.:
+ *
+ *	static struct platform_device v2m_virtio_device = {
+ *		.name = "virtio-mmio",
+ *		.id = -1,
+ *		.num_resources = 2,
+ *		.resource = (struct resource []) {
+ *			{
+ *				.start = 0x1001e000,
+ *				.end = 0x1001e0ff,
+ *				.flags = IORESOURCE_MEM,
+ *			}, {
+ *				.start = 42 + 32,
+ *				.end = 42 + 32,
+ *				.flags = IORESOURCE_IRQ,
+ *			},
+ *		}
+ *	};
+ *
+ * 2. Device Tree node, eg.:
+ *
+ *		virtio_block@1e000 {
+ *			compatible = "virtio,mmio";
+ *			reg = <0x1e000 0x100>;
+ *			interrupts = <42>;
+ *		}
+ *
+ * 3. Kernel module (or command line) parameter
+ *		[virtio_mmio.]devices=<device>[<delim><device>]
+ *    where:
+ *		<device>   := <size>@<baseaddr>:<irq>
+ *		<delim>    := ',' or ';'
+ *		<size>     := size (can use standard suffixes like K or M)
+ *		<baseaddr> := physical base address
+ *		<irq>      := interrupt number (as passed to request_irq())
+ *    eg.:
+ *		virtio_mmio.devices=0x100@0x100b0000:48,1K@0x1001e000:74
+ *
+ *
  * Registers layout (all 32-bit wide):
  *
  * offset d. name             description
@@ -42,6 +83,8 @@
  * See the COPYING file in the top-level directory.
  */
 
+#define pr_fmt(fmt) "virtio-mmio: " fmt
+
 #include <linux/highmem.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -443,6 +486,127 @@ static int __devexit virtio_mmio_remove(struct platform_device *pdev)
 
 
 
+/* Devices list parameter */
+
+#if defined(CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES)
+
+static char *virtio_mmio_cmdline_devices;
+module_param_named(devices, virtio_mmio_cmdline_devices, charp, 0);
+
+static struct device virtio_mmio_cmdline_parent = {
+	.init_name = "virtio-mmio-cmdline",
+};
+
+static int virtio_mmio_register_cmdline_devices(void)
+{
+	int err;
+	int id = 0;
+	char *device = NULL;
+	char *token;
+
+	err = device_register(&virtio_mmio_cmdline_parent);
+	if (err)
+		return err;
+
+	/* Split colon-or-semicolon-separated devices */
+	while ((token = strsep(&virtio_mmio_cmdline_devices, ",;")) != NULL) {
+		struct resource resources[] = {
+			{
+				.flags = IORESOURCE_IRQ,
+			}, {
+				.flags = IORESOURCE_MEM,
+			}
+		};
+		char *size, *base;
+		unsigned long long val;
+
+		if (!*token)
+			continue;
+
+		kfree(device);
+		device = kstrdup(token, GFP_KERNEL);
+
+		/* Split memory and IRQ resources */
+		base = strsep(&token, ":");
+		if (base == token || !token || !*token) {
+			pr_err("No IRQ in '%s'!\n", device);
+			continue;
+		}
+
+		/* Get IRQ */
+		if (kstrtoull(token, 0, &val) != 0) {
+			pr_err("Wrong IRQ in '%s'!\n", device);
+			continue;
+		}
+		resources[0].start = val;
+		resources[0].end = val;
+
+		/* Split base address and size */
+		size = strsep(&base, "@");
+		if (size == base || !base || !*base) {
+			pr_err("No base in '%s'!\n", device);
+			continue;
+		}
+
+		/* Get base address */
+		if (kstrtoull(base, 0, &val) != 0) {
+			pr_err("Wrong base in '%s'!\n", device);
+			continue;
+		}
+		resources[1].start = val;
+		resources[1].end = val;
+
+		/* Get size */
+		resources[1].end += memparse(size, &token) - 1;
+		if (size == token || *token) {
+			pr_err("Wrong size in '%s'!\n", device);
+			continue;
+		}
+
+		pr_info("Registering device %d at 0x%x-0x%x, IRQ %u.\n",
+				id, resources[1].start, resources[1].end,
+				resources[0].start);
+
+		platform_device_register_resndata(&virtio_mmio_cmdline_parent,
+				"virtio-mmio", id, resources,
+				ARRAY_SIZE(resources), NULL, 0);
+
+		id++;
+	}
+
+	kfree(device);
+
+	return 0;
+}
+
+static int virtio_mmio_unregister_cmdline_device(struct device *dev,
+		void *data)
+{
+	platform_device_unregister(to_platform_device(dev));
+
+	return 0;
+}
+
+static void virtio_mmio_unregister_cmdline_devices(void)
+{
+	device_for_each_child(&virtio_mmio_cmdline_parent, NULL,
+			virtio_mmio_unregister_cmdline_device);
+	device_unregister(&virtio_mmio_cmdline_parent);
+}
+
+#else
+
+static int virtio_mmio_register_cmdline_devices(void)
+{
+	return 0;
+}
+
+static void virtio_mmio_unregister_cmdline_devices(void)
+{
+}
+
+#endif
+
 /* Platform driver */
 
 static struct of_device_id virtio_mmio_match[] = {
@@ -463,11 +627,15 @@ static struct platform_driver virtio_mmio_driver = {
 
 static int __init virtio_mmio_init(void)
 {
-	return platform_driver_register(&virtio_mmio_driver);
+	int err = virtio_mmio_register_cmdline_devices();
+
+	return err ? err : platform_driver_register(&virtio_mmio_driver);
 }
 
 static void __exit virtio_mmio_exit(void)
 {
+	virtio_mmio_unregister_cmdline_devices();
+
 	platform_driver_unregister(&virtio_mmio_driver);
 }
 
-- 
1.6.3.3


