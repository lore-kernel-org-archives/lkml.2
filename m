Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0KKMDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:03:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:34329 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab0KKMDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:03:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,182,1288594800"; 
   d="scan'208";a="676493726"
Date: Thu, 11 Nov 2010 11:42:44 +0000
From: Alan Cox <alan@linux.intel.com>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, "Ben Dooks" <ben-linux@fluff.org>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Mike Frysinger" <vapier@gentoo.org>,
        "Feng Tang" <feng.tang@intel.com>,
        "Tobias Klauser" <tklauser@distanz.ch>,
        "LKML" <linux-kernel@vger.kernel.org>, <yong.y.wang@intel.com>,
        <qi.wang@intel.com>, <kok.howg.ewe@intel.com>,
        <andrew.chih.howe.khor@intel.com>
Subject: Re: [PATCH] EG20T: Update PCH_UART driver to 2.6.36
Message-ID: <20101111114244.6250ab48@linux.intel.com>
In-Reply-To: <000901cb816e$22528490$66f8800a@maildom.okisemi.com>
References: <4CD8D5A2.1080202@dsn.okisemi.com>
	<20101109103737.40bfab7b@linux.intel.com>
	<000901cb816e$22528490$66f8800a@maildom.okisemi.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +#ifdef CONFIG_PCH_DMA
> > > + #include <linux/dmaengine.h>
> > > + #include <linux/pch_dma.h>
> > > +#endif
> > 
> > The PCH DMA will have been included in the kernel anyway before this
> > merge so you can remove the ifdefs and include it regardless
> 
> No.
> PCH DMA have been already included at 2.6.36.
> You can see "pch_dma.c" in drivers/dma.

So that means pch_dma is always in the kernel source tree as of 2.6.36
- so the ifdef can go away ?

> > tty = tty_port_tty_get(...)
> > 
> > and when finished tty_kref_put(tty);
> > 
> > Also tty may be NULL, if the port closed as you were doing this, so
> > check the return from tty_port_tty_get and act accordingly.
> 
> I have a question.
> Though I can't find any accepted UART driver uses these
> functions(tty_port.../tty_kref...), What's for ?

We are gradually going through converting them all and I'm trying to
make sure no new ones creep in that don't use tty_port_tty_get.

Basically it does this

	tty_port_tty_get()

will return either a tty pointer with a reference (ie the tty will not
be deleted while you hold it), or will return NULL if the physical port
is no longer connected to a tty through close/hangup. It does all the
locking internally to ensure this is done safely.

	tty_kref_put()

drops the reference it obtained and after that point if the tty
reference count hits zero it may be deleted.

It ensures this cannot occur

		CPU1			CPU2

interrupt:
	tty = port->port.tty
					close
					port->port.tty = NULL
					kfree tty
	write to tty



> Many UART drivers accepted by upstream use the above macro, right ?

As far as possible the selection should be done at runtime, especially
for PC class devices. Linux distributors want to build a single kernel
for everything so having it runtime configured helps a lot.


> > If you don't support CPARMRK then you should clear that bit in
> > termios->c_flag so the caller knows it couldn't be set.
> 
> Sorry, I don't know CPARMRK.
> What's CPARMRK ?

Sorry my fault. I mean CMSPAR

CMSPAR if set selects mark/space parity. If your hardware doesn't
support this then do

	termios->c_cflag &= ~CMSPAR;


> I will use dma_alloc_coherent.
> 
> > 
> > I assume the correct device in this case would be the DMA
> > controller ?
> 
> Sorry, I can't understand your saying "correct device".
> What does "correct device" mean ?

dma_alloc_coherent takes a device pointer which should be the device
which is doing the DMA.

> Do you mean UART Rx/Tx interrupt Enable/Disable ?
> If yes, the control hava been already implemented.
> For example, in handle_tx (called from IRQ handler),
> you can see pch_uart_hal_disable_interrupt().

I will take another look next time the patch is submitted. However if
you are relying on disabling an IRQ source to avoid the interrupt
running in parallel with another routine remember on a multithreaded
CPU and on some hardware that it is possible for this to occur


		CPU1			CPU2
	Interrupt arrives
					Disable interrupt
	Interrupt routine runs		Other code runs


Alan
