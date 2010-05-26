Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab0EZB5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:57:42 -0400
Received: from king.tilera.com ([72.1.168.226]:1177 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933412Ab0EZB5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:57:40 -0400
Message-ID: <4BFC800D.2090309@tilera.com>
Date: Tue, 25 May 2010 21:57:33 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <alpine.LFD.2.00.1005252129441.2948@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005252129441.2948@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2010 01:57:39.0724 (UTC) FILETIME=[D24024C0:01CAFC76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, thanks for your feedback.  If I don't comment on something you
said it's because you were obviously right and I applied a suitable fix. :-)

On 5/25/2010 4:12 PM, Thomas Gleixner wrote:
> +/**
> + * tile_request_irq() - Allocate an interrupt handling instance.
> [...]
>
>   Why are you implementing your private interrupt handling
>   infrastructure ? What's wrong with the generic interrupt handling
>   code ? Why is each device driver forced to call tile_request_irq()
>   which makes it incompatible to the rest of the kernel and therefor
>   unshareable ?
>   

Our interrupt management code has evolved as we have developed this
code, so I won't present arguments as to why it's perfect the way it is,
but just why it IS the way it is.  :-)

The tile irq.c does not replace the generic Linux IRQ management code,
but instead provides a very limited set of virtual interrupts that are
only used by our para-virtualized device drivers, and delivered to Linux
via a single hypervisor downcall that atomically sets "virtual
interrupt" bits in a bitmask.  The PCI root complex driver reserves four
of these bits (i.e. irqs) to map real PCI interrupts; they are then fed
forward into the regular Linux IRQ system to manage all "standard"
devices.  The other tile-specific para-virtualized drivers that use this
interface are the PCI endpoint code, xgbe network driver, ATA-over-GPIO
driver, and the IPI layer.  None of these para-virtualized drivers are
actually shareable with other Linux architectures in any case.

We have an outstanding enhancement request in our bug tracking system to
switch to using the Linux generic IRQs directly, and plan to implement
it prior to our next major release.  But we haven't done it yet, and
this code, though somewhat crufty, is reasonably stable.  I'm also not
the primary maintainer of this particular piece of code, so I'd rather
wait until that person frees up and have him do it, instead of trying to
hack it myself.

In any case, I'll add commentary material (probably just an edited
version of the explanatory paragraph above) into irq.c so at least it's
clear what's going on.

> +void tile_free_irq(int index)
> +[...]
>
>   That code lacks any kind of protection and serialization.
>   

Interesting point.  As it happens, these calls are all made during boot,
so they are serialized that way.  But in principle we could use the xgbe
driver as a module, at least, so you're right; I'll add a spinlock.

> [...]
>
>   You check desc->handler, but you happily call the handler while
>   dev_id might be still NULL. See above.
>   

Assuming we spinlock the irq request/free routines, I think this is
safe, since the unlock memory fence will guarantee visibility of the
fields prior to any attempt to use them.  We always allocate the
interrupt, then tell the hypervisor to start delivering them; on device
unload we tell the hypervisor to stop delivering interrupts, then free
it.  The "tell the hypervisor" steps use on_each_cpu() and wait, so are
fully synchronous.

> +/*
> + * Generic, controller-independent functions:
> + */
> +
> +int show_interrupts(struct seq_file *p, void *v)
> +[...]
>
>   So that prints which interrupts ? Now you refer to the generic code,
>   while above you require that tile specific one. -ENOSENSE.
>   

Yes, this is confusing.  This routine is required by procfs, and it
shows just the PCI interrupts, not the tile irqs.  I'll add a comment,
and try to segregate the file into "generic irqs" and "tile irqs" more
obviously, for now.  The routine itself will be more sensible once we
integrate our tile_irqs into the generic system.

> +/* How many cycles per second we are running at. */
> +static cycles_t cycles_per_sec __write_once;
> +static u32 cyc2ns_mult __write_once;
> +#define cyc2ns_shift 30
>
>   Please do not use fixed shift values. Use the generic functions to
>   calculate the optimal shift/mult pairs instead. 
>   

Thanks; I wasn't aware of these.  I'll switch the code over to use them,
and the other helper functions you pointed out.

> +#if CHIP_HAS_SPLIT_CYCLE()
>
>   That should be a CONFIG_TILE_HAS_SPLIT_CYCLE and not a function like
>   macro define somewhere in a header file.
>   

This is not a configurable option.  The <arch/chip.h> header (which is
not a Linux header per-se, but one of our "core architecture" headers
that can be used in any programming context) provides a set of
CHIP_xxx() macros.  We use a functional macro style because we saw too
many instances of "#ifdef CHIP_FOO_MISSPELLED" where the misspelling
wasn't noticed until much later.

> +/*
> + * Provide support for effectively turning the timer interrupt on and
> + * off via the interrupt mask.  Make sure not to unmask it while we are
> + * running the timer interrupt handler, to avoid recursive timer
> + * interrupts; these may be OK in some cases, but it's generally cleaner
> + * to reset the kernel stack before starting the next timer interrupt.
>
>   Which would already be guaranteed by the generic interrupt code ....
>   The clockevent callbacks are already called with interrupts
>   disabled, so why all this magic ?
>   

The code was written so that it would be robust in the face of the timer
interrupt-path code potentially enabling interrupts, since I couldn't
convince myself it didn't.  I'll rip out all that code and replace it
with a couple of BUG() checks instead.  Thanks, that's a nice cleanup.

And thanks again for the feedback.  It's very helpful.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


