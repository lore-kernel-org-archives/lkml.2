Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab0GFJVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 05:21:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46045 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab0GFJVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 05:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <20100628220037.5744c207@debian>
References: <20100628215407.2017bf2f@debian> <20100628220037.5744c207@debian>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 6 Jul 2010 03:21:21 -0600
X-Google-Sender-Auth: I9zqxua3E9nLYhezBO748ddjsw8
Message-ID: <AANLkTikDdAuDOxBVgV_QDY-YZOOZCyl1O5aYzDXCjW10@mail.gmail.com>
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building code 
	out into drivers/of
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 8:00 PM, Andres Salomon <dilinger@queued.net> wrote:
>
> Stick code into drivers/of/pdt.c (Prom Device Tree) that other
> architectures with OpenFirmware resident in memory can make use of.
>
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Some more comments below...

BTW, for the changes, you might what to split this patch into two
pieces.  One to verbatim copy the code from prom_common.c, and a
second to adapt it for non-sparc.  That will make the changes obvious
to future readers.  It will also make review easier.

> ---
>  arch/sparc/Kconfig              |    1 +
>  arch/sparc/include/asm/prom.h   |   15 +++-
>  arch/sparc/kernel/prom.h        |   14 ---
>  arch/sparc/kernel/prom_common.c |  173 +------------------------------
>  drivers/of/Kconfig              |    4 +
>  drivers/of/Makefile             |    1 +
>  drivers/of/pdt.c                |  225 +++++++++++++++++++++++++++++++++++++++
>  include/linux/of_pdt.h          |   37 +++++++
>  8 files changed, 282 insertions(+), 188 deletions(-)
>  create mode 100644 drivers/of/pdt.c
>  create mode 100644 include/linux/of_pdt.h
>
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 6f1470b..b4cb63b 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -150,6 +150,7 @@ config ARCH_NO_VIRT_TO_BUS
>
>  config OF
>        def_bool y
> +       select OF_PROMTREE
>
>  config ARCH_SUPPORTS_DEBUG_PAGEALLOC
>        def_bool y if SPARC64
> diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
> index f845828..0834c2a 100644
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
> @@ -65,8 +66,18 @@ extern struct device_node *of_console_device;
>  extern char *of_console_path;
>  extern char *of_console_options;
>
> -extern void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
> -extern char *build_full_name(struct device_node *dp);
> +/* stuff used by of/pdt */
> +extern void * prom_early_alloc(unsigned long size);
> +extern void irq_trans_init(struct device_node *dp);
> +extern char *build_path_component(struct device_node *dp);
> +
> +extern char *prom_firstprop(int node, char *buffer);
> +extern char *prom_nextprop(int node, const char *oprop, char *buffer);
> +extern int prom_getproplen(int node, const char *prop);
> +extern int prom_getproperty(int node, const char *prop,
> +                           char *buffer, int bufsize);
> +extern int prom_getchild(int node);
> +extern int prom_getsibling(int node);

These become the API required by of/pdt.  They should be defined in a
arch-independent header file.  Something like include/linux/of_pdt.h

Right now only OLPC will be using this, so static function definitions
are just fine.  However, if there is ever more than one method for
talking to OFW, then these hooks will need to be converted into an ops
structure so the right one can be passed in at runtime.

> diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> new file mode 100644
> index 0000000..b24167f
> --- /dev/null
> +++ b/drivers/of/pdt.c
> @@ -0,0 +1,225 @@
> +/*
> + * Paul Mackerras      August 1996.
> + * Copyright (C) 1996-2005 Paul Mackerras.
> + *
> + *  Adapted for 64bit PowerPC by Dave Engebretsen and Peter Bergner.
> + *    {engebret|bergner}@us.ibm.com
> + *
> + *  Adapted for sparc by David S. Miller davem@davemloft.net
> + *  Adapted for multiple architectures by Andres Salomon <dilinger@queued.net>
> + *
> + *      This program is free software; you can redistribute it and/or
> + *      modify it under the terms of the GNU General Public License
> + *      as published by the Free Software Foundation; either version
> + *      2 of the License, or (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/of_pdt.h>
> +#include <asm/prom.h>
> +
> +/* TODO: mark this stuff as __initdata */
> +void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);

So do it.  :-)

> +
> +#if defined(CONFIG_SPARC)
> +static unsigned int prom_unique_id;
> +
> +#define inc_unique_id(p) do { \
> +       (p)->unique_id = prom_unique_id++; \
> +} while (0)
> +
> +static inline const char *fetch_node_name(struct device_node *dp)
> +{
> +       return dp->path_component_name;
> +}
> +
> +#else
> +
> +#define inc_unique_id(p)       do { } while(0)

Use an empty static inline instead.

> +
> +static inline const char *fetch_node_name(struct device_node *dp)
> +{
> +       return dp->name;
> +}
> +
> +static inline void irq_trans_init(struct device_node *dp)
> +{
> +       /* unused on non-SPARC architectures */
> +}
> +
> +#endif /* !CONFIG_SPARC */
> +
> +static struct property * __init build_one_prop(phandle node, char *prev,
> +                                              char *special_name,
> +                                              void *special_val,
> +                                              int special_len)

I'd like to see all the static symbols in this file prefixed with
something unique to avoid collisions with the global namespace.
of_pdt_* would be good.  I'm doing this with the other files in
drivers/of whenever I can too.

> +{
> +       static struct property *tmp = NULL;
> +       struct property *p;
> +       const char *name;
> +
> +       if (tmp) {
> +               p = tmp;
> +               memset(p, 0, sizeof(*p) + 32);
> +               tmp = NULL;
> +       } else {
> +               p = prom_early_alloc(sizeof(struct property) + 32);
> +               inc_unique_id(p);
> +       }
> +
> +       p->name = (char *) (p + 1);
> +       if (special_name) {
> +               strcpy(p->name, special_name);
> +               p->length = special_len;
> +               p->value = prom_early_alloc(special_len);
> +               memcpy(p->value, special_val, special_len);
> +       } else {
> +               if (prev == NULL) {
> +                       name = prom_firstprop(node, p->name);
> +               } else {
> +                       name = prom_nextprop(node, prev, p->name);
> +               }
> +
> +               if (!name || strlen(name) == 0) {
> +                       tmp = p;
> +                       return NULL;
> +               }
> +#ifdef CONFIG_SPARC32
> +               strcpy(p->name, name);
> +#endif
> +               p->length = prom_getproplen(node, p->name);
> +               if (p->length <= 0) {
> +                       p->length = 0;
> +               } else {
> +                       int len;
> +
> +                       p->value = prom_early_alloc(p->length + 1);
> +                       len = prom_getproperty(node, p->name, p->value,
> +                                              p->length);
> +                       if (len <= 0)
> +                               p->length = 0;
> +                       ((unsigned char *)p->value)[p->length] = '\0';
> +               }
> +       }
> +       return p;
> +}
> +
> +static struct property * __init build_prop_list(phandle node)
> +{
> +       struct property *head, *tail;
> +
> +       head = tail = build_one_prop(node, NULL,
> +                                    ".node", &node, sizeof(node));
> +
> +       tail->next = build_one_prop(node, NULL, NULL, NULL, 0);
> +       tail = tail->next;
> +       while(tail) {
> +               tail->next = build_one_prop(node, tail->name,
> +                                           NULL, NULL, 0);
> +               tail = tail->next;
> +       }
> +
> +       return head;
> +}
> +
> +static char * __init get_one_property(phandle node, const char *name)
> +{
> +       char *buf = "<NULL>";
> +       int len;
> +
> +       len = prom_getproplen(node, name);
> +       if (len > 0) {
> +               buf = prom_early_alloc(len);
> +               len = prom_getproperty(node, name, buf, len);
> +       }
> +
> +       return buf;
> +}
> +
> +struct device_node * __init prom_create_node(phandle node,
> +                                            struct device_node *parent)
> +{
> +       struct device_node *dp;
> +
> +       if (!node)
> +               return NULL;
> +
> +       dp = prom_early_alloc(sizeof(*dp));
> +       inc_unique_id(dp);
> +       dp->parent = parent;
> +
> +       kref_init(&dp->kref);
> +
> +       dp->name = get_one_property(node, "name");
> +       dp->type = get_one_property(node, "device_type");
> +       dp->phandle = node;
> +
> +       dp->properties = build_prop_list(node);
> +
> +       irq_trans_init(dp);
> +
> +       return dp;
> +}
> +
> +static char * __init build_full_name(struct device_node *dp)
> +{
> +       int len, ourlen, plen;
> +       char *n;
> +
> +       plen = strlen(dp->parent->full_name);
> +       ourlen = strlen(fetch_node_name(dp));
> +       len = ourlen + plen + 2;
> +
> +       n = prom_early_alloc(len);
> +       strcpy(n, dp->parent->full_name);
> +       if (!is_root_node(dp->parent)) {
> +               strcpy(n + plen, "/");
> +               plen++;
> +       }
> +       strcpy(n + plen, fetch_node_name(dp));
> +
> +       return n;
> +}
> +
> +struct device_node * __init prom_build_tree(struct device_node *parent,
> +                                           phandle node,
> +                                           struct device_node ***nextp)
> +{
> +       struct device_node *ret = NULL, *prev_sibling = NULL;
> +       struct device_node *dp;
> +
> +       while (1) {
> +               dp = prom_create_node(node, parent);
> +               if (!dp)
> +                       break;
> +
> +               if (prev_sibling)
> +                       prev_sibling->sibling = dp;
> +
> +               if (!ret)
> +                       ret = dp;
> +               prev_sibling = dp;
> +
> +               *(*nextp) = dp;
> +               *nextp = &dp->allnext;
> +
> +#if defined(CONFIG_SPARC)
> +               dp->path_component_name = build_path_component(dp);
> +#endif
> +               dp->full_name = build_full_name(dp);
> +
> +               dp->child = prom_build_tree(dp, prom_getchild(node), nextp);
> +
> +               if (prom_build_more)
> +                       prom_build_more(dp, nextp);
> +
> +               node = prom_getsibling(node);
> +       }
> +
> +       return ret;
> +}

prom_build_devicetree() should also be factored out.

> diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
> new file mode 100644
> index 0000000..f62616e
> --- /dev/null
> +++ b/include/linux/of_pdt.h
> @@ -0,0 +1,37 @@
> +#include <linux/of.h>  /* linux/of.h gets to determine #include ordering */

Do you really need this #include in this way?  Can it be moved inside
the #ifndef OF_PDT block below?

> +/*
> + * Definitions for building a device tree by calling into the
> + * Open Firmware PROM.
> + *
> + * Copyright (C) 1996-2005 Paul Mackerras.
> + * Copyright (C) 2010  Andres Salomon <dilinger@queued.net>
> + *
> + * Updates for PPC64 by Peter Bergner & David Engebretsen, IBM Corp.
> + * Updates for SPARC by David S. Miller
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
> +extern struct device_node *prom_create_node(phandle node,
> +                                           struct device_node *parent);
> +extern struct device_node *prom_build_tree(struct device_node *parent,
> +                                          phandle node,
> +                                          struct device_node ***nextp);
> +
> +extern void (*prom_build_more)(struct device_node *dp, struct device_node ***nextp);
> +
> +static inline int is_root_node(const struct device_node *dp)
> +{
> +       if (!dp)
> +               return 0;
> +
> +       return (dp->parent == NULL);
> +}

This doesn't look like a pdt specific function, it could go in
include/linux/of.h.

Another general comment, I'm still not thrilled with this code having
its own independent method for building the tree, but I doubt the
existing add/remove nodes and properties code is usable early enough
to be suitable for sparc.  How early do you extract the device tree on
OLPC?  How are you going to use the data?

Anyway, enough comments for tonight.  I'll may have more on then next
round.  Time to go to bed.

g.
