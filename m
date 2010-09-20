Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab0ITGMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 02:12:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10745 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0ITGMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 02:12:50 -0400
Date: Mon, 20 Sep 2010 15:12:34 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH] regulator: Add support samsung power domain
In-reply-to: <20100917113050.GA4322@rakim.wolfsonmicro.main>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, lrg@slimlogic.co.uk,
        "'Changhwan Youn'" <chaos.youn@samsung.com>,
        "'Jeongbae Seo'" <jeongbae.seo@samsung.com>
Message-id: <009d01cb588a$d45ce520$7d16af60$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActWW8semu9QW4S/R26V4rZVZe9gNQCLkgZQ
References: <1284717532-9992-1-git-send-email-kgene.kim@samsung.com>
 <20100917113050.GA4322@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> 
Hi :-)

> On Fri, Sep 17, 2010 at 06:58:52PM +0900, Kukjin Kim wrote:
> 
> > This patch adds common regulator driver for samsung power domain.
> > A consumer of controlling power domain uses regulator framework API,
> > So new samsung pd driver is inserted into regulator directory.
> 
> This looks conceptually OK for the regulator API - there's no operating
> points, it's just straight enable/disable stuff - but I do have a few
> concerns about this approach.
> 
Hmm..ok ;-)

> > +config REGULATOR_SAMSUNG_POWER_DOMAIN
> > +	tristate "Samsung power domain support"
> > +	help
> > +	  This driver provides support for samsung power domain.
> > +
> 
> This really ought to have a dependency on PLAT_SAMSUNG or something.

Ok..you're right. your suggestion is better.

> However, see below.
> 
Ok..

> > +static struct regulator_ops samsung_pd_ops = {
> > +	.is_enabled	= samsung_pd_is_enabled,
> > +	.enable		= samsung_pd_enable,
> > +	.disable	= samsung_pd_disable,
> > +	.enable_time	= samsung_pd_enable_time,
> > +};
> 
> You've got a microvolts in the platform data but no voltage stuff here.
> Equally well given that this is for processor internal stuff probably
> the change you need is to remove the voltage from the config.
> 
Yeah...will be removed useless stuff.

> > +	dev_dbg(&pdev->dev, "%s registerd\n", drvdata->desc.name);
> 
> Spelling mistake here.  The regulator API is fairly chatty so I'd have
> thought this was a bit redundant?
> 
Oh...thanks.

> > +struct samsung_pd_config {
> > +	const char *supply_name;
> > +	int microvolts;
> > +	unsigned startup_delay;
> > +	unsigned enabled_at_boot:1;
> > +	struct regulator_init_data *init_data;
> > +	int (*enable)(void);
> > +	int (*disable)(void);
> > +};
> 
> So, this driver is essentially just a mapping of this ops structure into
> the regulator API.  This is not at all Samsung specific so if it did get
> included it shouldn't have any Samsung references (other than the author
> and copyright ones) but I'm not convinced that this is the best approach.
> 
> What I'd have expected to see is either a regulator driver that at least
> knows something about updating registers in the CPU (or whatever else is
> needed to configure the power domains) or something more generic (along
> the lines of the existing fixed voltage regulator, possibly just some
> new features for it).  I'm tending more towards the former approach
> since if you're having to provide enable and disable operations you're
> getting very close to just implementing a subset regulator API.
> 
As you expected, we've already implemented a regulator API for S5PV210 and
S5PV310 in the machine-specific code.
According to your comments, it would be better to move those implementations
to the regulator driver code and we agree with you.
The reason the implementation is located in machine-specific code is that
the way to handle power domain in S5PV210 and S5PV310 is different but we
can handle this using platform_device_id.

> Another option to consider here is using runtime PM - other platforms
> seem to be going down that route, and are using it to also factor clock
> management for the IP blocks out (so that the block's clocks get enabled
> and disabled automatically when the block is active without needing any
> code in the driver).

To use runtime PM cannot be a substitute for using regulator API.
It's related to when to control the power domain whether using regulator API
is to how to control the power domain.

We have a plan to support runtime PM using regulator API.
Am I on the right track ?

Thank you for your comments. :-)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

