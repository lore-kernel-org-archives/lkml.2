Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0INU40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:56:26 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54895 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab0INU4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:56:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=DteXv/c4Gcz/L77O01sTVa0FAM+GKbPMqffFByNhKwwMNSi+p4yzhBNExFLW/UQ0t
	Jfam5RBOxxnMsrzabn6rA==
Date: Tue, 14 Sep 2010 13:56:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
In-Reply-To: <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org> <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com> <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Linus Torvalds wrote:

> > I can understand how it's confusing that only the first slab cache name is
> > being emitted, and I think that can be changed, but this shows way too
> > much information that is already available when CONFIG_SLUB_DEBUG is used
> > via the sysfs interface.
> 
> Umm. Not in any readable form, it isn't.
> 

The debug information is available via /proc/slabinfo, the relationships 
amongst merged caches is available via /sys/kernel/slab.  The former 
depends on the latter via Kconfig, so slub requires using both interfaces 
because of its implementation of merged caches to understand each cache's 
slab usage.

I agree the only way to show this information only via /proc/slabinfo so 
that you can ignore the sysfs interface is by doing exactly what is done 
here.  The problem is that it's an incomplete solution since it's 
truncated at 63 chars, it delimits cache names by '+' which is allowed in 
names already, and is obfuscated because it doesn't imply caches are 
merged (in fact, it implies additional rather than subsumption.

> The cause for this is that I made a bug-report about the wrong slab
> info, with me claiming 400+ thousand entries (taking up 10M of memory)
> for a slub cache that turned out to be entirely innocent.
> 
> That's what /proc/slabinfo said, and quite frankly, /proc/slabinfo was
> simply _lying_. It gave very misleading output.
> 

I understand, and that's addressed with my suggestion of using the unique 
cache identifier for each line in /proc/slabinfo which would map 1:1 to 
the sysfs dentries for those merged caches.  /proc/slabinfo would then 
represent the true slab state by listing actual caches and their usage.

Aggregating 63 chars of cache names on each line of /proc/slabinfo 
wouldn't have helped you when it reports 400+ thousand entries because you 
still can't identify the guilty cache.  For that issue, this would simply 
give you a list of suspects, and sysfs is a better inteface for that since 
it's complete and not truncated.

> In my not-so-humble opinion, either the merging needs to go away
> entirely, or the misleading output needs to be fixed.

Cache merging may have been advertised as a bigger performance improvement 
than it actually is, and I don't do it in my own slab allocator for other 
reasons, but it does lead to more effective memory use by reducing slab 
fragmentation.  On one of my benchmarking servers, over 60% of caches are 
merged and /sys/kernel/slab/.../partial reports roughly the same percent 
of fewer total partial slabs over the system in comparison to 
slub_nomerge.

Indeed, to debug egregious slab usage on your system you would opt-out of 
the more efficient memory use by using slub_nomerge and then checking 
/proc/slabinfo anyway.
