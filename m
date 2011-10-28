Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445Ab1J1VlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:41:00 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:43959 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab1J1Vk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:40:59 -0400
Date: Fri, 28 Oct 2011 23:40:39 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: hjk@hansjkoch.de, Greg KH <greg@kroah.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] Example to show use of uio pgprot
Message-ID: <20111028214039.GC23092@local>
References: <1319817030-23992-1-git-send-email-galak@kernel.crashing.org>
 <1319817030-23992-2-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319817030-23992-2-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 10:50:30AM -0500, Kumar Gala wrote:

A few remarks below.

> +static void __init dpa_uio_portal_init(struct dpa_uio_portal *p,
> +				const struct dpa_uio_class *c)

This can't be "void". You have to return apropiate errors.

> +{
> +	struct dpa_uio_info *info;
> +	const struct resource *res;
> +	u32 index;
> +	int irq, ret;
> +
> +	/* allocate 'info' */
> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		return;

return -ENOMEM (more similar cases below)

> +	atomic_set(&info->ref, 1);
> +	if (p->type == dpa_uio_portal_bman) {
> +		res = &p->bm_cfg->addr_phys[0];
> +		index = p->bm_cfg->public_cfg.index;
> +		irq = p->bm_cfg->public_cfg.irq;
> +	} else {
> +		res = &p->qm_cfg->addr_phys[0];
> +		index = p->qm_cfg->public_cfg.index;
> +		irq = p->qm_cfg->public_cfg.irq;
> +	}
> +	/* We need to map the cache-inhibited region in the kernel for
> +	 * interrupt-handling purposes. */
> +	info->addr_ci = ioremap_prot(res[DPA_PORTAL_CI].start,
> +				resource_size(&res[DPA_PORTAL_CI]),
> +				_PAGE_GUARDED | _PAGE_NO_CACHE);
> +	/* Name the UIO device according to the cell-index. It's supposed to be
> +	 * unique for each device class (Qman/Bman), and is also a convenient
> +	 * way for user-space to find the UIO device that corresponds to a given
> +	 * portal device-tree node. */
> +	sprintf(info->name, "%s%x", c->dev_prefix, index);
> +	info->pdev = platform_device_alloc(info->name, -1);
> +	if (!info->pdev) {
> +		iounmap(info->addr_ci);
> +		kfree(info);
> +		pr_err("dpa_uio_portal: platform_device_alloc() failed\n");
> +		return;
> +	}
> +	ret = platform_device_add(info->pdev);
> +	if (ret) {
> +		platform_device_put(info->pdev);
> +		iounmap(info->addr_ci);
> +		kfree(info);
> +		pr_err("dpa_uio_portal: platform_device_add() failed\n");
> +		return;
> +	}
> +	info->uio.name = info->name;
> +	info->uio.version = dpa_uio_version;
> +	info->uio.mem[DPA_PORTAL_CE].name = "cena";
> +	info->uio.mem[DPA_PORTAL_CE].addr = res[DPA_PORTAL_CE].start;
> +	info->uio.mem[DPA_PORTAL_CE].size = resource_size(&res[DPA_PORTAL_CE]);
> +	info->uio.mem[DPA_PORTAL_CE].memtype = UIO_MEM_PHYS;
> +	info->uio.mem[DPA_PORTAL_CI].name = "cinh";
> +	info->uio.mem[DPA_PORTAL_CI].addr = res[DPA_PORTAL_CI].start;
> +	info->uio.mem[DPA_PORTAL_CI].size = resource_size(&res[DPA_PORTAL_CI]);
> +	info->uio.mem[DPA_PORTAL_CI].memtype = UIO_MEM_PHYS;
> +	info->uio.irq = irq;
> +	info->uio.handler = dpa_uio_irq_handler;
> +	info->uio.set_pgprot = dpa_uio_pgprot;
> +	info->uio.open = dpa_uio_open;
> +	info->uio.release = dpa_uio_release;
> +	ret = uio_register_device(&info->pdev->dev, &info->uio);

This should be the last thing you do before return. You can have
interrupts even before uio_register_device returns.

> +	if (ret) {
> +		platform_device_del(info->pdev);
> +		platform_device_put(info->pdev);
> +		iounmap(info->addr_ci);
> +		kfree(info);
> +		pr_err("dpa_uio_portal: UIO registration failed\n");
> +		return;
> +	}
> +	list_add_tail(&info->node, &uio_portal_list);

That should probably be done prior to uio_register_device.

> +	pr_info("USDPAA portal initialised, %s\n", info->name);
> +}
> +
> +static int __init dpa_uio_init(void)
> +{
> +	const struct dpa_uio_class *classes[3], **c = classes;
> +	classes[0] = dpa_uio_bman();
> +	classes[1] = dpa_uio_qman();
> +	classes[2] = NULL;
> +	while (*c) {
> +		struct dpa_uio_portal *p;
> +		list_for_each_entry(p, &(*c)->list, node)
> +			dpa_uio_portal_init(p, *c);
> +		c++;
> +	}
> +	pr_info("USDPAA portal layer loaded\n");
> +	return 0;

You can't just return OK here if dpa_uio_portal_init() fails.

> +}
> +
> +static void __exit dpa_uio_exit(void)
> +{
> +	struct dpa_uio_info *info, *tmp;
> +	list_for_each_entry_safe(info, tmp, &uio_portal_list, node) {
> +		list_del(&info->node);
> +		uio_unregister_device(&info->uio);
> +		platform_device_del(info->pdev);
> +		platform_device_put(info->pdev);
> +		iounmap(info->addr_ci);
> +		pr_info("USDPAA portal removed, %s\n", info->name);
> +		kfree(info);
> +	}
> +	pr_info("USDPAA portal layer unloaded\n");
> +}
> +
> +
> +module_init(dpa_uio_init)
> +module_exit(dpa_uio_exit)
> +MODULE_LICENSE("GPL");
> +
> -- 
> 1.7.3.4
> 
> 
