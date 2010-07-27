Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab0G0WNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:13:45 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:30587 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0G0WNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:13:43 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.55,270,1278288000"; 
   d="scan'208";a="347005350"
From: Tom Lyon <pugs@cisco.com>
Organization: Cisco Systems, Inc.
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH V3] VFIO driver: Non-privileged user level PCI drivers
Date: Tue, 27 Jul 2010 15:13:14 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de,
        avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
References: <4c40d618./j7HFMCg9NusCIiB%pugs@cisco.com> <1279515407.20397.382.camel@x201> <20100719100617.GA31417@redhat.com>
In-Reply-To: <20100719100617.GA31417@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007271513.15093.pugs@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry for the long hiatus, I've been wrapped up in other issues.]

I think the fundamental issue to resolve is to decide on the model which the 
VFIO driver presents to its users.

Fundamentally, VFIO as part of the OS must protect the system from its users 
and also protect the users from each other.  No disagreement here.

But another fundamental purpose of an OS to to present an abstract model of 
the underlying hardware to its users, so that the users don't have to deal 
with the full complexity of the hardware.

So I think VFIO should present a 'virtual', abstracted PCI device to its users 
whereas Michael has argued for a simpler model of presenting the real PCI
device config registers while preventing writes only to the registers which 
would clearly disrupt the system.

Now, the virtual model *could* look little like the real hardware, and use 
bunches of ioctls for everything it needs, or it could look a lot like PCI and 
use reads and writes of the virtual PCI config registers to trigger its 
actions.  The latter makes things more amenable to those porting drivers from 
other environments.

I realize that to date the VFIO driver has been a  bit of a mish-mash between 
the ioctl and config based techniques; I intend to clean that up.  And, yes, 
the abstract model presented by VFIO will need plenty of documentation.

Since KVM/qemu already has its own notion of a virtual PCI device which it 
presents to the guest OS, we either need to reconcile VFIO and qemu, or 
provide a bypass of the VFIO virtual model.  This could be direct access 
through sysfs, or else an ioctl to VFIO.  Since I have no internals knowledge 
of qemu, I look to others to choose.

Other little things:
1. Yes, I can share some code with sysfs if I can get the right EXPORTs there.
2. I'll add multiple MSI support, but I wish to point out that even though the 
PCI MSI API supports it, none of the architectures do.
3. FLR needs work.  I was foolish enough to assume that FLR wouldn't reset 
BARs; now I know better.
4. I'll get rid of the vfio config_map in sysfs; it was there for debugging.
5. I'm still looking to support hotplug/unplug and power management stuff via 
generic netlink notifications.
