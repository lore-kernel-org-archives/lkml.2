Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab2EIGNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:13:49 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55837 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2EIGNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:13:46 -0400
Message-ID: <4FAA0ABB.8090906@linux.vnet.ibm.com>
Date: Wed, 09 May 2012 11:42:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Minho Ban <mhban@samsung.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] PM / Hibernate : Add wait for disk detection if resume_file
 is MAJOR:MINOR style
References: <4FA78724.5000401@samsung.com>
In-Reply-To: <4FA78724.5000401@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050820-1618-0000-0000-000001872285
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 01:56 PM, Minho Ban wrote:

> name_to_dev_t is not enough to check device detection when the resume_file is
> MAJOR:MINOR format. get_gendisk is needed in that case.
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


Nitpick: Multi-line comments should be of the form:

/*
 * name_to_dev_t is ineffective....
 * ....... major:minor format
 */

Regards,
Srivatsa S. Bhat

> +	if (isdigit(resume_file[0]) && resume_wait) {
> +		int partno;
> +		while (!get_gendisk(swsusp_resume_device, &partno))
> +			msleep(10);
> +	}
> +
>   Check_image:
>  	pr_debug("PM: Hibernation image partition %d:%d present\n",
>  		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));

