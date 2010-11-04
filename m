Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0KDPFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:05:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:34817 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab0KDPFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,296,1286175600"; 
   d="scan'208";a="854152488"
Date: Thu, 4 Nov 2010 11:03:52 -0400
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: dsterba@suse.cz, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andiry Xu <andiry.xu@amd.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: xhci: Use GFP_ATOMIC under spin_lock
Message-ID: <20101104150352.GD2968@xanatos>
References: <20101102224718.GB27513@ds.suse.cz>
 <4CD11AF7.309@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD11AF7.309@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 09:19:03AM +0100, Jiri Slaby wrote:
> On 11/02/2010 11:47 PM, David Sterba wrote:
> > coccinelle check scripts/coccinelle/locks/call_kern.cocci found that
> > in drivers/usb/host/xhci.c an allocation with GFP_KERNEL is done
> > with locks held:
> > 
> > xhci_resume
> >   spin_lock_irq(xhci->lock)
> >     xhci_setup_msix
> >       kmalloc(GFP_KERNEL)
> > 
> > Change it to GFP_ATOMIC.
> 
> Hi, I already reported that [1] and this is not enough. There are other
> sleepy calls like request_irq inside...
> 
> [1] http://lkml.org/lkml/2010/10/23/17

Andiry is looking into this.  Andiry, perhaps you don't need to take the
xHCI spinlock in xhci_resume()?  If that function is being called
because the PCI device is being resumed, you know nothing else is going
to touch the xHCI host controller.  (Except maybe the BIOS, but it isn't
going to respect xhci->lock at all.)  The USB core certainly won't touch
the host controller until it's resumed.  Maybe we could get an interrupt
with a port status change, but I think it's unlikely...

Alan, can you think of any reason the xHCI driver would need to grab its
host controller spinlock on PCI resume?

Sarah Sharp
