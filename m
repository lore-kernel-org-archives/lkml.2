Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0LVBCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 20:02:46 -0500
Received: from ozlabs.org ([203.10.76.45]:37953 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0LVBCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 20:02:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] Show version information for built-in modules in sysfs
Date: Wed, 22 Dec 2010 11:32:40 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
In-Reply-To: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012221132.41057.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010 08:30:19 am Dmitry Torokhov wrote:
> Currently only drivers that are built as modules have their versions
> shown in /sys/module/<module_name>/version, but this information might
> also be useful for built-in drivers as well. This especially important
> for drivers that do not define any parameters - such drivers, if
> built-in, are completely invisible from userspace.
> 
> This patch changes MODULE_VERSION() macro so that in case when we are
> compiling built-in module, version information is stored in a separate
> section. Kernel then uses this data to create 'version' sysfs attribute
> in the same fashion it creates attributes for module parameters.
> 
> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> ---
> 
> This change is driven by our desire to detect whether vmw_balloon driver
> is built-in into the kernel when we installing our tool package in the
> guest and avoid installing our own version of the driver.
> 
> Since vmw_balloon does not have any module parameter nor registers any
> driver core devices, without this patch it is completely invisible from
> userspace when built into the kernel.
> 
> Thanks,
> Dmitry
> 
>  include/asm-generic/vmlinux.lds.h |    7 ++++
>  include/linux/module.h            |   27 +++++++++++++++
>  kernel/params.c                   |   65 ++++++++++++++++++++++++++++++------
>  3 files changed, 88 insertions(+), 11 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index bd69d79..0d83dd1 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -355,6 +355,13 @@
>  		VMLINUX_SYMBOL(__start___param) = .;			\
>  		*(__param)						\
>  		VMLINUX_SYMBOL(__stop___param) = .;			\
> +	}								\
> +									\
> +	/* Built-in module versions. */					\
> +	__modver : AT(ADDR(__modver) - LOAD_OFFSET) {			\
> +		VMLINUX_SYMBOL(__start___modver) = .;			\
> +		*(__modver)						\
> +		VMLINUX_SYMBOL(__stop___modver) = .;			\
>  		. = ALIGN((align));					\
>  		VMLINUX_SYMBOL(__end_rodata) = .;			\
>  	}								\
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 7575bbb..f74ddda 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -58,6 +58,12 @@ struct module_attribute {
>  	void (*free)(struct module *);
>  };
>  
> +struct module_version_attribute {
> +	struct module_attribute mattr;
> +	const char *module_name;
> +	const char *version;
> +};
> +
>  struct module_kobject
>  {
>  	struct kobject kobj;
> @@ -161,7 +167,28 @@ extern struct module __this_module;
>    Using this automatically adds a checksum of the .c files and the
>    local headers in "srcversion".
>  */
> +
> +#ifdef MODULE
>  #define MODULE_VERSION(_version) MODULE_INFO(version, _version)
> +#else
> +#define MODULE_VERSION(_version)					\
> +	extern ssize_t __modver_version_show(struct module_attribute *,	\
> +					     struct module *, char *);	\
> +	static struct module_version_attribute __modver_version_attr	\
> +	__used								\
> +    __attribute__ ((unused,__section__ ("__modver"),aligned(sizeof(void *)))) \

__used and unused seems overkill, and confused.

Removed unused.

Cheers,
Rusty.
