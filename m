Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0EZOGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:06:24 -0400
Received: from www.tglx.de ([62.245.132.106]:44924 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab0EZOGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:06:23 -0400
Date: Wed, 26 May 2010 16:05:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: arch/tile
Message-ID: <alpine.LFD.2.00.1005261601530.2995@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, 25 May 2010, Chris Metcalf wrote:

> Thomas, thanks for your feedback.  If I don't comment on something you
> said it's because you were obviously right and I applied a suitable fix. :-)
> 
> On 5/25/2010 4:12 PM, Thomas Gleixner wrote:
> > +/**
> > + * tile_request_irq() - Allocate an interrupt handling instance.
> > [...]
> >
> >   Why are you implementing your private interrupt handling
> >   infrastructure ? What's wrong with the generic interrupt handling
> >   code ? Why is each device driver forced to call tile_request_irq()
> >   which makes it incompatible to the rest of the kernel and therefor
> >   unshareable ?
> >   
> 
> Our interrupt management code has evolved as we have developed this
> code, so I won't present arguments as to why it's perfect the way it is,
> but just why it IS the way it is.  :-)
> 
> The tile irq.c does not replace the generic Linux IRQ management code,
> but instead provides a very limited set of virtual interrupts that are
> only used by our para-virtualized device drivers, and delivered to Linux
> via a single hypervisor downcall that atomically sets "virtual
> interrupt" bits in a bitmask.  The PCI root complex driver reserves four
> of these bits (i.e. irqs) to map real PCI interrupts; they are then fed
> forward into the regular Linux IRQ system to manage all "standard"
> devices.  The other tile-specific para-virtualized drivers that use this
> interface are the PCI endpoint code, xgbe network driver, ATA-over-GPIO
> driver, and the IPI layer.  None of these para-virtualized drivers are
> actually shareable with other Linux architectures in any case.

  Ok, still ...
 
> We have an outstanding enhancement request in our bug tracking system to
> switch to using the Linux generic IRQs directly, and plan to implement
> it prior to our next major release.  But we haven't done it yet, and
> this code, though somewhat crufty, is reasonably stable.  I'm also not
> the primary maintainer of this particular piece of code, so I'd rather
> wait until that person frees up and have him do it, instead of trying to
> hack it myself.

  It should be rather straight forward and can be efficiently done
  with the handle_simple_irq() handler AFAICS. So I'd prefer to see
  that fixed befor the code gets merged.
 
> >   You check desc->handler, but you happily call the handler while
> >   dev_id might be still NULL. See above.
> >   
> 
> Assuming we spinlock the irq request/free routines, I think this is
> safe, since the unlock memory fence will guarantee visibility of the
> fields prior to any attempt to use them.  We always allocate the
> interrupt, then tell the hypervisor to start delivering them; on device
> unload we tell the hypervisor to stop delivering interrupts, then free
> it.  The "tell the hypervisor" steps use on_each_cpu() and wait, so are
> fully synchronous.

  Going to generic irq will solve all of that :)
 
> > +int show_interrupts(struct seq_file *p, void *v)
> > +[...]
> >
> >   So that prints which interrupts ? Now you refer to the generic code,
> >   while above you require that tile specific one. -ENOSENSE.
> >   
> 
> Yes, this is confusing.  This routine is required by procfs, and it
> shows just the PCI interrupts, not the tile irqs.  I'll add a comment,
> and try to segregate the file into "generic irqs" and "tile irqs" more
> obviously, for now.  The routine itself will be more sensible once we
> integrate our tile_irqs into the generic system.

  Ditto.
 
Thanks,

	tglx
