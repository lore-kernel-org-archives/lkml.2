Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1ISOVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 10:21:04 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43589 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1ISOVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 10:21:02 -0400
Date: Mon, 19 Sep 2011 16:20:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Han Pingtian <phan@redhat.com>
Cc: mchehab@redhat.com, linux-kernel@vger.kernel.org,
        edac-devel <linux-edac@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v2] Fix EDAC sdram_scrub_rate read/write failure
Message-ID: <20110919142055.GF7814@aftab>
References: <20110916105856.GA13253@hpt.nay.redhat.com>
 <20110916125326.GA1957@gere.osrc.amd.com>
 <20110919073722.GE2822@hpt.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919073722.GE2822@hpt.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 03:37:22AM -0400, Han Pingtian wrote:
> > Anyway, the EDAC document says that sdram_scrub_rate is
> > read/write and when writing you have to write -1 too. Care to fix
> Cannot figure out how to write -1 here. Since the document just says the
> value will be -1 when configuration fails or memory scrubbing is not
> implemented, I think we can do nothing when setting the vaule if
> scrubbing not implemented and just make sure showing will return -1.

This is a good indication of a bug in the API - I can't imagine why
would it make sense to write a negative value to a sysfs file just to
show that scrubbing interface support is not present. More likely the
OS should fail the write with -ENODEV or something saying that the
functionality is not there.

Which is much easier to interpret from userspace: if the write failed
you know something is wrong. If it succeeded OTOH, you still have to go
and

cat /sys/devices/system/edac/mc/mc<N>/sdram_scrub_rate

to make sure it really succeeded. Makes no sense.

So, I'm actually inclined to change the API here instead of adjusting
the code to adhere to it.

+ Tony.

@Tony, do you think the above makes sense? Anything against changing
that part of the EDAC API to say:

Sdram memory scrubbing rate:

        'sdram_scrub_rate'

        Read/Write attribute file that controls memory scrubbing. The scrubbing
        rate is set by writing a minimum bandwidth in bytes/sec to the attribute
        file. The rate will be translated to an internal value that gives at
        least the specified rate.

        Reading the file will return the actual scrubbing rate employed.

        If configuration fails or memory scrubbing is not implemented,
	the access to that attribute from userspace will fail.

?

Leaving the below for more background info.

Thanks.

> > mci_sdram_scrub_rate_store too, test your patch properly and resend?
> 
> Thanks your review. I have tested the new patch attached. Please have a
> look. 
> 
> Thanks.
> -- 
> Han Pingtian
> Quality Engineer
> hpt @ #kernel-qe
> Red Hat, Inc
> Freedom ... courage ... Commitment ... ACCOUNTABILITY

> From a77c8db0797f8c6b3e1ac30f8da0b7f2d9c10dbe Mon Sep 17 00:00:00 2001
> From: Han Pingtian <phan@redhat.com>
> Date: Fri, 16 Sep 2011 18:43:20 +0800
> Subject: [PATCH] Fix EDAC sdram_scrub_rate read/write failure
> 
> If sdram scrubbing rate isn't implemented on current system, read/write it
> will cause an error:
> 
> ]# cat /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
> cat: /sys/devices/system/edac/mc/mc0/sdram_scrub_rate: Invalid argument
> 
> ]# echo 1 > /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
> -bash: echo: write error: Invalid argument
> 
> The eba042a81edd6baaff44831b2d719b14a6d21e58 let it returning -EINVAL,
> but according to the document, the value should be -1, so there
> shouldn't be a failure.
> 
> Sdram memory scrubbing rate:
> 
>         'sdram_scrub_rate'
> 
>         Read/Write attribute file that controls memory scrubbing. The scrubbing
>         rate is set by writing a minimum bandwidth in bytes/sec to the attribute
>         file. The rate will be translated to an internal value that gives at
>         least the specified rate.
> 
>         Reading the file will return the actual scrubbing rate employed.
> 
>         If configuration fails or memory scrubbing is not implemented, the value
>         of the attribute file will be -1.
> 
> Signed-off-by: Han Pingtian <phan@redhat.com>
> ---
>  drivers/edac/edac_mc_sysfs.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index 29ffa35..dae14cf 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -451,8 +451,11 @@ static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
>  	unsigned long bandwidth = 0;
>  	int new_bw = 0;
>  
> -	if (!mci->set_sdram_scrub_rate)
> -		return -EINVAL;
> +	if (!mci->set_sdram_scrub_rate) {
> +		edac_printk(KERN_WARNING, EDAC_MC,
> +			"Memory scrub rate writing is not implemented\n");
> +		return count;
> +	}
>  
>  	if (strict_strtoul(data, 10, &bandwidth) < 0)
>  		return -EINVAL;
> @@ -474,8 +477,11 @@ static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
>  {
>  	int bandwidth = 0;
>  
> -	if (!mci->get_sdram_scrub_rate)
> -		return -EINVAL;
> +	if (!mci->get_sdram_scrub_rate) {
> +		edac_printk(KERN_WARNING, EDAC_MC,
> +			"Memory scrub rate reading not implemented\n");
> +		return sprintf(data, "%d\n", -1);
> +	}
>  
>  	bandwidth = mci->get_sdram_scrub_rate(mci);
>  	if (bandwidth < 0) {
> -- 
> 1.7.1
> 


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
