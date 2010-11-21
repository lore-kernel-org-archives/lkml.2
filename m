Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0KUAzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:55:31 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab0KUAz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:55:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Y2Rq10qFHYr8pQLq0W206GKx2z2/vVtoDiYyzcQgYY7Yjd8pTnYFhHCZcIbkbWVkO+
         ka/Lny39Fq7wBKkhF5Eg==
Date: Sat, 20 Nov 2010 16:55:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: b32542@freescale.com, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, Zeng Zhaoming <zengzm.kernel@gmail.com>
Subject: Re: [PATCH] slub: operate cache name memory same to slab and slob
In-Reply-To: <1290119265.26343.814.camel@calx>
Message-ID: <alpine.DEB.2.00.1011201650120.10618@chino.kir.corp.google.com>
References: <1290049259-20108-1-git-send-email-b32542@freescale.com> <1290114908.26343.721.camel@calx> <alpine.DEB.2.00.1011181333160.26680@chino.kir.corp.google.com> <1290119265.26343.814.camel@calx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Matt Mackall wrote:

> > The leak in ext4_mb_init() above is because it is using kstrdup() to 
> > allocate the string itself and then on destroy uses kmem_cache_name() to 
> > attain the slub allocator's pointer to the name, not the memory the ext4 
> > layer allocated itself.
> 
> And Pekka says:
> 
> > The kstrdup() is there because of SLUB cache merging. See commit 
> > 84c1cf62465e2fb0a692620dcfeb52323ab03d48 ("SLUB: Fix merged slab 
> > cache names") for details.
> 
> I see. So we can either:
> 
> - force anyone using dynamically-allocated names to track their own damn
> pointer
> - implement kstrdup in the other allocators and fix all callers (the
> bulk of which use static names!)
> - eliminate dynamically-allocated names (mostly useless when we start
> merging slabs!)
> - add an indirection layer for slub that holds the unmerged details
> - stop pretending we track slab names and show only generic names based
> on size in /proc
> 

I agree that we should force each user to track its own memory, and this 
is really what the issue is about (it doesn't matter if that memory is the 
cache's name).  This particular issue is an ext4 memory leak and not the 
responsibility of any allocator.

> kmem_cache_name() is also a highly suspect function in a
> post-merged-slabs kernel. As ext4 is the only user in the kernel, and it
> got it wrong, perhaps it's time to rip it out.
> 

Yes, I think kmem_cache_name() should be removed since it shouldn't be 
used for anything other than the internal slabinfo/slabtop display as the 
slub allocator actually specifies in include/linux/slub_def.h.  The only 
user is ext4 to track this dynamically allocated pointer, so we can 
eliminate it if we leave it to track its own memory allocations (a slab 
allocator shouldn't be carrying a metadata payload).
