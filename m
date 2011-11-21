Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab1KUR5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:57:00 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56368 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1KUR47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:56:59 -0500
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
In-Reply-To: <1321886688.3093.248.camel@hornet.cambridge.arm.com>
References: <1321365185-2928-1-git-send-email-pawel.moll@arm.com>
	 <87sjlooq3m.fsf@rustcorp.com.au>
	 <1321467222.3137.417.camel@hornet.cambridge.arm.com>
	 <87vcqe9ml9.fsf@rustcorp.com.au>
	 <1321886688.3093.248.camel@hornet.cambridge.arm.com>
Date: Mon, 21 Nov 2011 17:56:50 +0000
Message-ID: <1321898210.3093.263.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 21 Nov 2011 17:56:51.0293 (UTC) FILETIME=[F260A8D0:01CCA876]
X-MC-Unique: 111112117565501701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 14:44 +0000, Pawel Moll wrote:
> I'll post v3 tonight or tomorrow.

Ok, it won't be v3 then...

I tried again, using your suggestions - see below (just the crucial bit,
however I have the kernel-parameters.txt bits ready as well). Parsing
works like charm, however when it gets to device_register() and
platform_device_register_resndata() I hit the same problem as
previously. Both are using slab allocator...

device_register()->device_add()->device_private_init()->kzalloc()

and

platform_device_register_resndata()->platform_device_register_full()->
platform_device_alloc()->kzalloc().

Essentially it seems that the parameter callbacks are just executed
waaay to early to do more than just set few integers here and there...

Any ideas?

Cheers!

Paweł

8<-------------------------------------------------------------------

@@ -443,6 +489,145 @@ static int __devexit virtio_mmio_remove(struct platform_device *pdev)
 
 
 
+/* Devices list parameter */
+
+#if defined(CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES)
+
+static struct device vm_cmdline_parent = {
+	.init_name = "virtio-mmio-cmdline",
+};
+
+static int vm_cmdline_parent_registered;
+static int vm_cmdline_id;
+
+static int vm_cmdline_set(const char *str,
+		const struct kernel_param *kp)
+{
+	int err;
+	struct resource resources[2];
+	unsigned long long val;
+	char *delim;
+	struct platform_device *pdev;
+
+	/* Size */
+	resources[0].flags = IORESOURCE_MEM;
+	resources[0].end = memparse(str, &delim) - 1;
+	if (*delim != '@')
+		return -EINVAL;
+	str = delim + 1;
+
+	/* Base address */
+	delim = strchr(str, ':');
+	if (!delim)
+		return -EINVAL;
+	/* kstrtoull is strict, so we have to temporarily truncate */
+	*delim = '\0';
+	err = kstrtoull(str, 0, &val);
+	*delim = ':';
+	if (err)
+		return err;
+	resources[0].start = val;
+	resources[0].end += val;
+	str = delim + 1;
+	
+	/* Interrupt */
+	delim = strchr(str, ':');
+	if (delim) /* Optional device id delimiter */
+		*delim = '\0';
+	err = kstrtoull(str, 0, &val);
+	if (delim)
+		*delim = ':';
+	resources[1].flags = IORESOURCE_IRQ;
+	resources[1].start = resources[1].end = val;
+	str = delim + 1;
+
+	/* Optional device id */
+	if (delim) {
+		err = kstrtoull(str, 0, &val);
+		if (err)
+			return err;
+		vm_cmdline_id = val;
+	}
+
+	if (!vm_cmdline_parent_registered) {
+		err = device_register(&vm_cmdline_parent);
+		if (err) {
+			pr_err("Failed to register parent device!\n");
+			return err;
+		}
+		vm_cmdline_parent_registered = 1;
+	}
+
+       pr_info("Registering device virtio-mmio.%d at 0x%llx-0x%llx, IRQ %d.\n",
+		       vm_cmdline_id++,
+		       (unsigned long long)resources[0].start,
+		       (unsigned long long)resources[0].end,
+		       (int)resources[1].start);
+
+	pdev = platform_device_register_resndata(&vm_cmdline_parent,
+			"virtio-mmio", vm_cmdline_id++,
+			resources, ARRAY_SIZE(resources), NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	return 0;
+}
+
+static int vm_cmdline_get_device(struct device *dev, void *data)
+{
+	char *buffer = data;
+	unsigned int len = strlen(buffer);
+	struct platform_device *pdev = to_platform_device(dev);
+
+	snprintf(buffer + len, PAGE_SIZE - len, "0x%llx@0x%llx:%llu:%d\n",
+			pdev->resource[0].end - pdev->resource[0].start + 1ULL,
+			(unsigned long long)pdev->resource[0].start,
+			(unsigned long long)pdev->resource[1].start,
+			pdev->id);
+	return 0;
+}
+
+static int vm_cmdline_get(char *buffer, const struct kernel_param *kp)
+{
+	buffer[0] = '\0';
+	device_for_each_child(&vm_cmdline_parent, buffer,
+			vm_cmdline_get_device);
+	return strlen(buffer) + 1;
+}
+
+static struct kernel_param_ops vm_cmdline_param_ops = {
+	.set = vm_cmdline_set,
+	.get = vm_cmdline_get,
+};
+
+module_param_cb(device, &vm_cmdline_param_ops, NULL, S_IRUSR);
+
+static int vm_unregister_cmdline_device(struct device *dev,
+		void *data)
+{
+	platform_device_unregister(to_platform_device(dev));
+
+	return 0;
+}
+
+static void vm_unregister_cmdline_devices(void)
+{
+	if (vm_cmdline_parent_registered) {
+		device_for_each_child(&vm_cmdline_parent, NULL,
+				vm_unregister_cmdline_device);
+		device_unregister(&vm_cmdline_parent);
+		vm_cmdline_parent_registered = 0;
+	}
+}
+
+#else
+
+static void virtio_mmio_unregister_cmdline_devices(void)
+{
+}
+
+#endif
+
 /* Platform driver */
 
 static struct of_device_id virtio_mmio_match[] = {
@@ -469,6 +654,7 @@ static int __init virtio_mmio_init(void)
 static void __exit virtio_mmio_exit(void)
 {
 	platform_driver_unregister(&virtio_mmio_driver);
+	vm_unregister_cmdline_devices();
 }
 
 module_init(virtio_mmio_init);



