Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab0IHXMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 19:12:34 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:38565 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab0IHXMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:12:23 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC PATCH 1/1] PCI: override BIOS/firmware resource allocation
Date: Wed, 8 Sep 2010 17:11:49 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20100908065958.GA27447@ram-laptop> <201009081435.14209.bjorn.helgaas@hp.com> <20100908214438.GD27447@ram-laptop>
In-Reply-To: <20100908214438.GD27447@ram-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201009081711.49458.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 08, 2010 03:44:38 pm Ram Pai wrote:
> On Wed, Sep 08, 2010 at 02:35:13PM -0600, Bjorn Helgaas wrote:

> > What specific problem are you solving?  Does this patch enable
> > us to assign resources to a device that previously had none?
> > A concrete example might help.
> 
> On machines with BIOS/uEFI that is unaware of SRIOV BARs, the BIOS/uEFI
> fails to allocate memory resources to the SRIOV BARs of PCIe functions.
> On such machines PCI-e Virtual functions cannot be enabled. 

I think you mean that an upstream bridge window might not be big
enough to assign SR-IOV BARs, so we might have to reassign peers
of the bridge so we can expand the window.  But a concrete example
would make this clear.

> Also on machines where BIOS/uEFI allocations conflict, the corresponding 
> devices are disabled.

What does it mean for BIOS allocations to conflict?  Two BARs that
claim the same space?  Is that a BIOS defect?

> This patch provides the user the ability to explicitly tell the kernel
> to try and allocate resources to such devices or resolve any conflicts.
> 
> By default the kernel disables all devices that have conflicting or no
> allocations.

> > > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > > 
> > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > index f084af0..eec068f 100644
> > > --- a/Documentation/kernel-parameters.txt
> > > +++ b/Documentation/kernel-parameters.txt
> > > @@ -1961,6 +1961,21 @@ and is between 256 and 4096 characters. It is defined in the file
> > >  				PAGE_SIZE is used as alignment.
> > >  				PCI-PCI bridge can be specified, if resource
> > >  				windows need to be expanded.
> > > +		override=[off, conflict, always, <device>]
> > > +				off : Do not override BIOS/firmware allocations. This is the 
> > > +					default
> > > +				conflict : override BIOS/firmware allocations if conflicting
> > > +					or not allocated.
> > > +				always : override all BIOS/firmware allocations
> > > +				<device>: Format [<domain>:]<bus>:<slot>.<func>[; ...]
> > > +					override BIOS/firmware allocations of specified
> > > +					devices
> > > +
> > > +		clear=<device>
> > > +				<device>: Format [<domain>:]<bus>:<slot>.<func>[; ...]
> > > +					release BIOS/firmware allocations of specified
> > > +					devices. By default no allocations are cleared.
> > 
> > I object in principle to new kernel parameters that users might need
> > to use just to get their box to work.  How would a user know that he
> > might need this option?  Isn't it possible for the kernel to figure
> > that out automatically?
> 
> The user can use these options only if he/she realizes that some devices are 
> disabled. These options are not needed in the normal case which is about 95% of
> the time. But I need these parameter to get my box working with SRIOV adapters.
> And I am sure they are needed for many other boxes that face similar issue.

I don't think this is a very convincing argument.  As a user, I don't
want to have to "realize some devices are disabled" and then grope
around for an option to fix things up.  As a vendor, I don't want to
have to mention stuff like this in release notes for machines that
might need it.

>From your other response:
> Well Yanghai's patch, git commit 977d17bb1749517b353874ccdc9b85abc7a58c2a,
> tried to automate the process. But it was error prone and caused regression.

Is it actually impossible to do it automatically, or did we just
not try hard enough?

Bjorn
