Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0LMAEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:04:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36393 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab0LLXrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:25 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: djwong@us.ibm.com, martin.wilck@ts.fujitsu.com, jbarnes@virtuousgeek.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [141/223] PCI: fix offset check for sysfs mmapped files
Message-Id: <20101212234723.CEA1FB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Darrick J. Wong <djwong@us.ibm.com>

commit 8c05cd08a7504b855c265263e84af61aabafa329 upstream.

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

Acked-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pci/pci-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/pci/pci-sysfs.c
===================================================================
--- linux.orig/drivers/pci/pci-sysfs.c
+++ linux/drivers/pci/pci-sysfs.c
@@ -715,7 +715,7 @@ int pci_mmap_fits(struct pci_dev *pdev,
 	nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	start = vma->vm_pgoff;
 	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
-	pci_start = (mmap_api == PCI_MMAP_SYSFS) ?
+	pci_start = (mmap_api == PCI_MMAP_PROCFS) ?
 			pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
 	if (start >= pci_start && start < pci_start + size &&
 			start + nr <= pci_start + size)
