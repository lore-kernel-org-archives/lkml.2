Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab1DNR5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:57:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:38277 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab1DNRqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 071/209] PCI: fix offset check for sysfs mmapped files
Date: Thu, 14 Apr 2011 13:41:41 -0400
Message-Id: <1302803039-9400-72-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darrick J. Wong <djwong@us.ibm.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/pci-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 627d067..f5cd68c 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -702,7 +702,7 @@ int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma,
 	nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	start = vma->vm_pgoff;
 	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
-	pci_start = (mmap_api == PCI_MMAP_SYSFS) ?
+	pci_start = (mmap_api == PCI_MMAP_PROCFS) ?
 			pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
 	if (start >= pci_start && start < pci_start + size &&
 			start + nr <= pci_start + size)
-- 
1.7.4.4

