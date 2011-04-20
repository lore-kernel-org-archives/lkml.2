Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1DTXMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:12:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39420 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1DTXMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:12:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=AH/YDa7GqFTKjyaU9kMDCz8Dc+TwAx73jh4AF5b/SRgJny8afIvte9q3/diSj1CSV4
         zbUL9xJv5X1zNZ/YUJlA==
Date: Wed, 20 Apr 2011 16:12:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303337718.2587.51.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104201530430.13948@chino.kir.corp.google.com>
References: <20110420161615.462D.A69D9226@jp.fujitsu.com> <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com> <20110420174027.4631.A69D9226@jp.fujitsu.com> <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
 <1303337718.2587.51.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, James Bottomley wrote:

> > This is probably because the parisc's DISCONTIGMEM memory ranges don't 
> > have bits set in N_NORMAL_MEMORY.
> > 
> > diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
> > --- a/arch/parisc/mm/init.c
> > +++ b/arch/parisc/mm/init.c
> > @@ -266,8 +266,10 @@ static void __init setup_bootmem(void)
> >  	}
> >  	memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
> >  
> > -	for (i = 0; i < npmem_ranges; i++)
> > +	for (i = 0; i < npmem_ranges; i++) {
> > +		node_set_state(i, N_NORMAL_MEMORY);
> >  		node_set_online(i);
> > +	}
> >  #endif
> 
> Yes, this seems to be the missing piece that gets it to boot.  We really
> need this in generic code, unless someone wants to run through all the
> other arch's doing it ...
> 

Looking at all other architectures that allow ARCH_DISCONTIGMEM_ENABLE, we 
already know x86 is fine, avr32 disables ARCH_DISCONTIGMEM_ENABLE entirely 
because its code only brings online node 0, and tile already sets the bit 
in N_NORMAL_MEMORY correctly when bringing a node online, probably because 
it was introduced after the various node state masks were added in 
7ea1530ab3fd back in October 2007.

So we're really only talking about alpha, ia64, m32r, m68k, and mips and 
it only seems to matter when using CONFIG_SLUB, which isn't surprising 
when greping for it:

	$ grep -r N_NORMAL_MEMORY mm/*
	mm/memcontrol.c:	if (!node_state(node, N_NORMAL_MEMORY))
	mm/memcontrol.c:		if (!node_state(node, N_NORMAL_MEMORY))
	mm/page_alloc.c:	[N_NORMAL_MEMORY] = { { [0] = 1UL } },
	mm/page_alloc.c:			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
	mm/slub.c:	for_each_node_state(node, N_NORMAL_MEMORY) {
	mm/slub.c:	for_each_node_state(node, N_NORMAL_MEMORY) {
	mm/slub.c:	for_each_node_state(node, N_NORMAL_MEMORY) {
	mm/slub.c:	for_each_node_state(node, N_NORMAL_MEMORY) {
	mm/slub.c:	for_each_node_state(node, N_NORMAL_MEMORY) {
	mm/slub.c:	for_each_node_state(node, N_NORMAL_MEMORY) {
	mm/slub.c:	for_each_node_state(node, N_NORMAL_MEMORY) {
	mm/slub.c:		for_each_node_state(node, N_NORMAL_MEMORY) {
	mm/slub.c:		for_each_node_state(node, N_NORMAL_MEMORY) {
	mm/slub.c:	for_each_node_state(node, N_NORMAL_MEMORY)

Those memory controller occurrences only result in it passing a node id of 
-1 to kmalloc_node() which means no specific node target, and that's fine 
for DISCONTIGMEM since we don't care about any proximity between memory 
ranges.

This should fix the remaining architectures so they can use CONFIG_SLUB, 
but I hope it can be tested by the individual arch maintainers like you 
did for parisc.

diff --git a/arch/alpha/mm/numa.c b/arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c
+++ b/arch/alpha/mm/numa.c
@@ -245,6 +245,7 @@ setup_memory_node(int nid, void *kernel_end)
 			bootmap_size, BOOTMEM_DEFAULT);
 	printk(" reserving pages %ld:%ld\n", bootmap_start, bootmap_start+PFN_UP(bootmap_size));
 
+	node_set_state(nid, N_NORMAL_MEMORY);
 	node_set_online(nid);
 }
 
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -573,6 +573,8 @@ void __init find_memory(void)
 				  map>>PAGE_SHIFT,
 				  bdp->node_min_pfn,
 				  bdp->node_low_pfn);
+		if (node_present_pages(node))
+			node_set_state(node, N_NORMAL_MEMORY);
 	}
 
 	efi_memmap_walk(filter_rsvd_memory, free_node_bootmem);
diff --git a/arch/m32r/kernel/setup.c b/arch/m32r/kernel/setup.c
--- a/arch/m32r/kernel/setup.c
+++ b/arch/m32r/kernel/setup.c
@@ -247,7 +247,9 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_DISCONTIGMEM
 	nodes_clear(node_online_map);
+	node_set_state(0, N_NORMAL_MEMORY);	/* always has memory */
 	node_set_online(0);
+	node_set_state(1, N_NORMAL_MEMORY);	/* always has memory */
 	node_set_online(1);
 #endif	/* CONFIG_DISCONTIGMEM */
 
diff --git a/arch/m68k/mm/init_mm.c b/arch/m68k/mm/init_mm.c
--- a/arch/m68k/mm/init_mm.c
+++ b/arch/m68k/mm/init_mm.c
@@ -59,6 +59,8 @@ void __init m68k_setup_node(int node)
 	}
 #endif
 	pg_data_map[node].bdata = bootmem_node_data + node;
+	if (node_present_pages(node))
+		node_set_state(node, N_NORMAL_MEMORY);
 	node_set_online(node);
 }
 
diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -471,6 +471,8 @@ void __init paging_init(void)
 
 		if (end_pfn > max_low_pfn)
 			max_low_pfn = end_pfn;
+		if (end_pfn > start_pfn)
+			node_set_state(node, N_NORMAL_MEMORY);
 	}
 	zones_size[ZONE_NORMAL] = max_low_pfn;
 	free_area_init_nodes(zones_size);
