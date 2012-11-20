Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2KTOKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:10:51 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:13730 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KTOKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:10:49 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/4] AER-KVM: Error containment of PCI pass-thru devices
 assigned to KVM guests
Thread-Topic: [PATCH 0/4] AER-KVM: Error containment of PCI pass-thru
 devices assigned to KVM guests
Thread-Index: AQHNxui4h6c7cMTORE+3hu06XL5uJpfyu40AgAACbHA=
Date: Tue, 20 Nov 2012 14:09:46 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C90147066B@G4W3208.americas.hpqcorp.net>
References: <F9E001219150CB45BEDC82A650F360C90146F4DA@G4W3208.americas.hpqcorp.net>
 <20121120134104.GI27378@stefanha-thinkpad.redhat.com>
In-Reply-To: <20121120134104.GI27378@stefanha-thinkpad.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stefan Hajnoczi [mailto:stefanha@gmail.com]
> Sent: Tuesday, November 20, 2012 5:41 AM
> To: Pandarathil, Vijaymohan R
> Cc: kvm@vger.kernel.org; linux-pci@vger.kernel.org; qemu-devel@nongnu.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 0/4] AER-KVM: Error containment of PCI pass-thru
> devices assigned to KVM guests
> 
> On Tue, Nov 20, 2012 at 06:31:48AM +0000, Pandarathil, Vijaymohan R wrote:
> > Add support for error containment when a PCI pass-thru device assigned to
> a KVM
> > guest encounters an error. This is for PCIe devices/drivers that support
> AER
> > functionality. When the OS is notified of an error in a device either
> > through the firmware first approach or through an interrupt handled by
> the AER
> > root port driver, concerned subsystems are notified by invoking callbacks
> > registered by these subsystems. The device is also marked as tainted till
> the
> > corresponding driver recovery routines are successful.
> >
> > KVM module registers for a notification of such errors. In the KVM
> callback
> > routine, a global counter is incremented to keep track of the error
> > notification. Before each CPU enters guest mode to execute guest code,
> > appropriate checks are done to see if the impacted device belongs to the
> guest
> > or not. If the device belongs to the guest, qemu hypervisor for the guest
> is
> > informed and the guest is immediately brought down, thus preventing or
> > minimizing chances of any bad data being written out by the guest driver
> > after the device has encountered an error.
> 
> I'm surprised that the hypervisor would shut down the guest when PCIe
> AER kicks in for a pass-through device.  Shouldn't we pass the AER event
> into the guest and deal with it there?

Agreed. That would be the ideal behavior and is planned in a future patch.
Lack of control over the capabilities/type of the OS/drivers running in 
the guest is also a concern in passing along the event to the guest.

My understanding is that in the current implementation of Linux/KVM, these 
errors are not handled at all and can potentially cause a guest hang or 
crash or even data corruption depending on the implementation of the guest
driver for the device. As a first step, these patches make the behavior 
better by doing error containment with a predictable behavior when such
errors occur. 

> 
> The equivalent to this policy on physical hardware would be that the CPU
> is reset or the machine is powered down on AER.  That doesn't sound
> right.
> 
> Stefan
