Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1DGPBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:01:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47566 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754130Ab1DGPBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:01:04 -0400
Date: Thu, 7 Apr 2011 11:01:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
cc: "Xu, Andiry" <Andiry.Xu@amd.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
In-Reply-To: <20110407130008.GX23633@amd.com>
Message-ID: <Pine.LNX.4.44L0.1104071050270.2147-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011, Roedel, Joerg wrote:

> So we could access the data structure without any locks if we want using
> atomic_t for the probe_count and isoc_reqs members. But as I've seen
> meanwhile the lock still needs to protect the access to the hardware in
> the usb_amd_quirk_pll() function.
> So its probably not worth the work, what do you think?

You might as well use the spinlock.

However, is there a good reason to zero out the amd_chipset members in
usb_amd_dev_put()?  Can these things be added and removed dynamically?  
If they can't then the data should remain valid indefinitely once it
has been probed, and you could call pci_dev_put() at the end of
usb_amd_find_chipset_info().

And if they can, is it valid to call pci_dev_put() in usb_amd_dev_put()  
while holding a spinlock?  You might want to move those calls to the
end of the function.

Alan Stern

