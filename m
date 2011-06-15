Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1FOM6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 08:58:37 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54345 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1FOM6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:58:36 -0400
Date: Wed, 15 Jun 2011 18:28:16 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Josh Hunt <johunt@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Tapan Dhimant <tdhimant@akamai.com>
Subject: Re: [PATCH] lkdtm: Fix race when crashpoint is hit multiple times
 before checking count
Message-ID: <20110615125816.GB23151@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1308094827-29684-1-git-send-email-johunt@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308094827-29684-1-git-send-email-johunt@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 14, 2011 at 04:40:27PM -0700, Josh Hunt wrote:
> We observed the crash point count going negative in cases where the crash point
> is hit multiple times before the check of "count == 0" is done. Because of this
> we never call lkdtm_do_action(). This patch just adds a spinlock to protect
> count.
> 

Good catch! The fix Looks fine.

> Reported-by: Tapan Dhimant <tdhimant@akamai.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>

Acked-by: Ankita Garg <ankita@in.ibm.com>

> ---
>  drivers/misc/lkdtm.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
> index 81d7fa4..150cd70 100644
> --- a/drivers/misc/lkdtm.c
> +++ b/drivers/misc/lkdtm.c
> @@ -120,6 +120,7 @@ static int recur_count = REC_NUM_DEFAULT;
>  static enum cname cpoint = CN_INVALID;
>  static enum ctype cptype = CT_NONE;
>  static int count = DEFAULT_COUNT;
> +static DEFINE_SPINLOCK(count_lock);
> 
>  module_param(recur_count, int, 0644);
>  MODULE_PARM_DESC(recur_count, " Recursion level for the stack overflow test, "\
> @@ -230,11 +231,14 @@ static const char *cp_name_to_str(enum cname name)
>  static int lkdtm_parse_commandline(void)
>  {
>  	int i;
> +	unsigned long flags;
> 
>  	if (cpoint_count < 1 || recur_count < 1)
>  		return -EINVAL;
> 
> +	spin_lock_irqsave(&count_lock, flags);
>  	count = cpoint_count;
> +	spin_unlock_irqrestore(&count_lock, flags);
> 
>  	/* No special parameters */
>  	if (!cpoint_type && !cpoint_name)
> @@ -349,6 +353,9 @@ static void lkdtm_do_action(enum ctype which)
> 
>  static void lkdtm_handler(void)
>  {
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&count_lock, flags);
>  	count--;
>  	printk(KERN_INFO "lkdtm: Crash point %s of type %s hit, trigger in %d rounds\n",
>  			cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
> @@ -357,6 +364,7 @@ static void lkdtm_handler(void)
>  		lkdtm_do_action(cptype);
>  		count = cpoint_count;
>  	}
> +	spin_unlock_irqrestore(&count_lock, flags);
>  }
> 
>  static int lkdtm_register_cpoint(enum cname which)

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
