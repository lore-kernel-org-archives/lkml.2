Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1D1Vl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 17:41:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45584 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab1D1Vl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 17:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ApC/hPxE3aJ3dqoCiEAxLBFL38AFil6iTzDat1kj6P5aiZtEJq3H21BuQaFcUZAutZ
         Gf4yiNd74eO2sCcmFI6g==
Date: Thu, 28 Apr 2011 14:41:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@suse.de>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] m68k SLUB fix for 2.6.39
In-Reply-To: <1304026464.2598.36.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg> <alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com> <1304026464.2598.36.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011, James Bottomley wrote:

> > Since 4a5fa3590f09 ([PARISC] slub: fix panic with DISCONTIGMEM) from 
> > 2.6.39-rc4, you can't actually select slub on m68k without CONFIG_ADVANCED 
> > and CONFIG_SINGLE_MEMORY_CHUNK because it otherwises defaults to 
> > discontigmem.
> > 
> > James tested hppa64 with my N_NORMAL_MEMORY fix and found that it turned 
> > an SMP box into UP.  If you've tested slub on m68k without regressions, 
> > then perhaps you'd like to add a "|| M68K" to CONFIG_SLUB?
> 
> To be honest, I really don't see that fixing it.  As soon as you
> allocate memory beyond range zero, you move onto a non-zero node as far
> as slub is concerned, and that will oops.
> 

Possible nodes are represented in slub with N_NORMAL_MEMORY, so the 
kmem_cache_node structures are allocated and initialized based on this 
nodemask.  As long as the memory ranges map to nodes set in the nodemask, 
this should be fine.

> I think what the N_NORMAL_MEMORY patch did is just make it take a whiile
> before you start allocating from that range.  Try executing a memory
> balloon on the platform; that was how we first demonstrated the problem
> on parisc.
> 

With parisc, you encountered an oops in add_partial() because the 
kmem_cache_node structure for the memory range returned by page_to_nid() 
was not allocated.  init_kmem_cache_nodes() takes care of this for all 
memory ranges set in N_NORMAL_MEMORY.

Adding Christoph and Pekka to the cc if there is additional concerns about 
slub on this architecture.
