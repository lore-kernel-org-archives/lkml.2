Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2DFGwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 02:52:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58386 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2DFGw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 02:52:28 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Hunter, Jon" <jon-hunter@ti.com>
CC: "tony@atomide.com" <tony@atomide.com>, "Hilman, Kevin" <khilman@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grinberg@compulab.co.il" <grinberg@compulab.co.il>,
        "mike@compulab.co.il" <mike@compulab.co.il>,
        "Menon, Nishanth" <nm@ti.com>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "vimal.newwork@gmail.com" <vimal.newwork@gmail.com>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: RE: [PATCH v3 1/9] ARM: OMAP2+: gpmc: driver conversion
Thread-Topic: [PATCH v3 1/9] ARM: OMAP2+: gpmc: driver conversion
Thread-Index: AQHNE0Riyrz6RKL5ZUqDEt7OC2PTPZaMUK+AgAEDtGA=
Date: Fri, 6 Apr 2012 06:52:03 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A9317C5E58@DBDE01.ent.ti.com>
References: <cover.1333640054.git.afzal@ti.com>
 <cefbe934da40f0a169b1e3a75c46451e5546a8bd.1333640054.git.afzal@ti.com>
 <4F7DFED5.4030000@ti.com>
In-Reply-To: <4F7DFED5.4030000@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Fri, Apr 06, 2012 at 01:51:41, Hunter, Jon wrote:
> > +struct gpmc_irq	{
> > +	unsigned		irq;
> > +	u32			regval;
> 
> Are you using regval to indicate the bit-mask? If so, maybe call it 
> "bitmask" instead.

Yes, bitmask would be better.

> > +			switch (gpmc->irq[i].regval) {
> > +			case GPMC_IRQ_WAIT0EDGEDETECTION:
> > +			case GPMC_IRQ_WAIT1EDGEDETECTION:
> > +			case GPMC_IRQ_WAIT2EDGEDETECTION:
> > +			case GPMC_IRQ_WAIT3EDGEDETECTION:
> > +				val = __ffs(gpmc->irq[i].regval);
> > +				val -= __ffs(GPMC_IRQ_WAIT0EDGEDETECTION);
> > +				gpmc_cs_configure(cs->cs,
> > +					GPMC_CONFIG_WAITPIN, val);
> 
> Why is the configuration of the wait pin done here? It is possible to 
> use the wait pin may be used without enabling the interrupt.
> 
> Where do you handle allocating the wait pins to ensure two devices don't 
> attempt to use the same one? Like how the CS are managed.
> 
> Also, where you you configure the polarity of the wait pins? I would 
> have thought it would make sense to have the wait pin configured as part 
> of the cs configuration.

I will revisit waitpin configurations.

> > +	for (i = 0, j = 0, cs = gdp->cs_data; i<  gdp->num_cs; cs++, i++) {
> > +		dev->gpmc_res[j] = gpmc_setup_cs_mem(cs, gdp, gpmc);
> > +		if (dev->gpmc_res[j++].flags&  IORESOURCE_MEM)
> > +			j += gpmc_setup_cs_irq(gpmc, gdp, cs,
> > +						dev->gpmc_res + j);
> > +		else {
> > +			dev_err(gpmc->dev, "error: setup for %s\n", gdp->name);
> > +			devm_kfree(gpmc->dev, dev->gpmc_res);
> > +			dev->gpmc_res = NULL;
> > +			dev->num_gpmc_res = 0;
> > +			return -EINVAL;
> > +		}
> >   	}
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

This section will be modified to make it clearer.

> > +	if (gpmc->num_irq<  GPMC_NR_IRQ) {
> > +		dev_warn(gpmc->dev, "Insufficient interrupts for device\n");
> > +		return -EINVAL;
> > +	} else if (gpmc->num_irq>  GPMC_NR_IRQ)
> > +		gpmc->num_irq = GPMC_NR_IRQ;
> 
> Hmmm ... why not just have ...
> 
> 	if (gpmc->num_irq != GPMC_NR_IRQ) {
> 		dev_warn(...);
> 		return -EINVAL;
> 	}

This will cause irq setup to fail if num_irq > GPMC_NR_IRQ, even though
irq setup could have been done w/o any problem, only because platform
indicated willingness to accommodate more number of interrupts than
actually required for this device.

> This also raises the question why bother passing num_irq if we always 
> want it to be GPMC_NR_IRQ? Why not always initialise them all driver?

Because num_irq (or available irqs for fictitious irq chip) is platform specific.

> > +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > +	if (res == NULL)
> > +		dev_warn(gpmc->dev, "Failed to get resource: irq\n");
> > +	else
> > +		gpmc->master_irq = res->start;
> 
> Why not return an error if the IRQ is not found? We don't know if anyone 
> will be trying to use them.

Why do you want to do that ?

If someone (say NAND) wants to work with irq, and if interrupt is not
available, NAND driver can fail, and suppose smsc911x ethernet is present
and he is not using gpmc irq, if we fail here, smsc911x also would
not work, which would have worked otherwise.

It is a different matter that even NAND setup will happen properly,
even if interrupt is not available, it is only when NAND is told to
work with IRQ, it fails, please see nand patches.

And as of now in mainline (with the code as is), there is not a single
board that will need gpmc irq for gpmc peripherals to work.

I feel we should try to get more devices working rather than preventing
more devices from working, when it could have.

> > +	for (gdq = gp->device_pdata, gd = gpmc->device; *gdq; gdq++, i++) {
> > +		ret = gpmc_setup_device(*gdq, gd, gpmc);
> > +		if (IS_ERR_VALUE(ret))
> > +			dev_err(gpmc->dev, "gpmc setup on %s failed\n",
> > +								(*gdq)->name);
> > +		else
> > +			gd++;
> > +	}
> 
> Would a while loop be simpler?

My preference is to go with "for"

> 
> The above loop appears to terminate when *gdq == 0. Is this always 
> guaranteed? In other words, safe?

This is a standard idiom for array of pointers

> 
> I see that "i" is not being used in the above loop either.

That was left over code, it will be removed.

> > +struct gpmc_cs_data {
> > +	unsigned		cs;
> > +	unsigned long		mem_size;
> > +	unsigned long		mem_start;
> > +	unsigned long		mem_offset;
> > +	struct gpmc_config	*config;
> > +	unsigned		num_config;
> > +	struct gpmc_timings	*timing;
> > +	unsigned		irq_flags;
> 
> I found the name irq_flags a bit unclear. This appears to be a mask for 
> the interrupts used. So may be this should be "irq_mask" or just "irqs".

Probably, this confusion arose as an attempt was made to club irq bit fields
with irq capability, so as to reduce additional macro definitions.

Here my preference is to keep irq_flags (or can be irq_capabilities), define
a new set of macros, and use bitmask in struct gpmc_irq

Thanks for the comments.

Regards
Afzal
