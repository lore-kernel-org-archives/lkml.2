Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2ICCxC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 22:53:02 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:12590
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755799Ab2ICCxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 22:53:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1202h1082kzzz2dh2a8h668h839h944hd25hf0ah107ah1220h1155h)
Date: Mon, 3 Sep 2012 10:31:03 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH v4 1/7] mfd: add syscon driver based on regmap
Message-ID: <20120903023102.GA11891@shlinux2.ap.freescale.net>
References: <1346237818-9498-1-git-send-email-b29396@freescale.com>
 <1346237818-9498-2-git-send-email-b29396@freescale.com>
 <20120831012626.GA7726@r65073-Latitude-D630>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120831012626.GA7726@r65073-Latitude-D630>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 09:26:29AM +0800, Shawn Guo wrote:
> On Wed, Aug 29, 2012 at 06:56:52PM +0800, Dong Aisheng wrote:
> > +config MFD_SYSCON
> > +        bool "System Controller Register R/W Based on Regmap"
> 
> If the driver only compiles and works for device tree probe, we should
> have the following?
> 
> 	depends on OF
> 
Correct.
For currently it only supports dt.

> > +        select REGMAP_MMIO
> > +        help
> > +	  Select this option to enable accessing system control registers
> > +	  via regmap.
> > +
> 
> <snip>
> 
> > +struct regmap *syscon_node_to_regmap(struct device_node *np)
> > +{
> > +	struct syscon *syscon;
> > +	struct device *dev;
> > +
> > +	dev = driver_find_device(&syscon_driver.driver, NULL, np,
> > +				 syscon_match);
> > +	of_node_put(np);
> 
> This looks a little unnatural to me.  Function syscon_node_to_regmap
> becomes an API visible to clients, who might never know that np will
> be put inside the API.  I'm saying the client may also call of_node_put
> to put the node they get.
We probably could add a comment here for the API to avoid this happen.

> 
> I think of_node_put should be moved out from here and put into
> syscon_node_to_regmap and syscon_regmap_lookup_by_compatible.
> 
I guess no, if you want to move of_node_put into syscon_regmap_lookup_by_phandle,
then syscon_regmap_lookup_by_phandle has the same issue.
Actually i had considered your concern when writing this API...
The original purpose of doing like that is saving some duplicated 'of_node_put'
and make the API easy to use.
I searched the kernel dt code and found it existed some similar cases.
e.g: of_irq_find_parent, of_get_next_parent
So it looks to me that it may be usually to do like that for the cases that
the conversion from a node to other thing since the client may only care
about the things converted. For our case, it's regmap.
So i can't think it make too much sense for all client driver have to write
duplicated and meaningless 'of_node_put' code.

Regards
Dong Aisheng

> > +
> > +	if (!dev)
> > +		return ERR_PTR(-EPROBE_DEFER);
> > +
> > +	syscon = dev_get_drvdata(dev);
> > +
> > +	return syscon->regmap;
> > +}
> > +EXPORT_SYMBOL_GPL(syscon_node_to_regmap);
> > +
> > +struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
> > +{
> > +	struct device_node *syscon_np;
> > +
> > +	syscon_np = of_find_compatible_node(NULL, NULL, s);
> > +	if (!syscon_np)
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	return syscon_node_to_regmap(syscon_np);
> > +}
> > +EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
> > +
> > +struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
> > +					const char *property)
> > +{
> > +	struct device_node *syscon_np;
> > +
> > +	syscon_np = of_parse_phandle(np, property, 0);
> > +	if (!syscon_np)
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	return syscon_node_to_regmap(syscon_np);
> > +}
> > +EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);

