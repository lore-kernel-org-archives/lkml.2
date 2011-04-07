Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab1DGUav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 16:30:51 -0400
Received: from 8bytes.org ([88.198.83.132]:40443 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909Ab1DGUau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 16:30:50 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Apr 2011 16:30:50 EDT
Date: Thu, 7 Apr 2011 22:22:49 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, "Xu, Andiry" <Andiry.Xu@amd.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110407202249.GD19819@8bytes.org>
References: <20110407130008.GX23633@amd.com> <Pine.LNX.4.44L0.1104071050270.2147-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104071050270.2147-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 11:01:02AM -0400, Alan Stern wrote:
> On Thu, 7 Apr 2011, Roedel, Joerg wrote:
> 
> > So we could access the data structure without any locks if we want using
> > atomic_t for the probe_count and isoc_reqs members. But as I've seen
> > meanwhile the lock still needs to protect the access to the hardware in
> > the usb_amd_quirk_pll() function.
> > So its probably not worth the work, what do you think?
> 
> You might as well use the spinlock.

Yes, since we need it anyway for protecting the hardware-access we can
leave everything as is (with the fix).

> However, is there a good reason to zero out the amd_chipset members in
> usb_amd_dev_put()?  Can these things be added and removed dynamically?  
> If they can't then the data should remain valid indefinitely once it
> has been probed, and you could call pci_dev_put() at the end of
> usb_amd_find_chipset_info().

Well, in a real system it is indeed very unlikely that the chipset is
hotplugged. But for formal correctness it is right to hold a reference
to the pci_dev struct as long as we rely on a pointer to it.

> And if they can, is it valid to call pci_dev_put() in usb_amd_dev_put()  
> while holding a spinlock?  You might want to move those calls to the
> end of the function.

I just had a look, pci_dev_put seems to be invalid in atomic context
too.  If the reference count drops to 0 (which is very unlikely for the
chipset devices) the device and its kobject are released. This causes a
uevent to be sent to userspace which does GFP_KERNEL allocations and all
the stuff.
So for formal correctness the pci_dev_put calls need to be moved out of
the spinlock too.

Regards,

	Joerg

