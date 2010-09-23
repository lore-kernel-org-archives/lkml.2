Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0IWSgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:36:48 -0400
Received: from www.tglx.de ([62.245.132.106]:60908 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0IWSgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:36:47 -0400
Date: Thu, 23 Sep 2010 20:36:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arthur Kepner <akepner@sgi.com>
cc: linux-kernel@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [RFC/PATCHv2] kernel/irq: allow more precise irq affinity
 policies
In-Reply-To: <alpine.LFD.2.00.1009230908080.2416@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1009232015180.2416@localhost6.localdomain6>
References: <20100922235208.GC19058@sgi.com> <alpine.LFD.2.00.1009230908080.2416@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, Thomas Gleixner wrote:

> On Wed, 22 Sep 2010, Arthur Kepner wrote:
> 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index cea0cd9..8fa7f52 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -313,6 +313,17 @@ config NUMA_IRQ_DESC
> >  	def_bool y
> >  	depends on SPARSE_IRQ && NUMA
> >  
> > +config IRQ_POLICY_NUMA
> > +	bool "Assign default interrupt affinities in a NUMA-friendly way"
> > +	def_bool y
> > +	depends on SPARSE_IRQ && NUMA
> > +	---help---
> > +	   When a device requests an interrupt, the default CPU used to
> > +	   service the interrupt will be selected from a node 'near by'
> > +	   the device. Also, interrupt affinities will be spread around
> > +	   the node so as to prevent any single CPU from running out of
> > +	   interrupt vectors.
> > +

I thought more about this and came to the conclusion that this
facility is completely overengineered and mostly useless except for a
little detail.

The only problem which it solves is to prevent that we run out of
vectors on the low numbered cpus when that NIC which insists to create
one irq per cpu starts up.

Fine, I can see that this is a problem, but we do not need this
complete nightmare to solve it. We can do that way simpler.

 1) There is a patch from your coworker to work around that in the low
    level x86 code, which is probably working, but suboptimal and not
    generic

 2) We already know that the NIC requested the irq on node N. So when
    we set it up, we just honour the wish of the driver as long as it
    fits in the default (or modified) affinity mask and restrict the
    affinity to the cpus on that very node.

    That makes a whole lot of sense: The driver already knows on which
    cpus it wants to see the irq, because it allocated queues and
    stuff there.

    So that's probably a 10 lines or less patch do fix that.

So now to the whole other policy horror. That belongs to user space
and can be done in user space today. We do _NOT_ implement policies in
the kernel.

User space knows exactly how many irqs are affine to which cpu, knows
the topology and can do the balancing on its own.

So please go wild and put your nr_irqs * nr_irqs loop into some user
space program.

Thanks,

	tglx
