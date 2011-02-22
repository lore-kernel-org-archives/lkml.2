Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1BVL7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:59:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50263 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1BVL7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:59:09 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 22 Feb 2011 17:28:43 +0530
Subject: RE: [PATCH v2 1/2] PRUSS UIO driver support
Thread-Topic: [PATCH v2 1/2] PRUSS UIO driver support
Thread-Index: AcvR+M03u54fQn+RS3aI3/RZEtYLtgAjG98Q
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BD49152@dbde02.ent.ti.com>
References: <1298309715-21362-1-git-send-email-pratheesh@ti.com>
 <1298309715-21362-2-git-send-email-pratheesh@ti.com>
 <alpine.LFD.2.00.1102211939110.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102211939110.2701@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Tuesday, February 22, 2011 12:24 AM
> To: TK, Pratheesh Gangadhar
> Cc: davinci-linux-open-source@linux.davincidsp.com; hjk@hansjkoch.de;
> gregkh@suse.de; Chatterjee, Amit; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v2 1/2] PRUSS UIO driver support
> 
> On Mon, 21 Feb 2011, Pratheesh Gangadhar wrote:
> > +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> > +{
> > +	void __iomem *int_enable_reg = dev_info->mem[0].internal_addr
> > +					+ PRUSS_INTC_HIER;
> > +	void __iomem *int_status_reg = dev_info->mem[0].internal_addr
> > +					+ PRUSS_INTC_HIPIR+((irq-1) << 2);
> 
>   	void __iomem *base = dev_info->mem[0].internal_addr;
> 	void __iomem *int_enable_reg = base + PRUSS_INTC_HIER;
> 	....
> 
> Makes that readable.
Ok.
> 
> > +	/* Is interrupt enabled and active ? */
> > +	if (!(ioread32(int_enable_reg) & (1<<(irq-1))) &&
> > +		 (ioread32(int_status_reg) & PRUSS_INTC_HIPIR_INTPEND_MASK))
> > +		return IRQ_NONE;
> 
>   That returns when the interrupt is disabled _AND_ pending. It should
>   return when the interrupt is disabled _OR_ not pending.
I should have named it _NOPEND_MASK, basically mask is set when there is no pending interrupt.

> > +
> > +	/* Disable interrupt */
> > +	iowrite32(ioread32(int_enable_reg) & ~(1<<(irq-1)),
> > +		int_enable_reg);
> 
> Chosing shorter variable names avoid those line breaks all over the
> place.
> 
Ok.
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static void pruss_cleanup(struct platform_device *dev, struct uio_info
> *info)
> > +{
> > +	int count;
> 
> New line between variables and code please
> 
Ok.
> > +	if (info) {
> 
> This check is silly. pruss_probe() returns right away when it cannot
> allocate info. pruss_remove() is never called when info == NULL
> 
Ok.
> > +		for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
> > +			uio_unregister_device(&info[count]);
> > +			kfree(info[count].name);
> > +			iounmap(info[count].mem[0].internal_addr);
> 
> Why do you map/unmap the same physical address 8 times ????
Will fix this.
> 
> > +		}
> > +		if (ddr_virt_addr)
> > +			dma_free_coherent(&dev->dev, info[0].mem[2].size,
> > +					  info[0].mem[2].internal_addr,
> > +					  info[0].mem[2].addr);
> > +		kfree(info);
> > +	}
> > +	if (pruss_clk != NULL)
> 
> Silly check as well.
> 
Ok.
> > +		clk_put(pruss_clk);
> > +}
> > +
> > +static int __devinit pruss_probe(struct platform_device *dev)
> > +{
> > +	int ret = -ENODEV, count = 0;
> > +	struct resource *regs_pruram, *regs_l3ram, *regs_ddr;
> > +	char *string;
> > +
> > +	/* Power on PRU in case its not done as part of boot-loader */
> > +	pruss_clk = clk_get(&dev->dev, "pruss");
> > +	if (IS_ERR(pruss_clk)) {
> > +		dev_err(&dev->dev, "Failed to get clock\n");
> > +		ret = PTR_ERR(pruss_clk);
> > +		return ret;
> > +	} else {
> > +		clk_enable(pruss_clk);
> > +	}
> > +
> > +	info = kzalloc(sizeof(struct uio_info) * MAX_PRUSS_EVTOUT_INSTANCE,
> > +		       GFP_KERNEL);
> > +	if (info == NULL)
> 
>   if (!info)
> 
> > +		return -ENOMEM;
> 
>   Leaves the clock enabled
> 
Will fix this.
> > +	regs_pruram = platform_get_resource(dev, IORESOURCE_MEM, 0);
> > +	if (!regs_pruram) {
> > +		dev_err(&dev->dev, "No memory resource specified\n");
> > +		goto out_free;
> > +	}
> > +
> > +	regs_l3ram = platform_get_resource(dev, IORESOURCE_MEM, 1);
> > +	if (!regs_l3ram) {
> > +		dev_err(&dev->dev, "No memory resource specified\n");
> > +		goto out_free;
> > +	}
> > +
> > +	regs_ddr = platform_get_resource(dev, IORESOURCE_MEM, 2);
> > +	if (!regs_ddr) {
> > +		dev_err(&dev->dev, "No memory resource specified\n");
> > +		goto out_free;
> > +	}
> > +	ddr_virt_addr =
> > +	    dma_alloc_coherent(&dev->dev, regs_ddr->end - regs_ddr->start +
> 1,
> > +			       &ddr_phy_addr, GFP_KERNEL | GFP_DMA);
> > +	if (!ddr_virt_addr) {
> > +		dev_err(&dev->dev, "Could not allocate external memory\n");
> > +		goto out_free;
> > +	}
> > +
> > +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
> 
> Sigh. Can't you have a pointer struct uio_info *p and do the following.
> 
Ok.
>       for (cnt = 0; p = info; cnt < MAX_PRUSS_EVTOUT_INSTANCE; cnt++, p++)
> {
> 
>       	       p->mem[0] ...
> 
> > +		info[count].mem[0].addr = regs_pruram->start;
> > +		info[count].mem[0].size =
> > +		    regs_pruram->end - regs_pruram->start + 1;
> > +		if (!info[count].mem[0].addr ||
> > +			!(info[count].mem[0].size - 1)) {
> 
> All you catch is size == 0. So with size == 1 it works ???
I can drop this check as well as normally one won't specify improbable size for mapping memory during configuration.
> 
> > +			dev_err(&dev->dev, "Invalid memory resource\n");
> > +			goto out_free;
> > +		}
> > +		info[count].mem[0].internal_addr =
> > +		    ioremap(regs_pruram->start, info[count].mem[0].size);
> 
> That's redundant to remap the same address 8 times. That and the check
> above should be done before the loop and the result used in the loop.
> 
Ok, will do.
> > +		if (!info[count].mem[0].internal_addr) {
> > +			dev_err(&dev->dev,
> > +				"Can't remap memory address range\n");
> > +			goto out_free;
> > +		}
> > +		info[count].mem[0].memtype = UIO_MEM_PHYS;
> > +
> > +		info[count].mem[1].addr = regs_l3ram->start;
> > +		info[count].mem[1].size =
> > +		    regs_l3ram->end - regs_l3ram->start + 1;
> > +		if (!info[count].mem[1].addr ||
> > +			!(info[count].mem[1].size - 1)) {
> > +			dev_err(&dev->dev, "Invalid memory resource\n");
> > +			goto out_free;
> > +		}
> 
> No need to check the same thing over and over.
> 
> > +		info[count].mem[1].memtype = UIO_MEM_PHYS;
> > +
> > +		info[count].mem[2].internal_addr = ddr_virt_addr;
> > +		info[count].mem[2].addr = ddr_phy_addr;
> > +		info[count].mem[2].size = regs_ddr->end - regs_ddr->start + 1;
> > +		info[count].mem[2].memtype = UIO_MEM_PHYS;
> > +
> > +		string = kzalloc(20, GFP_KERNEL);
> > +		sprintf(string, "pruss_evt%d", count);
> > +		info[count].name = string;
> 
>   kasprintf() please
Ok.
> 
> > +		info[count].version = "0.50";
> > +
> > +		/* Register PRUSS IRQ lines */
> > +		info[count].irq = IRQ_DA8XX_EVTOUT0 + count;
> > +
> > +		info[count].irq_flags = 0;
> 
>   Is already zero
> 
Ok.
> > +		info[count].handler = pruss_handler;
> > +
> > +		ret = uio_register_device(&dev->dev, &info[count]);
> > +
> > +		if (ret < 0)
> > +			goto out_free;
> > +	}
> > +
> > +	platform_set_drvdata(dev, info);
> > +	return 0;
> > +
> > +out_free:
> > +	pruss_cleanup(dev, info);
> > +	return ret;
> > +}
> > +
> > +static int __devexit pruss_remove(struct platform_device *dev)
> > +{
> > +	struct uio_info *info = platform_get_drvdata(dev);
> 
> Empty line between variables and code.
> 
Ok.
> > +	pruss_cleanup(dev, info);
> > +	platform_set_drvdata(dev, NULL);
> > +	return 0;
> 
Thanks,
Pratheesh
