Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab2CLWdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:33:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811Ab2CLWdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:33:03 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/2] RFC Isolation API
To: david@gibson.dropbear.id.au, aik@ozlabs.ru, dwmw2@infradead.org
Cc: alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Mar 2012 16:32:46 -0600
Message-ID: <20120312220109.30321.83419.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO is completely stalled waiting on a poorly defined device isolation
infrastructure to take shape.  Rather than waiting any longer, I've
decided to write my own.  This is nowhere near ready for upstream, but
attempts to hash out some of the interactions of isolation groups.

To recap, an isolation group is a set of devices, between which there
is no guaranteed isolation.  Between isolation groups, we do have
isolation, generally provided by an IOMMU.  On x86 systems with either
VT-d or AMD-Vi, we often have function level isolation (assuming you
trust the device).  Hardware topologies such as PCIe-to-PCI bridges
can decrease this granularity.  PowerPC systems often set the delimiter
at the PCI bridge level and refer to these as Partitionable Endpoints.

VFIO is a userspace driver interface tailored as a replacement for
KVM device assignment.  In order to provide secure userspace driver
interfaces, we must first ensure that we have an isolated device
infrastructure.  This attempts to define the basics of such an
interface.

In addition to isolation groups, this series also introduces the idea
of an isolation "provider".  This is simply a driver which defines
isolation groups, for example intel-iommu.  This interface supports
multiple providers simultaneously.  We also have the idea of a "manager"
for an isolation group.  When a manager is set for an isolation group,
it changes the way driver matching works for devices.  We only allow
matching to drivers registered by the isolation group manager.  Once all
of the devices in an isolation group are bound to manager registered
drivers (or no driver), the group is "locked" under manager control.

This proposal is far from complete, but I hope it can re-fire some
discussion and work in this space.  Please let me know what you like,
what you don't like, and ideas for the gaps.  Thanks,

Alex

---

Alex Williamson (2):
      intel-iommu: Basic isolation group provider support
      Isolation groups


 drivers/base/Kconfig        |   10 +
 drivers/base/Makefile       |    1 
 drivers/base/base.h         |    5 
 drivers/base/isolation.c    |  798 +++++++++++++++++++++++++++++++++++++++++++
 drivers/iommu/intel-iommu.c |   70 ++++
 include/linux/device.h      |    4 
 include/linux/isolation.h   |  138 +++++++
 7 files changed, 1026 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/isolation.c
 create mode 100644 include/linux/isolation.h
