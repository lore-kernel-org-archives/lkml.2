Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab0LVBRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 20:17:14 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:50859 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943Ab0LVBRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 20:17:13 -0500
Date: Tue, 21 Dec 2010 17:17:12 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Show version information for built-in modules in sysfs
Message-ID: <20101222011712.GA19105@dtor-ws.eng.vmware.com>
References: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
 <201012221132.41057.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012221132.41057.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 05:02:40PM -0800, Rusty Russell wrote:
> On Thu, 16 Dec 2010 08:30:19 am Dmitry Torokhov wrote:
> > Currently only drivers that are built as modules have their versions
> > shown in /sys/module/<module_name>/version, but this information might
> > also be useful for built-in drivers as well. This especially important
> > for drivers that do not define any parameters - such drivers, if
> > built-in, are completely invisible from userspace.
> > 
> > This patch changes MODULE_VERSION() macro so that in case when we are
> > compiling built-in module, version information is stored in a separate
> > section. Kernel then uses this data to create 'version' sysfs attribute
> > in the same fashion it creates attributes for module parameters.
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> > ---
> > 
> > This change is driven by our desire to detect whether vmw_balloon driver
> > is built-in into the kernel when we installing our tool package in the
> > guest and avoid installing our own version of the driver.
> > 
> > Since vmw_balloon does not have any module parameter nor registers any
> > driver core devices, without this patch it is completely invisible from
> > userspace when built into the kernel.
> > 
> > Thanks,
> > Dmitry
> > 
> >  include/asm-generic/vmlinux.lds.h |    7 ++++
> >  include/linux/module.h            |   27 +++++++++++++++
> >  kernel/params.c                   |   65 ++++++++++++++++++++++++++++++------
> >  3 files changed, 88 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index bd69d79..0d83dd1 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -355,6 +355,13 @@
> >  		VMLINUX_SYMBOL(__start___param) = .;			\
> >  		*(__param)						\
> >  		VMLINUX_SYMBOL(__stop___param) = .;			\
> > +	}								\
> > +									\
> > +	/* Built-in module versions. */					\
> > +	__modver : AT(ADDR(__modver) - LOAD_OFFSET) {			\
> > +		VMLINUX_SYMBOL(__start___modver) = .;			\
> > +		*(__modver)						\
> > +		VMLINUX_SYMBOL(__stop___modver) = .;			\
> >  		. = ALIGN((align));					\
> >  		VMLINUX_SYMBOL(__end_rodata) = .;			\
> >  	}								\
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 7575bbb..f74ddda 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -58,6 +58,12 @@ struct module_attribute {
> >  	void (*free)(struct module *);
> >  };
> >  
> > +struct module_version_attribute {
> > +	struct module_attribute mattr;
> > +	const char *module_name;
> > +	const char *version;
> > +};
> > +
> >  struct module_kobject
> >  {
> >  	struct kobject kobj;
> > @@ -161,7 +167,28 @@ extern struct module __this_module;
> >    Using this automatically adds a checksum of the .c files and the
> >    local headers in "srcversion".
> >  */
> > +
> > +#ifdef MODULE
> >  #define MODULE_VERSION(_version) MODULE_INFO(version, _version)
> > +#else
> > +#define MODULE_VERSION(_version)					\
> > +	extern ssize_t __modver_version_show(struct module_attribute *,	\
> > +					     struct module *, char *);	\
> > +	static struct module_version_attribute __modver_version_attr	\
> > +	__used								\
> > +    __attribute__ ((unused,__section__ ("__modver"),aligned(sizeof(void *)))) \
> 
> __used and unused seems overkill, and confused.
> 

Must admit that I copied used/unused verbatim from linux/moduleparam.h:

/* This is the fundamental function for registering boot/module
   parameters. */
#define __module_param_call(prefix, name, ops, arg, isbool, perm)	\
	/* Default value instead of permissions? */			\
	static int __param_perm_check_##name __attribute__((unused)) =	\
	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
	static const char __param_str_##name[] = prefix #name;		\
	static struct kernel_param __moduleparam_const __param_##name	\
	__used								\
    __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
	= { __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,	\
	    { arg } }


So should it be removed from here as well?

Thanks,

Dmitry

