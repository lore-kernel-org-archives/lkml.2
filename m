Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab0IOACs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 20:02:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25092 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0IOACr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 20:02:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qyfbAjxAWK6rg6ywxYcy+Yp1dApaVCjm0Pba4X8lv7EPQkGsVXNX3fzO36j7vOv/a
	RRXhN/L0r+jEU0g0rsMgQ==
Date: Tue, 14 Sep 2010 17:02:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
In-Reply-To: <4C8FE263.5070101@kernel.org>
Message-ID: <alpine.DEB.2.00.1009141646350.26982@chino.kir.corp.google.com>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org> <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com> <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
 <alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com> <4C8FE263.5070101@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010, Pekka Enberg wrote:

> > > In my not-so-humble opinion, either the merging needs to go away
> > > entirely, or the misleading output needs to be fixed.
> > Cache merging may have been advertised as a bigger performance improvement
> > than it actually is, and I don't do it in my own slab allocator for other
> > reasons, but it does lead to more effective memory use by reducing slab
> > fragmentation.  On one of my benchmarking servers, over 60% of caches are
> > merged and /sys/kernel/slab/.../partial reports roughly the same percent
> > of fewer total partial slabs over the system in comparison to
> > slub_nomerge.
> Last time I checked (and it's been a while), it did reduce _internal
> fragmentation_ for the naive "memory used after boot" scenario. I don't think
> I ever advertised it as a performance improvement. Dunno if somebody else did.
> 

I believe that cache merging was advertised as being both a small 
cacheline optimization and a method for reducing slab fragmentation by 
filling up partial slabs.  Regardless, I measured the latter to be much 
more significant and found only a very slight improvement for netperf 
TCP_RR on machines with large cpu counts in comparison to slub_nomerge.

I don't believe that we need to remove cache merging and allocate more 
memory by default to be able to identify a particular cache using an 
egregious amount of slab when troubleshooting a problem.  That amount of 
memory (probably 4-8MB) is significant without kmem_cache_shrink() since, 
using my example where 60% of caches were merged into others, the partial 
list won't shrink below min_partial slabs for those ~120 caches.

I prefer my suggestion of using the unique ids of each cache in 
/proc/slabinfo since it won't unfairly attribute slab to caches that 
didn't allocate it.  Sure, /proc/slabinfo can't tell you which cache is at 
fault without booting with slub_nomerge, enabling tracing, using 
SLAB_TRACE, or kmemleak, but I think that's better than sacrificing the 
slab fragmentation by default.
