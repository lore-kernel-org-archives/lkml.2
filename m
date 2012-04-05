Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2DEUem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 16:34:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44769 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035Ab2DEUel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 16:34:41 -0400
Message-ID: <4F7E01CF.3040203@ti.com>
Date: Thu, 5 Apr 2012 15:34:23 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: Kevin Hilman <khilman@ti.com>, <nm@ti.com>, <linux@arm.linux.org.uk>,
        <sameo@linux.intel.com>, <tony@atomide.com>,
        <artem.bityutskiy@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        Vaibhav Hiremath <hvaibhav@ti.com>, <dbaryshkov@gmail.com>,
        <vimal.newwork@gmail.com>, <grinberg@compulab.co.il>,
        <mike@compulab.co.il>, <linux-mtd@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/9] ARM: OMAP2+: gpmc: driver conversion
References: <cover.1333640054.git.afzal@ti.com> <cefbe934da40f0a169b1e3a75c46451e5546a8bd.1333640054.git.afzal@ti.com> <4F7DFED5.4030000@ti.com>
In-Reply-To: <4F7DFED5.4030000@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.115.64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Afzal,

On 04/05/2012 03:21 PM, Jon Hunter wrote:
> Hi Afzal,
>
> On 04/05/2012 10:45 AM, Afzal Mohammed wrote:
>
> [...]
>
>> +struct gpmc_irq {
>> + unsigned irq;
>> + u32 regval;
>
> Are you using regval to indicate the bit-mask? If so, maybe call it
> "bitmask" instead.
>
> [...]
>
>> +static __devinit
>> +int gpmc_setup_cs_irq(struct gpmc *gpmc, struct gpmc_device_pdata *gdp,
>> + struct gpmc_cs_data *cs, struct resource *res)
>> +{
>> + int i, n, val;
>> +
>> + for (i = 0, n = 0; i< gpmc->num_irq; i++)
>> + if (gpmc->irq[i].regval& cs->irq_flags) {
>> + res[n].start = res[n].end = gpmc->irq[i].irq;
>> + res[n].flags = IORESOURCE_IRQ;
>> +
>> + dev_info(gpmc->dev, "resource irq %u for %s "
>> + "(on CS %d) [bit: %x]\n", res[n].start,
>> + gdp->name, cs->cs, __ffs(gpmc->irq[i].regval));
>> +
>> + switch (gpmc->irq[i].regval) {
>> + case GPMC_IRQ_WAIT0EDGEDETECTION:
>> + case GPMC_IRQ_WAIT1EDGEDETECTION:
>> + case GPMC_IRQ_WAIT2EDGEDETECTION:
>> + case GPMC_IRQ_WAIT3EDGEDETECTION:
>> + val = __ffs(gpmc->irq[i].regval);
>> + val -= __ffs(GPMC_IRQ_WAIT0EDGEDETECTION);
>> + gpmc_cs_configure(cs->cs,
>> + GPMC_CONFIG_WAITPIN, val);
>
> Why is the configuration of the wait pin done here? It is possible to
> use the wait pin may be used without enabling the interrupt.

Sorry very bad english here on my part. I meant "it is possible to use a 
wait pin, without enabling the interrupt".

> Where do you handle allocating the wait pins to ensure two devices don't
> attempt to use the same one? Like how the CS are managed.
>
> Also, where you you configure the polarity of the wait pins? I would
> have thought it would make sense to have the wait pin configured as part
> of the cs configuration.
>
>> + }
>> + n++;
>> + }
>> +
>> + return n;
>> +}
>> +
>> +static __devinit int gpmc_setup_device(struct gpmc_device_pdata *gdp,
>> + struct gpmc_device *dev, struct gpmc *gpmc)
>> +{
>> + int i, j, n;
>> + struct gpmc_cs_data *cs;
>> +
>> + for (i = 0, n = 0, cs = gdp->cs_data; i< gdp->num_cs; i++, cs++)
>> + n += hweight32(cs->irq_flags& GPMC_IRQ_MASK);
>> +
>> + n += gdp->num_cs;
>> +
>> + dev->gpmc_res = devm_kzalloc(gpmc->dev, sizeof(*dev->gpmc_res) * n,
>> + GFP_KERNEL);
>> + if (dev->gpmc_res == NULL) {
>> + dev_err(gpmc->dev, "error: memory allocation\n");
>> + return -ENOMEM;
>> + }
>> +
>> + for (i = 0, j = 0, cs = gdp->cs_data; i< gdp->num_cs; cs++, i++) {
>> + dev->gpmc_res[j] = gpmc_setup_cs_mem(cs, gdp, gpmc);
>> + if (dev->gpmc_res[j++].flags& IORESOURCE_MEM)
>> + j += gpmc_setup_cs_irq(gpmc, gdp, cs,
>> + dev->gpmc_res + j);
>> + else {
>> + dev_err(gpmc->dev, "error: setup for %s\n", gdp->name);
>> + devm_kfree(gpmc->dev, dev->gpmc_res);
>> + dev->gpmc_res = NULL;
>> + dev->num_gpmc_res = 0;
>> + return -EINVAL;
>> + }
>> }
>
> This section of code is not straight-forward to read. I see what you are
> doing, but I am wondering if this could be improved.
>
> First of all, returning a structure from a function is making this code
> harder to read. Per the CodingStyle document in the kernel, it is
> preferred for a function to return success or failure if the function is
> an action, like a setup.
>
> Secondly, do you need to pass cs, gdp and gpmc to gpmc_setup_cs_mem()?
> It appears that gdp and gpmc are only used for prints. You could
> probably avoid passing gdp and move the print to outside this function.
>
>> + dev->num_gpmc_res = j;
>>
>> - ret = request_irq(gpmc_irq,
>> - gpmc_handle_irq, IRQF_SHARED, "gpmc", gpmc_base);
>> - if (ret)
>> - pr_err("gpmc: irq-%d could not claim: err %d\n",
>> - gpmc_irq, ret);
>> - return ret;
>> + dev->name = gdp->name;
>> + dev->id = gdp->id;
>> + dev->pdata = gdp->pdata;
>> + dev->pdata_size = gdp->pdata_size;
>> + dev->per_res = gdp->per_res;
>> + dev->num_per_res = gdp->num_per_res;
>> +
>> + return 0;
>> +}
>> +
>> +static __devinit
>> +struct platform_device *gpmc_create_device(struct gpmc_device *p,
>> + struct gpmc *gpmc)
>> +{
>> + int num = p->num_per_res + p->num_gpmc_res;
>> + struct resource *res;
>> + struct platform_device *pdev;
>> +
>> + res = devm_kzalloc(gpmc->dev, sizeof(struct resource) * num,
>> + GFP_KERNEL);
>> + if (!res) {
>> + dev_err(gpmc->dev, "error: allocating memory\n");
>> + return NULL;
>> + }
>> +
>> + memcpy((char *)res, (const char *) p->gpmc_res,
>> + sizeof(struct resource) * p->num_gpmc_res);
>> + memcpy((char *)(res + p->num_gpmc_res), (const char *)p->per_res,
>> + sizeof(struct resource) * p->num_per_res);
>> +
>> + pdev = platform_device_register_resndata(gpmc->dev, p->name, p->id,
>> + res, num, p->pdata, p->pdata_size);
>> +
>> + devm_kfree(gpmc->dev, res);
>> +
>> + return pdev;
>> }
>> -postcore_initcall(gpmc_init);
>>
>> static irqreturn_t gpmc_handle_irq(int irq, void *dev)
>> {
>> - u8 cs;
>> + int i;
>> + u32 regval;
>> + struct gpmc *gpmc = dev;
>>
>> - /* check cs to invoke the irq */
>> - cs = ((gpmc_read_reg(GPMC_PREFETCH_CONFIG1))>> CS_NUM_SHIFT)& 0x7;
>> - if (OMAP_GPMC_IRQ_BASE+cs<= OMAP_GPMC_IRQ_END)
>> - generic_handle_irq(OMAP_GPMC_IRQ_BASE+cs);
>> + regval = gpmc_read_reg(GPMC_IRQSTATUS);
>> +
>> +
>> + for (i = 0; i< gpmc->num_irq; i++)
>> + if (regval& gpmc->irq[i].regval)
>> + generic_handle_irq(gpmc->irq[i].irq);
>> + gpmc_write_reg(GPMC_IRQSTATUS, regval);
>>
>> return IRQ_HANDLED;
>> }
>>
>> +static int gpmc_irq_endis(struct irq_data *p, bool endis)
>> +{
>> + struct gpmc *gpmc = irq_data_get_irq_chip_data(p);
>> + int i;
>> + u32 regval;
>> +
>> + for (i = 0; i< gpmc->num_irq; i++)
>> + if (p->irq == gpmc->irq[i].irq) {
>> + regval = gpmc_read_reg(GPMC_IRQENABLE);
>> + if (endis)
>> + regval |= gpmc->irq[i].regval;
>> + else
>> + regval&= ~gpmc->irq[i].regval;
>> + gpmc_write_reg(GPMC_IRQENABLE, regval);
>> + break;
>> + }
>> +
>> + return 0;
>> +}
>> +
>> +static void gpmc_irq_disable(struct irq_data *p)
>> +{
>> + gpmc_irq_endis(p, false);
>> +}
>> +
>> +static void gpmc_irq_enable(struct irq_data *p)
>> +{
>> + gpmc_irq_endis(p, true);
>> +}
>> +
>> +static void gpmc_irq_noop(struct irq_data *data) { }
>> +
>> +static unsigned int gpmc_irq_noop_ret(struct irq_data *data) { return
>> 0; }
>> +
>> +static __devinit int gpmc_setup_irq(struct gpmc *gpmc)
>> +{
>> + int i;
>> + u32 regval;
>> +
>> + if (!gpmc->master_irq)
>> + return -EINVAL;
>> +
>> + if (gpmc->num_irq< GPMC_NR_IRQ) {
>> + dev_warn(gpmc->dev, "Insufficient interrupts for device\n");
>> + return -EINVAL;
>> + } else if (gpmc->num_irq> GPMC_NR_IRQ)
>> + gpmc->num_irq = GPMC_NR_IRQ;
>
> Hmmm ... why not just have ...
>
> if (gpmc->num_irq != GPMC_NR_IRQ) {
> dev_warn(...);
> return -EINVAL;
> }
>
> This also raises the question why bother passing num_irq if we always
> want it to be GPMC_NR_IRQ? Why not always initialise them all driver?
>
>> + gpmc->irq[0].regval = GPMC_IRQ_FIFOEVENT;
>> + gpmc->irq[1].regval = GPMC_IRQ_TERMINALCOUNT;
>> + gpmc->irq[2].regval = GPMC_IRQ_WAIT0EDGEDETECTION;
>> + gpmc->irq[3].regval = GPMC_IRQ_WAIT1EDGEDETECTION;
>> + gpmc->irq[4].regval = GPMC_IRQ_WAIT2EDGEDETECTION;
>> + gpmc->irq[5].regval = GPMC_IRQ_WAIT3EDGEDETECTION;

We need to be careful here, OMAP4 and OMAP5 devices only have 3 wait 
pins. Hence, one less interrupt.

We may need to add a check on GPMC IP revision here.

Cheers
Jon
