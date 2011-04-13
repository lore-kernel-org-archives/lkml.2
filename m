Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1DMOoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:44:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35941 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756367Ab1DMOoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:44:18 -0400
Date: Wed, 13 Apr 2011 10:44:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
cc: Sergei Shtylyov <sshtylyov@mvista.com>, Borislav Petkov <bp@alien8.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7] USB host: Fix lockdep warning in AMD PLL quirk
In-Reply-To: <20110413063816.GG20607@amd.com>
Message-ID: <Pine.LNX.4.44L0.1104131043490.2005-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011, Roedel, Joerg wrote:

> On Tue, Apr 12, 2011 at 06:59:27AM -0400, Sergei Shtylyov wrote:
> > On 12-04-2011 10:41, Roedel, Joerg wrote:
> 
> > > +	if (nb)
> > > +		pci_dev_put(nb);
> > > +	if (smbus)
> > > +		pci_dev_put(amd_chipset.smbus_dev);
> > 
> >     Here it is. This pointer is NULL, it should be 'smbus' instead.
> 
> Ok, this is fixed now too.
> 
> From 7ee4b6274f5e4c1f238e9ff4faa0b9a43f5203e2 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Wed, 6 Apr 2011 13:07:53 +0200
> Subject: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
> 
> Booting latest kernel on my test machine produces a lockdep
> warning from the usb_amd_find_chipset_info() function:
> 
>  WARNING: at /data/lemmy/linux.trees.git/kernel/lockdep.c:2465 lockdep_trace_alloc+0x95/0xc2()
>  Hardware name: Snook
>  Modules linked in:
>  Pid: 959, comm: work_for_cpu Not tainted 2.6.39-rc2+ #22
>  Call Trace:
>   [<ffffffff8103c0d4>] warn_slowpath_common+0x80/0x98
>   [<ffffffff812387e6>] ? T.492+0x24/0x26
>   [<ffffffff8103c101>] warn_slowpath_null+0x15/0x17
>   [<ffffffff81068667>] lockdep_trace_alloc+0x95/0xc2
>   [<ffffffff810ed9ac>] slab_pre_alloc_hook+0x18/0x3b
>   [<ffffffff810ef227>] kmem_cache_alloc_trace+0x25/0xba
>   [<ffffffff812387e6>] T.492+0x24/0x26
>   [<ffffffff81238816>] pci_get_subsys+0x2e/0x73
>   [<ffffffff8123886c>] pci_get_device+0x11/0x13
>   [<ffffffff814082a9>] usb_amd_find_chipset_info+0x3f/0x18a
> ...
> 
> It turns out that this function calls pci_get_device under a spin_lock
> with irqs disabled, but the pci_get_device function is only allowed in
> preemptible context.
> 
> This patch fixes the warning by making all data-structure
> modifications on temporal storage and commiting this back
> into the visible structure at the end. While at it, this
> patch also moves the pci_dev_put calls out of the spinlocks
> because this function might sleep too.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

