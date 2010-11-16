Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab0KPH6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:58:17 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41117 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759363Ab0KPH6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:58:16 -0500
Date: Mon, 15 Nov 2010 23:58:14 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [REGRESSSION 2.6.37-rc2][PATCH] pci: Fix mmap address check in
	pci_mmap_fits
Message-ID: <20101116075814.GR14383@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20101116072247.GQ14383@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116072247.GQ14383@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just loaded 2.6.37-rc2 on my machines, and I noticed that X no longer starts.
Running an strace of the X server shows that it's doing this:

open("/sys/bus/pci/devices/0000:07:00.0/resource0", O_RDWR) = 10
mmap(NULL, 16777216, PROT_READ|PROT_WRITE, MAP_SHARED, 10, 0) = -1 EINVAL (Invalid argument)

This code seems to be asking for a shared read/write mapping of 16MB worth of
BAR0 starting at file offset 0, and letting the kernel assign a starting
address.  Unfortunately, this -EINVAL causes X not to start.  Looking into
dmesg, there's a complaint like so:

process "Xorg" tried to map 0x01000000 bytes at page 0x00000000 on 0000:07:00.0 BAR 0 (start 0x        96000000, size 0x         1000000)

...with the following code in pci_mmap_fits:

	pci_start = (mmap_api == PCI_MMAP_SYSFS) ?
		pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
        if (start >= pci_start && start < pci_start + size &&
                        start + nr <= pci_start + size)

It looks like the logic here is set up such that when the mmap call comes via
sysfs, the check in pci_mmap_fits wants vma->vm_pgoff to be between the
resource's start and end address, and the end of the vma to be no farther than
the end.  However, the sysfs PCI resource files always start at offset zero,
which means that this test always fails for programs that mmap the sysfs files.
Given the comment in the original commit
3b519e4ea618b6943a82931630872907f9ac2c2b, I _think_ the old procfs files
require that the file offset be equal to the resource's base address when
mmapping.

I think what we want here is for pci_start to be 0 when mmap_api ==
PCI_MMAP_PROCFS.  The following patch makes that change, after which the Matrox
and Mach64 X drivers work again.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/pci/pci-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 95712a3..63d5042 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -715,7 +715,7 @@ int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma,
 	nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	start = vma->vm_pgoff;
 	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
-	pci_start = (mmap_api == PCI_MMAP_SYSFS) ?
+	pci_start = (mmap_api == PCI_MMAP_PROCFS) ?
 			pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
 	if (start >= pci_start && start < pci_start + size &&
 			start + nr <= pci_start + size)
