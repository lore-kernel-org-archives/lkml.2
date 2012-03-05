Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2CEJkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 04:40:15 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38796 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab2CEJkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 04:40:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mnazarewicz@gmail.com designates 10.213.11.2 as permitted sender) smtp.mail=mnazarewicz@gmail.com; dkim=pass header.i=mnazarewicz@gmail.com
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: m.szyprowski@samsung.com, "Barry Song" <Barry.Song@csr.com>
Cc: workgroup.linux@csr.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Barry Song" <Baohua.Song@csr.com>
Subject: Re: [PATCH v2] MM: CMA: add a simple kernel module as the helper to
 test CMA
References: <1330931626-30855-1-git-send-email-Barry.Song@csr.com>
Date: Mon, 05 Mar 2012 10:40:09 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.waoyg7dp3l0zgt@mpn-glaptop>
In-Reply-To: <1330931626-30855-1-git-send-email-Barry.Song@csr.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Mar 2012 08:13:46 +0100, Barry Song <Barry.Song@csr.com> wrote:
> Any write request to /dev/cma_test will let the module to allocate memory from
> CMA, for example:
>
> 1st time
> $ echo 1024 > /dev/cma_test
> will require cma_test to request 1MB(1024KB)
> 2nd time
> $ echo 2048 > /dev/cma_test
> will require cma_test to request 2MB(2048KB)
>
> Any read request to /dev/cma_test will let the module to free the 1st valid
> memory from CMA, for example:
>
> 1st time
> $ cat /dev/cma_test
> will require cma_test to free the 1MB allocated in the first write request
> 2nd time
> $ cat /dev/cma_test
> will require cma_test to free the 2MB allocated in the second write request
>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>

> diff --git a/tools/cma/cma_test.c b/tools/cma/cma_test.c
> new file mode 100644
> index 0000000..46af250
> --- /dev/null
> +++ b/tools/cma/cma_test.c
> @@ -0,0 +1,140 @@
> +/*
> + * kernel module helper for testing CMA
> + *
> + * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.

It's 2012.

> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +struct cma_allocation {
> +	struct list_head list;
> +	unsigned long size;
> +	dma_addr_t dma;
> +	void *virt;
> +};
> +
> +static struct device *cma_dev;
> +static LIST_HEAD(cma_allocations);
> +static DEFINE_SPINLOCK(cma_lock);
> +
> +/*
> + * any read request will free the 1st allocated coherent memory, eg.
> + * cat /dev/cma_test
> + */
> +static ssize_t
> +cma_test_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> +{
> +	struct cma_allocation *alloc = NULL;
> +
> +	spin_lock(&cma_lock);
> +	if (!list_empty(&cma_allocations)) {
> +		alloc = list_first_entry(&cma_allocations,
> +			struct cma_allocation, list);
> +		list_del(&alloc->list);
> +	}
> +	spin_unlock(&cma_lock);
> +

Come to think of it, how about putting:

	if (!alloc)
		return -EIDRM;

here and then removing one indention level later:

> +	if (alloc) {
> +		dma_free_coherent(cma_dev, alloc->size, alloc->virt,
> +			alloc->dma);
> +
> +		_dev_info(cma_dev, "free CM at virtual address: 0x%p dma address: 0x%p size:%luKiB\n",

This message seem overly long and “0x” seem redundant.  How about something like:

		_dev_info(cma_dev, "free: virt:%p dma:%p size:%luK\n",

which has all the same information but is shorter?

> +			alloc->virt, (void *)alloc->dma, alloc->size / SZ_1K);
> +		kfree(alloc);
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * any write request will alloc a new coherent memory, eg.
> + * echo 1024 > /dev/cma_test
> + * will request 1024KiB by CMA
> + */
> +static ssize_t
> +cma_test_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	struct cma_allocation *alloc;
> +	int ret;
> +
> +	alloc = kmalloc(sizeof *alloc, GFP_KERNEL);
> +	if (!alloc)
> +		return -ENOMEM;
> +
> +	ret = kstrtoul_from_user(buf, count, 0, &alloc->size);
> +	if (ret)
> +		return ret;
> +
> +	if (!alloc->size)
> +		return -EINVAL;
> +
> +	if (alloc->size > (ULONG_MAX << PAGE_SHIFT))

You've changed units from pages to KiBs and, I've just realised that, since
dma_alloc_coherent accepts “size_t” as argument, this should read:

	if (alloc->size > ~(size_t)0 / SZ_1K)

(“<<” was in fact a bug in my code from the beginning.)

> +		return -EOVERFLOW;

Most importantly, there was a memory leak in my original suggestion, and
it got carried over to this patch.  The above code should look
something like that:

	ret = kstrtoul_from_user(buf, count, 0, &alloc->size);
	if (ret)
		return ret;

	if (!alloc->size)
		return -EINVAL;

	if (alloc->size > ~(size_t)0 / SZ_1K)
		return -EOVERFLOW;

	alloc = kmalloc(sizeof *alloc, GFP_KERNEL);
	if (!alloc)
		return -ENOMEM;

> +	alloc->size *= SZ_1K;
> +	alloc->virt = dma_alloc_coherent(cma_dev, alloc->size,
> +		&alloc->dma, GFP_KERNEL);
> +
> +	if (alloc->virt) {
> +		_dev_info(cma_dev, "allocate CM at virtual address: 0x%p"
> +			"address: 0x%p size:%luKiB\n", alloc->virt,

Similarly to message earlier, how about:

		_dev_info(cma_dev, "alloc: virt:%p dma:%p size:%luK\n",

> +			(void *)alloc->dma, alloc->size / SZ_1K);
> +
> +		spin_lock(&cma_lock);
> +		list_add_tail(&alloc->list, &cma_allocations);
> +		spin_unlock(&cma_lock);
> +
> +		return count;
> +	} else {
> +		dev_err(cma_dev, "no mem in CMA area\n");
> +		kfree(alloc);
> +		return -ENOSPC;
> +	}
> +}
> +
> +static const struct file_operations cma_test_fops = {
> +	.owner =    THIS_MODULE,
> +	.read  =    cma_test_read,
> +	.write =    cma_test_write,
> +};
> +
> +static struct miscdevice cma_test_misc = {
> +	.name = "cma_test",
> +	.fops = &cma_test_fops,
> +};
> +
> +static int __init cma_test_init(void)
> +{
> +	int ret = 0;

Drop “= 0”, or better yet, combain this declaration with the next line.

> +
> +	ret = misc_register(&cma_test_misc);
> +	if (unlikely(ret)) {
> +		pr_err("failed to register cma test misc device!\n");
> +		return ret;
> +	}
> +	cma_dev = cma_test_misc.this_device;
> +	cma_dev->coherent_dma_mask = ~0;
> +	_dev_info(cma_dev, "registered.\n");
> +
> +	return ret;

	return 0;

> +}
> +module_init(cma_test_init);
> +
> +static void __exit cma_test_exit(void)
> +{
> +	misc_deregister(&cma_test_misc);
> +}
> +module_exit(cma_test_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Barry Song <Baohua.Song@csr.com>");
> +MODULE_DESCRIPTION("kernel module to help the test of CMA");
> +MODULE_ALIAS("CMA test");

Can module alias contain spaces?  I don't think this declaration even
adds anything useful. “cma_test” as module name should be good enough.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
