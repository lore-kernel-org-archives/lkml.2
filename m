Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2DEUWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 16:22:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44038 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584Ab2DEUWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 16:22:07 -0400
Message-ID: <4F7DFED5.4030000@ti.com>
Date: Thu, 5 Apr 2012 15:21:41 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <dwmw2@infradead.org>,
        <sameo@linux.intel.com>, <grinberg@compulab.co.il>,
        <mike@compulab.co.il>, <nm@ti.com>, <artem.bityutskiy@linux.intel.com>,
        <vimal.newwork@gmail.com>, <dbaryshkov@gmail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: Re: [PATCH v3 1/9] ARM: OMAP2+: gpmc: driver conversion
References: <cover.1333640054.git.afzal@ti.com> <cefbe934da40f0a169b1e3a75c46451e5546a8bd.1333640054.git.afzal@ti.com>
In-Reply-To: <cefbe934da40f0a169b1e3a75c46451e5546a8bd.1333640054.git.afzal@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.115.64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Afzal,

On 04/05/2012 10:45 AM, Afzal Mohammed wrote:

[...]

> +struct gpmc_irq	{
> +	unsigned		irq;
> +	u32			regval;

Are you using regval to indicate the bit-mask? If so, maybe call it 
"bitmask" instead.

[...]

> +static __devinit
> +int gpmc_setup_cs_irq(struct gpmc *gpmc, struct gpmc_device_pdata *gdp,
> +			struct gpmc_cs_data *cs, struct resource *res)
> +{
> +	int i, n, val;
> +
> +	for (i = 0, n = 0; i<  gpmc->num_irq; i++)
> +		if (gpmc->irq[i].regval&  cs->irq_flags) {
> +			res[n].start = res[n].end = gpmc->irq[i].irq;
> +			res[n].flags = IORESOURCE_IRQ;
> +
> +			dev_info(gpmc->dev, "resource irq %u for %s "
> +				"(on CS %d) [bit: %x]\n", res[n].start,
> +				gdp->name, cs->cs, __ffs(gpmc->irq[i].regval));
> +
> +			switch (gpmc->irq[i].regval) {
> +			case GPMC_IRQ_WAIT0EDGEDETECTION:
> +			case GPMC_IRQ_WAIT1EDGEDETECTION:
> +			case GPMC_IRQ_WAIT2EDGEDETECTION:
> +			case GPMC_IRQ_WAIT3EDGEDETECTION:
> +				val = __ffs(gpmc->irq[i].regval);
> +				val -= __ffs(GPMC_IRQ_WAIT0EDGEDETECTION);
> +				gpmc_cs_configure(cs->cs,
> +					GPMC_CONFIG_WAITPIN, val);

Why is the configuration of the wait pin done here? It is possible to 
use the wait pin may be used without enabling the interrupt.

Where do you handle allocating the wait pins to ensure two devices don't 
attempt to use the same one? Like how the CS are managed.

Also, where you you configure the polarity of the wait pins? I would 
have thought it would make sense to have the wait pin configured as part 
of the cs configuration.

> +			}
> +			n++;
> +		}
> +
> +	return n;
> +}
> +
> +static __devinit int gpmc_setup_device(struct gpmc_device_pdata *gdp,
> +				struct gpmc_device *dev, struct gpmc *gpmc)
> +{
> +	int i, j, n;
> +	struct gpmc_cs_data *cs;
> +
> +	for (i = 0, n = 0, cs = gdp->cs_data; i<  gdp->num_cs; i++, cs++)
> +		n += hweight32(cs->irq_flags&  GPMC_IRQ_MASK);
> +
> +	n += gdp->num_cs;
> +
> +	dev->gpmc_res = devm_kzalloc(gpmc->dev, sizeof(*dev->gpmc_res) * n,
> +								GFP_KERNEL);
> +	if (dev->gpmc_res == NULL) {
> +		dev_err(gpmc->dev, "error: memory allocation\n");
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0, j = 0, cs = gdp->cs_data; i<  gdp->num_cs; cs++, i++) {
> +		dev->gpmc_res[j] = gpmc_setup_cs_mem(cs, gdp, gpmc);
> +		if (dev->gpmc_res[j++].flags&  IORESOURCE_MEM)
> +			j += gpmc_setup_cs_irq(gpmc, gdp, cs,
> +						dev->gpmc_res + j);
> +		else {
> +			dev_err(gpmc->dev, "error: setup for %s\n", gdp->name);
> +			devm_kfree(gpmc->dev, dev->gpmc_res);
> +			dev->gpmc_res = NULL;
> +			dev->num_gpmc_res = 0;
> +			return -EINVAL;
> +		}
>   	}

This section of code is not straight-forward to read. I see what you are 
doing, but I am wondering if this could be improved.

First of all, returning a structure from a function is making this code 
harder to read. Per the CodingStyle document in the kernel, it is 
preferred for a function to return success or failure if the function is 
an action, like a setup.

Secondly, do you need to pass cs, gdp and gpmc to gpmc_setup_cs_mem()? 
It appears that gdp and gpmc are only used for prints. You could 
probably avoid passing gdp and move the print to outside this function.

> +	dev->num_gpmc_res = j;
>
> -	ret = request_irq(gpmc_irq,
> -			gpmc_handle_irq, IRQF_SHARED, "gpmc", gpmc_base);
> -	if (ret)
> -		pr_err("gpmc: irq-%d could not claim: err %d\n",
> -						gpmc_irq, ret);
> -	return ret;
> +	dev->name = gdp->name;
> +	dev->id = gdp->id;
> +	dev->pdata = gdp->pdata;
> +	dev->pdata_size = gdp->pdata_size;
> +	dev->per_res = gdp->per_res;
> +	dev->num_per_res = gdp->num_per_res;
> +
> +	return 0;
> +}
> +
> +static __devinit
> +struct platform_device *gpmc_create_device(struct gpmc_device *p,
> +							struct gpmc *gpmc)
> +{
> +	int num = p->num_per_res + p->num_gpmc_res;
> +	struct resource *res;
> +	struct platform_device *pdev;
> +
> +	res = devm_kzalloc(gpmc->dev, sizeof(struct resource) * num,
> +								GFP_KERNEL);
> +	if (!res) {
> +		dev_err(gpmc->dev, "error: allocating memory\n");
> +		return NULL;
> +	}
> +
> +	memcpy((char *)res, (const char *) p->gpmc_res,
> +				sizeof(struct resource) * p->num_gpmc_res);
> +	memcpy((char *)(res + p->num_gpmc_res), (const char *)p->per_res,
> +				sizeof(struct resource) * p->num_per_res);
> +
> +	pdev = platform_device_register_resndata(gpmc->dev, p->name, p->id,
> +					res, num, p->pdata, p->pdata_size);
> +
> +	devm_kfree(gpmc->dev, res);
> +
> +	return pdev;
>   }
> -postcore_initcall(gpmc_init);
>
>   static irqreturn_t gpmc_handle_irq(int irq, void *dev)
>   {
> -	u8 cs;
> +	int i;
> +	u32 regval;
> +	struct gpmc *gpmc = dev;
>
> -	/* check cs to invoke the irq */
> -	cs = ((gpmc_read_reg(GPMC_PREFETCH_CONFIG1))>>  CS_NUM_SHIFT)&  0x7;
> -	if (OMAP_GPMC_IRQ_BASE+cs<= OMAP_GPMC_IRQ_END)
> -		generic_handle_irq(OMAP_GPMC_IRQ_BASE+cs);
> +	regval = gpmc_read_reg(GPMC_IRQSTATUS);
> +
> +
> +	for (i = 0; i<  gpmc->num_irq; i++)
> +		if (regval&  gpmc->irq[i].regval)
> +			generic_handle_irq(gpmc->irq[i].irq);
> +	gpmc_write_reg(GPMC_IRQSTATUS, regval);
>
>   	return IRQ_HANDLED;
>   }
>
> +static int gpmc_irq_endis(struct irq_data *p, bool endis)
> +{
> +	struct gpmc *gpmc = irq_data_get_irq_chip_data(p);
> +	int i;
> +	u32 regval;
> +
> +	for (i = 0; i<  gpmc->num_irq; i++)
> +		if (p->irq == gpmc->irq[i].irq) {
> +			regval = gpmc_read_reg(GPMC_IRQENABLE);
> +			if (endis)
> +				regval |= gpmc->irq[i].regval;
> +			else
> +				regval&= ~gpmc->irq[i].regval;
> +			gpmc_write_reg(GPMC_IRQENABLE, regval);
> +			break;
> +		}
> +
> +	return 0;
> +}
> +
> +static void gpmc_irq_disable(struct irq_data *p)
> +{
> +	gpmc_irq_endis(p, false);
> +}
> +
> +static void gpmc_irq_enable(struct irq_data *p)
> +{
> +	gpmc_irq_endis(p, true);
> +}
> +
> +static void gpmc_irq_noop(struct irq_data *data) { }
> +
> +static unsigned int gpmc_irq_noop_ret(struct irq_data *data) { return 0; }
> +
> +static __devinit int gpmc_setup_irq(struct gpmc *gpmc)
> +{
> +	int i;
> +	u32 regval;
> +
> +	if (!gpmc->master_irq)
> +		return -EINVAL;
> +
> +	if (gpmc->num_irq<  GPMC_NR_IRQ) {
> +		dev_warn(gpmc->dev, "Insufficient interrupts for device\n");
> +		return -EINVAL;
> +	} else if (gpmc->num_irq>  GPMC_NR_IRQ)
> +		gpmc->num_irq = GPMC_NR_IRQ;

Hmmm ... why not just have ...

	if (gpmc->num_irq != GPMC_NR_IRQ) {
		dev_warn(...);
		return -EINVAL;
	}

This also raises the question why bother passing num_irq if we always 
want it to be GPMC_NR_IRQ? Why not always initialise them all driver?

> +	gpmc->irq[0].regval = GPMC_IRQ_FIFOEVENT;
> +	gpmc->irq[1].regval = GPMC_IRQ_TERMINALCOUNT;
> +	gpmc->irq[2].regval = GPMC_IRQ_WAIT0EDGEDETECTION;
> +	gpmc->irq[3].regval = GPMC_IRQ_WAIT1EDGEDETECTION;
> +	gpmc->irq[4].regval = GPMC_IRQ_WAIT2EDGEDETECTION;
> +	gpmc->irq[5].regval = GPMC_IRQ_WAIT3EDGEDETECTION;
> +
> +	for (i = 0; i<  gpmc->num_irq; i++)
> +		gpmc->irq[i].irq = gpmc->irq_start + i;
> +
> +	gpmc->irq_chip.name = "gpmc";
> +	gpmc->irq_chip.irq_startup = gpmc_irq_noop_ret;
> +	gpmc->irq_chip.irq_enable = gpmc_irq_enable;
> +	gpmc->irq_chip.irq_disable = gpmc_irq_disable;
> +	gpmc->irq_chip.irq_shutdown = gpmc_irq_noop;
> +	gpmc->irq_chip.irq_ack = gpmc_irq_noop;
> +	gpmc->irq_chip.irq_mask = gpmc_irq_noop;
> +	gpmc->irq_chip.irq_unmask = gpmc_irq_noop;
> +
> +	for (i = 0; i<  gpmc->num_irq; i++) {
> +		irq_set_chip_and_handler(gpmc->irq[i].irq,
> +					&gpmc->irq_chip, handle_simple_irq);
> +		irq_set_chip_data(gpmc->irq[i].irq, gpmc);
> +		set_irq_flags(gpmc->irq[i].irq, IRQF_VALID | IRQF_NOAUTOEN);
> +	}
> +
> +	/* clear interrupts */
> +	regval = gpmc_read_reg(GPMC_IRQSTATUS);
> +	gpmc_write_reg(GPMC_IRQSTATUS, regval);
> +
> +	return request_irq(gpmc->master_irq, gpmc_handle_irq, IRQF_SHARED,
> +							"gpmc", gpmc);
> +}
> +
> +static __devinit int gpmc_probe(struct platform_device *pdev)
> +{
> +	u32 l;
> +	int i;
> +	int ret = 0;
> +	struct resource *res = NULL;
> +	struct gpmc_pdata *gp = dev_get_platdata(&pdev->dev);
> +	struct gpmc_device_pdata **gdq = NULL;
> +	struct gpmc_device *gd = NULL;
> +
> +	gpmc = devm_kzalloc(&pdev->dev, sizeof(struct gpmc), GFP_KERNEL);
> +	if (gpmc == NULL)
> +		return -ENOMEM;
> +
> +	gpmc->dev =&pdev->dev;
> +	gpmc->fclk_period = gp->fclk_period;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res == NULL)
> +		return -ENOENT;
> +
> +	gpmc->phys_base = res->start;
> +	gpmc->memsize = resource_size(res);
> +
> +	gpmc->io_base = devm_request_and_ioremap(gpmc->dev, res);
> +	if (!gpmc->io_base)
> +		return -EADDRNOTAVAIL;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (res == NULL)
> +		dev_warn(gpmc->dev, "Failed to get resource: irq\n");
> +	else
> +		gpmc->master_irq = res->start;

Why not return an error if the IRQ is not found? We don't know if anyone 
will be trying to use them.

> +	gpmc->irq_start = gp->irq_start;
> +	gpmc->num_irq = gp->num_irq;
> +	gpmc_setup_irq(gpmc);
> +
> +	gpmc->ecc_used = -EINVAL;
> +	spin_lock_init(&gpmc->mem_lock);
> +	platform_set_drvdata(pdev, gpmc);
> +
> +	l = gpmc_read_reg(GPMC_REVISION);
> +	dev_info(gpmc->dev, "GPMC revision %d.%d\n", (l>>  4)&  0x0f, l&  0x0f);
> +
> +	gpmc_mem_init();
> +
> +	for (gdq = gp->device_pdata, gd = gpmc->device; *gdq; gdq++, i++) {
> +		ret = gpmc_setup_device(*gdq, gd, gpmc);
> +		if (IS_ERR_VALUE(ret))
> +			dev_err(gpmc->dev, "gpmc setup on %s failed\n",
> +								(*gdq)->name);
> +		else
> +			gd++;
> +	}

Would a while loop be simpler?

The above loop appears to terminate when *gdq == 0. Is this always 
guaranteed? In other words, safe?

I see that "i" is not being used in the above loop either.

> +	gpmc->num_device = gd - gpmc->device;
> +
> +	for (i = 0, gd = gpmc->device; i<  gpmc->num_device; i++, gd++)
> +		if (IS_ERR(gpmc_create_device(gd, gpmc)))
> +			dev_err(gpmc->dev, "device creation on %s failed\n",
> +								gd->name);
> +
> +	return 0;
> +}
> +
> +static __devexit int gpmc_free_irq(struct gpmc *gpmc)
> +{
> +	/* TODO: free gpmc irq chip */
> +
> +	if (gpmc->master_irq)
> +		free_irq(gpmc->master_irq, gpmc);
> +
> +	return 0;
> +}
> +
> +static __devexit int gpmc_remove(struct platform_device *pdev)
> +{
> +	struct gpmc *gpmc = platform_get_drvdata(pdev);
> +
> +	platform_set_drvdata(pdev, NULL);
> +	gpmc_free_irq(gpmc);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver gpmc_driver = {
> +	.probe		= gpmc_probe,
> +	.remove		= __devexit_p(gpmc_remove),
> +	.driver		= {
> +		.name	= DRIVER_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(gpmc_driver);
> +
>   #ifdef CONFIG_ARCH_OMAP3
>   static struct omap3_gpmc_regs gpmc_context;
>
> @@ -855,10 +1193,10 @@ int gpmc_enable_hwecc(int cs, int mode, int dev_width, int ecc_size)
>   	unsigned int val;
>
>   	/* check if ecc module is in used */
> -	if (gpmc_ecc_used != -EINVAL)
> +	if (gpmc->ecc_used != -EINVAL)
>   		return -EINVAL;
>
> -	gpmc_ecc_used = cs;
> +	gpmc->ecc_used = cs;
>
>   	/* clear ecc and enable bits */
>   	val = ((0x00000001<<8) | 0x00000001);
> @@ -906,7 +1244,7 @@ int gpmc_calculate_ecc(int cs, const u_char *dat, u_char *ecc_code)
>   {
>   	unsigned int val = 0x0;
>
> -	if (gpmc_ecc_used != cs)
> +	if (gpmc->ecc_used != cs)
>   		return -EINVAL;
>
>   	/* read ecc result */
> @@ -916,7 +1254,7 @@ int gpmc_calculate_ecc(int cs, const u_char *dat, u_char *ecc_code)
>   	/* P2048o, P1024o, P512o, P256o, P2048e, P1024e, P512e, P256e */
>   	*ecc_code++ = ((val>>  8)&  0x0f) | ((val>>  20)&  0xf0);
>
> -	gpmc_ecc_used = -EINVAL;
> +	gpmc->ecc_used = -EINVAL;
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(gpmc_calculate_ecc);
> diff --git a/arch/arm/plat-omap/include/plat/gpmc.h b/arch/arm/plat-omap/include/plat/gpmc.h
> index 1527929..fa62cdf 100644
> --- a/arch/arm/plat-omap/include/plat/gpmc.h
> +++ b/arch/arm/plat-omap/include/plat/gpmc.h
> @@ -36,6 +36,7 @@
>   #define GPMC_PREFETCH_FIFO_CNT	0x00000007 /* bytes available in FIFO for r/w */
>   #define GPMC_PREFETCH_COUNT	0x00000008 /* remaining bytes to be read/write*/
>   #define GPMC_STATUS_BUFFER	0x00000009 /* 1: buffer is available to write */
> +#define GPMC_CONFIG_WAITPIN	0x0000000A
>
>   #define GPMC_NAND_COMMAND	0x0000000a
>   #define GPMC_NAND_ADDRESS	0x0000000b
> @@ -83,6 +84,17 @@
>   #define GPMC_IRQ_FIFOEVENTENABLE	0x01
>   #define GPMC_IRQ_COUNT_EVENT		0x02
>
> +#define	GPMC_IRQ_FIFOEVENT		BIT(0)
> +#define	GPMC_IRQ_TERMINALCOUNT		BIT(1)
> +#define	GPMC_IRQ_WAIT0EDGEDETECTION	BIT(8)
> +#define	GPMC_IRQ_WAIT1EDGEDETECTION	BIT(9)
> +#define	GPMC_IRQ_WAIT2EDGEDETECTION	BIT(10)
> +#define	GPMC_IRQ_WAIT3EDGEDETECTION	BIT(11)
> +#define	GPMC_IRQ_MASK	\
> +	(GPMC_IRQ_FIFOEVENT | GPMC_IRQ_TERMINALCOUNT | \
> +	GPMC_IRQ_WAIT0EDGEDETECTION | GPMC_IRQ_WAIT1EDGEDETECTION | \
> +	GPMC_IRQ_WAIT2EDGEDETECTION | GPMC_IRQ_WAIT3EDGEDETECTION)
> +
>   #define PREFETCH_FIFOTHRESHOLD_MAX	0x40
>   #define PREFETCH_FIFOTHRESHOLD(val)	((val)<<  8)
>
> @@ -131,6 +143,42 @@ struct gpmc_timings {
>   	u16 wr_data_mux_bus;	/* WRDATAONADMUXBUS */
>   };
>
> +struct gpmc_config {
> +	int cmd;
> +	int val;
> +};
> +
> +struct gpmc_cs_data {
> +	unsigned		cs;
> +	unsigned long		mem_size;
> +	unsigned long		mem_start;
> +	unsigned long		mem_offset;
> +	struct gpmc_config	*config;
> +	unsigned		num_config;
> +	struct gpmc_timings	*timing;
> +	unsigned		irq_flags;

I found the name irq_flags a bit unclear. This appears to be a mask for 
the interrupts used. So may be this should be "irq_mask" or just "irqs".

> +};
> +
> +struct gpmc_device_pdata {
> +	char			*name;
> +	int			id;
> +	void			*pdata;
> +	unsigned		pdata_size;
> +	/* resources configured via GPMC will be created by GPMC driver */
> +	struct resource		*per_res;
> +	unsigned		num_per_res;
> +	struct gpmc_cs_data	*cs_data;
> +	unsigned		num_cs;
> +};
> +
> +struct gpmc_pdata {
> +	/* GPMC_FCLK period in picoseconds */
> +	unsigned long			fclk_period;
> +	struct gpmc_device_pdata	**device_pdata;
> +	unsigned			irq_start;
> +	unsigned			num_irq;

Again, not sure why we need to pass num_irq.

Cheers
Jon
