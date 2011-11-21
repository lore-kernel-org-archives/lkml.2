Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1KUPij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:38:39 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:3847 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1KUPii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:38:38 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 21 Nov 2011 23:50:42 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 3/8] of: create of_phandle_args to simplify return of
 phandle parsing data
Message-ID: <20111121155042.GB16417@S2100-06.ap.freescale.net>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-4-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320801583-12774-4-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 06:19:38PM -0700, Grant Likely wrote:
[...]
>  /**
> - * of_parse_phandles_with_args - Find a node pointed by phandle in a list
> + * of_parse_phandle_with_args - Find a node pointed by phandle in a list
>   * @np:		pointer to a device tree node containing a list
>   * @list_name:	property name that contains a list
>   * @cells_name:	property name that specifies phandles' arguments count
>   * @index:	index of a phandle to parse out
> - * @out_node:	optional pointer to device_node struct pointer (will be filled)
> - * @out_args:	optional pointer to arguments pointer (will be filled)
> + * @out_args:	optional pointer to output arguments structure (will be filled)
>   *
>   * This function is useful to parse lists of phandles and their arguments.
> - * Returns 0 on success and fills out_node and out_args, on error returns
> - * appropriate errno value.
> + * Returns 0 on success and fills out_args, on error returns appropriate
> + * errno value.
>   *
>   * Example:
>   *
> @@ -851,94 +850,105 @@ EXPORT_SYMBOL(of_parse_phandle);
>   * }
>   *
>   * To get a device_node of the `node2' node you may call this:
> - * of_parse_phandles_with_args(node3, "list", "#list-cells", 2, &node2, &args);
> + * of_parse_phandle_with_args(node3, "list", "#list-cells", 2, &args);

Not introduced by this patch, but if I read the code correctly,
the fourth parameter should be 1?

>   */
> -int of_parse_phandles_with_args(struct device_node *np, const char *list_name,
> +int of_parse_phandle_with_args(struct device_node *np, const char *list_name,
>  				const char *cells_name, int index,
> -				struct device_node **out_node,
> -				const void **out_args)
> +				struct of_phandle_args *out_args)
>  {
>  	int ret = -EINVAL;
> -	const __be32 *list;
> -	const __be32 *list_end;
> -	int size;
> -	int cur_index = 0;
> +	const __be32 *list, *list_end;
> +	int size, cur_index = 0;
> +	uint32_t count = 0;
>  	struct device_node *node = NULL;
> -	const void *args = NULL;
> +	phandle phandle;
>  
> +	/* Retrieve the phandle list property */
>  	list = of_get_property(np, list_name, &size);
> -	if (!list) {
> -		ret = -ENOENT;
> +	if (!list)
>  		goto err0;
> -	}
>  	list_end = list + size / sizeof(*list);
>  
> +	/*
> +	 * Loop over all the entries in the list, parsing the #cells property
> +	 * for each one to determine how long each argument list is
> +	 */
>  	while (list < list_end) {
> -		const __be32 *cells;
> -		phandle phandle;
> +		count = 0;
>  
> +		/*
> +		 * If phandle is null, then it is an empty entry with no args,
> +		 * skip forward to the next entry
> +		 */
>  		phandle = be32_to_cpup(list++);
> -		args = list;
> -
> -		/* one cell hole in the list = <>; */
> -		if (!phandle)
> -			goto next;
> -
> -		node = of_find_node_by_phandle(phandle);
> -		if (!node) {
> -			pr_debug("%s: could not find phandle\n",
> -				 np->full_name);
> -			goto err0;
> -		}
> +		if (phandle) {
> +			/*
> +			 * Find the provider node and parse the #*-cells
> +			 * property to determine how long the arguements are
> +			 */
> +			node = of_find_node_by_phandle(phandle);
> +			if (!node) {
> +				pr_debug("%s: could not find phandle\n",
> +					 np->full_name);
> +				ret = -EINVAL;
> +				goto err0;
> +			}
> +			if (of_property_read_u32(node, cells_name, &count)) {
> +				pr_debug("%s: could not get %s for %s\n",
> +					 np->full_name, cells_name,
> +					 node->full_name);
> +				ret = -EINVAL;
> +				goto err1;
> +			}
>  
> -		cells = of_get_property(node, cells_name, &size);
> -		if (!cells || size != sizeof(*cells)) {
> -			pr_debug("%s: could not get %s for %s\n",
> -				 np->full_name, cells_name, node->full_name);
> -			goto err1;
> +			/*
> +			 * Make sure that the arguments actually fit in the
> +			 * remaining property data length
> +			 */
> +			if (list + count > list_end) {
> +				pr_debug("%s: insufficient arguments length\n",
> +					 np->full_name);
> +				goto err1;
> +			}
>  		}
>  
> -		list += be32_to_cpup(cells);
> -		if (list > list_end) {
> -			pr_debug("%s: insufficient arguments length\n",
> -				 np->full_name);
> -			goto err1;
> -		}
> -next:
> -		if (cur_index == index)
> +		/*
> +		 * All of the error cases in the loop bail out to the err
> +		 * labels, so at this point, the parsing was successful, but
> +		 * it might be an empty entry
> +		 */
> +		if (cur_index == index) {
> +			ret = phandle ? 0 : -ENOENT;

We have some return code here ...

>  			break;
> +		}
>  
>  		of_node_put(node);
>  		node = NULL;
> -		args = NULL;
> +		list += count;
>  		cur_index++;
>  	}
>  
> -	if (!node) {
> -		/*
> -		 * args w/o node indicates that the loop above has stopped at
> -		 * the 'hole' cell. Report this differently.
> -		 */
> -		if (args)
> -			ret = -EEXIST;
> -		else
> -			ret = -ENOENT;
> +	if (!node)
>  		goto err0;
> -	}
> -
> -	if (out_node)
> -		*out_node = node;
> -	if (out_args)
> -		*out_args = args;
>  
> +	if (out_args) {
> +		int i;
> +		if (WARN_ON(count > MAX_PHANDLE_ARGS))
> +			count = MAX_PHANDLE_ARGS;
> +		out_args->np = node;
> +		out_args->args_count = count;
> +		for (i = 0; i < count; i++)
> +			out_args->args[i] = be32_to_cpup(list++);
> +	}
>  	return 0;

... should this be "return ret"?

> -err1:
> +
> + err1:
>  	of_node_put(node);
> -err0:
> + err0:
>  	pr_debug("%s failed with status %d\n", __func__, ret);
>  	return ret;
>  }
> -EXPORT_SYMBOL(of_parse_phandles_with_args);
> +EXPORT_SYMBOL(of_parse_phandle_with_args);
>  

-- 
Regards,
Shawn

