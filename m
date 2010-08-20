Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab0HTN62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:58:28 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33571 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750905Ab0HTN60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:58:26 -0400
Date: Fri, 20 Aug 2010 08:58:22 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>
Subject: Re: [Patch] numa:x86_64: Cacheline aliasing makes
 for_each_populated_zone extremely expensive -V2.
Message-ID: <20100820135822.GA3220@sgi.com>
References: <20100818183024.GZ3043@sgi.com>
 <4C6DB62C.9040105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6DB62C.9040105@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 03:54:36PM -0700, H. Peter Anvin wrote:
> On 08/18/2010 11:30 AM, Robin Holt wrote:
> >  
> > -	node_data[nodeid] = early_node_mem(nodeid, start, end, pgdat_size,
> > +	/*
> > +	 * Allocate an extra cacheline per node to reduce cacheline
> > +	 * aliasing when scanning all node's node_data.
> > +	 */
> > +	cache_alias_offset = nodeid * SMP_CACHE_BYTES;
> > +	node_data[nodeid] = cache_alias_offset +
> > +			    early_node_mem(nodeid, start, end,
> > +					   pgdat_size + cache_alias_offset,
> >  					   SMP_CACHE_BYTES);
> > -	if (node_data[nodeid] == NULL)
> > +	if (node_data[nodeid] == (void *)cache_alias_offset)
> >  		return;
> >  	nodedata_phys = __pa(node_data[nodeid]);
> >  	reserve_early(nodedata_phys, nodedata_phys + pgdat_size, "NODE_DATA");
> 
> I'm concerned about this, because it really seems to rely on subtleties
> in the behavior of early_node_mem, as well as the direction of
> find_e820_area -- which is pretty much intended to change anyway.  It's
> the "action at a distance" effect.
> 
> What we really want, I think, is to push the offsetting into
> find_early_area().  Right now we have an alignment parameter, but what
> we need is an alignment and a color parameter (this is just a classic
> case of cache coloring, after all) which indicates the desirable offset
> from the alignment base.

That sounds reasonable.  Are there other examples you can think of which
I can build upon?

Robin
