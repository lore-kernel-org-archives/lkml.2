Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2EUMkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:40:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51104 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2EUMkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:40:31 -0400
Date: Mon, 21 May 2012 14:40:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521124025.GC17065@gmail.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120521082240.GA31407@gmail.com>
 <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> > So, in theory, prior the patch you should be seeing irqs go 
> > to only one CPU, while after the patch they are spread out 
> > amongst the CPU. If it's using LowestPrio delivery then we 
> > depend on the hardware doing this for us - how does this 
> > work out in practice, are the target CPUs round-robin-ed, 
> > with a new CPU for every new IRQ delivered?
> 
> That is exactly what I can observe.
> 
> As of 'target CPUs round-robin-ed' and 'with a new CPU for 
> every new IRQ delivered' -- that is something we can not 
> control as you noted. Nor do we care to my understanding.
> 
> I can not commit on every h/w out there obviously, but on my 
> PowerEdge M910 with some half-dozen clusters with six CPU per 
> each, the interrupts are perfectly balanced among those ones 
> present in IRTEs.

But that is not 'perfectly balanced' in many cases.

When the hardware round-robins the interrupts then each 
interrupt will go to a 'cache cold' CPU in essence. This is 
pretty much the worst thing possible thing to do in most cases: 
while it's "perfectly balanced" in the sense of distributing 
cycles evenly between CPUs, each interrupt handler execution 
will generate an avalance of cachemisses, for cachelines there 
were modified in the previous invocation of the irq.

One notable exception is when the CPUs are SMT/Hyperthreading 
siblings, in that case they are sharing even the L1 cache, so 
there's very little cost to round-robining the IRQs within the 
CPU mask.

But AFAICS irqbalanced will spread irqs on wider masks than SMT 
sibling boundaries, exposing us to the above performance 
problem.

So I think we need to tread carefully here.

Thanks,

	Ingo
