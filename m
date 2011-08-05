Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab1HEWe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:34:28 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2881 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab1HEWe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:34:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 05 Aug 2011 15:34:11 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Ben Dooks <ben-i2c@fluff.org>, Axel Lin <axel.lin@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>, John Bonesio <bones@secretlab.ca>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 5 Aug 2011 15:33:53 -0700
Subject: RE: [PATCH] i2c: tegra: Add CONFIG_OF guards for device tree bits
Thread-Topic: [PATCH] i2c: tegra: Add CONFIG_OF guards for device tree bits
Thread-Index: AcxTR8BFt1T01+x1RQyVF/gYA+nTxgAd78UQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049F172098@HQMAIL01.nvidia.com>
References: <1312527921.21955.2.camel@phoenix>
 <20110805081444.GC19115@trinity.fluff.org>
In-Reply-To: <20110805081444.GC19115@trinity.fluff.org>
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

Ben Dooks wrote at Friday, August 05, 2011 2:15 AM:
> On Fri, Aug 05, 2011 at 03:05:21PM +0800, Axel Lin wrote:
> > The device tree bits need to be protected by CONFIG_OF guards.
> > This patch fixes below build error with "make tegra_defconfig;make".
> >
> >   CC      drivers/i2c/busses/i2c-tegra.o
> > drivers/i2c/busses/i2c-tegra.c: In function 'tegra_i2c_probe':
> > drivers/i2c/busses/i2c-tegra.c:615: error: implicit declaration of function 'of_get_property'
> > drivers/i2c/busses/i2c-tegra.c:616: warning: assignment makes pointer from integer without a cast
> 
> It might be worth asking Grant if providing stubs for the of_ calls are
> as good idea, I'd like to avoid having #ifdef CONFIG_OF splattered around
> the place (it leads to errors).

When I first proposed the patch below, Grant said:

> ... I've been avoiding creating a
> dummy inline of of_get_property(), but not for any particularly strong
> reason other than to avoid bloating linux/of.h.  I probably would
> accept a patch that added it.

So, I'll go ahead and whip up a patch to do that instead, since Ben
would prefer not to have the ifdefs in the I2C driver.

> > make[3]: *** [drivers/i2c/busses/i2c-tegra.o] Error 1
> > make[2]: *** [drivers/i2c/busses] Error 2
> > make[1]: *** [drivers/i2c] Error 2
> > make: *** [drivers] Error 2
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  drivers/i2c/busses/i2c-tegra.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> > index 0c6e840..1bfe85e 100644
> > --- a/drivers/i2c/busses/i2c-tegra.c
> > +++ b/drivers/i2c/busses/i2c-tegra.c
> > @@ -548,7 +548,6 @@ static int tegra_i2c_probe(struct platform_device *pdev)
> >  	struct resource *iomem;
> >  	struct clk *clk;
> >  	struct clk *i2c_clk;
> > -	const unsigned int *prop;
> >  	void *base;
> >  	int irq;
> >  	int ret = 0;
> > @@ -611,11 +610,15 @@ static int tegra_i2c_probe(struct platform_device *pdev)
> >  	if (pdata) {
> >  		i2c_dev->bus_clk_rate = pdata->bus_clk_rate;
> >
> > +#ifdef CONFIG_OF
> >  	} else if (i2c_dev->dev->of_node) {    /* if there is a device tree node ... */
> > +		const unsigned int *prop;
> > +
> >  		prop = of_get_property(i2c_dev->dev->of_node,
> >  				"clock-frequency", NULL);
> >  		if (prop)
> >  			i2c_dev->bus_clk_rate = be32_to_cpup(prop);
> > +#endif
> >  	}
> >
> >  	if (pdev->id == 3)
> > --
> > 1.7.4.1

-- 
nvpublic

