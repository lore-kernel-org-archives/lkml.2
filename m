Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab2DKFMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:12:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36136 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2DKFMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:12:22 -0400
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
Thread-Index: AQHNE0Riyrz6RKL5ZUqDEt7OC2PTPZaMUK+AgAEDtGCABTzygIABT3KwgAA7PACAAPe7MA==
Date: Wed, 11 Apr 2012 05:11:56 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A9317C6F4B@DBDE01.ent.ti.com>
References: <cover.1333640054.git.afzal@ti.com>
 <cefbe934da40f0a169b1e3a75c46451e5546a8bd.1333640054.git.afzal@ti.com>
 <4F7DFED5.4030000@ti.com>
 <C8443D0743D26F4388EA172BF4E2A7A9317C5E58@DBDE01.ent.ti.com>
 <4F833D8D.8000802@ti.com>
 <C8443D0743D26F4388EA172BF4E2A7A9317C693C@DBDE01.ent.ti.com>
 <4F8488A2.7030602@ti.com>
In-Reply-To: <4F8488A2.7030602@ti.com>
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

On Wed, Apr 11, 2012 at 00:53:14, Hunter, Jon wrote:
> I agree with your argument but I was thinking today only OMAP uses the 
> GPMC so we could not worry about this. Ok, leave as-is, but can we 
> modify the code as follows as the "else if" is not really needed...
> 
> if (gpmc->num_irq < GPMC_NR_IRQ) {
> 	dev_warn(gpmc->dev, "Insufficient interrupts for device\n");
> 	return -EINVAL;
> }
> 
> gpmc->num_irq = GPMC_NR_IRQ;

Yes, it is better

> 
> >>
> >> Furthermore, GPMC_NR_IRQ is defined as 6 which is correct for OMAP2/3
> >> but not for OMAP4/5, it is 5. Therefore, we need to detect whether we
> >> are using an OMAP2/3 or OMAP4+ and set num_irqs based upon this. This
> >> could be done in the probe and we can avoid passing this.
> >
> > Is it dependent on OMAPX or GPMC IP version? if it is IP version, then driver
> > can be enhanced to handle it, if not, platform has to pass this information.
> 
> Here are the GPMC IP revisions ...
> 
> OMAP5430 = 0x00000060
> OMAP4430 = 0x00000060
> OMAP3630 = 0x00000050
> OMAP3430 = 0x00000050
> 
> So this should work for OMAP. We should check OMAP2 as well. What about 
> the AMxxx devices?


I badly needed this information, thanks.

AM3359 = 0x00000060, it has only 2 waitpin interrupts

> >>>>> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >>>>> +	if (res == NULL)
> >>>>> +		dev_warn(gpmc->dev, "Failed to get resource: irq\n");
> >>>>> +	else
> >>>>> +		gpmc->master_irq = res->start;
> >>>>
> >>>> Why not return an error if the IRQ is not found? We don't know if anyone
> >>>> will be trying to use them.
> >>>
> >>> Why do you want to do that ?
> >>
> >> Because this indicates a BUG :-)
> >
> > I disagree, this need not be considered a bug always,
> > for eg. If gpmc irq is not connected to intc
> 
> Ok, so for devices existing today this indicates a bug ;-)

I do not want to consider that case to be bug enough for probe
to fail, there are other drivers which does similar enhancing
its use cases,

eg. 1e351a9 mfd: Make TPS65910 usable without interrupts

> 
> At a minimum you need to improve the error handing here. If the 
> platform_get_resource fails you are still calling "gpmc_setup_irq()" 
> which appears to be pointless. It would be better if the gpmc irq chip 
> is not initialised in this case so that drivers attempting to request 
> these irqs failed.

Please see gpmc_setup_irq, if irq is not present, it returns in the
beginning, and gpmc_irq_chip is not initialized in that case.

> >>>>> +	for (gdq = gp->device_pdata, gd = gpmc->device; *gdq; gdq++, i++) {
> >>>>> +		ret = gpmc_setup_device(*gdq, gd, gpmc);
> >>>>> +		if (IS_ERR_VALUE(ret))
> >>>>> +			dev_err(gpmc->dev, "gpmc setup on %s failed\n",
> >>>>> +								(*gdq)->name);
> >>>>> +		else
> >>>>> +			gd++;
> >>>>> +	}
> >>>>
> >>>> Would a while loop be simpler?
> >>>
> >>> My preference is to go with "for"
> >>
> >> Ok, just wondering if this could be cleaned up a little.
> >
> > For travelling through array of pointers, for looks natural to me, if you
> > have a better way, please send it, it can be folded in next version.
> 
> Could you have num_devices to indicate how many platform devices there 
> are and then a simple for-loop of 0 to num_devices?

This will cause coding to be done by platform to be less simple, and my
preference is not to use another variable

Regards
Afzal
