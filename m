Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030542Ab2GLDfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 23:35:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63616 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639Ab2GLDfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 23:35:15 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V3 5/6] Avoid duplicate probe for of platform devices
To: Greg KH <greg@kroah.com>, Li Yang-R58472 <r58472@freescale.com>
Cc: Jia Hongtao-B38951 <B38951@freescale.com>,
        Rob Herring <robherring2@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20120709145831.GB3961@kroah.com>
References: <1339148585-16947-1-git-send-email-B38951@freescale.com> <4FD60FB1.7050106@gmail.com> <412C8208B4A0464FA894C5F0C278CD5D01A16829@039-SN1MPN1-002.039d.mgd.msft.net> <20120706042611.GA1841@kroah.com> <412C8208B4A0464FA894C5F0C278CD5D01A168F2@039-SN1MPN1-002.039d.mgd.msft.net> <20120706161718.GA26894@kroah.com> <412C8208B4A0464FA894C5F0C278CD5D01A1E694@039-SN1MPN1-002.039d.mgd.msft.net> <94F013E7935FF44C83EBE7784D62AD3F09354AE6@039-SN2MPN1-021.039d.mgd.msft.net> <20120709145831.GB3961@kroah.com>
Date: Wed, 11 Jul 2012 19:01:41 +0100
Message-Id: <20120711180141.B01733E07D1@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012 07:58:31 -0700, Greg KH <greg@kroah.com> wrote:
> On Mon, Jul 09, 2012 at 03:46:59AM +0000, Li Yang-R58472 wrote:
> > > > I don't understand, why is this just showing up now?  What changed to
> > > > cause this?  Couldn't that be the real problem here?
> > > >
> > > 
> > > The issue is showing up because we now probe devices twice.
> > > Previously, we just probe devices once. But now we changed the way of pci
> > > init which makes pci controllers should be probed earlier than other
> > > devices.
> > > So we have to probe pci nodes separately. Probe more than once is the
> > > root
> > > cause of this issue.
> > > 
> > > The pci patchset I mentioned please refer to:
> > > http://patchwork.ozlabs.org/patch/163742/
> > 
> > Let me try to clarify a little bit.  The of platform bus normally
> > traverse the device tree to add all the devices.  The change which
> > caused problem is that we need to probe PCIe RC devices at a earlier
> > stage of initialization.
> 
> That sounds, wrong.

Yes, really really wrong; starting with terminology...

> > So we added these PCIe RC devices earlier than the normal device tree
> > traversal process.  These PCIe RC devices will be scanned again during
> > the normal traversal and cause duplicated devices being added.  Our
> > proposal is to deal with duplicated devices automatically and make it
> > possible to scan the device tree multiple times for devices to be
> > added. 

... This isn't *probing* twice; it is *registration*.  That's cause
confusion on this thread.

> Then you need to put something in your own tree scanning logic to not
> try to register devices multiple times.  How about a simple flag in your
> device structure instead of having to muck around in the driver core
> internals?

Right.  If you're going to create the pci bus devices early, then you
need to explicitly inhibit creation of them later... but still; why do
the PCI bus devices need to be registered separately from the rest of the
devices on the simple-bus?  Why not just move *all* device registration
earlier?

> 
> Although one should seriously question the need to want to recan the bus
> and register devices at different times of the boot process...

Yes; the model they're trying to use sounds wrong.

g.

