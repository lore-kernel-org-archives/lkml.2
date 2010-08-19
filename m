Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab0HSWzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 18:55:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41757 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab0HSWzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 18:55:03 -0400
Message-ID: <4C6DB62C.9040105@zytor.com>
Date: Thu, 19 Aug 2010 15:54:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Jack Steiner <steiner@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>
Subject: Re: [Patch] numa:x86_64: Cacheline aliasing makes for_each_populated_zone
 extremely expensive -V2.
References: <20100818183024.GZ3043@sgi.com>
In-Reply-To: <20100818183024.GZ3043@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 11:30 AM, Robin Holt wrote:
>  
> -	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
> +	/*
> +	 * Allocate an extra cacheline per node to reduce cacheline
> +	 * aliasing when scanning all node's node_data.
> +	 */
> +	cache_alias_offset = nodeid * SMP_CACHE_BYTES;
> +	node_data[nodeid] = cache_alias_offset +
> +			    early_node_mem(nodeid, start, end,
> +					   pgdat_size + cache_alias_offset,
>  					   SMP_CACHE_BYTES);
> -	if (node_data[nodeid] == NULL)
> +	if (node_data[nodeid] == (void *)cache_alias_offset)
>  		return;
>  	nodedata_phys = __pa(node_data[nodeid]);
>  	reserve_early(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");

I'm concerned about this, because it really seems to rely on subtleties
in the behavior of early_node_mem, as well as the direction of
find_e820_area -- which is pretty much intended to change anyway.  It's
the "action at a distance" effect.

What we really want, I think, is to push the offsetting into
find_early_area().  Right now we have an alignment parameter, but what
we need is an alignment and a color parameter (this is just a classic
case of cache coloring, after all) which indicates the desirable offset
from the alignment base.

	-hpa
