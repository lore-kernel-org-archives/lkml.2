Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab1EDESm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 00:18:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab1EDESl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 00:18:41 -0400
Subject: Re: [PATCH 2/2] drm/nouveau: Check that the device is enabled
 before processing interrupt
From: Alex Williamson <alex.williamson@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi==E4wgRDY3DCDejAZtVvOGjOtbgA@mail.gmail.com>
References: <20110502004806.2307.34136.stgit@ul30vt.home>
	 <20110502004940.2307.71738.stgit@ul30vt.home>
	 <BANLkTi==E4wgRDY3DCDejAZtVvOGjOtbgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 22:18:32 -0600
Message-ID: <1304482712.3255.135.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 13:50 +1000, Dave Airlie wrote:
> On Mon, May 2, 2011 at 10:49 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > We're likely to be sharing an interrupt line with other devices,
> > which means our handler might get called after we've turned off
> > the device via vga switcheroo.  This can lead to all sorts of
> > badness, like nv04_fifo_isr() spewing "PFIFO still angry after
> > 100 spins, halt" to the console before the system enters a hard
> > hang.
> >
> > We can avoid this by simply checking if the device is still
> > enabled before processing an interrupt.  To avoid races, flush
> > any inflight interrupts using synchronize_irq().  Note that
> > since pci_intx() is called after pci_save_state(),
> > pci_restore_state() will automatically re-enable INTx.
> 
> I still think we should just need the synchronize_irq followed by a
> check in the irq handler for all fs,
> 
> or is there a race there I'm missing?

The synchronize_irq by itself doesn't guarantee anything.  The irq
handler could be immediately started on another CPU once that returns
and be well past the first device read before we make it far enough
through pci_set_power_state that the device becomes unresponsive.  Can
we guarantee that first device read in the interrupt handler will always
be 0 or -1 in the suspend path?  Even as the last milliamperes of charge
drain out of the device?

By adding the device enabled check in the interrupt handler, disabling
the device, then calling synchronize_irq, we guarantee that the entire
interrupt handler path is not being executed and won't be executed again
until we re-enable the device.  It does seem a bit odd, but how many
other devices in the system are entirely powered off, with a driver
attached and interrupt handler registered while the system is still
humming along?  Thanks,

Alex

