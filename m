Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0IOUdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 16:33:17 -0400
Received: from smtp-out.google.com ([74.125.121.35]:36021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0IOUdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 16:33:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=n3cbvOYvVsHJCQwk4wfEk+oX9v9c/RHkF5YzkmSu1ck0HzeWeu3IGeaFy3AiM/jm5
	RMrQHZkPAOAhQmIgnMY6g==
Date: Wed, 15 Sep 2010 13:33:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Theodore Tso <tytso@mit.edu>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
In-Reply-To: <1097CAA8-8234-4FE2-BAA1-9C7D9FA01CEC@mit.edu>
Message-ID: <alpine.DEB.2.00.1009151322370.29425@chino.kir.corp.google.com>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org> <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com> <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
 <alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com> <4C8FE263.5070101@kernel.org> <alpine.DEB.2.00.1009141646350.26982@chino.kir.corp.google.com> <1097CAA8-8234-4FE2-BAA1-9C7D9FA01CEC@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010, Theodore Tso wrote:

> > I don't believe that we need to remove cache merging and allocate more 
> > memory by default to be able to identify a particular cache using an 
> > egregious amount of slab when troubleshooting a problem.  
> 
> Why not keep a separate accounting for each cache, even if we use the 
> same set of pages for a set of slab cache?   It is *really* *useful* to 
> be able to get that kind of debugging information without needing to 
> reboot the system into some kind of magic debugging mode.  More than 
> once I've had to debug a customer system where there was some kind of 
> memory allocation problem, where rebooting wouldn't have been an option, 
> or where rebooting would have destroyed the evidence.
> 
> It would seem to me that if there was a "super-slab" pointer in the 
> slab cache structure, then if it turns out the slab system wants to 
> merge a new slab cache with an existing one, you could instead allocate 
> a "super slab" structure, copy information from the initial slab cache 
> into the "super slab" and then set a pointer to the "super slab".   The 
> only information that would be kept in the individual slab cache 
> structures that have a non-zero "super slab" pointer would be the number 
> of objects allocator for that particular object time.
> 

I'd love to have per-cache statistics that we could export without the 
cost of the extra memory from fragmented partial slabs.  You'd have to do 
this for every cache even if it's a "superslab", though, to avoid a branch 
in the fastpath to find the cpu slab.  I'm not sure if Pekka and Christoph 
will be happy with the allocation of kmem_cache structures for mergable 
caches and the increment of the statistic in the fastpath.
