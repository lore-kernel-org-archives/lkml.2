Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1AJXcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:32:12 -0500
Received: from smtp-out.google.com ([74.125.121.67]:38470 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1AJXcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:32:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=wWGqBkD7x8biZuJSdwVKK45NNziRx41eeUQc1Wxo2KVcyPbHGGWpST+a8szS3RVwqO
         THqQldz+EFIESIT15P5g==
Date: Mon, 10 Jan 2011 15:31:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Catalin Marinas <catalin.marinas@arm.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] kmemleak: Reduce verbosity when memory allocation
 fails
In-Reply-To: <AANLkTik-NwSioPg96EFUDzuK=zK0kNbvUeQbt0rwQAtX@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1101101527580.15655@chino.kir.corp.google.com>
References: <20110110181133.14995.12364.stgit@e102109-lin.cambridge.arm.com> <alpine.DEB.2.00.1101101232580.11969@chino.kir.corp.google.com> <AANLkTik-NwSioPg96EFUDzuK=zK0kNbvUeQbt0rwQAtX@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-981405303-1294702322=:15655"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-981405303-1294702322=:15655
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 10 Jan 2011, Catalin Marinas wrote:

> > It would be a shame if the allocation were __GFP_NORETRY and kmemleak
> > ended up looping forever because it suppresses the bit for a single page,
> > it uses __GFP_NOMEMALLOC and kmemleak ends up allocating from memory
> > reserves, or it uses __GFP_HARDWALL and kmemleak is allocating metadata in
> > a different cpuset.
> >
> > I'm not sure why you're not just masking __GFP_NOFAIL and __GFP_REPEAT and
> > then failing gracefully?  (And __GFP_ZERO and __GFP_COMP, too, of course.)
> 
> The reason I wouldn't allow kmemleak allocations to fail is that once
> it happened kmemleak cannot recover. Once it missed an allocation for
> its metadata, the corresponding memory block cannot be tracked nor
> scanned leading to false positives. I had thought about even passing
> __GFP_REPEAT but I think this is kind of implied for 0-order
> allocations.
> 

Yes, __GFP_REPEAT is a no-op for order-0 allocations for the current 
implementation.

> If the user calling the kernel alloc function cannot get memory,
> kmemleak won't be called anyway.
> 

I'm talking about when the allocation is successful and the metadata 
allocation is not, such as what Toralf reported.  If you pass 
__GFP_NOFAIL, it's going to loop forever which is certainly not what we'd 
want: we'd rather just disable kmemleak and continue doing work.  If you 
pass __GFP_NOMEMALLOC, then kmemleak can allocate from memory reserves in 
the reclaim path which is not allowed.  And if you don't pass 
__GFP_HARDWALL, then these allocations can break memory isolation by 
allowing the metadata to be allocated from different cpusets.

In other words, I'm pretty sure you don't want to be masking these options 
off of the caller allocation when passed.  It makes no sense for the user 
to do a GFP_KERNEL | __GFP_NORETRY allocation and then have kmemleak loop 
forever.
--531368966-981405303-1294702322=:15655--
