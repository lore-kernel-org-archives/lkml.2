Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab1FXEZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 00:25:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55650 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1FXEZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 00:25:36 -0400
From: "Grosen, Mark" <mgrosen@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>, Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Grant Likely <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: RE: [RFC 5/8] remoteproc: add davinci implementation
Thread-Topic: [RFC 5/8] remoteproc: add davinci implementation
Thread-Index: AQHML+P0Hfr3a08OpEW7Q/TK8TF6jpTLaEUAgAB6tVA=
Date: Fri, 24 Jun 2011 04:25:14 +0000
Message-ID: <FFF198FBBF957F4393BA834040FEFFA202D66E@DFLE35.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-6-git-send-email-ohad@wizery.com>
 <4E035B78.3080200@mvista.com>
In-Reply-To: <4E035B78.3080200@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sergei Shtylyov
> Sent: Thursday, June 23, 2011 8:28 AM
> Subject: Re: [RFC 5/8] remoteproc: add davinci implementation
> 
> Hello.

Sergei, thanks for the feedback. Comments below.

Mark

> 
>     It should work on DA830 as well, but not on real DaVinci, so the
> name is misleading...

Yes, we debated calling it da8xx, but felt that with minor changes it could
accomodate the other SoCs in the davinci family. However, it may be better
to start with just the da8xx/omapl13x parts and then rename if we add the
others. 

> [...]
> > +
> > +/*
> > + * Technical Reference:
> > + * OMAP-L138 Applications Processor System Reference Guide
> > + * http://www.ti.com/litv/pdf/sprugm7d
> > + */
> > +
> > +/* local reset bit (0 is asserted) in MDCTL15 register (section
> 9.6.18) */
> > +#define LRST		BIT(8)
> 
>     Perhaps this should be named nLRST or something if the sense is inverted?

If there is an established naming convention for this, I'll adopt it.

> 
> > +/* next state bits in MDCTL15 register (section 9.6.18) */
> > +#define NEXT_ENABLED	0x3
> 
>     Isn't this already declared in <mach/psc.h> as PSC_STATE_ENABLED?

Yes, thanks, I missed it.

> > +/* register for DSP boot address in SYSCFG0 module (section 11.5.6)
> */
> > +#define HOST1CFG	0x44
> 
>     Worth declaring in <mach/da8xx.h> instead...

Possibly - since it is only used for the DSP, I thought it would be better
to keep local to this implementation. I'll adopt whichever approach is the
convention. 

> > +static inline int davinci_rproc_start(struct rproc *rproc, u64
> bootaddr)
> > +{
> > +	struct device *dev = rproc->dev;
> > +	struct davinci_rproc_pdata *pdata = dev->platform_data;
> > +	struct davinci_soc_info *soc_info = &davinci_soc_info;
> > +	void __iomem *psc_base;
> > +	struct clk *dsp_clk;
> > +
> > +	/* hw requires the start (boot) address be on 1KB boundary */
> > +	if (bootaddr & 0x3ff) {
> > +		dev_err(dev, "invalid boot address: must be aligned to
> 1KB\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	dsp_clk = clk_get(dev, pdata->clk_name);
> 
>     We could match using clkdev functionality, but the clock entry
> would need to be changed then...

I followed the existing pattern I saw in other drivers. If there is a new,
better way, please point me to an example.

> 
> > +	if (IS_ERR_OR_NULL(dsp_clk)) {
> > +		dev_err(dev, "clk_get error: %ld\n", PTR_ERR(dsp_clk));
> > +		return PTR_ERR(dsp_clk);
> > +	}
> > +
> > +	clk_enable(dsp_clk);
> 
>      This seems rather senseless activity as on DA8xx the DSP core
> boots the ARM core, so the DSP clock will be already enabled.

I think it is needed. It's true that the DSP initiates the boot, but then it is
reset and the clock disabled. See Section 13.2 of
http://focus.ti.com/lit/ug/sprugm7e/sprugm7e.pdf:

13.2 DSP Wake Up

Following deassertion of device reset, the DSP intializes the ARM296 so that
it can execute the ARM ROM bootloader. Upon successful wake up, the ARM
places the DSP in a reset and clock gated (SwRstDisable) state that is
controlled by the LPSC and the SYSCFG modules.

Besides, the boot loader could have disabled it to save power. The ARM and
DSP are clocked independently, so I think it's best to use clock management.

> > +	rproc->priv = dsp_clk;
> > +
> > +	psc_base = ioremap(soc_info->psc_bases[0], SZ_4K);
> > +
> > +	/* insure local reset is asserted before writing start address */
> > +	__raw_writel(NEXT_ENABLED, psc_base + MDCTL + 4 *
> DA8XX_LPSC0_GEM);
> > +
> > +	__raw_writel(bootaddr, DA8XX_SYSCFG0_VIRT(HOST1CFG));
> 
>     DA8XX_SYSCFG0_VIRT() is not supposed to be used outside mach-davinci. The
> variable it refers is not exported, so driver module won't work.

Ooops, I clearly did not build this as a module. Suggestion how to fix this?

> > +	/* de-assert local reset to start the dsp running */
> > +	__raw_writel(LRST | NEXT_ENABLED, psc_base + MDCTL +
> > +		4 * DA8XX_LPSC0_GEM);
> > +
> > +	iounmap(psc_base);
> > +
> > +	return 0;
> > +}
> > +
> > +static inline int davinci_rproc_stop(struct rproc *rproc)
> > +{
> > +	struct davinci_soc_info *soc_info = &davinci_soc_info;
> > +	void __iomem *psc_base;
> > +	struct clk *dsp_clk = rproc->priv;
> > +
> > +	psc_base = ioremap(soc_info->psc_bases[0], SZ_4K);
> > +
> > +	/* halt the dsp by asserting local reset */
> > +	__raw_writel(NEXT_ENABLED, psc_base + MDCTL + 4 *
> DA8XX_LPSC0_GEM);
> > +
> > +	clk_disable(dsp_clk);
> > +	clk_put(dsp_clk);
> > +
> > +	iounmap(psc_base);
> > +
> > +	return 0;
> > +}
> 
>     All this is DA8xx specific code which won't fly on real DaVincis, so I
> suggest that you rename the file to da8xx_remoteproc.c for clarity; and
> rename the patch as well...

This is probably the right thing to do ...

Mark
