Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab1KPSNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:13:52 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53791 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1KPSNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:13:51 -0500
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>
In-Reply-To: <87sjlooq3m.fsf@rustcorp.com.au>
References: <1321365185-2928-1-git-send-email-pawel.moll@arm.com>
	 <87sjlooq3m.fsf@rustcorp.com.au>
Date: Wed, 16 Nov 2011 18:13:42 +0000
Message-ID: <1321467222.3137.417.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 16 Nov 2011 18:13:43.0681 (UTC) FILETIME=[79BE0F10:01CCA48B]
X-MC-Unique: 111111618134702501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 00:42 +0000, Rusty Russell wrote:
> On Tue, 15 Nov 2011 13:53:05 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> > +static char *virtio_mmio_cmdline_devices;
> > +module_param_named(devices, virtio_mmio_cmdline_devices, charp, 0);
> 
> This is the wrong way to do this.
> 
> Don't put things in a charp and process it later.  It's lazy.  

Definitely not lazy - string parsing is very absorbing, really! ;-)

> You
> should write parsers for it and call it straight from module_param.
> 
> And if you do it that way, multiple devices are simply multiple
> arguments.
>
> module_param_cb(device, &param_ops_virtio_mmio, NULL, 0400);

Hm. Honestly, first time I hear someone suggesting using the param_cb
variant... It doesn't seem to be too popular ;-)

$ git grep ^module_param\(.\*charp.\*\)\; | wc -l
159
$ git grep ^module_param_cb\(.\*\)\; | wc -l
7

But anyway, I tried to do use your suggestion (see below), even if I'm
not convinced it's winning anything. But, in order to use the strsep()
and kstrtoull() I need a non-const version of the string. And as the
slab is not available at the time, I can't simply do kstrdup(), I'd have
to abuse the "const char *val" params_ops.set's argument...
Interestingly charp operations have the same problem:

int param_set_charp(const char *val, const struct kernel_param *kp)
<...>
        /* This is a hack.  We can't kmalloc in early boot, and we
         * don't need to; this mangled commandline is preserved. */
        if (slab_is_available()) {

Also, regarding the fact that one parameter define more than one
"entity" - this is how mtd partitions are defined (all similarities
intended ;-), see "drivers/mtd/cmdlinepart.c". And I quite like this
syntax...

There's one more thing I realize I missed. The platform devices are
registered starting from id 0 (so as "virtio-mmio.0"). Now, if you
happened to have a statically defined virtio-mmio with the same id,
there would be a clash. So I wanted to add a "first_id" parameter, but
with the _cb parameter I can't guarantee ordering (I mean, to have the
"first_id" available _before_ first device is being instantiated). So
I'd have to cache the devices and then create them in one go. Sounds
like the charp parameter for me :-)

So, unless you have really strong feelings about it, I'd stick to the
single-string version, I'll just add the "first_id" parameter tomorrow.

Cheers!

Paweł

8<---------------------------------------

/* Devices list parameter */

#if defined(CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES)

static struct device virtio_mmio_cmdline_parent = {
	.init_name = "virtio-mmio-cmdline",
};

static int virtio_mmio_cmdline_parent_registered;
static int virtio_mmio_cmdline_id;

static int virtio_mmio_register_cmdline_device(const char *device,
		const struct kernel_param *kp)
{
	int err;
	struct resource resources[] = {
		{
			.flags = IORESOURCE_IRQ,
		}, {
			.flags = IORESOURCE_MEM,
		}
	};
	char *__token, *token, *size, *base;
	unsigned long long val;

	token = __token = kstrdup(device, GFP_KERNEL);
	printk("token=%s\n", token);

	/* Split memory and IRQ resources */
	pr_info("base=%s, token=%s\n", base, token);
	if (base == token || !token || !*token)
		goto error;

	/* Get IRQ */
	if (kstrtoull(token, 0, &val) != 0)
		goto error;
	resources[0].start = val;
	resources[0].end = val;

	/* Split base address and size */
	size = strsep(&base, "@");
	if (size == base || !base || !*base)
		pr_err("No base in '%s'!\n", device);

	/* Get base address */
	if (kstrtoull(base, 0, &val) != 0)
		pr_err("Wrong base in '%s'!\n", device);
	resources[1].start = val;
	resources[1].end = val;

	/* Get size */
	resources[1].end += memparse(size, &token) - 1;
	if (size == token || *token)
		goto error;

	kfree(__token);

	pr_info("Registering device virtio-mmio.%d at 0x%x-0x%x, IRQ %u.\n",
			virtio_mmio_cmdline_id, resources[1].start,
			resources[1].end, resources[0].start);

	if (!virtio_mmio_cmdline_parent_registered) {
		err = device_register(&virtio_mmio_cmdline_parent);
		if (err) {
			pr_err("Failed to register parent device!\n");
			return err;
		}
		virtio_mmio_cmdline_parent_registered = 1;
	}

	return platform_device_register_resndata(&virtio_mmio_cmdline_parent,
			"virtio-mmio", virtio_mmio_cmdline_id++,
			resources, ARRAY_SIZE(resources), NULL, 0) != NULL;

error:
	kfree(__token);
	return -EINVAL;
}

static struct kernel_param_ops virtio_mmio_cmdline_param_ops = {
	.set = virtio_mmio_register_cmdline_device,
};

module_param_cb(device, &virtio_mmio_cmdline_param_ops, NULL, 0);



