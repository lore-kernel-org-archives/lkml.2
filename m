Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab1F1JhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 05:37:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47111 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260Ab1F1Jgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:36:53 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Grosen, Mark" <mgrosen@ti.com>, Sergei Shtylyov <sshtylyov@mvista.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 28 Jun 2011 15:06:22 +0530
Subject: RE: [RFC 5/8] remoteproc: add davinci implementation
Thread-Topic: [RFC 5/8] remoteproc: add davinci implementation
Thread-Index: AQHML+P0Hfr3a08OpEW7Q/TK8TF6jpTLaEUAgAB6tVCAARO0AIAElT0AgAD53AA=
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D7938F3@dbde02.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	<1308640714-17961-6-git-send-email-ohad@wizery.com>
	<4E035B78.3080200@mvista.com>
	<FFF198FBBF957F4393BA834040FEFFA202D66E@DFLE35.ent.ti.com>
	<4E04A9AE.3030801@mvista.com>
 <FFF198FBBF957F4393BA834040FEFFA202EC68@DFLE35.ent.ti.com>
In-Reply-To: <FFF198FBBF957F4393BA834040FEFFA202EC68@DFLE35.ent.ti.com>
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

Hi Mark,

On Mon, Jun 27, 2011 at 23:50:25, Grosen, Mark wrote:
 
> > >>> +static inline int davinci_rproc_start(struct rproc *rproc, u64
> > >> bootaddr)
> > >>> +{
> > >>> +	struct device *dev = rproc->dev;
> > >>> +	struct davinci_rproc_pdata *pdata = dev->platform_data;
> > >>> +	struct davinci_soc_info *soc_info = &davinci_soc_info;
> > >>> +	void __iomem *psc_base;
> > >>> +	struct clk *dsp_clk;
> > >>> +
> > >>> +	/* hw requires the start (boot) address be on 1KB boundary */
> > >>> +	if (bootaddr & 0x3ff) {
> > >>> +		dev_err(dev, "invalid boot address: must be aligned to
> > >> 1KB\n");
> > >>> +		return -EINVAL;
> > >>> +	}
> > >>> +
> > >>> +	dsp_clk = clk_get(dev, pdata->clk_name);
> > 
> > >>     We could match using clkdev functionality, but the clock entry
> > >> would need to be changed then...
> > 
> > > I followed the existing pattern I saw in other drivers.
> > 
> > Probably MUSB? We're trying to move away from passing the clock name to thge
> > drivers, using match by device instead.
> > 
> > > If there is a new, better way, please point me to an example.
> > 
> >     Look at the da850_clks[] in mach-davinci/da850.c: if the device name is
> > specified as a first argument to CLK() macro (instead of clock name the second
> > argument), the matching is done by device, so you don't need to specify the
> > clock name to clk_get(), passing NULL instead.
> 
> Thanks, I'll look at this and ask for Sekhar and Kevin's preferences.

The second argument is not a (SoC specific)
clock name, it is the "connection id" which
is specific to the IP (not to the SoC).

For example, the EMAC IP may want to deal
with interface clock, functional clock and
mii clock. So, it passes a connection identifier
to tell the clock framework which particular
clock it is interested in. The names of these
connection identifiers will not change with SoC
as they are IP property. So, it will not be
right to get this through platform data.

If there is no connection identifier in
your case, you can just pass the second
argument as NULL. The clock matching will
happen using device name (which should
remain same across SoCs too).

Of course, this means that any incorrectly defined
clock lookup structures for dsp clock in platform
code needs to be corrected.

Thanks,
Sekhar

