Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab1LSPmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:42:40 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:14311
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab1LSPmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:42:36 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zz98dKzz1202hz70kz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWGJMT-01-8SA-02
X-M-MSG: 
Date: Mon, 19 Dec 2011 16:41:56 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>, <aik@ozlabs.ru>,
        <benh@kernel.crashing.org>, <dwmw2@infradead.org>, <chrisw@redhat.com>,
        <agraf@suse.de>, <scottwood@freescale.com>, <B08248@freescale.com>,
        <rusty@rustcorp.com.au>, <iommu@lists.linux-foundation.org>,
        <qemu-devel@nongnu.org>, <linux-kernel@vger.kernel.org>,
        <joro@8bytes.org>
Subject: Re: [RFC] Device isolation infrastructure v2
Message-ID: <20111219154156.GG29877@amd.com>
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
 <1323972307.2437.19.camel@x201.home>
 <20111216145353.GA29877@amd.com>
 <20111219001125.GA30390@truffala.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111219001125.GA30390@truffala.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 11:11:25AM +1100, David Gibson wrote:
> Well.. that's not where it is in Alex's code either.  The iommu layer
> (to the extent that there is such a "layer") supplies the group info,
> but the group management is in vfio, not the iommu layer.  With mine
> it is in the driver core because the struct device seemed the logical
> place for the group id.

Okay, seems we have different ideas of what the 'grouping code' is. I
talked about the group enumeration code only. But group handling code is
certainly important to some degree too. But before we argue about the
right place of the code we should agree on the semantics such code
should provide.

For me it is fine when the code is in VFIO for now, since VFIO is the
only user at the moment. When more users pop up we can easily move it
out to somewhere else. But the semantics influence the interface to
user-space too, so it is more important now. It splits up into a number
of sub problems:

	1) How userspace detects the device<->group relationship?
	2) Do we want group-binding/unbinding to device drivers?
	3) Group attach/detach to iommu-domains?
	4) What to do with hot-added devices?

For 1) I think the current solution with the iommu_group file is fine.
It is somewhat expensive for user-space to figure out the per-group
device-sets, but that is a one-time effort so it doesn't really matter.
Probably we can rename 'iommu_group' to 'isolation_group' or something.

Regarding 2), I think providing user-space a way to unbind groups of
devices from their drivers is a horrible idea. It makes it too easy for
the user to shoot himself in the foot. For example when the user wants
to assign a network card to a guest, but that card is in the same group
as the GPU and the screen wents blank when the guest is started.
Requiring devices to be unbound one-by-one is better because this way
the user always needs to know what he is doing.

For the remaining two questions I think the concept of a default-domain
is helpful.  The default-domain is a per-group domain which is created
by the iommu-driver at initialization time. It is the domain each device
is assigned to when it is not assigned to any other domain (which means
that each device/group is always attached to a domain). The default
domain will be used by the DMA-API layer. This implicitly means, that a
device which is not in the default-domain can't be used with the
dma-api. The dma_supported() function will return false for those
devices.

So what does this mean for point 3? I think we can implement attaching
and detaching groups in the iommu-api. This interface is not exposed to
userspace and can help VFIO and possible future users. Semantic is, that
domain_attach_group() only works when all devices in the group are in
their default domain and domain_detach_group() puts them back into the
default domain.

Question 4) is also solved with the default-domain concept. A hot-added
device is put in the domain of its group automatically. If the group is
owned by VFIO and another driver attaches to the device dma_supported
will return false and initialization will fail.

> Right, so, the other problem is that a well boundaried "iommu-driver'
> is something that only exists on x86 at present, and the "iommu api"
> is riddled with x86-centric thinking.  Or more accurately, design
> based on how the current intel and amd iommus work.  On systems like
> POWER, use of the iommu is not optional - it's built into the PCI host
> bridge and must be initialized when the bridge is probed, much earlier
> than iommu driver initialization on x86.  They have no inbuilt concept
> of domains (though we could fake in software in some circumstances).

Well, the iommu-api was designed for amd-vi and vt-d. But its concepts
turn out to be more general and by no way x86-centric anymore. We
support a couple of ARM platforms too for example. More to come. With
small extensions to the API we will also support GART-like IOMMUs in the
future.
For your hardware the domain-concept will work too. In terms of the
iommu-api a domain is nothing more than an address space. As far as I
understand there is a 1-1 mapping between a hardware iommu and a domain
in your case. The easiest solution then is to share the datastructures
which describe the address space to the hardware between all iommus in a
particular domain.


Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

