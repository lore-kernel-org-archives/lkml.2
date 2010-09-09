Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0IIAAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 20:00:13 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59770 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab0IIAAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 20:00:10 -0400
Date: Wed, 8 Sep 2010 17:00:00 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 1/1] PCI: override BIOS/firmware resource allocation
Message-ID: <20100909000000.GH27447@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20100908065958.GA27447@ram-laptop>
 <201009081435.14209.bjorn.helgaas@hp.com>
 <20100908214438.GD27447@ram-laptop>
 <201009081711.49458.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009081711.49458.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 05:11:49PM -0600, Bjorn Helgaas wrote:
> On Wednesday, September 08, 2010 03:44:38 pm Ram Pai wrote:
> > On Wed, Sep 08, 2010 at 02:35:13PM -0600, Bjorn Helgaas wrote:
> 
> > > What specific problem are you solving?  Does this patch enable
> > > us to assign resources to a device that previously had none?
> > > A concrete example might help.
> > 
> > On machines with BIOS/uEFI that is unaware of SRIOV BARs, the BIOS/uEFI
> > fails to allocate memory resources to the SRIOV BARs of PCIe functions.
> > On such machines PCI-e Virtual functions cannot be enabled. 
> 
> I think you mean that an upstream bridge window might not be big
> enough to assign SR-IOV BARs, so we might have to reassign peers
> of the bridge so we can expand the window.  But a concrete example
> would make this clear.

True. The upstream bridge does not have enough window to satisfy SR-IOV BARs.
It has to be reallocated with a larger window, a behavior the OS does not do
currently. This patch does it when the appropriate override option is provided.

> 
> > Also on machines where BIOS/uEFI allocations conflict, the corresponding 
> > devices are disabled.
> 
> What does it mean for BIOS allocations to conflict?  Two BARs that
> claim the same space?  Is that a BIOS defect?

Yes buggy BIOS. I have not run into this issue personally. But I believe, the
reason for Yanghai's original patch was to handle buggy BIOSes.

> 
> > This patch provides the user the ability to explicitly tell the kernel
> > to try and allocate resources to such devices or resolve any conflicts.
> > 
> > By default the kernel disables all devices that have conflicting or no
> > allocations.
> 
> > > > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > > > 
> > > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > > index f084af0..eec068f 100644
> > > > --- a/Documentation/kernel-parameters.txt
> > > > +++ b/Documentation/kernel-parameters.txt
> > > > @@ -1961,6 +1961,21 @@ and is between 256 and 4096 characters. It is defined in the file
> > > >  				PAGE_SIZE is used as alignment.
> > > >  				PCI-PCI bridge can be specified, if resource
> > > >  				windows need to be expanded.
> > > > +		override=[off, conflict, always, <device>]
> > > > +				off : Do not override BIOS/firmware allocations. This is the 
> > > > +					default
> > > > +				conflict : override BIOS/firmware allocations if conflicting
> > > > +					or not allocated.
> > > > +				always : override all BIOS/firmware allocations
> > > > +				<device>: Format [<domain>:]<bus>:<slot>.<func>[; ...]
> > > > +					override BIOS/firmware allocations of specified
> > > > +					devices
> > > > +
> > > > +		clear=<device>
> > > > +				<device>: Format [<domain>:]<bus>:<slot>.<func>[; ...]
> > > > +					release BIOS/firmware allocations of specified
> > > > +					devices. By default no allocations are cleared.
> > > 
> > > I object in principle to new kernel parameters that users might need
> > > to use just to get their box to work.  How would a user know that he
> > > might need this option?  Isn't it possible for the kernel to figure
> > > that out automatically?
> > 
> > The user can use these options only if he/she realizes that some devices are 
> > disabled. These options are not needed in the normal case which is about 95% of
> > the time. But I need these parameter to get my box working with SRIOV adapters.
> > And I am sure they are needed for many other boxes that face similar issue.
> 
> I don't think this is a very convincing argument.  As a user, I don't
> want to have to "realize some devices are disabled" and then grope
> around for an option to fix things up.  As a vendor, I don't want to
> have to mention stuff like this in release notes for machines that
> might need it.

True if we can automatically detect and resolv the issue. But given the different
combinations of BIOS behavior coupled with device resource requirements, I am
not sure one would be able to get it all working just perfect.

> 
> From your other response:
> > Well Yanghai's patch, git commit 977d17bb1749517b353874ccdc9b85abc7a58c2a,
> > tried to automate the process. But it was error prone and caused regression.
> 
> Is it actually impossible to do it automatically, or did we just
> not try hard enough?

I dont think it is matter of trying hard enough. Its a matter of testing 
the patches on all the configurations out there and ensuring that it all works.
Its quite an open-ended effort. you might prove me wrong :)

RP

> 
> Bjorn
