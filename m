Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab2BGWNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:13:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:63643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab2BGWNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:13:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="107488981"
Date: Tue, 7 Feb 2012 14:13:17 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>, stern@rowland.harvard.edu
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        andiry.xu@amd.com, linux-kernel@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, Takashi Iwai <tiwai@suse.de>,
        trenn@suse.de, linux-pci@vger.kernel.org,
        Michal Marek <MMarek@suse.com>
Subject: Re: [PATCH] usb: enable pci MSI/MSIX in usb core
Message-ID: <20120207221317.GA6103@xanatos>
References: <1328531341-22705-1-git-send-email-alex.shi@intel.com>
 <4F311233.9070404@intel.com>
 <20120207144204.GA7214@kroah.com>
 <20120207172743.GA4780@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207172743.GA4780@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 09:27:43AM -0800, Sarah Sharp wrote:
> I'm trying to track down an oops on my for-usb-linus queue that could
> either be related to Alex's original MSI work around patch, or the patch
> Oliver posted for working around PCI MMIO not being enabled fast enough.
> I don't want to review this MSI improvement patch until I'm sure the
> original MSI work around patch is stable.
> 
> Alex, please give me time to debug bug fixes for 3.3 before pushing on
> features for 3.4.

Alex, your original MSI enabling patch simply does not work.  The xHCI
PCI driver was marked as const and the xHCI PCI probe function oopsed as
soon as it tried to add HCD_MSI_FIRST to driver->flags.  Please test all
the patches in your patchsets individually to make sure they don't cause
bugs, as this will break git-bisect.  It's especially troublesome to not
test a patch I've said will be needed for stable, since we really try
not to break stable. </grumpy maintainer rant>

The oops brings up an interesting point.  I think the reason the xHCI
PCI driver structure is marked as const is because it's shared across
all xHCI hosts in the system.  Even if you remove the const keyword, you
could be modifying the flags while another xHCI host controller is being
initialized.

I think PCI probe isn't run in parallel, but you could still have the
case where the Intel Panther Point xHCI PCI probe runs first,
HCD_MSI_FIRST gets added to the hcd driver flags, and then the PCI probe
runs for a Fresco Logic add-in card that doesn't handle MSI, and the USB
core doesn't attempt to allocate the legacy IRQ because HCD_MSI_FIRST is
set.  Then the Fresco Logic host controller will be left with no
interrupt.


Alan, is the hc_driver structure (xhci_pci_hc_driver) shared across all
xHCI PCI hosts in the system?

Sarah Sharp
