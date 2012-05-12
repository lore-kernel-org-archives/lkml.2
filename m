Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab2ELVeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 17:34:13 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40892 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab2ELVeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 17:34:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Minho Ban <mhban@samsung.com>
Subject: Re: [PATCH] PM / Hibernate : Use get_gendisk to verify partition if resume_file is integer format
Date: Sat, 12 May 2012 23:39:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
References: <4FAA4597.7060302@samsung.com>
In-Reply-To: <4FAA4597.7060302@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205122339.01696.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 09, 2012, Minho Ban wrote:
> Sometimes resume= parameter comes in integer style (e.g. major:minor) then
> name_to_dev_t can not detect partition properly. (especially async device like
> usb, mmc)
> This patch calls get_gendisk if resumewait is true and resume_file is in integer
> format.
> 
> Signed-off-by: Minho Ban <mhban@samsung.com>
> ---
>  Documentation/kernel-parameters.txt |    2 ++
>  kernel/power/hibernate.c            |   13 +++++++++++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index c1601e5..5900b49 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2372,6 +2372,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	resume=		[SWSUSP]
>  			Specify the partition device for software suspend
> +			Format:
> +			{/dev/<dev> | PARTUUID=<uuid> | <int>:<int> | <hex>}
>  
>  	resume_offset=	[SWSUSP]
>  			Specify the offset from the beginning of the partition
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index e09dfbf..8b53db3 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -25,6 +25,8 @@
>  #include <linux/freezer.h>
>  #include <linux/gfp.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/ctype.h>
> +#include <linux/genhd.h>
>  #include <scsi/scsi_scan.h>
>  
>  #include "power.h"
> @@ -722,6 +724,17 @@ static int software_resume(void)
>  
>  	/* Check if the device is there */
>  	swsusp_resume_device = name_to_dev_t(resume_file);
> +
> +	/*
> +	 * name_to_dev_t is ineffective to verify parition if resume_file is in
> +	 * integer format. (e.g. major:minor)
> +	 */
> +	if (isdigit(resume_file[0]) && resume_wait) {
> +		int partno;
> +		while (!get_gendisk(swsusp_resume_device, &partno))
> +			msleep(10);
> +	}

Hmm.  Wouldn't it be better to do:

	if (isdigit(resume_file[0]) && resume_wait) {
		int partno;
		while (!get_gendisk(swsusp_resume_device, &partno))
			msleep(10);
	} else {
		swsusp_resume_device = name_to_dev_t(resume_file);
	}

?

Your new code will overwrite whatever swsusp_resume_device is set to by the
preceding statement anyway.

> +
>  	if (!swsusp_resume_device) {
>  		/*
>  		 * Some device discovery might still be in progress; we need
> 

Thanks,
Rafael
