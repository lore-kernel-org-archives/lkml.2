Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0IOWxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:53:16 -0400
Received: from smtp-out.google.com ([74.125.121.35]:51136 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab0IOWxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:53:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=G7M0zpogzl/z+iKutU8QZQDTkbDXn+Nw3PVSU0DY8e6K6QBQENWTAOy7JwHkplUjF
	UfQPhFEhGMmyN6qiZ+gIQ==
Date: Wed, 15 Sep 2010 15:53:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
In-Reply-To: <20100915222509.GE3730@thunk.org>
Message-ID: <alpine.DEB.2.00.1009151537080.15256@chino.kir.corp.google.com>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org> <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com> <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
 <alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com> <4C8FE263.5070101@kernel.org> <alpine.DEB.2.00.1009141646350.26982@chino.kir.corp.google.com> <1097CAA8-8234-4FE2-BAA1-9C7D9FA01CEC@mit.edu> <alpine.DEB.2.00.1009151322370.29425@chino.kir.corp.google.com>
 <20100915222509.GE3730@thunk.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010, Ted Ts'o wrote:

> All I can say is I hope the merging code is intelligent.  We recently
> had a problem where we were wasting huge amounts of memory because we
> were allocating large numbers of a the ext4_group_info structure,
> which was 132 bytes, and for which kmalloc() used a size-256 slab ---
> and the wasted memory was enough to cause OOM's in a critical
> (unfortunately statically sized) container when the disks got large
> enough and numerous enough.  The fix was to use a separate cache just
> for these 132-byte objects, and not to use kmalloc().
> 

That's not cache merging and it wasn't with slub.  kmalloc() allocates 
from caches that are initialized at boot with the smallest power-of-two 
size that allows the object with alignment to fit (and we have special 
96-byte and 192-byte kmalloc caches because they tend to be popular).  So 
with slub, a kmalloc(132, ...) would allocate from kmalloc-192 instead.

Cache merging merges caches created with kmem_cache_create() with already 
existing caches, perhaps even those kmalloc caches, that have the same 
basic properties.  There's some pretty strict requirements if a cache may 
be merged or not: it's alignment must be compatible, and the size must not 
waste more than 8 bytes on 64-bit.  Debugging flags and things like 
SLAB_DESTORY_BY_RCU won't be merged, either.

> I would be really annoyed if we switched to a slab allocator which did
> merging, and then found that the said slab allocator helpfully merged
> the 132-byte slab cache and the size-256 slab into a single slab
> cache, on the grounds that it thought it would save memory...  (I
> guess I'm just really really nervous about merging happening behind my
> back, and I really like having the per-object type allocation
> statistics.)
> 

Slub would allocate kmalloc(132, ...) from kmalloc-192, and it wouldn't 
merge your new cache created for ext4_group_info with any other cache 
unless it shared the same flags and had a size of 132-140 bytes with a 
compatible alignment.  On my system, it looks likely that such a cache 
would get merged with the numa_policy cache.
