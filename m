Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1IBMY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:24:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57865 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab1IBMYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:24:54 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Magnus Damm <magnus.damm@gmail.com>
Subject: [RFC 0/2] Memory mapped virtio device
Date: Fri,  2 Sep 2011 13:24:15 +0100
Message-Id: <1314966257-7503-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 02 Sep 2011 12:24:23.0080 (UTC) FILETIME=[3F44EA80:01CC696B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This is a proposal of a memory mapped virtio device.

The main goal was to provide an equivalent of the virtio PCI device,
happily used by KVM an qemu on x86, which could be used by PCI-less
platforms (common in ARM world). The interface exposed by my device
is very similar to the original virtio_pci one, maybe just a little
bit simplified (no sophisticated IRQ infrastructure here). Of course
all the control registers live in memory space, instead of PCI IO
space (writel vs iowrite32).

This raises an obvious question whether these two implementation
could share some common code. Probably some constant values could
be shared (like VIRTIO_*_HOST_FEATURES or VIRTIO_*_VRING_ALIGN),
maybe struct virtio_*_vq_info as well. On the other hand the vring
interface itself is an abstraction layer already... I really don't
know, all comments and ideas appreciated.

The second thing is AMBAness of the driver... I've decided to
make it an AMBA device rather than simple platform device to add
at least a touch of "dicoverability". The idea was simple - one
can add "permanent" virtio AMBA device in the kernel placing it
somewhere in reserved area of real hardware, so the kernel running
on hardware will not get correct amba_id value and ignore the
device. With the eve of Device-Trees-Everywhere this argument is
slightly out of date, as qemu could add the virtio device even in
runtime. So maybe I should convert it into a platform_device then?

This brings additional problem though. Magnus Damm already proposed
a platform virtio device here:

http://thread.gmane.org/gmane.linux.ports.sh.devel/11554

however it's something completely different, as his use case is a
heterogeneous system and the virtio is used mainly as a transport
between nodes. It also uses lguest-based interface, which is much
less applicable to the qemu reality.

The second patch simply makes it possible to use virtio framework
on ARM.

Let me just add that Peter Maydell (Linaro qemu magician) kindly
agreed to work on the qemu side of the problem once we have some
consensus regarding the interface.

Pawel Moll (2):
  virtio: Add AMBA bus driver for virtio device
  arm: Add VIRTUALIZATION configuration menu and virtio options

 arch/arm/Kconfig             |   16 ++
 drivers/virtio/Kconfig       |   11 +
 drivers/virtio/Makefile      |    1 +
 drivers/virtio/virtio_amba.c |  443 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_amba.h  |   62 ++++++
 5 files changed, 533 insertions(+), 0 deletions(-)
 create mode 100644 drivers/virtio/virtio_amba.c
 create mode 100644 include/linux/virtio_amba.h

