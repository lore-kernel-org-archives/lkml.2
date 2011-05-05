Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1EEIhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:37:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:40959 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1EEIhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:37:13 -0400
Date: Thu, 5 May 2011 10:37:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Grant Likely <grant.likely@secretlab.ca>, Michal Simek <monstr@monstr.eu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/6] General device tree irq domain infrastructure
In-Reply-To: <1304555953.2513.390.camel@pasglop>
Message-ID: <alpine.LFD.2.02.1105051026370.3005@ionos>
References: <20110428192227.8979.49181.stgit@ponder>  <1304386999.2513.293.camel@pasglop>  <20110504155227.GA3317@ponder.secretlab.ca> <1304555953.2513.390.camel@pasglop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Benjamin Herrenschmidt wrote:
> > As for the mapping, I agree that the functionality is generally
> > useful, I'm just not fond of the current implementation.  I think it
> > is more complex than it needs to be and I'm not excited about bring it
> > over to the other architectures as-is.
>
> Nobody cares about the current implementation. What is important is
> indeed the functionality. The basic thing I think everybody agrees is
> that you need to extend the irq_desc (or data, whatever tglx prefers)
> with two bits of information: Some identifier of the domain and some
> identifier of the interrupt number within that domain.

irq_data because that's what is handed into the callbacks and you
probably want to have the HW number there.
 
> In addition, PIC code will need a way to perform efficient reverse
> mapping. You may decide that for simple IRQ controllers that handle a
> small linear range of interrupts, it's kosher to simply reserve a linear
> range of descriptors and use a simple offset, I'm find with that now
> that we no longer live in a world constrained by NR_IRQ.
> 
> But the need for the radix tree remains for things that have massively
> large potential HW numbers such as we have on powerpc.
> 
> > For the majority of fixed hw interrupt controllers it is overkill.
> > There is no need for a map table when all the irq descs (<=32 of them)
> > get allocated when the irq controller is instantiated and the mapping
> > consists of 'virq = hw_irq + virq_base'.  For instance, with the arm
> > irq controllers, it's be more than sufficient to use irq_alloc_descs
> > to obtain a range of irq numbers and then a simple of_irq_domain
> > registration to handle the parsing.
> 
> That's true if and only if you make NR_IRQ a non issue and if you accept
> the general wastage due to unused interrupts.
> 
> The main problem has always been that hard limit which made me chose a
> more efficient mechanisms. Take a mac with 2 cascaded MPICs with 256
> sources each which are mostly never used. I would need an NR_IRQs of 512
> with your scheme (plus 16 because I do want to continue avoiding the
> "ISA" numbers), which is a waste of space, even with SPARSE_IRQ.
> 
> Now I hope eventually NR_IRQ will go away and we'll have a more
> efficient mechanism to allocate descriptors and so it will become less
> of an issue.

Well, NR_IRQS in the sparse case is irrelevant already and I'm looking
into a way to remove the !SPARSE code completely.

One thing we can do to avoid allocating 512 irq descriptors for the
MAC case is to reserve the space and only allocate the descriptors you
really need to be operational.

> > For the cases where an interrupt controller isn't able to alloc all
> > the irq descs at once, like for MSI, then yes the LINEAR and RADIX
> > mappings are important.  What bothers me though is the way irq_host
> > needs to use unions and the ->revmap_type value to implement multiple
> > behaviours into a single type.  That's the sort of thing that can be
> > broken out into a library and instantiated only by the interrupt
> > controllers that actually need it.
> 
> But that's what it is really. You'll notice that on the fast path the
> interrupt controller code calls directly into the "right" type of revmap
> routine. You may want to refactor things a bit if you want, but the
> union served me well simply because I didnt have to bother doing lots of
> different alloc_bootmem back then. Nowadays, kmalloc is available much
> earlier so it might have become a non issue too.
> 
> >   Similarly, it bothers me that that
> > radix mapping makes up a significant portion of the code, yet it has
> > only one user. 
> 
> "significant" ? Seriously ? Like 3 function calls ? It's nothing. We use
> an existing radix tree facility, and the amount of code in our irq.c is
> actually very small.
> 
> Originally it was living in xics in fact, but I moved it out
> specifically because I wanted a common interface to remapping, so for
> example, I can expose the linux -> hw mapping in debugfs generically,
> among others.

And there is another reverse mapping implementation in the superH
code.

> >  I'd be happier if each kind of mapping had its own
> > structure that embedded a generic irq_host/irq_domain with mapping
> > specific ops populated to manipulate it.
> 
> Whatever, that's just plumbing, I don't care either way, that doesn't
> change the fact that the concept of domain doesn't have much to do with
> OF :-)
> 
> > Regardless, the immediate priority is to implement a mapper that will
> > work for all architectures (or at least everything but powerpc and
> > sparc).
> 
> I oppose the implementation of a new mapper that doesn't include
> powerpc, that would be stupid. Either re-use ours or implement a new one
> that encompass our needs. I can't talk for sparc but I wouldn't be
> surprised if David thought about the same lines.
> 
> >   x86 has already implemented a skeleton irq_domain because
> > there wasn't any common code for it to use.  ARM also needs the
> > functionality immediately, and I don't want to see yet another
> > arch-specific implementation.  I'd like to get the framework in place
> > now, and grafting in mapping features as follow on patches.  That way
> > the new DT users aren't blocked while waiting for us to hammer down
> > the features that the other architectures don't need yet.
> 
> But the mapping code exist already. It returns a device-node as the
> interrupt controller. What you then need is to establish the
> relationship between that device-node and a domain in linux, and have
> code to decode the content of the interrupts property.
> 
> So you need the concept of domain first, generic, and -then- you can
> start adding a way to bind it to OF.

Ack.
 
Thanks,

	tglx
