Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab0G1Vwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:52:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab0G1Vwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:52:42 -0400
Date: Thu, 29 Jul 2010 00:46:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de,
        avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V3] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100728214654.GC9184@redhat.com>
References: <4c40d618./j7HFMCg9NusCIiB%pugs@cisco.com>
 <201007271513.15093.pugs@cisco.com>
 <20100727235322.GB19930@redhat.com>
 <201007281414.22335.pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007281414.22335.pugs@cisco.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 02:14:21PM -0700, Tom Lyon wrote:
> On Tuesday, July 27, 2010 04:53:22 pm Michael S. Tsirkin wrote:
> > On Tue, Jul 27, 2010 at 03:13:14PM -0700, Tom Lyon wrote:
> > > [ Sorry for the long hiatus, I've been wrapped up in other issues.]
> > > 
> > > I think the fundamental issue to resolve is to decide on the model which
> > > the VFIO driver presents to its users.
> > > 
> > > Fundamentally, VFIO as part of the OS must protect the system from its
> > > users and also protect the users from each other.  No disagreement here.
> > > 
> > > But another fundamental purpose of an OS to to present an abstract model
> > > of the underlying hardware to its users, so that the users don't have to
> > > deal with the full complexity of the hardware.
> > > 
> > > So I think VFIO should present a 'virtual', abstracted PCI device to its
> > > users whereas Michael has argued for a simpler model of presenting the
> > > real PCI device config registers while preventing writes only to the
> > > registers which would clearly disrupt the system.
> > 
> > In fact, there is no contradiction. I am all for an abstracted
> > API *and* I think the virtualization concept is a bad way
> > to build this API.
> > 
> > The 'virtual' interface you present is very complex and hardware specific:
> > you do not hide literally *anything*. Deciding which functionality
> > userspace needs, and exposing it to userspace as a set of APIs would be
> > abstract. Instead you ask people to go read the PCI spec, the device spec,
> > and bang on PCI registers, little-endian-ness and all, then try to
> > interpret what do the virtual values mean.
> 
> Exactly! The PCI bus is far better *specified*, *documented*, and widely 
> implemented than a Linux driver could ever hope to be.

Yes but it does not map all that well to what you need to do.
We need a sane backward compatibility plan, cross-platform support,
error reporting, atomicity ... PCI config has support for none of this.
So you implement a "kind of" PCI config, where accesses might fail
or not go through to device, where there are some atomicity guarantees
but not others ...
And there won't even be a header file to look at to say "aha,
this driver has this functionality".
How does an application know whether you support capability X?
Reading the driver source seems to be shaping up the only way.

>  And there are lots of 
> current Linux drivers which bang around in pci config space simply because the 
> authors were not aware of some api call buried deep in linux which would do 
> the work for them - or - got tired of using OS-specific APIs when porting a 
> driver and decided to just ask the hardware.

Really? Example? drivers either use proper APIs or are broken in some way.
You can not even size the BARs without using the OS API.
So what's safe to do directly? Maybe reading out device/vendor/revision ID ...
looks like small change to me.

> 
> > Example:
> > 
> > How do I find # of MSI-X vectors? Sure, scan the capability list,
> > find the capability, read the value, convert from little endian
> > at each step.
> > A page or two of code, and let's hope I have a ppc to test on.
> > And note no driver has this code - they all use OS routines.
> > 
> > So why wouldn't
> > 	ioctl(dev, VFIO_GET_MSIX_VECTORS, &n);
> > better serve the declared goal of presenting an abstracted PCI device to
> > users?
> 
> By and large, the user drivers just know how many because the hardware is 
> constant.

But you might not have CPU resources to allocate all vectors.
And, same will apply to any register you spend code virtualizing.

> And inventing 20 or 30 ioctls to do a bunch of random stuff is gross


If you dislike ioctls, use read/write at a defined offset,
or sysfs. Just don't pretend you can say "look at PCI spec"
and avoid the need to document your interface this way.

> when you 
> can instead use normal read and write calls to a well defined structure.

It is not all that well defined.
What if hardware supports MSIX but host controller does not?
Do you return error from write enabling MSIX?
Virtualize it and pretend there is no capability?
PCI has no provision for this, and deciding what to do
here is policy which kernel should not dictate.


> > 
> > > Now, the virtual model *could* look little like the real hardware, and
> > > use bunches of ioctls for everything it needs,
> > 
> > Or reads/writes at special offsets, or sysfs attributes.
> > 
> > > or it could look a lot like PCI and
> > > use reads and writes of the virtual PCI config registers to trigger its
> > > actions.  The latter makes things more amenable to those porting drivers
> > > from other environments.
> > 
> > I really doubt this helps at all. Drivers typically use OS-specific
> > APIs. It is very uncommon for them to touch standard registers,
> > which is 100% of what your patch seem to be dealing with.
> > 
> > And again, how about a small userspace library that would wrap vfio and
> > add the abstractions for drivers that do need them?
> 
> Yes, there will be userspace libraries - I already have a vfio backend for 
> libpci.

So move the virtualization stuff there, and out of kernel.

> > > I realize that to date the VFIO driver has been a  bit of a mish-mash
> > > between the ioctl and config based techniques; I intend to clean that
> > > up.  And, yes, the abstract model presented by VFIO will need plenty of
> > > documentation.
> > 
> > And, it will need to be maintained forever, bugs and all.
> > For example, if you change some register you emulated
> > to fix a bug, to the driver this looks like a hardware change,
> > and it will crash.
> 
> The changes will come only to allow for a more-perfect emulation,
> so I doubt 
> that  will cause driver problems.

You plan changing the API to accomodate new hardware
and doubt this will create problems?
'more perfect emulation' for one app is a crasher bug for another one.


> No different than discovering and fixing 
> bugs in the ioctls needed in you scenario.

Very different. With a sane interface you can just add
another register to encode new information, keeping
the old one around to avoid breaking userspace.
PCI is not designed to allow this, so it does not.

> > 
> > The PCI spec has some weak versioning support, but it
> > is mostly not a problem in that space: a specific driver needs to
> > only deal with a specific device.  We have a generic driver so PCI
> > configuration space is a bad interface to use.
> 
> PCI has great versioning. Damn near every change made in 16+ years has been 
> upwards compatible.

You plan to push interface extensions for your driver through PCI SIG?

>  BIOS and OS writers don't have trouble with generic PCI, 
> why should vfio?

They do with it what it was defined to do. You want to use it
as a system call interface which it was never intended for.

> > 
> > > Since KVM/qemu already has its own notion of a virtual PCI device which
> > > it presents to the guest OS, we either need to reconcile VFIO and qemu,
> > > or provide a bypass of the VFIO virtual model.  This could be direct
> > > access through sysfs, or else an ioctl to VFIO.  Since I have no
> > > internals knowledge of qemu, I look to others to choose.
> > 
> > Ah, so there will be 2 APIs, one for qemu, one for userspace drivers?
> 
> I hope not, but I also hope not to become the qemu expert to find out.  Alex 
> W. seemed to be making progress in this area.
> 
> > 
> > > Other little things:
> > > 1. Yes, I can share some code with sysfs if I can get the right EXPORTs
> > > there. 2. I'll add multiple MSI support, but I wish to point out that
> > > even though the PCI MSI API supports it, none of the architectures do.
> > > 3. FLR needs work.  I was foolish enough to assume that FLR wouldn't
> > > reset BARs; now I know better.
> > 
> > And as I said separately, drivers might reset BARs without FLR as well.
> > As long as io/memory is disabled, we really should allow userspace
> > write anything in BARs. And once we let it do it, most of the problem goes
> > away.
> > 
> > > 4. I'll get rid of the vfio config_map in sysfs; it was there for
> > > debugging. 5. I'm still looking to support hotplug/unplug and power
> > > management stuff via generic netlink notifications.
