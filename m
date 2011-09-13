Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1IMKvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:51:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:57204 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab1IMKve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:51:34 -0400
Subject: Re: [PATCH 0/2] PCI: PCI-E MPS bug fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jon Mason <mason@myri.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <6dad18a7-cf65-46db-8283-78b8da5bfa3a@email.android.com>
References: <1315518078-30619-1-git-send-email-mason@myri.com>
	 <CA+55aFyFXXyEvOs0asgNeCrLzvH+e1zXgOen1rDd9BkB09J5NQ@mail.gmail.com>
	 <6dad18a7-cf65-46db-8283-78b8da5bfa3a@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 07:50:45 -0300
Message-ID: <1315911045.455.150.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> You should apply them. I would queue them, and but I don't have
> another PCI tree anywhere for you to pull them. 
> 
> In fact, I'll be out for the next few weeks; I'll ask Bjorn to cover
> for me. 

Note that I might be missing some patches, but what's currently in Linus
tree is rather wrong.

The comment is right, but the implementation is bogus:

static void pcie_write_mps(struct pci_dev *dev, int mps)
{
	int rc, dev_mpss;

	dev_mpss = 128 << dev->pcie_mpss;

	if (pcie_bus_config == PCIE_BUS_PERFORMANCE) {
		if (dev->bus->self) {
			dev_dbg(&dev->bus->dev, "Bus MPSS %d\n",
				128 << dev->bus->self->pcie_mpss);

			/* For "MPS Force Max", the assumption is made that
			 * downstream communication will never be larger than
			 * the MRRS.  So, the MPS only needs to be configured
			 * for the upstream communication.  This being the case,
			 * walk from the top down and set the MPS of the child
			 * to that of the parent bus.
			 */
			mps = 128 << dev->bus->self->pcie_mpss;

So here, we decide to use as an mps, the mpss of the bridge. That's already not
quite right. The bridge might itself be clamped down (because it's parent has
a smaller MPSS, well, your other bugs below will prevent that but that's how
it should be)

So we should use the MPS of the bridge not the MPSS (ie the configured MPS of
the bridge, not the max MPS of the bridge).

That does mean that we do need to configure the bridge first before we configure
the bridge children, I don't remember if that's what happens with the walk function
so we need to dbl check (I have to run, no time to check right now)

			if (mps > dev_mpss)
				dev_warn(&dev->dev, "MPS configured higher than"
					 " maximum supported by the device.  If"
					 " a bus issue occurs, try running with"
					 " pci=pcie_bus_safe.\n");

Yeah right. Instead of warning, we should actually -clamp- it. IE If the
bridge can do 4096 bytes and the device can only do 128 bytes, it's crazy
to try to set the device to 4096 bytes.

The idea is that we set the device to the higher it can up to the size
supported by the brigde, not the exact size of the brigde regardless of
whether that's bigger than what the device can handle.

It -never- makes any sense to configure a device to an MPS larger than
it's own maxium.

		}

		dev->pcie_mpss = ffs(mps) - 8;

And here I'm baffled. Why on earth would we -ever- want to change dev->pcie_mpss ?

This is the the HARD maximum supported by the device, as read from the capability
register. Changing our idea of what the device supports as a maximum isn't going
to help us... all it will do is allow the subsequent:
  
	}

	rc = pcie_set_mps(dev, mps);
	if (rc)
		dev_err(&dev->dev, "Failed attempting to set the MPS\n");

To actually try to program the bogus mps value we just calculated (ie the device
larger than what it supports).

}

The right thing to do here for the "performance" case is to use the min() of
the bus mps and the dev_mpss basically.

Ie. Going top down:

 - If !parent, mps = mpss else mps = min(mpss, parent->mps)
 - Iterate children

That's it.

So of course, the current implementation -will- break things. It might even explain
some of the radeon problems you've been observing, ie, might have nothing to do with
MRRS...

As to whether we should default to "safe" or "performance", well, it really depends
on the platform.

I know for a fact on power that my host bridges are never going to generate a downstream
request with a TLP larger than 128 bytes, and we never do PCIe  <-> PCIe transfers, 
so "performance" is good for me.

x86 with funky DMA engines in the CPU etc... might be capable of generating larger
TLPs, in which case it must switch to "safe".

Note that this whole business is really a mis-design of PCIe. The 'performance' mode is
a way to try to work around it and not end up with everything clamped down to the minimum
MPS (128 bytes) all the time, but it's a bit risky. Ideally the spec should have separated
at least the MPS of packets generated vs. the MPS of packets received at the root
complex level.

Now, I am giving some courses/training today and may not have time to propose a patch,
but if you don't get to it by tomorrow I'll see what I can do.

Cheers,
Ben.

