Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0JODKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 23:10:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55454 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab0JODK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 23:10:29 -0400
Date: Fri, 15 Oct 2010 05:10:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
Message-ID: <20101015031014.GC9640@elte.hu>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com>
 <20101014011056.a58bac55.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1010141509270.3696@chino.kir.corp.google.com>
 <20101014153223.a710d70c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014153223.a710d70c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 14 Oct 2010 15:15:28 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
> 
> > On Thu, 14 Oct 2010, Andrew Morton wrote:
> > 
> > > > ZONE_DMA is unnecessary for a large number of machines that do not
> > > > require addressing in the lower 16MB of memory because they do not use
> > > > ISA devices with 16-bit address registers (plus one page byte register).
> > > > 
> > > > This patch allows users to disable ZONE_DMA for x86 if they know they
> > > > will not be using such devices with their kernel.
> > > > 
> > > > This prevents the VM from unnecessarily reserving a ratio of memory
> > > > (defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
> > > > for such allocations when it will never be used.
> > > > 
> > > 
> > > I wonder how hard it would be to do this at runtime, probably with a
> > > boot parameter.
> > > 
> > 
> > A "no_zone_dma" boot parameter wouldn't allow us to achieve the text or 
> > data savings that we see from disabling all three options in question 
> > here.
> 
> True, but doing it at runtime is vastly more user-friendly.  Distros 
> aren't doing to double the number of kernels they package for this 
> option!

Strongly agreed!

Can we automate it perhaps? Drivers could express their zone needs, and 
perhaps we can free up the zone if there's no relevant driver loaded by 
the time we have booted up? If a hotplug driver arrives later on, is the 
MM good enough for us to be able to reinstate the zone dynamically?

Since we allocate top-down generally, the chance that the low zone is 
100% filled up with pinned, unmovable kmalloc buffers is small, so this 
solution could be practical - even if much of that zone is utilized 
already. These low allocations are pretty small typically.

We could also shrink the zone to an emergency amount, say 1MB, instead 
of zapping it completely, or so.

Thanks,

	Ingo
