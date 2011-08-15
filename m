Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1HOUgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:36:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40307 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1HOUgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:36:22 -0400
Date: Mon, 15 Aug 2011 21:36:17 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 10/12] arm/tegra: Add device tree support to pinmux
 driver
Message-ID: <20110815203617.GB22355@gallagher>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
 <1313189697-21287-11-git-send-email-swarren@nvidia.com>
 <20110815200716.GA22355@gallagher>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815200716.GA22355@gallagher>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 09:07:16PM +0100, Jamie Iles wrote:
> Hi Stephen,
> 
> On Fri, Aug 12, 2011 at 04:54:55PM -0600, Stephen Warren wrote:
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> >  arch/arm/mach-tegra/pinmux.c |  115 ++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 115 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
> > index 05fa1a3..33246c2 100644
> > --- a/arch/arm/mach-tegra/pinmux.c
> > +++ b/arch/arm/mach-tegra/pinmux.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/errno.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/io.h>
> > +#include <linux/of.h>
> >  #include <linux/platform_device.h>
> >  
> >  #include <mach/iomap.h>
> > @@ -147,6 +148,41 @@ static const char *func_name(enum tegra_mux_func func)
> >  	return tegra_mux_names[func];
> >  }
> >  
> [...]
> >  
> >  static const char *tri_name(unsigned long val)
> >  {
> > @@ -666,15 +702,94 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
> >  	}
> >  }
> >  
> > +#ifdef CONFIG_OF
> > +static void __init tegra_pinmux_probe_dt(struct platform_device *pdev)
> > +{
> > +	int pg;
> > +
> > +	for (pg = 0; pg < TEGRA_MAX_PINGROUP; pg++) {
> > +		const char *pg_name = pingroup_name(pg);
> > +		struct tegra_pingroup_config config;
> > +		struct device_node *pg_node;
> > +		int ret;
> > +		const char *s;
> > +
> > +		pg_node = of_find_child_node_by_name(pdev->dev.of_node,
> > +						     pg_name);
> > +		if (pg_node == NULL)
> > +			continue;
> > +
> > +		config.pingroup = pg;
> > +
> > +		ret = of_property_read_string(pg_node, "nvidia,function", &s);
> > +		if (ret < 0) {
> > +			dev_err(&pdev->dev,
> > +				"%s: Missing property nvidia,function\n",
> > +				pg_name);
> > +			continue;
> > +		}
> > +		ret = func_enum(s, &config.func);
> > +		if (ret < 0) {
> > +			dev_err(&pdev->dev,
> > +				"%s: Invalid nvidia,function value %s\n",
> > +				pg_name, s);
> > +			continue;
> > +		}
> > +
> > +		ret = of_property_read_string(pg_node, "nvidia,pull", &s);
> > +		if (ret >= 0) {
> > +			if (!strcmp(s, "up"))
> > +				config.pupd = TEGRA_PUPD_PULL_UP;
> > +			else if (!strcmp(s, "down"))
> > +				config.pupd = TEGRA_PUPD_PULL_DOWN;
> > +			else if (!strcmp(s, "normal"))
> > +				config.pupd = TEGRA_PUPD_NORMAL;
> > +			else {
> > +				dev_err(&pdev->dev,
> > +					"%s: Invalid nvidia,pull value %s\n",
> > +					pg_name, s);
> > +				continue;
> > +			}
> > +		} else
> > +			config.pupd = TEGRA_PUPD_NORMAL;
> > +
> > +		if (of_find_property(pg_node, "nvidia,tristate", NULL))
> > +			config.tristate = TEGRA_TRI_TRISTATE;
> > +		else
> > +			config.tristate = TEGRA_TRI_NORMAL;
> > +
> > +		dev_err(&pdev->dev, "%s: func %d (%s) pull %d tri %d\n",
> > +			pg_name, config.func, func_name(config.func),
> > +			config.pupd, config.tristate);
> > +
> > +		tegra_pinmux_config_pingroup(&config);
> > +
> > +		of_node_put(pg_node);
> > +	}
> > +}
> 
> I need to implement DT muxing configuration for my platform, and I believe 
> that what you have here would work fine for me too, and to avoid duplicating 
> the same thing, I wonder if this could be a little more generic.
> 
> So if the platform specific pinmux driver called the pinmux parser with a 
> callback for a pingroup configuration function then this wouldn't need the 
> nvidia specific properties.  I'd envisage the setup callback to be something 
> like:
> 
> 	int pingroup_configure(const char *name, unsigned long flags);

and it if this took the device_node too then the platform specific bits could 
handle more esoteric properties if required.  I'll have a go at prototyping 
this tomorrow unless there are any obvious reasons that this is a stupid idea!

Jamie
