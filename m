Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2AIH3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:29:39 -0500
Received: from ozlabs.org ([203.10.76.45]:60451 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab2AIH3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:29:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jon Masters <jcm@redhat.com>, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH] modules: sysfs - export: taint, address, size
In-Reply-To: <1325951076.860.2.camel@mop>
References: <1325951076.860.2.camel@mop>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 09 Jan 2012 17:57:16 +1030
Message-ID: <871ur99vzf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jan 2012 16:44:36 +0100, Kay Sievers <kay.sievers@vrfy.org> wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: modules: sysfs - export taint, address, size
> 
> Recent tools do not use /proc to retrieve module information. A few values
> are currently missing from sysfs.

Well, strace says lsmod still does.  Is libkmod doing something
different?  Should we be deprecating /proc/modules?

> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>  kernel/module.c |   89 +++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 62 insertions(+), 27 deletions(-)
> 
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -849,6 +849,26 @@ out:
>  	return ret;
>  }
>  
> +static size_t module_flags_taint(struct module *mod, char *buf)
> +{
> +	size_t l = 0;
> +
> +	if (mod->taints & (1 << TAINT_PROPRIETARY_MODULE))
> +		buf[l++] = 'P';
> +	else if (mod->taints & (1 << TAINT_OOT_MODULE))
> +		buf[l++] = 'O';
> +	if (mod->taints & (1 << TAINT_FORCED_MODULE))
> +		buf[l++] = 'F';
> +	if (mod->taints & (1 << TAINT_CRAP))
> +		buf[l++] = 'C';
> +	/*
> +	 * TAINT_FORCED_RMMOD: could be added.
> +	 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
> +	 * apply to modules.
> +	 */
> +	return l;
> +}

The else here is weird.  Shouldn't we leave the exclusion elsewhere?

> +static ssize_t show_address(struct module_attribute *mattr,
> +			    struct module_kobject *mk, char *buffer)
> +{
> +	return sprintf(buffer, "0x%pK\n", mk->mod->module_core);
> +}
> +
> +struct module_attribute module_address =
> +	__ATTR(address, 0444, show_address, NULL);
> +
> +static ssize_t show_size(struct module_attribute *mattr,
> +			struct module_kobject *mk, char *buffer)
> +{
> +	return sprintf(buffer, "%u\n", mk->mod->init_size + mk->mod->core_size);
> +}
> +
> +struct module_attribute module_size =
> +	__ATTR(size, 0444, show_size, NULL);

This copies a past mistake, and is definitely wrong.  Either expose both
pointers and sizes, or don't include init_size here.  Sure, it'll
normally be 0, but if not it's confusing...

But the bigger question is: Why are we exposing these sizes?
/proc/modules did since 2.2, or before, but that doesn't make it the
best option...

Cheers,
Rusty.
