Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2KZXqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:46:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab2KZXqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:46:23 -0500
Date: Mon, 26 Nov 2012 21:46:12 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] AER-KVM: Error containment of PCI pass-thru devices
 assigned to KVM guests
Message-ID: <20121126234612.GC10634@amt.cnet>
References: <F9E001219150CB45BEDC82A650F360C90146F4DA@G4W3208.americas.hpqcorp.net>
 <20121120134104.GI27378@stefanha-thinkpad.redhat.com>
 <F9E001219150CB45BEDC82A650F360C90147066B@G4W3208.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F9E001219150CB45BEDC82A650F360C90147066B@G4W3208.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 02:09:46PM +0000, Pandarathil, Vijaymohan R wrote:
> 
> 
> > -----Original Message-----
> > From: Stefan Hajnoczi [mailto:stefanha@gmail.com]
> > Sent: Tuesday, November 20, 2012 5:41 AM
> > To: Pandarathil, Vijaymohan R
> > Cc: kvm@vger.kernel.org; linux-pci@vger.kernel.org; qemu-devel@nongnu.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 0/4] AER-KVM: Error containment of PCI pass-thru
> > devices assigned to KVM guests
> > 
> > On Tue, Nov 20, 2012 at 06:31:48AM +0000, Pandarathil, Vijaymohan R wrote:
> > > Add support for error containment when a PCI pass-thru device assigned to
> > a KVM
> > > guest encounters an error. This is for PCIe devices/drivers that support
> > AER
> > > functionality. When the OS is notified of an error in a device either
> > > through the firmware first approach or through an interrupt handled by
> > the AER
> > > root port driver, concerned subsystems are notified by invoking callbacks
> > > registered by these subsystems. The device is also marked as tainted till
> > the
> > > corresponding driver recovery routines are successful.
> > >
> > > KVM module registers for a notification of such errors. In the KVM
> > callback
> > > routine, a global counter is incremented to keep track of the error
> > > notification. Before each CPU enters guest mode to execute guest code,
> > > appropriate checks are done to see if the impacted device belongs to the
> > guest
> > > or not. If the device belongs to the guest, qemu hypervisor for the guest
> > is
> > > informed and the guest is immediately brought down, thus preventing or
> > > minimizing chances of any bad data being written out by the guest driver
> > > after the device has encountered an error.
> > 
> > I'm surprised that the hypervisor would shut down the guest when PCIe
> > AER kicks in for a pass-through device.  Shouldn't we pass the AER event
> > into the guest and deal with it there?
> 
> Agreed. That would be the ideal behavior and is planned in a future patch.
> Lack of control over the capabilities/type of the OS/drivers running in 
> the guest is also a concern in passing along the event to the guest.
> 
> My understanding is that in the current implementation of Linux/KVM, these 
> errors are not handled at all and can potentially cause a guest hang or 
> crash or even data corruption depending on the implementation of the guest
> driver for the device. As a first step, these patches make the behavior 
> better by doing error containment with a predictable behavior when such
> errors occur. 

For both ACPI notifications and Linux PCI AER driver there is a way for
the PCI driver to receive a notification, correct?

Can just have virt/kvm/assigned-dev.c code register such a notifier (as
a "PCI driver") and then perform appropriate action?

Also the semantics of "tainted driver" is not entirely clear.

Is there any reason for not having this feature for VFIO only, as KVM
device assigment is being phased out?

