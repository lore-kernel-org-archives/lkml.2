Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab2BAErM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 23:47:12 -0500
Received: from ozlabs.org ([203.10.76.45]:33355 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab2BAErK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 23:47:10 -0500
From: David Gibson <david@gibson.dropbear.id.au>
To: dwmw2@infradead.org, iommu@lists.linux-foundation.org
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, joerg.roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: RFC: Device isolation groups
Date: Wed,  1 Feb 2012 15:46:51 +1100
Message-Id: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces a new infrastructure to the driver core
for representing "device isolation groups".  That is, groups of
devices which can be "isolated" in such a way that the rest of the
system can be protected from them, even in the presence of userspace
or a guest OS directly driving the devices.

Isolation will typically be due to an IOMMU which can safely remap DMA
and interrupts coming from these devices.  We need to represent whole
groups, rather than individual devices, because there are a number of
cases where the group can be isolated as a whole, but devices within
it cannot be safely isolated from each other - this usually occurs
because the IOMMU cannot reliably distinguish which device in the
group initiated a transaction.  In other words, isolation groups
represent the minimum safe granularity for passthrough to guests or
userspace.

This series provides the core infraustrcture for tracking isolation
groups, and example implementations initializing the groups
appropriately for two PCI bridges (which include IOMMUs) found on IBM
POWER systems.

Actually using the group information is not included here, but David
Woodhouse has expressed an interest in using a structure like this to
represent operations in iommu_ops more correctly.

Some tracking of groups is a prerequisite for safe passthrough of
devices to guests or userspace, such as done by VFIO.  Current VFIO
patches use the iommu_ops->device_group mechanism for this.  However,
that mechanism is awkward, because without an in-kernel concrete
representation of groups, enumerating a group requires traversing
every device on a given bus type.  It also fails to cover some very
plausible IOMMU topologies, because its groups cannot span devices on
multiple bus types.

