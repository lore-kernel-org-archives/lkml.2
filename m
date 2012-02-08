Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2BHB3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 20:29:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:62585 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261Ab2BHB3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 20:29:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104321125"
Subject: Re: [PATCH] usb: enable pci MSI/MSIX in usb core
From: "Alex,Shi" <alex.shi@intel.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: stern@rowland.harvard.edu, Greg KH <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, andiry.xu@amd.com,
        linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Takashi Iwai <tiwai@suse.de>, trenn@suse.de, linux-pci@vger.kernel.org,
        Michal Marek <MMarek@suse.com>
In-Reply-To: <20120207221317.GA6103@xanatos>
References: <1328531341-22705-1-git-send-email-alex.shi@intel.com>
	 <4F311233.9070404@intel.com> <20120207144204.GA7214@kroah.com>
	 <20120207172743.GA4780@xanatos>  <20120207221317.GA6103@xanatos>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Feb 2012 09:26:32 +0800
Message-ID: <1328664392.12669.233.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 14:13 -0800, Sarah Sharp wrote:
> On Tue, Feb 07, 2012 at 09:27:43AM -0800, Sarah Sharp wrote:
> > I'm trying to track down an oops on my for-usb-linus queue that could
> > either be related to Alex's original MSI work around patch, or the patch
> > Oliver posted for working around PCI MMIO not being enabled fast enough.
> > I don't want to review this MSI improvement patch until I'm sure the
> > original MSI work around patch is stable.
> > 
> > Alex, please give me time to debug bug fixes for 3.3 before pushing on
> > features for 3.4.
> 
> Alex, your original MSI enabling patch simply does not work.  The xHCI
> PCI driver was marked as const and the xHCI PCI probe function oopsed as
> soon as it tried to add HCD_MSI_FIRST to driver->flags.  Please test all
> the patches in your patchsets individually to make sure they don't cause
> bugs, as this will break git-bisect.  It's especially troublesome to not
> test a patch I've said will be needed for stable, since we really try
> not to break stable. </grumpy maintainer rant>

I am sorry for bring trouble on the patch. 
But all my patches were tested with possible USB3 HCD in our site,
include a NEC device and the BIOS broken Intel panther point HCD.

[    3.772513] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[    3.772515] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
[    3.772552] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    3.772593] xhci_hcd 0000:00:14.0: irq 45 for MSI/MSI-X
[    3.772602] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.772639] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 1

Maybe some kernel configuration related with this oops? 

> 
> The oops brings up an interesting point.  I think the reason the xHCI
> PCI driver structure is marked as const is because it's shared across
> all xHCI hosts in the system.  Even if you remove the const keyword, you
> could be modifying the flags while another xHCI host controller is being
> initialized.
> 
> I think PCI probe isn't run in parallel, but you could still have the
> case where the Intel Panther Point xHCI PCI probe runs first,
> HCD_MSI_FIRST gets added to the hcd driver flags, and then the PCI probe
> runs for a Fresco Logic add-in card that doesn't handle MSI, and the USB
> core doesn't attempt to allocate the legacy IRQ because HCD_MSI_FIRST is
> set.  Then the Fresco Logic host controller will be left with no
> interrupt.

Yes, you are right here.
So, the first patch naturally have this problem. But my latest patch:
enable MSI in usb-core won't the problem. Because it direct skip the
Fresco Card for MSI, not get help from flags. 

So, let's drop the previous 2 patches and using this latest one? 
> 
> 
> Alan, is the hc_driver structure (xhci_pci_hc_driver) shared across all
> xHCI PCI hosts in the system?
> 
> Sarah Sharp


