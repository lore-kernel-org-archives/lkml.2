Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab0JKEKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 00:10:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64598 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0JKEKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 00:10:39 -0400
Date: Sun, 10 Oct 2010 22:10:36 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] of: no longer call prom_ functions directly; use
 an ops structure
Message-ID: <20101011041036.GC23588@angua.secretlab.ca>
References: <20101010014641.0b1b6b79@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010014641.0b1b6b79@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 01:46:41AM -0700, Andres Salomon wrote:
> 
> Rather than assuming an architecture defines prom_getchild and friends,
> define an ops struct with hooks for the various prom functions that
> pdt.c needs.  This ops struct is filled in by the
> arch-(and sometimes firmware-)specific code, and passed to
> of_pdt_build_devicetree.
> 
> Update sparc code to define the ops struct as well.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Applied, thanks.

g.

> ---
>  arch/sparc/kernel/prom_common.c |   36 ++++++++++++++++++++++++++++++++++-
>  drivers/of/pdt.c                |   40 +++++++++++++++++---------------------
>  include/linux/of_pdt.h          |   20 ++++++++++++++++++-
>  3 files changed, 72 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/sparc/kernel/prom_common.c b/arch/sparc/kernel/prom_common.c
> index fe84d56..ed25834 100644
> --- a/arch/sparc/kernel/prom_common.c
> +++ b/arch/sparc/kernel/prom_common.c
> @@ -118,11 +118,45 @@ int of_find_in_proplist(const char *list, const char *match, int len)
>  }
>  EXPORT_SYMBOL(of_find_in_proplist);
>  
> +/*
> + * SPARC32 and SPARC64's prom_nextprop() do things differently
> + * here, despite sharing the same interface.  SPARC32 doesn't fill in 'buf',
> + * returning NULL on an error.  SPARC64 fills in 'buf', but sets it to an
> + * empty string upon error.
> + */
> +static int __init handle_nextprop_quirks(char *buf, const char *name)
> +{
> +	if (!name || strlen(name) == 0)
> +		return -1;
> +
> +#ifdef CONFIG_SPARC32
> +	strcpy(buf, name);
> +#endif
> +	return 0;
> +}
> +
> +static int __init prom_common_nextprop(phandle node, char *prev, char *buf)
> +{
> +	const char *name;
> +
> +	buf[0] = '\0';
> +	name = prom_nextprop(node, prev, buf);
> +	return handle_nextprop_quirks(buf, name);
> +}
> +
>  unsigned int prom_early_allocated __initdata;
>  
> +static struct of_pdt_ops prom_sparc_ops __initdata = {
> +	.nextprop = prom_common_nextprop,
> +	.getproplen = prom_getproplen,
> +	.getproperty = prom_getproperty,
> +	.getchild = prom_getchild,
> +	.getsibling = prom_getsibling,
> +};
> +
>  void __init prom_build_devicetree(void)
>  {
> -	of_pdt_build_devicetree(prom_root_node);
> +	of_pdt_build_devicetree(prom_root_node, &prom_sparc_ops);
>  	of_console_init();
>  
>  	pr_info("PROM: Built device tree with %u bytes of memory.\n",
> diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> index 2fdb1b4..fd02fc1 100644
> --- a/drivers/of/pdt.c
> +++ b/drivers/of/pdt.c
> @@ -23,7 +23,8 @@
>  #include <linux/of.h>
>  #include <linux/of_pdt.h>
>  #include <asm/prom.h>
> -#include <asm/oplib.h>
> +
> +static struct of_pdt_ops *of_pdt_prom_ops __initdata;
>  
>  void __initdata (*prom_build_more)(struct device_node *dp,
>  		struct device_node ***nextp);
> @@ -59,7 +60,7 @@ static struct property * __init build_one_prop(phandle node, char *prev,
>  {
>  	static struct property *tmp = NULL;
>  	struct property *p;
> -	const char *name;
> +	int err;
>  
>  	if (tmp) {
>  		p = tmp;
> @@ -77,28 +78,20 @@ static struct property * __init build_one_prop(phandle node, char *prev,
>  		p->value = prom_early_alloc(special_len);
>  		memcpy(p->value, special_val, special_len);
>  	} else {
> -		if (prev == NULL) {
> -			name = prom_firstprop(node, p->name);
> -		} else {
> -			name = prom_nextprop(node, prev, p->name);
> -		}
> -
> -		if (!name || strlen(name) == 0) {
> +		err = of_pdt_prom_ops->nextprop(node, prev, p->name);
> +		if (err) {
>  			tmp = p;
>  			return NULL;
>  		}
> -#ifdef CONFIG_SPARC32
> -		strcpy(p->name, name);
> -#endif
> -		p->length = prom_getproplen(node, p->name);
> +		p->length = of_pdt_prom_ops->getproplen(node, p->name);
>  		if (p->length <= 0) {
>  			p->length = 0;
>  		} else {
>  			int len;
>  
>  			p->value = prom_early_alloc(p->length + 1);
> -			len = prom_getproperty(node, p->name, p->value,
> -					       p->length);
> +			len = of_pdt_prom_ops->getproperty(node, p->name,
> +					p->value, p->length);
>  			if (len <= 0)
>  				p->length = 0;
>  			((unsigned char *)p->value)[p->length] = '\0';
> @@ -130,10 +123,10 @@ static char * __init get_one_property(phandle node, const char *name)
>  	char *buf = "<NULL>";
>  	int len;
>  
> -	len = prom_getproplen(node, name);
> +	len = of_pdt_prom_ops->getproplen(node, name);
>  	if (len > 0) {
>  		buf = prom_early_alloc(len);
> -		len = prom_getproperty(node, name, buf, len);
> +		len = of_pdt_prom_ops->getproperty(node, name, buf, len);
>  	}
>  
>  	return buf;
> @@ -211,21 +204,25 @@ static struct device_node * __init prom_build_tree(struct device_node *parent,
>  #endif
>  		dp->full_name = build_full_name(dp);
>  
> -		dp->child = prom_build_tree(dp, prom_getchild(node), nextp);
> +		dp->child = prom_build_tree(dp,
> +				of_pdt_prom_ops->getchild(node), nextp);
>  
>  		if (prom_build_more)
>  			prom_build_more(dp, nextp);
>  
> -		node = prom_getsibling(node);
> +		node = of_pdt_prom_ops->getsibling(node);
>  	}
>  
>  	return ret;
>  }
>  
> -void __init of_pdt_build_devicetree(phandle root_node)
> +void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
>  {
>  	struct device_node **nextp;
>  
> +	BUG_ON(!ops);
> +	of_pdt_prom_ops = ops;
> +
>  	allnodes = prom_create_node(root_node, NULL);
>  #if defined(CONFIG_SPARC)
>  	allnodes->path_component_name = "";
> @@ -234,6 +231,5 @@ void __init of_pdt_build_devicetree(phandle root_node)
>  
>  	nextp = &allnodes->allnext;
>  	allnodes->child = prom_build_tree(allnodes,
> -					  prom_getchild(allnodes->phandle),
> -					  &nextp);
> +			of_pdt_prom_ops->getchild(allnodes->phandle), &nextp);
>  }
> diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
> index c0a8774..303c5ff 100644
> --- a/include/linux/of_pdt.h
> +++ b/include/linux/of_pdt.h
> @@ -13,10 +13,28 @@
>  #ifndef _LINUX_OF_PDT_H
>  #define _LINUX_OF_PDT_H
>  
> +/* overridable operations for calling into the PROM */
> +struct of_pdt_ops {
> +	/*
> +	 * buf should be 32 bytes; return 0 on success.
> +	 * If prev is NULL, the first property will be returned.
> +	 */
> +	int (*nextprop)(phandle node, char *prev, char *buf);
> +
> +	/* for both functions, return proplen on success; -1 on error */
> +	int (*getproplen)(phandle node, const char *prop);
> +	int (*getproperty)(phandle node, const char *prop, char *buf,
> +			int bufsize);
> +
> +	/* phandles are 0 if no child or sibling exists */
> +	phandle (*getchild)(phandle parent);
> +	phandle (*getsibling)(phandle node);
> +};
> +
>  extern void *prom_early_alloc(unsigned long size);
>  
>  /* for building the device tree */
> -extern void of_pdt_build_devicetree(phandle root_node);
> +extern void of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops);
>  
>  extern void (*prom_build_more)(struct device_node *dp,
>  		struct device_node ***nextp);
> -- 
> 1.5.6.5
> 
