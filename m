Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1KUDf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 22:35:56 -0500
Received: from ozlabs.org ([203.10.76.45]:52071 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab1KUDfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 22:35:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
In-Reply-To: <1321467222.3137.417.camel@hornet.cambridge.arm.com>
References: <1321365185-2928-1-git-send-email-pawel.moll@arm.com> <87sjlooq3m.fsf@rustcorp.com.au> <1321467222.3137.417.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 21 Nov 2011 14:02:50 +1030
Message-ID: <87vcqe9ml9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 18:13:42 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> On Wed, 2011-11-16 at 00:42 +0000, Rusty Russell wrote:
> > On Tue, 15 Nov 2011 13:53:05 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> > > +static char *virtio_mmio_cmdline_devices;
> > > +module_param_named(devices, virtio_mmio_cmdline_devices, charp, 0);
> > 
> > This is the wrong way to do this.
> > 
> > Don't put things in a charp and process it later.  It's lazy.  
> 
> Definitely not lazy - string parsing is very absorbing, really! ;-)
> 
> > You
> > should write parsers for it and call it straight from module_param.
> > 
> > And if you do it that way, multiple devices are simply multiple
> > arguments.
> >
> > module_param_cb(device, &param_ops_virtio_mmio, NULL, 0400);
> 
> Hm. Honestly, first time I hear someone suggesting using the param_cb
> variant... It doesn't seem to be too popular ;-)

No it's not; I didn't bother when I converted things across, and it
shows.  But we expect virtio hackers to be smarter than average :)

> But anyway, I tried to do use your suggestion (see below), even if I'm
> not convinced it's winning anything. But, in order to use the strsep()
> and kstrtoull() I need a non-const version of the string. And as the
> slab is not available at the time, I can't simply do kstrdup(), I'd have
> to abuse the "const char *val" params_ops.set's argument...
> Interestingly charp operations have the same problem:
> 
> int param_set_charp(const char *val, const struct kernel_param *kp)
> <...>
>         /* This is a hack.  We can't kmalloc in early boot, and we
>          * don't need to; this mangled commandline is preserved. */
>         if (slab_is_available()) {
> 
> Also, regarding the fact that one parameter define more than one
> "entity" - this is how mtd partitions are defined (all similarities
> intended ;-), see "drivers/mtd/cmdlinepart.c". And I quite like this
> syntax...

Yes, that's the traditional method.  I don't really hate it, but it
seems unnecessary and it's less useful when reporting parse errors.

> There's one more thing I realize I missed. The platform devices are
> registered starting from id 0 (so as "virtio-mmio.0"). Now, if you
> happened to have a statically defined virtio-mmio with the same id,
> there would be a clash. So I wanted to add a "first_id" parameter, but
> with the _cb parameter I can't guarantee ordering (I mean, to have the
> "first_id" available _before_ first device is being instantiated). So
> I'd have to cache the devices and then create them in one go. Sounds
> like the charp parameter for me :-)

Well, tell them to get the cmdline order right, or allow an explicit
device id in the commandline.

Since I hope we're going to be coding together more often, I've written
this how I would have done it (based loosely on your version) to
compare.

Main changes other than the obvious:
1) Documentation in kernel-parameters.txt
2) Doesn't leak mem on error paths.
3) Handles error from platform_device_register_resndata().
4) Uses shorter names for static functions/variables.
5) Allows (read) access to kernel parameters via sysfs.
5) Completely untested.

See what you think...
Rusty.

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -110,6 +110,7 @@ parameter is applicable:
 	USB	USB support is enabled.
 	USBHID	USB Human Interface Device support is enabled.
 	V4L	Video For Linux support is enabled.
+	VMMIO	CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is enabled.
 	VGA	The VGA console has been enabled.
 	VT	Virtual terminal support is enabled.
 	WDT	Watchdog support is enabled.
@@ -2720,6 +2721,12 @@ bytes respectively. Such letter suffixes
 	video=		[FB] Frame buffer configuration
 			See Documentation/fb/modedb.txt.
 
+	virtio_mmio.device=<size>[KMG]@<baseaddr>:<irq>
+			Can be used multiple times for multiple devices.
+			Example would be:
+				virtio_mmio.device=0x100@0x100b0000:48
+
+
 	vga=		[BOOT,X86-32] Select a particular video mode
 			See Documentation/x86/boot.txt and
 			Documentation/svga.txt.
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -46,4 +46,15 @@ config VIRTIO_BALLOON
 
  	 If unsure, say N.
 
+config VIRTIO_MMIO_CMDLINE_DEVICES
+	bool "Memory mapped virtio devices parameter parsing"
+	depends on VIRTIO_MMIO
+	---help---
+	 Allow virtio-mmio devices instantiation via the kernel command line
+	 or module parameters. Be aware that using incorrect parameters (base
+	 address in particular) can crash your system - you have been warned.
+	 See Documentation/kernel-parameters.txt for details.
+
+	 If unsure, say 'N'.
+
 endmenu
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -6,6 +6,45 @@
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
+ * 3. Kernel module (or command line) parameter (can be used more than once!)
+ *		[virtio_mmio.]device=<size>@<baseaddr>:<irq>
+ *    where:
+ *		<size>     := size (can use standard suffixes like K or M)
+ *		<baseaddr> := physical base address
+ *		<irq>      := interrupt number (as passed to request_irq())
+ *    eg.:
+ *		virtio_mmio.device=0x100@0x100b0000:48 virtio_mmio.device=1K@0x1001e000:74
+ *
+ *
  * Registers layout (all 32-bit wide):
  *
  * offset d. name             description
@@ -42,6 +81,8 @@
  * See the COPYING file in the top-level directory.
  */
 
+#define pr_fmt(fmt) "virtio-mmio: " fmt
+
 #include <linux/highmem.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -443,6 +484,119 @@ static int __devexit virtio_mmio_remove(
 
 
 
+/* Devices list parameter */
+
+#if defined(CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES)
+static struct device cmdline_parent;
+static bool cmdline_parent_registered;
+static int cmdline_id __initdata;
+
+/* <size>@<baseaddr>:<irq> */
+static int set_cmdline_device(const char *device, const struct kernel_param *kp)
+{
+	int err;
+	struct resource resources[2];
+	unsigned long long val;
+	char *delim, *p;
+	struct platform_device *pdev;
+
+	delim = strchr(device, '@');
+	if (!delim)
+		return -EINVAL;
+
+	/* kstrtoull is strict, so we have to temporarily truncate. */
+	*delim = '\0';
+	err = kstrtoull(device, 0, &val);
+	*delim = '@';
+	if (err)
+		return err;
+
+	resources[0].flags = IORESOURCE_MEM;
+	resources[0].start = val;
+	resources[0].end = val + memparse(delim + 1, &p) - 1;
+
+	if (*p != ':')
+		return -EINVAL;
+
+	err = kstrtoull(p+1, 0, &val);
+	if (err)
+		return err;
+
+	resources[1].flags = IORESOURCE_IRQ;
+	resources[1].start = resources[1].end = val;
+
+	pr_info("Registering device virtio-mmio.%d at 0x%lx-0x%lx, IRQ %u.\n",
+		cmdline_id,
+		(long)resources[0].start, (long)resources[0].end,
+		(int)resources[1].start);
+
+	if (!cmdline_parent_registered) {
+		cmdline_parent.init_name = "virtio-mmio-cmdline";
+		err = device_register(&cmdline_parent);
+		if (err) {
+			pr_err("Failed to register parent device (%u)!\n", err);
+			return err;
+		}
+		cmdline_parent_registered = true;
+	}
+
+	pdev = platform_device_register_resndata(&cmdline_parent,
+						 "virtio-mmio",
+						 cmdline_id,
+						 resources,
+						 ARRAY_SIZE(resources),
+						 NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+	cmdline_id++;
+	return 0;
+}
+
+static int get_dev(struct device *dev, void *_buf)
+{
+	char *buf = _buf;
+	unsigned int len = strlen(buf);
+	struct platform_device *pdev = to_platform_device(dev);
+
+	snprintf(buf + len, PAGE_SIZE - len, "%llu@%llu:%llu\n",
+		 pdev->resource[0].end - pdev->resource[0].start + 1ULL,
+		 (unsigned long long)pdev->resource[0].start,
+		 (unsigned long long)pdev->resource[1].start);
+	return 0;
+}
+
+static int get_cmdline_device(char *buffer, const struct kernel_param *kp)
+{
+	buffer[0] = '\0';
+	device_for_each_child(&cmdline_parent, buffer, get_dev);
+	return strlen(buffer) + 1;
+}
+
+static struct kernel_param_ops cmdline_param_ops = {
+	.set = set_cmdline_device,
+	.get = get_cmdline_device,
+};
+
+module_param_cb(device, &cmdline_param_ops, NULL, 0400);
+
+static int unregister_cmdline_device(struct device *dev, void *data)
+{
+	platform_device_unregister(to_platform_device(dev));
+	return 0;
+}
+
+static void unregister_cmdline_devices(void)
+{
+	device_for_each_child(&cmdline_parent, NULL, unregister_cmdline_device);
+	if (cmdline_parent_registered)
+		device_unregister(&cmdline_parent);
+}
+#else /* ! CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES */
+static void unregister_cmdline_devices(void)
+{
+}
+#endif
+
 /* Platform driver */
 
 static struct of_device_id virtio_mmio_match[] = {
@@ -468,6 +622,7 @@ static int __init virtio_mmio_init(void)
 
 static void __exit virtio_mmio_exit(void)
 {
+	unregister_cmdline_devices();
 	platform_driver_unregister(&virtio_mmio_driver);
 }
 
