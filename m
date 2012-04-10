Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2DJLA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 07:00:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49668 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab2DJLA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 07:00:57 -0400
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
Thread-Index: AQHNE0Riyrz6RKL5ZUqDEt7OC2PTPZaMUK+AgAEDtGCABTzygIABT3Kw
Date: Tue, 10 Apr 2012 11:00:33 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A9317C693C@DBDE01.ent.ti.com>
References: <cover.1333640054.git.afzal@ti.com>
 <cefbe934da40f0a169b1e3a75c46451e5546a8bd.1333640054.git.afzal@ti.com>
 <4F7DFED5.4030000@ti.com>
 <C8443D0743D26F4388EA172BF4E2A7A9317C5E58@DBDE01.ent.ti.com>
 <4F833D8D.8000802@ti.com>
In-Reply-To: <4F833D8D.8000802@ti.com>
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

On Tue, Apr 10, 2012 at 01:20:37, Hunter, Jon wrote:
> > Because num_irq (or available irqs for fictitious irq chip) is platform specific.
> 
> Ok, so OMAP_GPMC_NR_IRQS is defined and will not vary from device to 
> device, so why pass this? Why not use it directly?

Because OMAP_GPMC_NR_IRQS is platform specific, final intention is to
not have any platform specific header files in GPMC driver, not sure
as of now whether it would be possible. So keeping platform specific
things away from the driver as much as possible.

And consider scenario where GPMC IP is used in other than OMAP family,
even though this a theoretical case, wanted to stress the point that
intention is to keep driver platform independent.

Or else dynamic allocation of irqs may have to be used.

> 
> Furthermore, GPMC_NR_IRQ is defined as 6 which is correct for OMAP2/3 
> but not for OMAP4/5, it is 5. Therefore, we need to detect whether we 
> are using an OMAP2/3 or OMAP4+ and set num_irqs based upon this. This 
> could be done in the probe and we can avoid passing this.
 
Is it dependent on OMAPX or GPMC IP version? if it is IP version, then driver
can be enhanced to handle it, if not, platform has to pass this information.

> >>> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >>> +	if (res == NULL)
> >>> +		dev_warn(gpmc->dev, "Failed to get resource: irq\n");
> >>> +	else
> >>> +		gpmc->master_irq = res->start;
> >>
> >> Why not return an error if the IRQ is not found? We don't know if anyone
> >> will be trying to use them.
> >
> > Why do you want to do that ?
> 
> Because this indicates a BUG :-)

I disagree, this need not be considered a bug always,
for eg. If gpmc irq is not connected to intc

> 
> > If someone (say NAND) wants to work with irq, and if interrupt is not
> > available, NAND driver can fail, and suppose smsc911x ethernet is present
> > and he is not using gpmc irq, if we fail here, smsc911x also would
> > not work, which would have worked otherwise.
> >
> > It is a different matter that even NAND setup will happen properly,
> > even if interrupt is not available, it is only when NAND is told to
> > work with IRQ, it fails, please see nand patches.
> >
> > And as of now in mainline (with the code as is), there is not a single
> > board that will need gpmc irq for gpmc peripherals to work.
> >
> > I feel we should try to get more devices working rather than preventing
> > more devices from working, when it could have.
> 
> I understand your point, but then you are hiding a BUG. If someone 
> introduces a BUG that causes this to fail, then it is easier to detect, 
> find and fix.
> 
>  From my perspective get the resources should never fail and if it does 
> and break the driver for all devices, then so be it, because a BUG has 
> been introduced. Ok, this may not be critical at this point but still is 
> should not fail.

Agree for resources which are a must for device to work, not for resources
that can enhance its capability.

> 
> >>> +	for (gdq = gp->device_pdata, gd = gpmc->device; *gdq; gdq++, i++) {
> >>> +		ret = gpmc_setup_device(*gdq, gd, gpmc);
> >>> +		if (IS_ERR_VALUE(ret))
> >>> +			dev_err(gpmc->dev, "gpmc setup on %s failed\n",
> >>> +								(*gdq)->name);
> >>> +		else
> >>> +			gd++;
> >>> +	}
> >>
> >> Would a while loop be simpler?
> >
> > My preference is to go with "for"
> 
> Ok, just wondering if this could be cleaned up a little.

For travelling through array of pointers, for looks natural to me, if you
have a better way, please send it, it can be folded in next version.

Regards
Afzal
