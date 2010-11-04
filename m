Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0KDPJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:09:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41236 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751291Ab0KDPJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:09:32 -0400
Date: Thu, 4 Nov 2010 11:09:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Jiri Slaby <jslaby@suse.cz>, <dsterba@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andiry Xu <andiry.xu@amd.com>
Subject: Re: [PATCH] USB: xhci: Use GFP_ATOMIC under spin_lock
In-Reply-To: <20101104150352.GD2968@xanatos>
Message-ID: <Pine.LNX.4.44L0.1011041106570.2522-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Sarah Sharp wrote:

> On Wed, Nov 03, 2010 at 09:19:03AM +0100, Jiri Slaby wrote:
> > On 11/02/2010 11:47 PM, David Sterba wrote:
> > > coccinelle check scripts/coccinelle/locks/call_kern.cocci found that
> > > in drivers/usb/host/xhci.c an allocation with GFP_KERNEL is done
> > > with locks held:
> > > 
> > > xhci_resume
> > >   spin_lock_irq(xhci->lock)
> > >     xhci_setup_msix
> > >       kmalloc(GFP_KERNEL)
> > > 
> > > Change it to GFP_ATOMIC.
> > 
> > Hi, I already reported that [1] and this is not enough. There are other
> > sleepy calls like request_irq inside...
> > 
> > [1] http://lkml.org/lkml/2010/10/23/17
> 
> Andiry is looking into this.  Andiry, perhaps you don't need to take the
> xHCI spinlock in xhci_resume()?  If that function is being called
> because the PCI device is being resumed, you know nothing else is going
> to touch the xHCI host controller.  (Except maybe the BIOS, but it isn't
> going to respect xhci->lock at all.)  The USB core certainly won't touch
> the host controller until it's resumed.  Maybe we could get an interrupt
> with a port status change, but I think it's unlikely...
> 
> Alan, can you think of any reason the xHCI driver would need to grab its
> host controller spinlock on PCI resume?

Maybe an interrupt isn't as unlikely as all that.  To be safe you 
should acquire the spinlock.  The real question is why these other 
routines are performing actions that could block in a path that holds 
the lock.  Maybe the spinlock should be acquired _after_ doing the 
potentially-blocking operations.

Alan Stern

