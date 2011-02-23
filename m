Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab1BWU0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:26:06 -0500
Received: from www.tglx.de ([62.245.132.106]:54838 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab1BWU0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:26:05 -0500
Date: Wed, 23 Feb 2011 21:25:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
cc: davinci-linux-open-source@linux.davincidsp.com, hjk@hansjkoch.de,
        gregkh@suse.de, amit.chatterjee@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/2] PRUSS UIO driver support
In-Reply-To: <1298469161-7644-2-git-send-email-pratheesh@ti.com>
Message-ID: <alpine.LFD.2.00.1102232057260.2701@localhost6.localdomain6>
References: <1298469161-7644-1-git-send-email-pratheesh@ti.com> <1298469161-7644-2-git-send-email-pratheesh@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Pratheesh Gangadhar wrote:

Is it actually too much of an hassle to cc the people who spent their
time to review previous versions of your patch ?

> +struct clk *pruss_clk;
> +struct uio_info *info;
> +void *ddr_virt_addr = NULL, *prussio_virt_addr = NULL;

Grrr. We do not initialize with NULL.

> +dma_addr_t ddr_phy_addr;

Also all of these want to be static.

> +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> +{
> +	void __iomem *base = dev_info->mem[0].internal_addr;
> +	void __iomem *intren_reg = base + PINTC_HIER;
> +	void __iomem *intrstat_reg = base + PINTC_HIPIR + ((irq - 1) << 2);
> +	int intren_regval = ioread32(intren_reg), intr_mask = (1 << (irq - 1));
> +
> +	/* Is interrupt enabled and active ? */
> +	if (!(intren_regval & intr_mask)
> +	    && (ioread32(intrstat_reg) & PINTC_HIPIR_NO_PEND_MASK))
> +		return IRQ_NONE;

You could avoid all these ugly line breaks by chosing sensible short
names for variables and defines.

> +	/* Disable interrupt */
> +	iowrite32((intren_regval & ~intr_mask), intren_reg);
> +	return IRQ_HANDLED;
> +}
> +
> +static void pruss_cleanup(struct platform_device *dev, struct uio_info *info)
> +{
> +	int count;
> +	struct uio_info *p;

Nit: I prefer the longer declarations above the shorter ones. It's
easier to parse, but that's really my personal preference. 

	struct uio_info *p;
	int count;

Compare and contrast it and decide yourself.

> +
> +	for (count = 0, p = info; count < MAX_PRUSS_EVTOUT_INSTANCE;
> +	     count++, p++) {

Aside of making that constant shorter, you could assign info to p in
the variable declaration already. So avoid that line break.

> +		uio_unregister_device(p);
> +		kfree(p->name);
> +	}
> +	iounmap(prussio_virt_addr);
> +	dma_free_coherent(&dev->dev, info[0].mem[2].size,
> +			  info[0].mem[2].internal_addr, info[0].mem[2].addr);

You sure, that iounmap and dma_free_coherent are too happy about being
called with NULL pointers?

> +
> +	kfree(info);
> +	clk_put(pruss_clk);
> +}
> +
> +static int __devinit pruss_probe(struct platform_device *dev)
> +{
> +	int ret = -ENODEV, count = 0;
> +	struct resource *regs_prussio, *regs_l3ram, *regs_ddr;
> +	struct uio_info *p;
> +
> +	info = kzalloc(sizeof(struct uio_info) * MAX_PRUSS_EVTOUT_INSTANCE,
> +		       GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	/* Power on PRU in case its not done as part of boot-loader */
> +	pruss_clk = clk_get(&dev->dev, "pruss");
> +	if (IS_ERR(pruss_clk)) {
> +		dev_err(&dev->dev, "Failed to get clock\n");
> +		ret = PTR_ERR(pruss_clk);
> +		return ret;

Memory leak.

> +	} else {
> +		clk_enable(pruss_clk);
> +	}
> +
> +	regs_prussio = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	if (!regs_prussio) {
> +		dev_err(&dev->dev, "No PRUSS I/O resource specified\n");
> +		goto out_free;
> +	}
> +
> +	regs_l3ram = platform_get_resource(dev, IORESOURCE_MEM, 1);
> +	if (!regs_l3ram) {
> +		dev_err(&dev->dev, "No L3 RAM resource specified\n");
> +		goto out_free;
> +	}
> +
> +	regs_ddr = platform_get_resource(dev, IORESOURCE_MEM, 2);
> +	if (!regs_ddr) {
> +		dev_err(&dev->dev, "No External RAM resource specified\n");
> +		goto out_free;
> +	}
> +
> +	if (!regs_prussio->start || !regs_l3ram->start) {
> +		dev_err(&dev->dev, "Invalid memory resource\n");
> +		goto out_free;
> +	}
> +
> +	ddr_virt_addr =
> +	    dma_alloc_coherent(&dev->dev, regs_ddr->end - regs_ddr->start + 1,
> +			       &ddr_phy_addr, GFP_KERNEL | GFP_DMA);
> +	if (!ddr_virt_addr) {
> +		dev_err(&dev->dev, "Could not allocate external memory\n");
> +		goto out_free;
> +	}
> +
> +	prussio_virt_addr =
> +	    ioremap(regs_prussio->start,
> +		    regs_prussio->end - regs_prussio->start + 1);

Either make those variable names shorter or do:

       len = regs_prussio->end - regs_prussio->start + 1;
       prussio_virt_addr = ioremap(regs_prussio->start, len);

Those multi line breaks are irritating and not necessary at all.

They result from mindlessly converting code following an unfortunately
popular codingstyle which is only readable on extra wide screen
monitors. I really wonder when people start to understand that the
human eye can only parse up to a certain line width easily. There is a
reason why newspapers are printed in columns.

Please be a bit more careful about this. Just mechanically converting
existing horrible code to 80 chars does not make it more readable and
less horrible than not converting it at all.

> +	if (prussio_virt_addr) {
> +		dev_err(&dev->dev, "Can't remap PRUSS I/O  address range\n");
> +		goto out_free;
> +	}
> +
> +	for (count = 0, p = info; count < MAX_PRUSS_EVTOUT_INSTANCE;
> +	     count++, p++) {

See above.

	for (cnt = 0, p = info; cnt < MAX_PRUSS_EVT; cnt++, p++) {

is better readable and contains exactly the same amount of
information.

Thanks,

	tglx
