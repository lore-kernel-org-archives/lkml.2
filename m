Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab0HEPj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:39:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab0HEPjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:39:24 -0400
Date: Thu, 5 Aug 2010 11:39:10 -0400
From: Jason Baron <jbaron@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: yehuda@hq.newdream.net, LKML <linux-kernel@vger.kernel.org>,
        greg@kroah.com
Subject: Re: [PATCH] Dynamic Debug: Introduce global fake module param
	module.ddebug
Message-ID: <20100805153910.GB2930@redhat.com>
References: <201007261414.30718.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007261414.30718.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 02:14:30PM +0200, Thomas Renninger wrote:
> This patch is based on 2.6.35-rc5 + this patchset I posted recently:                                                           
> [patch 0/3] Dynamic Debug providing early boot debug messages via boot parameter
> 
> It would be great to see these getting merged into 2.6.36...
> 
> Thanks,
> 
>         Thomas
> 
> -----
> 
> Dynamic Debug: Introduce global fake module param module.ddebug
> 
> Dynamic Debug allows enabling of pr_debug or KERN_DEBUG messages at runtime.
> This is controlled via /sys/kernel/debug/dynamic_debug/control.
> One major drawback is that the whole initialization of a module cannot be
> tracked, because ddebug is only aware of debug strings of loaded modules.
> But this is the most interesting part...
> 
> This patch introduces a fake module parameter module.ddebug(not shown in
> /sys/module/*/parameters, thus it does not use any resources/memory).
> 
> If a module gets ddebug passed as a module parameter (e.g. via module.ddebug
> kernel boot param or via "modprobe module ddebug"), all debug strings of this
> module get activated by issuing "module module_name +p" internally
> (not via sysfs) when the module gets loaded.
> 
> Possible enhancements for the future if ddebug might get extended with
> further flags:
> module.ddebug=flags
> Then module.ddebug="p" would be the same as module.ddebug, but if there
> is a "x" ddebug flag added, one could pass:
> module.ddebug="xp"
> which would result in such a dynamic debug query:
> module module_name +xp
> 
> One not handled side-effect of this patch:
> Modules must not use "ddebug" module parameter or it will get ignored.
> I tried to find a compile time check, but I could not see how that
> is possible. Possibly a run-time check or at least documentation (where?)
> should get added, that "ddebug" must not get used as a module parameter.
> 
> Tested with:
> options hp-wmi ddebug
> in modprobe.conf.local
> -> works and pr_debug messages issued at module initialization time show
> up. Also "p" flag gets set for the whole hp-wmi module debug strings:
> grep hp-wmi /sys/../dynamic_debug/control
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> ---
>  include/linux/dynamic_debug.h |    5 +++++
>  kernel/params.c               |    9 ++++++++-
>  lib/dynamic_debug.c           |    2 +-
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> Index: linux-platform_drivers/kernel/params.c
> ===================================================================
> --- linux-platform_drivers.orig/kernel/params.c
> +++ linux-platform_drivers/kernel/params.c
> @@ -24,6 +24,7 @@
>  #include <linux/err.h>
>  #include <linux/slab.h>
>  #include <linux/ctype.h>
> +#include <linux/dynamic_debug.h>
>  
>  #if 0
>  #define DEBUGP printk
> @@ -132,7 +133,7 @@ int parse_args(const char *name,
>  	       unsigned num,
>  	       int (*unknown)(char *param, char *val))
>  {
> -	char *param, *val;
> +	char *param, *val, ddebug[1024];
>  
>  	DEBUGP("Parsing ARGS: %s\n", args);
>  
> @@ -144,6 +145,12 @@ int parse_args(const char *name,
>  		int irq_was_disabled;
>  
>  		args = next_arg(args, &param, &val);
> +		if (parameq(param, "ddebug")) {
> +			sprintf(ddebug, "module %s +p", name);
> +			ddebug_exec_query(ddebug);
> +			continue;
> +		}
> +
>  		irq_was_disabled = irqs_disabled();
>  		ret = parse_one(param, val, params, num, unknown);
>  		if (irq_was_disabled && !irqs_disabled()) {
> Index: linux-platform_drivers/include/linux/dynamic_debug.h
> ===================================================================
> --- linux-platform_drivers.orig/include/linux/dynamic_debug.h
> +++ linux-platform_drivers/include/linux/dynamic_debug.h
> @@ -41,6 +41,7 @@ int ddebug_add_module(struct _ddebug *ta
>  
>  #if defined(CONFIG_DYNAMIC_DEBUG)
>  extern int ddebug_remove_module(const char *mod_name);
> +extern int ddebug_exec_query(char *query_string);
>  
>  #define __dynamic_dbg_enabled(dd)  ({	     \
>  	int __ret = 0;							     \
> @@ -77,6 +78,10 @@ static inline int ddebug_remove_module(c
>  {
>  	return 0;
>  }
> +static inline int ddebug_exec_query(char *query_string)
> +{
> +	return 0;
> +}
>  
>  #define dynamic_pr_debug(fmt, ...)					\
>  	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
> Index: linux-platform_drivers/lib/dynamic_debug.c
> ===================================================================
> --- linux-platform_drivers.orig/lib/dynamic_debug.c
> +++ linux-platform_drivers/lib/dynamic_debug.c
> @@ -429,7 +429,7 @@ static int ddebug_parse_flags(const char
>  	return 0;
>  }
>  
> -static int ddebug_exec_query(char *query_string)
> +int ddebug_exec_query(char *query_string)
>  {
>  	unsigned int flags = 0, mask = 0;
>  	struct ddebug_query query;


patch looks pretty good to me. I'm not sure how we reserve the 'ddebug'
keyword. However, I think its probably ok, if we mention it in
'kernel-parameters.txt' and in the dynamic debug documentation.

Also, ddebug could show up in /sys/module/$(modulename}/parameters/ ,
but this can probably be done in a followup patch.

Also, if 'ddebug' alone is set on the kernel command line, i'd like to
see us enable all debug statements. We could implement this by adding a
special 'meta' module to the control file which is just has a module
name of of 'All' or something like that. This could also be done in a
subsequent patch.

We also need to at least remove the 'dynamic_printk' doc from
kernel-parameters.txt.

thanks,

-Jason
