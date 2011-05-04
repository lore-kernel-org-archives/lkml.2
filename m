Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1EDPCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:02:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab1EDPCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:02:42 -0400
Subject: Re: [git pull] m68k SLUB fix for 2.6.39
From: James Bottomley <James.Bottomley@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg>
	 <alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com>
	 <1304026464.2598.36.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 10:02:35 -0500
Message-ID: <1304521355.2810.21.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 14:41 -0700, David Rientjes wrote:
> On Thu, 28 Apr 2011, James Bottomley wrote:
> 
> > > Since 4a5fa3590f09 ([PARISC] slub: fix panic with DISCONTIGMEM) from 
> > > 2.6.39-rc4, you can't actually select slub on m68k without CONFIG_ADVANCED 
> > > and CONFIG_SINGLE_MEMORY_CHUNK because it otherwises defaults to 
> > > discontigmem.
> > > 
> > > James tested hppa64 with my N_NORMAL_MEMORY fix and found that it turned 
> > > an SMP box into UP.  If you've tested slub on m68k without regressions, 
> > > then perhaps you'd like to add a "|| M68K" to CONFIG_SLUB?
> > 
> > To be honest, I really don't see that fixing it.  As soon as you
> > allocate memory beyond range zero, you move onto a non-zero node as far
> > as slub is concerned, and that will oops.
> > 
> 
> Possible nodes are represented in slub with N_NORMAL_MEMORY, so the 
> kmem_cache_node structures are allocated and initialized based on this 
> nodemask.  As long as the memory ranges map to nodes set in the nodemask, 
> this should be fine.
> 
> > I think what the N_NORMAL_MEMORY patch did is just make it take a whiile
> > before you start allocating from that range.  Try executing a memory
> > balloon on the platform; that was how we first demonstrated the problem
> > on parisc.
> > 
> 
> With parisc, you encountered an oops in add_partial() because the 
> kmem_cache_node structure for the memory range returned by page_to_nid() 
> was not allocated.  init_kmem_cache_nodes() takes care of this for all 
> memory ranges set in N_NORMAL_MEMORY.

Yes, but I also encountered it after I applied you patch, which is why I
still pushed the Kconfig patch.  It's possible, since there were a huge
number of patches flying around that the kernel base was contaminated,
so I'll strip down to just linus HEAD + parisc coherence patches,
reverting the Kconfig one and try again.

James


