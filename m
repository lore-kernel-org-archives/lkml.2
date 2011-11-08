Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1KHJas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:30:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1KHJap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:30:45 -0500
Date: Tue, 8 Nov 2011 10:30:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com
Subject: Re: [PATCH 1/7] PM / Domains: Make it possible to use per-device
 start/stop routines
In-Reply-To: <201111070106.14607.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.1111080951040.10851@axis700.grange>
References: <201111070101.33960.rjw@sisk.pl> <201111070106.14607.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:UcQDe/OYAXo8GZD0034l/3S2l2Q/SbJuH1xdDX44jLp
 Dc3tmHYo1TezF6ivcqQjsaCqYAdqEMnaXd+Sx6Ekp9cSVIRzCR
 LDTMoIgcWC3yIruEa9iZOAAcDKV4fd6WuL0MXBPwnU7zWeoR/A
 Ajvrxwg61Xiozin7AhaygIihfNS+ozD7aUa8INgLvu0rWgBidt
 LupNZF+C46MaFvlF1uI40FqFUC8JVZlKPDYjyFaI7+hWFS7CFi
 0FEmdAHAT+Gam8yVY1QE20i7HsUXbzl/Uu97oj4UFRWWGf94vR
 aI3gJ/JPjQU4kd1xFnRJUuY9q5pCT1nvJwIzQRKqaRuG8u6fpY
 Hnf7VOr3Rv8IHXeOrN+4vm62Tz47aXLyCNcs7dMUg1wyVIL4go
 M3AEtvnxPK0xQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael

On Mon, 7 Nov 2011, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The current generic PM domains code requires that the same .stop()
> and .start() device callback routines be used for all devices in the
> given domain, which is inflexible and may not cover some specific use
> cases.  For this reason, make it possible to use device specific
> .start() and .stop() callback routines by adding corresponding
> callback pointers to struct generic_pm_domain_data.  Add a new helper
> routine, pm_genpd_register_callbacks(), that can be used to populate
> the new per-device callback pointers.
> 
> Modify the shmobile's power domains code to allow drivers to add
> their own code to be run during the device stop and start operations
> with the help of the new callback pointers.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

[snip]

> Index: linux/drivers/base/power/domain.c
> ===================================================================
> --- linux.orig/drivers/base/power/domain.c
> +++ linux/drivers/base/power/domain.c
> @@ -29,6 +29,36 @@ static struct generic_pm_domain *dev_to_
>  	return pd_to_genpd(dev->pm_domain);
>  }
>  
> +static int genpd_stop_dev(struct generic_pm_domain *genpd, struct device *dev)
> +{
> +	int (*stop)(struct device *dev);
> +
> +	stop = genpd->stop_device;
> +	if (stop)
> +		return stop(dev);
> +
> +	stop = dev_gpd_data(dev)->ops.stop;
> +	if (stop)
> +		return stop(dev);

With this implementation your approach is: in your genpd_stop_dev() and 
genpd_start_dev() you first check for the pm-domain _common_ .start() and 
.stop(), and if they exist, the specific ones will not be called. Then in 
your sh7372 pm domain implementation you do the domain-common part - 
switch the PM clock on or off, and you _again_ check for device-specific 
domains, and this time you call both of them.

Do you have specific reasons to think, that calling both of them from 
genpd_stop_dev() / genpd_start_dev() might not fit some PM-domain 
implementations?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
