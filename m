Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1DTRgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 13:36:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49280 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1DTRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 13:36:52 -0400
Date: Wed, 20 Apr 2011 19:36:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@amd64.org>, "rwhitton@iee.org" <rwhitton@iee.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Background memory scrubbing
Message-ID: <20110420173627.GE2734@aftab>
References: <16117.1303310442@jupiter.eclipse.co.uk>
 <4DAEF98D.2090802@ladisch.de>
 <20110420153529.GA2312@gere.osrc.amd.com>
 <20110420154658.GD1624@x4.trippels.de>
 <20110420155853.GB2312@gere.osrc.amd.com>
 <20110420164506.GE1624@x4.trippels.de>
 <20110420165533.GA1624@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420165533.GA1624@x4.trippels.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 12:55:33PM -0400, Markus Trippelsdorf wrote:
> > > This is KERN_DEBUG since .38 (commit 24f9a7fe3f19f3fd310f556364d01a22911724b3)
> > > and it shouldn't appear on the console if you don't change your default log level.
> > 
> > Yes. Sorry, but I was referring to dmesg and not the console. 
> > What I mean is that maybe debugf1 or debugf2 is more appropriate than
> > amd64_debug?
> 
> In other words:

Ok, that whole debugging output there is partly historical remains and
we don't really need them if we're smart about it. But you'll have to
change your patch and make a proper commit message :).

> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 31e71c4f..13b107e 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -211,7 +211,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
>  
>  	scrubval = scrubval & 0x001F;
>  
> -	amd64_debug("pci-read, sdram scrub control value: %d\n", scrubval);
> +	debugf1 ("pci-read, sdram scrub control value: %d\n", scrubval);

remove this one completely.

>  
>  	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
>  		if (scrubrates[i].scrubval == scrubval) {
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index 26343fd..8a34aea 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -459,7 +459,7 @@ static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
>  
>  	new_bw = mci->set_sdram_scrub_rate(mci, bandwidth);
>  	if (new_bw >= 0) {
> -		edac_printk(KERN_DEBUG, EDAC_MC, "Scrub rate set to %d\n", new_bw);
> +		debugf1 ("Scrub rate set to %d\n", new_bw);
>  		return count;
>  	}

Make here the success case implicit and issue a warning only if we fail
setting the scrub rate:


	new_bw = mci->set_sdram_scrub_rate(mci, bandwidth);
	if (new_bw < 0) {
		edac_printk(KERN_WARNING, EDAC_MC,
			    "Error setting scrub rate to: %lu\n", bandwidth);
		return -EINVAL;
	}

and do the same thing with mci_sdram_scrub_rate_show() below.

>  
> @@ -483,7 +483,7 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
>  		return bandwidth;
>  	}
>  
> -	edac_printk(KERN_DEBUG, EDAC_MC, "Read scrub rate: %d\n", bandwidth);
> +	debugf1 ("Read scrub rate: %d\n", bandwidth);

This one can go too since the success-case is in sysfs anyway.

>  	return sprintf(data, "%d\n", bandwidth);
>  }

Would you like to do that?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
