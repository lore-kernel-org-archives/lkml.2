Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab0JNWPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:15:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32639 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab0JNWPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qJtEBoCmoIhAX+joNDCo7JmF1P5Uv8VNilzOaaskgm4FFh0akEMZxIz/BV71HN2XK/
         oLazLcrRiGwGVvPyGrsw==
Date: Thu, 14 Oct 2010 15:15:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
In-Reply-To: <20101014011056.a58bac55.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1010141509270.3696@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <20101014011056.a58bac55.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010, Andrew Morton wrote:

> > ZONE_DMA is unnecessary for a large number of machines that do not
> > require addressing in the lower 16MB of memory because they do not use
> > ISA devices with 16-bit address registers (plus one page byte register).
> > 
> > This patch allows users to disable ZONE_DMA for x86 if they know they
> > will not be using such devices with their kernel.
> > 
> > This prevents the VM from unnecessarily reserving a ratio of memory
> > (defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
> > for such allocations when it will never be used.
> > 
> 
> I wonder how hard it would be to do this at runtime, probably with a
> boot parameter.
> 

A "no_zone_dma" boot parameter wouldn't allow us to achieve the text or 
data savings that we see from disabling all three options in question 
here.

Hot-adding ZONE_DMA at runtime would be possible but there's no guarantee 
that memory hasn't fully been used by the time you do it, so it disregards 
lowmem_reserve_ratio unless you migrate everything, which has a dependency 
on it being movable.

> I'd be a little concerned at the effects of this on page reclaim and
> the page allocator - it might expose weird pre-existing bugs or
> inefficiencies.  But we can cross that bridge when we fall off it, I
> guess.
> 

We've run with it for a couple years, we can even undefine __GFP_DMA to 
find allocations that we compile into the kernel to ensure we don't have a 
requirement for the zone.  Perhaps only define the gfp flag when we have 
CONFIG_ZONE_DMA and break users' builds until they disable options that 
require it (or enable CONFIG_ZONE_DMA)?

It would be great if we could do "select ZONE_DMA" for all options that 
require it, though.
