Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0JOJJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:09:45 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32382 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab0JOJJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qApx73x8BwytJc6ASC5HllVaDz7yZ8vkcP5Io+r5IAU16JCSajNq8mTH3iDv42eYeg
         5jx6eqtQ4GI6sQVnrhHA==
Date: Fri, 15 Oct 2010 02:09:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
In-Reply-To: <20101014153223.a710d70c.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1010150206190.8103@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <20101014011056.a58bac55.akpm@linux-foundation.org> <alpine.DEB.2.00.1010141509270.3696@chino.kir.corp.google.com> <20101014153223.a710d70c.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010, Andrew Morton wrote:

> > We've run with it for a couple years, we can even undefine __GFP_DMA to 
> > find allocations that we compile into the kernel to ensure we don't have a 
> > requirement for the zone.
> 
> "we" is google, I assume.
> 

Yes.

> >  Perhaps only define the gfp flag when we have 
> > CONFIG_ZONE_DMA and break users' builds until they disable options that 
> > require it
> 
> That sounds a good idea.
> 
> What happens in the current patch if someone passes __GFP_DMA when
> CONFIG_ZONE_DMA=n?  ENOMEM?  Perhaps it should WARN() as well.
> 

It'll return NULL and I suggested adding a 

#ifndef CONFIG_ZONE_DMA
	if (WARN_ON_ONCE(gfp_mask & __GFP_DMA))
		return NULL;
#endif

up front in the slowpath.

> hm.  It'd be better to make all the drivers depend on ZONE_DMA.  Good
> luck with that :)
> 

If they all truly depended on it then we'd never have been able to disable 
it.  I think breaking the build when you have CONFIG_ZONE_DMA=n and 
something is passing GFP_DMA would be the best alternative.
