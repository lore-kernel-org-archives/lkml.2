Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab2ECSup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:50:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58239 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753784Ab2ECSuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:50:44 -0400
Message-ID: <1336071041.13866.39.camel@joe2Laptop>
Subject: Re: [PATCH 2/3] params: replace printk(KERN_<LVL>...) with
 pr_<lvl>(...)
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jbaron@redhat.com
Date: Thu, 03 May 2012 11:50:41 -0700
In-Reply-To: <1336067860-19953-2-git-send-email-jim.cromie@gmail.com>
References: <1336067860-19953-1-git-send-email-jim.cromie@gmail.com>
	 <1336067860-19953-2-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 11:57 -0600, Jim Cromie wrote:
> I left 1 printk which uses __FILE__, __LINE__ explicitly, which should
> not be subject to generic preferences expressed via pr_fmt().
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  kernel/params.c |   33 ++++++++++++---------------------
>  1 files changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/params.c b/kernel/params.c
> index be78c90..08414ba 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -201,25 +201,21 @@ int parse_args(const char *doing,
>  		irq_was_disabled = irqs_disabled();
>  		ret = parse_one(param, val, doing, params, num,
>  				min_level, max_level, unknown);
> -		if (irq_was_disabled && !irqs_disabled()) {
> -			printk(KERN_WARNING "parse_args(): option '%s' enabled "
> -					"irq's!\n", param);
> -		}
> +		if (irq_was_disabled && !irqs_disabled())
> +			pr_warn("option '%s' enabled irq's!\n", param);
> +

The other parse_args pr_<level> uses have
	'"%s: ...", doing, ...'.
Maybe this one should too.

>  		switch (ret) {
>  		case -ENOENT:
> -			printk(KERN_ERR "%s: Unknown parameter `%s'\n",
> -			       doing, param);
> +			pr_err("%s: Unknown parameter `%s'\n", doing, param);
>  			return ret;
[]
> @@ -753,11 +746,9 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
>  #endif
>  		if (err) {
>  			kobject_put(&mk->kobj);
> -			printk(KERN_ERR
> -				"Module '%s' failed add to sysfs, error number %d\n",
> +			pr_err("Module '%s' failed add to sysfs, error: %d\n"
> +				"The system will be unstable now.\n",
>  				name, err);
> -			printk(KERN_ERR
> -				"The system will be unstable now.\n");
>  			return NULL;
>  		}
>  

It'd be nice to align the arguments and perhaps a
single line output may be better.

Maybe something like:

			pr_err("Adding module '%s' to sysfs failed (%d), the system is unstable\n",
			       name, err);

though perhaps this should be pr_crit
if it's really unstable.

