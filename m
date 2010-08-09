Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab0HIFMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:12:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65165 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0HIFMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:12:43 -0400
MIME-Version: 1.0
In-Reply-To: <20100808231116.21c7d6f3@dev.queued.net>
References: <20100808231116.21c7d6f3@dev.queued.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 8 Aug 2010 23:12:21 -0600
X-Google-Sender-Auth: o1x7UH8fCc2cTSl-e6oSYTW5bCQ
Message-ID: <AANLkTimG7u5eXWSn5VznKfuFcFD+evTzo1_QpAFmCdpL@mail.gmail.com>
Subject: Re: [PATCH 2/3] sparc: make driver/of/pdt no longer sparc-specific
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres, thanks for the patch.  Comments below.

g.

On Sun, Aug 8, 2010 at 9:11 PM, Andres Salomon <dilinger@queued.net> wrote:
>
> Clean up pdt.c:
>  - make build dependent upon config OF_PROMTREE
>  - #ifdef out the sparc-specific stuff
>  - create pdt-specific header
>  - create a pdt_ops struct that pdt uses to call arch-specific prom routines
>
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  arch/sparc/Kconfig              |    1 +
>  arch/sparc/include/asm/prom.h   |    5 +-
>  arch/sparc/kernel/prom.h        |    6 --
>  arch/sparc/kernel/prom_common.c |   57 ++++++++++++++++++++++-
>  drivers/of/Kconfig              |    4 ++
>  drivers/of/Makefile             |    1 +
>  drivers/of/pdt.c                |   98 +++++++++++++++++++++++++-------------
>  include/linux/of_pdt.h          |   42 +++++++++++++++++
>  8 files changed, 171 insertions(+), 43 deletions(-)
>  create mode 100644 include/linux/of_pdt.h
>
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 13a9f2f..ed3f009 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -24,6 +24,7 @@ config SPARC
>        select HAVE_ARCH_KGDB if !SMP || SPARC64
>        select HAVE_ARCH_TRACEHOOK
>        select ARCH_WANT_OPTIONAL_GPIOLIB
> +       select OF_PROMTREE

Group this with the select OF from earlier in the config SPARC option.

>        select RTC_CLASS
>        select RTC_DRV_M48T59
>        select HAVE_PERF_EVENTS
> diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
> index f845828..329a976 100644
> --- a/arch/sparc/include/asm/prom.h
> +++ b/arch/sparc/include/asm/prom.h
> @@ -18,6 +18,7 @@
>  * 2 of the License, or (at your option) any later version.
>  */
>  #include <linux/types.h>
> +#include <linux/of_pdt.h>
>  #include <linux/proc_fs.h>
>  #include <linux/mutex.h>
>  #include <asm/atomic.h>
> @@ -65,8 +66,8 @@ extern struct device_node *of_console_device;
>  extern char *of_console_path;
>  extern char *of_console_options;
>
> -extern void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
> -extern char *build_full_name(struct device_node *dp);
> +extern void irq_trans_init(struct device_node *dp);
> +extern char *build_path_component(struct device_node *dp);
>
>  #endif /* __KERNEL__ */
>  #endif /* _SPARC_PROM_H */
> diff --git a/arch/sparc/kernel/prom.h b/arch/sparc/kernel/prom.h
> index eeb04a7..cf5fe1c 100644
> --- a/arch/sparc/kernel/prom.h
> +++ b/arch/sparc/kernel/prom.h
> @@ -4,12 +4,6 @@
>  #include <linux/spinlock.h>
>  #include <asm/prom.h>
>
> -extern void * prom_early_alloc(unsigned long size);
> -extern void irq_trans_init(struct device_node *dp);
> -
> -extern unsigned int prom_unique_id;
> -
> -extern char *build_path_component(struct device_node *dp);
>  extern void of_console_init(void);
>
>  extern unsigned int prom_early_allocated;
> diff --git a/arch/sparc/kernel/prom_common.c b/arch/sparc/kernel/prom_common.c
> index 7b454f6..4c5f67f 100644
> --- a/arch/sparc/kernel/prom_common.c
> +++ b/arch/sparc/kernel/prom_common.c
> @@ -20,6 +20,7 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/of.h>
> +#include <linux/of_pdt.h>
>  #include <asm/prom.h>
>  #include <asm/oplib.h>
>  #include <asm/leon.h>
> @@ -117,6 +118,60 @@ int of_find_in_proplist(const char *list, const char *match, int len)
>  }
>  EXPORT_SYMBOL(of_find_in_proplist);
>
> +/*
> + * SPARC32 and SPARC64's prom_firstprop/prom_nextprop do things differently
> + * here, despite sharing the same interface.  SPARC32 doesn't fill in 'buf',
> + * returning NULL on an error.  SPARC64 fills in 'buf', but sets it to an
> + * empty string upon error.
> + */
> +static int __init handle_prop_quirks(char *buf, const char *name)
> +{
> +       if (!name || strlen(name) == 0)
> +               return -1;
> +
> +#ifdef CONFIG_SPARC32
> +       strcpy(buf, name);
> +#endif
> +       return 0;
> +}
> +
> +static int __init prom_common_firstprop(phandle node, char *buf)
> +{
> +       const char *name;
> +
> +       buf[0] = '\0';
> +       name = prom_firstprop(node, buf);
> +       return handle_prop_quirks(buf, name);
> +}
> +
> +static int __init prom_common_nextprop(phandle node, const char *prev,
> +               char *buf)
> +{
> +       const char *name;
> +
> +       buf[0] = '\0';
> +       name = prom_nextprop(node, prev, buf);
> +       return handle_prop_quirks(buf, name);
> +}

Rather than having both prom_common_{firstprop,nextprop}(), there only
needs to be one hook; prom_common_nextprop().  Make it use the
firstprop behaviour when it is passed a NULL in the prev pointer.
This will simplify the users of this code further down.

> +
>  unsigned int prom_early_allocated __initdata;
>
> -#include "../../../drivers/of/pdt.c"
> +static struct of_pdt_ops prom_sparc_ops __initdata = {
> +       .firstprop = prom_common_firstprop,
> +       .nextprop = prom_common_nextprop,
> +       .getproplen = (int (*)(phandle, const char *))prom_getproplen,
> +       .getproperty = (int (*)(phandle, const char *, char *, int))prom_getproperty,
> +       .getchild = (phandle (*)(phandle))prom_getchild,
> +       .getsibling = (phandle (*)(phandle))prom_getsibling,

If you have to explicitly cast these function pointers, then you're
doing it wrong.  :-)  Listen to and fix the compiler complaint here.

> +};
> +
> +void __init prom_build_devicetree(void)
> +{
> +       of_pdt_set_ops(&prom_sparc_ops);
> +       of_pdt_build_devicetree(prom_root_node);

Maybe I'm being nitpicky here, but I would pass the ops structure into
of_pdt_build_devicetree() directly.  I don't like the implied state of
setting the ops pointer separate from parsing the tree.

> +
> +       of_console_init();
> +
> +       printk(KERN_INFO "PROM: Built device tree with %u bytes of memory.\n",
> +              prom_early_allocated);

pr_info()

> +}
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index 1678dbc..c8a4b7c 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -5,6 +5,10 @@ config OF_FLATTREE
>        bool
>        depends on OF
>
> +config OF_PROMTREE
> +       bool
> +       depends on OF
> +

I can tell from the context here you're working from an older tree.
Please rebase onto Linus' current top-of-tree.  :-)  A bunch of OF
related patches have been merged for 2.6.36 that will conflict with
this patch.

>  config OF_DYNAMIC
>        def_bool y
>        depends on OF && PPC_OF
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index f232cc9..54e8517 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -1,5 +1,6 @@
>  obj-y = base.o
>  obj-$(CONFIG_OF_FLATTREE) += fdt.o
> +obj-$(CONFIG_OF_PROMTREE) += pdt.o
>  obj-$(CONFIG_OF_DEVICE) += device.o platform.o
>  obj-$(CONFIG_OF_GPIO)   += gpio.o
>  obj-$(CONFIG_OF_I2C)   += of_i2c.o
> diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> index 61d9477..22f46fb 100644
> --- a/drivers/of/pdt.c
> +++ b/drivers/of/pdt.c
> @@ -1,5 +1,4 @@
> -/* prom_common.c: OF device tree support common code.
> - *
> +/*

You should still retain a one-line description of what this file is for.

>  * Paul Mackerras      August 1996.
>  * Copyright (C) 1996-2005 Paul Mackerras.
>  *
> @@ -7,6 +6,7 @@
>  *    {engebret|bergner}@us.ibm.com
>  *
>  *  Adapted for sparc by David S. Miller davem@davemloft.net
> + *  Adapted for multiple architectures by Andres Salomon <dilinger@queued.net>
>  *
>  *      This program is free software; you can redistribute it and/or
>  *      modify it under the terms of the GNU General Public License
> @@ -20,13 +20,44 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/of.h>
> +#include <linux/of_pdt.h>
>  #include <asm/prom.h>
> -#include <asm/oplib.h>
> -#include <asm/leon.h>
>
> -void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
> +void __initdata (*prom_build_more)(struct device_node *dp,
> +               struct device_node ***nextp);
> +
> +static struct of_pdt_ops prom_ops __initdata;

Why a full copy of the structure instead of a pointer?

> +
> +#if defined(CONFIG_SPARC)
> +static unsigned int prom_unique_id __initdata;
> +
> +#define inc_unique_id(p) do { \
> +       (p)->unique_id = prom_unique_id++; \
> +} while (0)

Use a static inline.  C code is preferred over preprocessor code.
Also preserver the namespace and use the of_pdt_ prefix (that goes for
all the new functions here in this file).

> +
> +static inline const char *fetch_node_name(struct device_node *dp)
> +{
> +       return dp->path_component_name;
> +}
> +
> +#else
> +
> +static inline void inc_unique_id(void *p)
> +{
> +       /* unused on non-SPARC architectures */
> +}
> +
> +static inline const char *fetch_node_name(struct device_node *dp)
> +{
> +       return dp->name;
> +}

It would be nice to rationalize the differences between how sparc and
powerpc use the ->name/->path_component_name fields; but I haven't
investigated what the differences are.

> +
> +static inline void irq_trans_init(struct device_node *dp)
> +{
> +       /* unused on non-SPARC architectures */
> +}

For empty statics like this; I'm fine with this more concise form:

+static inline void inc_unique_id(void *p) { }
+static inline void irq_trans_init(struct device_node *dp) { }

(again, add the of_pdt_ prefix)

>
> -unsigned int prom_unique_id;
> +#endif /* !CONFIG_SPARC */
>
>  static struct property * __init build_one_prop(phandle node, char *prev,
>                                               char *special_name,
> @@ -35,7 +66,6 @@ static struct property * __init build_one_prop(phandle node, char *prev,
>  {
>        static struct property *tmp = NULL;
>        struct property *p;
> -       const char *name;
>
>        if (tmp) {
>                p = tmp;
> @@ -43,7 +73,7 @@ static struct property * __init build_one_prop(phandle node, char *prev,
>                tmp = NULL;
>        } else {
>                p = prom_early_alloc(sizeof(struct property) + 32);
> -               p->unique_id = prom_unique_id++;
> +               inc_unique_id(p);
>        }
>
>        p->name = (char *) (p + 1);
> @@ -53,27 +83,24 @@ static struct property * __init build_one_prop(phandle node, char *prev,
>                p->value = prom_early_alloc(special_len);
>                memcpy(p->value, special_val, special_len);
>        } else {
> -               if (prev == NULL) {
> -                       name = prom_firstprop(node, p->name);
> -               } else {
> -                       name = prom_nextprop(node, prev, p->name);
> -               }
> +               int err;
>
> -               if (!name || strlen(name) == 0) {
> +               if (prev == NULL)
> +                       err = prom_ops.firstprop(node, p->name);
> +               else
> +                       err = prom_ops.nextprop(node, prev, p->name);

As mentioned earlier, this is better with a single .nextprop() hook
that behaves differently when a NULL prev pointer is passed.

> +               if (err) {
>                        tmp = p;
>                        return NULL;
>                }
> -#ifdef CONFIG_SPARC32
> -               strcpy(p->name, name);
> -#endif
> -               p->length = prom_getproplen(node, p->name);
> +               p->length = prom_ops.getproplen(node, p->name);
>                if (p->length <= 0) {
>                        p->length = 0;
>                } else {
>                        int len;
>
>                        p->value = prom_early_alloc(p->length + 1);
> -                       len = prom_getproperty(node, p->name, p->value,
> +                       len = prom_ops.getproperty(node, p->name, p->value,
>                                               p->length);
>                        if (len <= 0)
>                                p->length = 0;
> @@ -106,10 +133,10 @@ static char * __init get_one_property(phandle node, const char *name)
>        char *buf = "<NULL>";
>        int len;
>
> -       len = prom_getproplen(node, name);
> +       len = prom_ops.getproplen(node, name);
>        if (len > 0) {
>                buf = prom_early_alloc(len);
> -               len = prom_getproperty(node, name, buf, len);
> +               len = prom_ops.getproperty(node, name, buf, len);
>        }
>
>        return buf;
> @@ -124,7 +151,7 @@ static struct device_node * __init prom_create_node(phandle node,
>                return NULL;
>
>        dp = prom_early_alloc(sizeof(*dp));
> -       dp->unique_id = prom_unique_id++;
> +       inc_unique_id(dp);
>        dp->parent = parent;
>
>        kref_init(&dp->kref);
> @@ -140,13 +167,13 @@ static struct device_node * __init prom_create_node(phandle node,
>        return dp;
>  }
>
> -char * __init build_full_name(struct device_node *dp)
> +static char * __init build_full_name(struct device_node *dp)
>  {
>        int len, ourlen, plen;
>        char *n;
>
>        plen = strlen(dp->parent->full_name);
> -       ourlen = strlen(dp->path_component_name);
> +       ourlen = strlen(fetch_node_name(dp));
>        len = ourlen + plen + 2;
>
>        n = prom_early_alloc(len);
> @@ -155,7 +182,7 @@ char * __init build_full_name(struct device_node *dp)
>                strcpy(n + plen, "/");
>                plen++;
>        }
> -       strcpy(n + plen, dp->path_component_name);
> +       strcpy(n + plen, fetch_node_name(dp));
>
>        return n;
>  }
> @@ -182,36 +209,39 @@ static struct device_node * __init prom_build_tree(struct device_node *parent,
>                *(*nextp) = dp;
>                *nextp = &dp->allnext;
>
> +#if defined(CONFIG_SPARC)
>                dp->path_component_name = build_path_component(dp);
> +#endif
>                dp->full_name = build_full_name(dp);
>
> -               dp->child = prom_build_tree(dp, prom_getchild(node), nextp);
> +               dp->child = prom_build_tree(dp, prom_ops.getchild(node), nextp);
>
>                if (prom_build_more)
>                        prom_build_more(dp, nextp);
>
> -               node = prom_getsibling(node);
> +               node = prom_ops.getsibling(node);
>        }
>
>        return ret;
>  }
>
> -void __init prom_build_devicetree(void)
> +void __init of_pdt_build_devicetree(int root_node)
>  {
>        struct device_node **nextp;
>
> -       allnodes = prom_create_node(prom_root_node, NULL);
> +       allnodes = prom_create_node(root_node, NULL);
>        allnodes->path_component_name = "";
>        allnodes->full_name = "/";
>
>        nextp = &allnodes->allnext;
>        allnodes->child = prom_build_tree(allnodes,
> -                       prom_getchild(allnodes->phandle),
> +                       prom_ops.getchild(allnodes->phandle),
>                        &nextp);
> +}
>
> -       of_console_init();
> +void __init of_pdt_set_ops(struct of_pdt_ops *ops)
> +{
> +       BUG_ON(!ops);
>
> -       printk("PROM: Built device tree with %u bytes of memory.\n",
> -              prom_early_allocated);
> +       prom_ops = *ops;

As mentioned above, why is the structure copied instead of just
storing the pointer.

>  }
> -
> diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
> new file mode 100644
> index 0000000..1324ba5
> --- /dev/null
> +++ b/include/linux/of_pdt.h
> @@ -0,0 +1,42 @@
> +/*
> + * Definitions for building a device tree by calling into the
> + * Open Firmware PROM.
> + *
> + * Copyright (C) 2010  Andres Salomon <dilinger@queued.net>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#ifndef _LINUX_OF_PDT_H
> +#define _LINUX_OF_PDT_H
> +
> +extern void *prom_early_alloc(unsigned long size);
> +
> +/* overridable operations for calling into the PROM */
> +struct of_pdt_ops {
> +       /* buffers passed should be 32 bytes; return 0 on success */
> +       int (*firstprop)(phandle node, char *buf);
> +       int (*nextprop)(phandle node, const char *prev, char *buf);
> +
> +       /* for both functions, return proplen on success; -1 on error */
> +       int (*getproplen)(phandle node, const char *prop);
> +       int (*getproperty)(phandle node, const char *prop, char *buf,
> +                       int bufsize);
> +
> +       /* phandles are 0 if no child or sibling exists */
> +       phandle (*getchild)(phandle parent);
> +       phandle (*getsibling)(phandle node);
> +};
> +
> +extern void of_pdt_set_ops(struct of_pdt_ops *ops);
> +
> +/* for building the device tree */
> +extern void of_pdt_build_devicetree(int root_node);
> +
> +extern void (*prom_build_more)(struct device_node *dp,
> +               struct device_node ***nextp);
> +
> +#endif /* _LINUX_OF_PDT_H */
> --
> 1.5.6.5
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
