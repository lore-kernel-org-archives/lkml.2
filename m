Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2JIMiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:38:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47039 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab2JIMiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:38:06 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: RE: [PATCH 1/2] pwm: pwm-tiecap: Add device-tree binding support
 for APWM driver
Thread-Topic: [PATCH 1/2] pwm: pwm-tiecap: Add device-tree binding support
 for APWM driver
Thread-Index: AQHNm9yobIMSc4CNQUWf2NRAW+lIrZelMnQAgAQMDBCABeJbgIABooMg
Date: Tue, 9 Oct 2012 12:36:53 +0000
Deferred-Delivery: Tue, 9 Oct 2012 12:36:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9CA82E@DBDE01.ent.ti.com>
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
 <1348658863-29428-2-git-send-email-avinashphilip@ti.com>
 <20121002060014.GA4298@avionic-0098.mockup.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9CA1E8@DBDE01.ent.ti.com>
 <20121008133951.GA26525@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121008133951.GA26525@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 19:09:51, Thierry Reding wrote:
> On Mon, Oct 08, 2012 at 01:31:19PM +0000, Philip, Avinash wrote:
> > On Tue, Oct 02, 2012 at 11:30:14, Thierry Reding wrote:
> > > On Wed, Sep 26, 2012 at 04:57:42PM +0530, Philip, Avinash wrote:
> [...]
> > > > @@ -231,13 +290,56 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
> > > >  	}
> > > >  
> > > >  	pm_runtime_enable(&pdev->dev);
> > > > +
> > > > +	/*
> > > > +	 * Some platform has extra PWM-subsystem common config space
> > > > +	 * and requires special handling of clock gating.
> > > > +	 */
> > > > +	if (pdata && pdata->has_configspace) {
> > > > +		r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > > > +		if (!r) {
> > > > +			dev_err(&pdev->dev, "no memory resource defined\n");
> > > > +			ret = -ENODEV;
> > > > +			goto err_disable_clock;
> > > > +		}
> > > > +
> > > > +		pc->config_base = devm_ioremap(&pdev->dev, r->start,
> > > > +				resource_size(r));
> > > > +		if (!pc->config_base) {
> > > > +			dev_err(&pdev->dev, "failed to ioremap() registers\n");
> > > > +			ret = -EADDRNOTAVAIL;
> > > > +			goto err_disable_clock;
> > > > +		}
> > > 
> > > Isn't this missing a request_mem_region()? I assume you don't do that
> > > here because you need the same region in the EHRPWM driver, right?
> > 
> > request_mem_region() is avoided as this region is shared across PWM
> > sub modules ECAP & EHRPWM. 
> > 
> > > This should be indication enough that the design is not right here.
> > > I think we need a proper abstraction here. Can this not be done via
> > > PM runtime support? If not, maybe this should be represented by
> > > clock objects since the bit obviously enables a clock.
> > 
> > It is not done as part of PM runtime as this is has nothing to
> > do with clock tree of the SOC. The bits we were enabling here
> > should consider as an enable of the individual sub module as
> > part of IP integration. Hence we were handling these subsystem
> > module enable in the driver itself.
> 
> My point remains valid: you shouldn't be able to access the same
> register through two different drivers. That's one of the reasons, if
> not the only reasen, why the request_mem_region() function exists. I
> think you should add some abstraction to provide this functionality to
> the drivers. I assume that eventually there will be more than just the
> PWM cores that require access to this register.

Enabling of PWM sub modules from CONFIG space is only present in AM33xx
as part of IP integration (ECAP, EHRPWM & EQEP).

Enabling of sub modules (ECAP, EHRPWM & EQEP) should do in CONFIG space. 
Hence sub module drivers are accessing CONFIG space without reserving it 
Individually from drivers (request_mem_region()).

Can you describe/point how it can be handled in a separate Abstraction layer
as this is shared across ECAP, EHRPWM & EQEP (EQEP driver is not yet available).


Adding it as part of PM runtime support is not a right place.
In PWM-SS, CONFIG Space is "Shared" across different sub modules and hence
can't be considered as a part of clock tree.

Thanks
Avinash

> 
> Thierry
> 

