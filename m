Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306Ab0JIQjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 12:39:15 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54432 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756388Ab0JIQjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 12:39:14 -0400
Date: Sat, 9 Oct 2010 11:39:09 -0500
From: Robin Holt <holt@sgi.com>
To: Russ Anderson <rja@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [BUG] x86: bootmem broken on SGI UV
Message-ID: <20101009163908.GX14068@sgi.com>
References: <20101008213429.GB7223@sgi.com>
 <4CAFA1DB.6010802@kernel.org>
 <20101009125944.GA18248@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101009125944.GA18248@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 07:59:45AM -0500, Russ Anderson wrote:
> Yes, Yinghai's patch fixes the problem.
> Thank you very much.

Will this be included in 2.6.36?  It is needed for boot in order for UV
systems to boot.

Thanks,
Robin

> 
> 
> On Fri, Oct 08, 2010 at 03:57:31PM -0700, Yinghai Lu wrote:
> > On 10/08/2010 02:34 PM, Russ Anderson wrote:
> > 
> > After looking at the changelog, it turns out it is broken for a while by
> > following commit
> > 
> > |commit 8716273caef7f55f39fe4fc6c69c5f9f197f41f1
> > |Author: David Rientjes <rientjes@google.com>
> > |Date:   Fri Sep 25 15:20:04 2009 -0700
> > |
> > |    x86: Export srat physical topology
> > 
> > before that commit, register_active_regions() is called SRAT memory entries.
> > 
> > Try to use nodememblk_range[] instead of nodes[].
> > 
> > For stable tree: from 2.6.33 to 2.3.36 need this patch by
> > changing memblock_x86_register_active_regions() with e820_register_active_regions()
> > 
> > Reported-by: Russ Anderson <rja@sgi.com>
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > Cc: stable@kernel.org
> > 
> > ---
> >  arch/x86/mm/srat_64.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6/arch/x86/mm/srat_64.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/mm/srat_64.c
> > +++ linux-2.6/arch/x86/mm/srat_64.c
> > @@ -421,9 +421,11 @@ int __init acpi_scan_nodes(unsigned long
> >  		return -1;
> >  	}
> >  
> > -	for_each_node_mask(i, nodes_parsed)
> > -		memblock_x86_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
> > -						nodes[i].end >> PAGE_SHIFT);
> > +	for (i = 0; i < num_node_memblks; i++)
> > +		memblock_x86_register_active_regions(memblk_nodeid[i],
> > +						node_memblk_range[i].start >> PAGE_SHIFT,
> > +						node_memblk_range[i].end >> PAGE_SHIFT);
> > +
> >  	/* for out of order entries in SRAT */
> >  	sort_node_map();
> >  	if (!nodes_cover_memory(nodes)) {
> 
> -- 
> Russ Anderson, OS RAS/Partitioning Project Lead  
> SGI - Silicon Graphics Inc          rja@sgi.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
