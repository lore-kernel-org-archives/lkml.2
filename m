Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab2DFWkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 18:40:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:40421 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2DFWki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 18:40:38 -0400
Date: Sat, 7 Apr 2012 00:40:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Slaby <jslaby@suse.cz>
cc: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Slaby <jirislaby@gmail.com>,
        Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, daniel@ffwll.ch
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared [generic IRQ
 handling broken?]
In-Reply-To: <4F7F60BF.9070500@suse.cz>
Message-ID: <alpine.LFD.2.02.1204062343050.2542@ionos>
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz> <4F758400.3080907@suse.cz> <1333104359_155028@CP5-2952> <4F75A303.3030409@suse.cz> <1333110296_156038@CP5-2952> <4F7F60BF.9070500@suse.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Jiri Slaby wrote:

> On 03/30/2012 02:24 PM, Chris Wilson wrote:
> > On Fri, 30 Mar 2012 14:11:47 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
> >> On 03/30/2012 12:45 PM, Chris Wilson wrote:
> >>> On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
> >>>> I don't know what to dump more, because iir is obviously zero too. What
> >>>> other sources of interrupts are on the (G33) chip?
> >>>
> >>> IIR is the master interrupt, with chained secondary interrupt statuses.
> >>> If IIR is 0, the interrupt wasn't raised by the GPU.
> >>
> >> This does not make sense, the handler does something different. Even if
> >> IIR is 0, it still takes a look at pipe stats.
> > 
> > That was introduced in 05eff845a28499762075d3a72e238a31f4d2407c to close
> > a race where the pipestat triggered an interrupt after we processed the
> > secondary registers and before reseting the primary.
> > 
> > But the basic premise that we should only enter the interrupt handler
> > with IIR!=0 holds (presuming non-shared interrupt lines such as MSI).
> 
> Ok, this behavior is definitely new. I get several "nobody cared" about
> this interrupt a week. This never used to happen. And something weird
> emerges in /proc/interrupts when this happens:
>  42:    1003292    1212890   PCI-MSI-edge      ???s????????????:0000:00:02.0
> instead of
>  42:    1006715    1218472   PCI-MSI-edge      i915@pci:0000:00:02.0
> 
> It very looks like the generic IRQ handling code is broken. Like it
> frees/corrupts irq_desc and ...

OMG, your problem analyzing skills are amazing.

If irq_desc would have been freed, then it wouldn't print the numbers
and the irq type. And irq_desc is not corrupted either, otherwise the
whole thing would explode in your face.

The printout of the name is done via action->name. The irq action
merily holds a pointer to the device name string, which is handed over
with request_irq. So you are saying that the core code corrupts the
memory which was handed in via a pointer by the driver?

So now that's really an amazing core feature:

It corrupts the memory with weird characters and still maintains the
PCI bus number correct. So it not only corrupts memory it also moves
the PCI part of the string a few characters to the end.

If the pointer in the irq action would have been corrupted, then you
would see a few weird characters and then the full string, not a
random thing which is half correct and shifted by a few bytes.

The pointer which is handed in is dev->devname, which gets allocated
and filled in drm_pci_set_busid().

> ... then as well calls random handlers.

Which random handlers would be called? The core code only calls
handlers which are associated to an particular interrupt. And only
when that particular interrupt is raised and not because the CPU pulls
interrupt events out of thin air.

And it calls the stupid i915 handler and not something else, otherwise
you would not observe the IIR=0 printk or whatever you put there for
debugging.

> Suspend/resume cycle helps in this case and "i915@pci:0000:00:02.0" is
> back in /proc/interrupts as can be seen above.

That's proving what? That the irq core code magically restores the
correct string, right? And probably it stops calling random handlers
as well. Brilliant deduction.

You know what? suspend calls free_irq() via i915_drm_freeze() ->
drm_irq_uninstall() and the resume code calls request_irq() again.
free_irq() removes the action and request_irq installs it fresh.

So now the interesting part is that free_irq() checks the dev_id
cookie for a match, which is also stored in the irq action. So we are
dealing with a magic corrupt only action->name and action->handler
problem. Pretty realistic.

What the heck makes you assume that the irq core code is broken?  Core
code, which works on a gazillion of machines and different device
drivers and does not corrupt anything except that i915 thingy?

Come on, you need to provide better evidence than weird ass guessing.

If you're still convinced that the irq core is messing with your
device string, then simply hand in a NULL pointer when requesting the
interrupt. That will make the core code explode nicely when it tries
to modify that memory.

Thanks,

	tglx
