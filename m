Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab1BRQwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:52:15 -0500
Received: from www.tglx.de ([62.245.132.106]:58421 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100Ab1BRQwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:52:13 -0500
Date: Fri, 18 Feb 2011 17:51:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
cc: davinci-linux-open-source@linux.davincidsp.com,
        "Hans J. Koch" <hjk@hansjkoch.de>, gregkh@suse.de,
        amit.chatterjee@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] PRUSS UIO driver support
In-Reply-To: <1298041530-26855-2-git-send-email-pratheesh@ti.com>
Message-ID: <alpine.LFD.2.00.1102181715260.2701@localhost6.localdomain6>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com> <1298041530-26855-2-git-send-email-pratheesh@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Pratheesh Gangadhar wrote:
> +/*
> + * Host event IRQ numbers from PRUSS 	
> + * 3 PRU_EVTOUT0 PRUSS Interrupt
> + * 4 PRU_EVTOUT1 PRUSS Interrupt
> + * 5 PRU_EVTOUT2 PRUSS Interrupt
> + * 6 PRU_EVTOUT3 PRUSS Interrupt
> + * 7 PRU_EVTOUT4 PRUSS Interrupt
> + * 8 PRU_EVTOUT5 PRUSS Interrupt
> + * 9 PRU_EVTOUT6 PRUSS Interrupt
> + * 10 PRU_EVTOUT7 PRUSS Interrupt
> +*/
> +
> +#define MAX_PRUSS_EVTOUT_INSTANCE	(8)
> +
> +static struct clk *pruss_clk;
> +static struct uio_info *info[MAX_PRUSS_EVTOUT_INSTANCE];
> +static void *ddr_virt_addr;
> +static dma_addr_t ddr_phy_addr;
> +
> +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> +{
> +	return IRQ_HANDLED;

  See other mail.

> +}
> +
> +static int __devinit pruss_probe(struct platform_device *dev)
> +{
> +	int ret = -ENODEV;
> +	int count = 0;

  Please make this one line.

> +	struct resource *regs_pruram, *regs_l3ram, *regs_ddr;
> +	char *string;
> +
> +	/* Power on PRU in case its not done as part of boot-loader */
> +	pruss_clk = clk_get(&dev->dev, "pruss");
> +	if (IS_ERR(pruss_clk)) {
> +		dev_err(&dev->dev, "Failed to get clock\n");
> +		ret = PTR_ERR(pruss_clk);
> +		pruss_clk = NULL;
> +		return ret;
> +	} else {
> +		clk_enable(pruss_clk);
> +	}
> +
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
> +		info[count] = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
> +		if (!info[count])
> +			return -ENOMEM;

  That leaks memory in case of count > 0

  And this whole loop is crap:

  struct uio_info *info = kzalloc(sizeof(struct uio_info) * MAX_PRUSS_EVTOUT_INSTANCE,
  	 	  	  	  GFP_KERNEL);

  perhaps ?		

> +	}
> +
> +	regs_pruram = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	if (!regs_pruram) {
> +		dev_err(&dev->dev, "No memory resource specified\n");
> +		goto out_free;
> +	}
> +
> +	regs_l3ram = platform_get_resource(dev, IORESOURCE_MEM, 1);
> +	if (!regs_l3ram) {
> +		dev_err(&dev->dev, "No memory resource specified\n");
> +		goto out_free;
> +	}
> +
> +	regs_ddr = platform_get_resource(dev, IORESOURCE_MEM, 2);
> +	if (!regs_ddr) {
> +		dev_err(&dev->dev, "No memory resource specified\n");
> +		goto out_free;
> +	}
> +	ddr_virt_addr =
> +	    dma_alloc_coherent(&dev->dev, regs_ddr->end - regs_ddr->start + 1,
> +			       &ddr_phy_addr, GFP_KERNEL | GFP_DMA);
> +	if (!ddr_virt_addr) {
> +		dev_err(&dev->dev, "Could not allocate external memory\n");
> +		goto out_free;
> +	}
> +
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
> +		info[count]->mem[0].addr = regs_pruram->start;
> +		info[count]->mem[0].size =
> +		    regs_pruram->end - regs_pruram->start + 1;
> +		if (!info[count]->mem[0].addr
> +		    || !(info[count]->mem[0].size - 1)) {
> +			dev_err(&dev->dev, "Invalid memory resource\n");
> +			break;

  Is this break intentional ? Assume you have registered one uio
  instance already then ret = 0 and you fall into the good path below.

> +		}
> +		info[count]->mem[0].internal_addr =
> +		    ioremap(regs_pruram->start, info[count]->mem[0].size);
> +		if (!info[count]->mem[0].internal_addr) {
> +			dev_err(&dev->dev,
> +				"Can't remap memory address range\n");
> +			break;

  Ditto

> +		}
> +		info[count]->mem[0].memtype = UIO_MEM_PHYS;
> +
> +		info[count]->mem[1].addr = regs_l3ram->start;
> +		info[count]->mem[1].size =
> +		    regs_l3ram->end - regs_l3ram->start + 1;
> +		if (!info[count]->mem[1].addr
> +		    || !(info[count]->mem[1].size - 1)) {
> +			dev_err(&dev->dev, "Invalid memory resource\n");
> +			break;
> +		}
> +		info[count]->mem[1].internal_addr =
> +		    ioremap(regs_l3ram->start, info[count]->mem[1].size);
> +		if (!info[count]->mem[1].internal_addr) {
> +			dev_err(&dev->dev,
> +				"Can't remap memory address range\n");
> +			break;
> +		}
> +		info[count]->mem[1].memtype = UIO_MEM_PHYS;
> +
> +		info[count]->mem[2].addr = ddr_phy_addr;
> +		info[count]->mem[2].size = regs_ddr->end - regs_ddr->start + 1;
> +		if (!info[count]->mem[2].addr
> +		    || !(info[count]->mem[2].size - 1)) {
> +			dev_err(&dev->dev, "Invalid memory resource\n");
> +			break;

  This is silly. If ddr_virt_addr == NULL you never reach that code.


> +		}
> +		info[count]->mem[2].internal_addr = ddr_virt_addr;
> +		if (!info[count]->mem[2].internal_addr) {
> +			dev_err(&dev->dev,
> +				"Can't remap memory address range\n");

  This is silly. If ddr_virt_addr == NULL you never reach that code.

> +			break;
> +		}
> +		info[count]->mem[2].memtype = UIO_MEM_PHYS;
> +
> +		string = kzalloc(20, GFP_KERNEL);
> +		sprintf(string, "pruss_evt%d", count);
> +		info[count]->name = string;
> +		info[count]->version = "0.50";
> +
> +		/* Register PRUSS IRQ lines */
> +		info[count]->irq = IRQ_DA8XX_EVTOUT0 + count;
> +
> +		info[count]->irq_flags = IRQF_SHARED;

  Huch. That can be shared ? Then you must in the interrupt handler

  1) check whether the interrupt is originated from your device
  2) mask at the device level.

> +		info[count]->handler = pruss_handler;
> +
> +		ret = uio_register_device(&dev->dev, info[count]);
> +
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	if (ret < 0) {
> +		if (ddr_virt_addr)
> +			dma_free_coherent(&dev->dev,
> +					  regs_ddr->end - regs_ddr->start + 1,
> +					  ddr_virt_addr, ddr_phy_addr);
> +		while (count--) {
> +			uio_unregister_device(info[count]);
> +			kfree(info[count]->name);
> +			iounmap(info[count]->mem[0].internal_addr);

  Please move that section below the return 0 and use goto out_uio;
  instead of break;

  This is real horrible.

> +		}
> +	} else {
> +		platform_set_drvdata(dev, info);
> +		return 0;
> +	}
> +
> +out_free:
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++)
> +		kfree(info[count]);
> +
> +	if (pruss_clk != NULL)
> +		clk_put(pruss_clk);
> +
> +	return ret;
> +}
> +
> +static int __devexit pruss_remove(struct platform_device *dev)
> +{
> +	int count = 0;
> +	struct uio_info **info;
> +
> +	info = (struct uio_info **)platform_get_drvdata(dev);
> +
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
> +		uio_unregister_device(info[count]);
> +		kfree(info[count]->name);

  In the above error exit path you do:

		iounmap(info[count]->mem[0].internal_addr);

  And in both cases you dont unmap info[count]->mem[1].internal_addr

  Why do you have those kernel mappings at all if you do not access
  the device from this code ?

> +
> +	}
> +	iounmap(info[0]->mem[0].internal_addr);
> +	iounmap(info[0]->mem[1].internal_addr);

  Sigh

> +	if (ddr_virt_addr)
> +		dma_free_coherent(&dev->dev, info[0]->mem[2].size,
> +				  info[0]->mem[2].internal_addr,
> +				  info[0]->mem[2].addr);
> +
> +	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++)
> +		kfree(info[count]);
> +
> +	platform_set_drvdata(dev, NULL);
> +
> +	if (pruss_clk != NULL)
> +		clk_put(pruss_clk);
> +	return 0;

So you have basically the same cleanup code twice with different bugs.
Please avoid this kind of mistake which will happen with duplicated
code. The right way to do that is creating a cleanup function and call
them from both places.

You can call uio_unregister_device on a non registered info struct as
well. So all it takes is:

	if (ddr_virt_addr)
		dma_free_coherent(&dev->dev, info[0]->mem[2].size,
				  info[0]->mem[2].internal_addr,
				  info[0]->mem[2].addr);

	for (count = 0; count < MAX_PRUSS_EVTOUT_INSTANCE; count++) {
      	  	if (!info[count])
			break;

		uio_unregister_device(info[count]);
		kfree(info[count]->name);
		...
		kfree(info[count]);
		info[count] = NULL; 
        }

	platform_set_drvdata(dev, NULL);

	if (pruss_clk)
		clk_put(pruss_clk);

Thanks,

	tglx
