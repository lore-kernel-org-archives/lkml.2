Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2EGTeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:34:31 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57781 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab2EGTe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:34:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Minho Ban <mhban@samsung.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC/PATCH] PM / Hibernate : Add wait for disk detection if resume_file is MAJOR:MINOR style
Date: Mon, 7 May 2012 21:39:19 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4FA78724.5000401@samsung.com>
In-Reply-To: <4FA78724.5000401@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205072139.20129.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 07, 2012, Minho Ban wrote:
> name_to_dev_t is not enough to check device detection when the resume_file is
> MAJOR:MINOR format.

It's not assumed to be in that format, although I suppose we can add the
possibility to specify it this way.

> get_gendisk is needed in that case.
> 
> Signed-off-by: Minho Ban <mhban@samsung.com>
> ---
>  kernel/power/hibernate.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index e09dfbf..27efaef 100644
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
> @@ -749,6 +751,14 @@ static int software_resume(void)
>  		}
>  	}
>  
> +	/* name_to_dev_t is ineffective if resume_file comes in major:minor
> +	 * format */
> +	if (isdigit(resume_file[0]) && resume_wait) {

The check here is too late.  It should be done before name_to_dev_t() is
used on resume_file for the first time.

> +		int partno;
> +		while (!get_gendisk(swsusp_resume_device, &partno))
> +			msleep(10);
> +	}
> +
>   Check_image:
>  	pr_debug("PM: Hibernation image partition %d:%d present\n",
>  		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));

Besides, I'd like the documentation to be updated to reflect this change too.

Thanks,
Rafael
