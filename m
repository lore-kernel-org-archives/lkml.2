Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab0LHBYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:24:12 -0500
Received: from kroah.org ([198.145.64.141]:33516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541Ab0LHBCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:45 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:40 2010
Message-Id: <20101208005740.484921855@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [190/289] PCI: fix size checks for mmap() on /proc/bus/pci files
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Wilck <martin.wilck@ts.fujitsu.com>

commit 3b519e4ea618b6943a82931630872907f9ac2c2b upstream.

The checks for valid mmaps of PCI resources made through /proc/bus/pci files
that were introduced in 9eff02e2042f96fb2aedd02e032eca1c5333d767 have several
problems:

1. mmap() calls on /proc/bus/pci files are made with real file offsets > 0,
whereas under /sys/bus/pci/devices, the start of the resource corresponds
to offset 0. This may lead to false negatives in pci_mmap_fits(), which
implicitly assumes the /sys/bus/pci/devices layout.

2. The loop in proc_bus_pci_mmap doesn't skip empty resouces. This leads
to false positives, because pci_mmap_fits() doesn't treat empty resources
correctly (the calculated size is 1 << (8*sizeof(resource_size_t)-PAGE_SHIFT)
in this case!).

3. If a user maps resources with BAR > 0, pci_mmap_fits will emit bogus
WARNINGS for the first resources that don't fit until the correct one is found.

On many controllers the first 2-4 BARs are used, and the others are empty.
In this case, an mmap attempt will first fail on the non-empty BARs
(including the "right" BAR because of 1.) and emit bogus WARNINGS because
of 3., and finally succeed on the first empty BAR because of 2.
This is certainly not the intended behaviour.

This patch addresses all 3 issues.
Updated with an enum type for the additional parameter for pci_mmap_fits().

Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci-sysfs.c |   22 ++++++++++++++++------
 drivers/pci/pci.h       |    7 ++++++-
 drivers/pci/proc.c      |    2 +-
 3 files changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -705,17 +705,21 @@ void pci_remove_legacy_files(struct pci_
 
 #ifdef HAVE_PCI_MMAP
 
-int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma)
+int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma,
+		  enum pci_mmap_api mmap_api)
 {
-	unsigned long nr, start, size;
+	unsigned long nr, start, size, pci_start;
 
+	if (pci_resource_len(pdev, resno) == 0)
+		return 0;
 	nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	start = vma->vm_pgoff;
 	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
-	if (start < size && size - start >= nr)
+	pci_start = (mmap_api == PCI_MMAP_SYSFS) ?
+			pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
+	if (start >= pci_start && start < pci_start + size &&
+			start + nr <= pci_start + size)
 		return 1;
-	WARN(1, "process \"%s\" tried to map 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",
-		current->comm, start, start+nr, pci_name(pdev), resno, size);
 	return 0;
 }
 
@@ -745,8 +749,14 @@ pci_mmap_resource(struct kobject *kobj,
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
-	if (!pci_mmap_fits(pdev, i, vma))
+	if (!pci_mmap_fits(pdev, i, vma, PCI_MMAP_SYSFS)) {
+		WARN(1, "process \"%s\" tried to map 0x%08lx bytes "
+			"at page 0x%08lx on %s BAR %d (start 0x%16Lx, size 0x%16Lx)\n",
+			current->comm, vma->vm_end-vma->vm_start, vma->vm_pgoff,
+			pci_name(pdev), i,
+			pci_resource_start(pdev, i), pci_resource_len(pdev, i));
 		return -EINVAL;
+	}
 
 	/* pci_mmap_page_range() expects the same kind of entry as coming
 	 * from /proc/bus/pci/ which is a "user visible" value. If this is
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -22,8 +22,13 @@ extern void pci_remove_firmware_label_fi
 #endif
 extern void pci_cleanup_rom(struct pci_dev *dev);
 #ifdef HAVE_PCI_MMAP
+enum pci_mmap_api {
+	PCI_MMAP_SYSFS,	/* mmap on /sys/bus/pci/devices/<BDF>/resource<N> */
+	PCI_MMAP_PROCFS	/* mmap on /proc/bus/pci/<BDF> */
+};
 extern int pci_mmap_fits(struct pci_dev *pdev, int resno,
-			 struct vm_area_struct *vma);
+			 struct vm_area_struct *vmai,
+			 enum pci_mmap_api mmap_api);
 #endif
 int pci_probe_reset_function(struct pci_dev *dev);
 
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -260,7 +260,7 @@ static int proc_bus_pci_mmap(struct file
 
 	/* Make sure the caller is mapping a real resource for this device */
 	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
-		if (pci_mmap_fits(dev, i, vma))
+		if (pci_mmap_fits(dev, i, vma,  PCI_MMAP_PROCFS))
 			break;
 	}
 


