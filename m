Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1F0SXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 14:23:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46931 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab1F0SVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 14:21:11 -0400
From: "Grosen, Mark" <mgrosen@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
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
Thread-Index: AQHML+P0Hfr3a08OpEW7Q/TK8TF6jpTLaEUAgAB6tVCAARO0AIAElT0A
Date: Mon, 27 Jun 2011 18:20:25 +0000
Message-ID: <FFF198FBBF957F4393BA834040FEFFA202EC68@DFLE35.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-6-git-send-email-ohad@wizery.com>
 <4E035B78.3080200@mvista.com>
 <FFF198FBBF957F4393BA834040FEFFA202D66E@DFLE35.ent.ti.com>
 <4E04A9AE.3030801@mvista.com>
In-Reply-To: <4E04A9AE.3030801@mvista.com>
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
> Sent: Friday, June 24, 2011 8:14 AM
> 
> Grosen, Mark wrote:
> 
> >>     It should work on DA830 as well,
> 
>     So please make it dependent on ARCH_DAVINCI_DA8XX.
> 
> >> but not on real DaVinci, so the name is misleading...
> 
> > Yes, we debated calling it da8xx, but felt that with minor changes it could
> > accomodate the other SoCs in the davinci family.
> 
>     I don't think it's a good idea. Using cpu_is_*() is drivers is bad. Using
> #ifdef's is not an option either.
> 
> > However, it may be better
> > to start with just the da8xx/omapl13x parts and then rename if we add the
> > others.

Sergei, I'll respond more to this in a response to Sekhar's ideas. We may be
able to make this work generically for davinci w/o idef's.

> Looking into my old PSC manual (can't get the recent documentation from TI's
> site right now), the bit is called LRSTz.
>     It's worth moving this #define into <mach/psc.h> as well.

Ok, I agree we should try to match the HW names as much as possible

> >>> +/* register for DSP boot address in SYSCFG0 module (section 11.5.6) */
> >>> +#define HOST1CFG	0x44
> 
> >>     Worth declaring in <mach/da8xx.h> instead...
> 
> > Possibly - since it is only used for the DSP, I thought it would be better
> > to keep local to this implementation. I'll adopt whichever approach is the
> > convention.
> 
>     Well, the general approach is to keep the #define's where they are
> used, so maybe we should keep this #define here.

Will review as part of the general cleanup.

> 
> >>> +static inline int davinci_rproc_start(struct rproc *rproc, u64
> >> bootaddr)
> >>> +{
> >>> +	struct device *dev = rproc->dev;
> >>> +	struct davinci_rproc_pdata *pdata = dev->platform_data;
> >>> +	struct davinci_soc_info *soc_info = &davinci_soc_info;
> >>> +	void __iomem *psc_base;
> >>> +	struct clk *dsp_clk;
> >>> +
> >>> +	/* hw requires the start (boot) address be on 1KB boundary */
> >>> +	if (bootaddr & 0x3ff) {
> >>> +		dev_err(dev, "invalid boot address: must be aligned to
> >> 1KB\n");
> >>> +		return -EINVAL;
> >>> +	}
> >>> +
> >>> +	dsp_clk = clk_get(dev, pdata->clk_name);
> 
> >>     We could match using clkdev functionality, but the clock entry
> >> would need to be changed then...
> 
> > I followed the existing pattern I saw in other drivers.
> 
> Probably MUSB? We're trying to move away from passing the clock name to thge
> drivers, using match by device instead.
> 
> > If there is a new, better way, please point me to an example.
> 
>     Look at the da850_clks[] in mach-davinci/da850.c: if the device name is
> specified as a first argument to CLK() macro (instead of clock name the second
> argument), the matching is done by device, so you don't need to specify the
> clock name to clk_get(), passing NULL instead.

Thanks, I'll look at this and ask for Sekhar and Kevin's preferences.

Mark
