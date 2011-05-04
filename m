Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab1EDEWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 00:22:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab1EDEWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 00:22:34 -0400
Subject: Re: [PATCH 2/2] drm/nouveau: Check that the device is enabled
 before processing interrupt
From: Dave Airlie <airlied@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <1304482712.3255.135.camel@x201>
References: <20110502004806.2307.34136.stgit@ul30vt.home>
	 <20110502004940.2307.71738.stgit@ul30vt.home>
	 <BANLkTi==E4wgRDY3DCDejAZtVvOGjOtbgA@mail.gmail.com>
	 <1304482712.3255.135.camel@x201>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 14:22:30 +1000
Message-ID: <1304482950.3676.24.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 22:18 -0600, Alex Williamson wrote:
> On Wed, 2011-05-04 at 13:50 +1000, Dave Airlie wrote:
> > On Mon, May 2, 2011 at 10:49 AM, Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > > We're likely to be sharing an interrupt line with other devices,
> > > which means our handler might get called after we've turned off
> > > the device via vga switcheroo.  This can lead to all sorts of
> > > badness, like nv04_fifo_isr() spewing "PFIFO still angry after
> > > 100 spins, halt" to the console before the system enters a hard
> > > hang.
> > >
> > > We can avoid this by simply checking if the device is still
> > > enabled before processing an interrupt.  To avoid races, flush
> > > any inflight interrupts using synchronize_irq().  Note that
> > > since pci_intx() is called after pci_save_state(),
> > > pci_restore_state() will automatically re-enable INTx.
> > 
> > I still think we should just need the synchronize_irq followed by a
> > check in the irq handler for all fs,
> > 
> > or is there a race there I'm missing?
> 
> The synchronize_irq by itself doesn't guarantee anything.  The irq
> handler could be immediately started on another CPU once that returns
> and be well past the first device read before we make it far enough
> through pci_set_power_state that the device becomes unresponsive.  Can
> we guarantee that first device read in the interrupt handler will always
> be 0 or -1 in the suspend path?  Even as the last milliamperes of charge
> drain out of the device?

It should always be a valid irq or 0xffffffff. It got nothing to do with
milliamperes of charge, and all to do with the PCI BAR decodes being
turned off.

> By adding the device enabled check in the interrupt handler, disabling
> the device, then calling synchronize_irq, we guarantee that the entire
> interrupt handler path is not being executed and won't be executed again
> until we re-enable the device.  It does seem a bit odd, but how many
> other devices in the system are entirely powered off, with a driver
> attached and interrupt handler registered while the system is still
> humming along?  Thanks,

The theory is lots. OLPC does this sort of things for its breakfast I'd
have thought.

which is why I still think we are missing something, when we D3 the
device it should be the same as suspend/resume cycle pretty much,

I'll have to think about it a bit more and maybe see what PM guys can
tell us.

mjg59 any clues?

Dave.

