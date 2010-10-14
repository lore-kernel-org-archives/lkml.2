Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0JNWdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:33:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361Ab0JNWdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:33:22 -0400
Date: Thu, 14 Oct 2010 15:32:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
Message-Id: <20101014153223.a710d70c.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1010141509270.3696@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com>
	<20101014011056.a58bac55.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1010141509270.3696@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 15:15:28 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Thu, 14 Oct 2010, Andrew Morton wrote:
> 
> > > ZONE_DMA is unnecessary for a large number of machines that do not
> > > require addressing in the lower 16MB of memory because they do not use
> > > ISA devices with 16-bit address registers (plus one page byte register).
> > > 
> > > This patch allows users to disable ZONE_DMA for x86 if they know they
> > > will not be using such devices with their kernel.
> > > 
> > > This prevents the VM from unnecessarily reserving a ratio of memory
> > > (defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
> > > for such allocations when it will never be used.
> > > 
> > 
> > I wonder how hard it would be to do this at runtime, probably with a
> > boot parameter.
> > 
> 
> A "no_zone_dma" boot parameter wouldn't allow us to achieve the text or 
> data savings that we see from disabling all three options in question 
> here.

True, but doing it at runtime is vastly more user-friendly.  Distros
aren't doing to double the number of kernels they package for this
option!

Of course, we could do both.

> Hot-adding ZONE_DMA at runtime would be possible but there's no guarantee 
> that memory hasn't fully been used by the time you do it, so it disregards 
> lowmem_reserve_ratio unless you migrate everything, which has a dependency 
> on it being movable.
> 
> > I'd be a little concerned at the effects of this on page reclaim and
> > the page allocator - it might expose weird pre-existing bugs or
> > inefficiencies.  But we can cross that bridge when we fall off it, I
> > guess.
> > 
> 
> We've run with it for a couple years, we can even undefine __GFP_DMA to 
> find allocations that we compile into the kernel to ensure we don't have a 
> requirement for the zone.

"we" is google, I assume.

>  Perhaps only define the gfp flag when we have 
> CONFIG_ZONE_DMA and break users' builds until they disable options that 
> require it

That sounds a good idea.

What happens in the current patch if someone passes __GFP_DMA when
CONFIG_ZONE_DMA=n?  ENOMEM?  Perhaps it should WARN() as well.

> (or enable CONFIG_ZONE_DMA)?

hm.  It'd be better to make all the drivers depend on ZONE_DMA.  Good
luck with that :)

> It would be great if we could do "select ZONE_DMA" for all options that 
> require it, though.
