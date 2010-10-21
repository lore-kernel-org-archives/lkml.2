Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0JUIlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:41:15 -0400
Received: from dgate20.ts.fujitsu.com ([80.70.172.51]:33918 "EHLO
	dgate20.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0JUIlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:41:13 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Oct 2010 04:41:12 EDT
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Received:X-Authentication-Warning:Date:
   From:To:Subject:Cc:Message-ID:User-Agent:MIME-Version:
   Content-Type;
  b=UqNiIQvFcfls3Ip9NYNNxwi5nQQxELk+xEBk4QD+YBNa4JDxNxh2MloB
   MuOdem4SxE23fP5vngvGpzNlyxK/j2y6CEPlGJ311aKP/jNfkBY79tH5z
   BPqFkzF4sBUZAOekTHhZOlepCLKL8H3P713o89h8iGjxtjrldkpM/Fmc4
   1s+yRpVPCMe2u0pJZ/zC4HjnyYouEoK9IW1U/tvfFJ1kOoOhMmGMI/+YN
   yf7HjllO7bmuXjwpHgNr6f/Gnkrp4;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.58,216,1286143200"; 
   d="scan'208";a="48738469"
X-IronPort-AV: E=Sophos;i="4.58,216,1286143200"; 
   d="scan'208";a="101452648"
Date: Thu, 21 Oct 2010 10:38:16 +0200
From: martin.wilck@ts.fujitsu.com
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        jbarnes@virtuousgeek.org
Subject: [PATCH] fix size checks for mmap() on /proc/bus/pci files
 (resent)
Cc: gerhard.wichert@ts.fujitsu.com, martin.wilck@ts.fujitsu.com
Message-ID: <4cbffbf8.Qhs/h1a0ymU/N8ON%martin.wilck@ts.fujitsu.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_4cbffbf8.3Qsa1gI4/ms1FkUIi/Bi5ckTo9I6z6O86Vyj5kOcynWQD8Mh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--=_4cbffbf8.3Qsa1gI4/ms1FkUIi/Bi5ckTo9I6z6O86Vyj5kOcynWQD8Mh
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

(Resent because of broken recepient list in last mail - sorry.)

[PATCH] fix size checks for mmap() on /proc/bus/pci files

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

The following patch addresses all 3 issues. Please review.

Signed-off-by: Martin Wilck <Martin.Wilck@ts.fujitsu,com>

--- a/drivers/pci/pci.h.orig	2010-09-01 06:57:20.000000000 +0200
+++ a/drivers/pci/pci.h	2010-10-20 18:44:22.000000000 +0200
@@ -14,7 +14,7 @@ extern void pci_remove_sysfs_dev_files(s
 extern void pci_cleanup_rom(struct pci_dev *dev);
 #ifdef HAVE_PCI_MMAP
 extern int pci_mmap_fits(struct pci_dev *pdev, int resno,
-			 struct vm_area_struct *vma);
+			 struct vm_area_struct *vmai, int is_proc);
 #endif
 int pci_probe_reset_function(struct pci_dev *dev);
 
--- a/drivers/pci/proc.c.orig	2010-09-01 06:57:17.000000000 +0200
+++ a/drivers/pci/proc.c	2010-10-20 18:53:37.000000000 +0200
@@ -259,7 +259,7 @@ static int proc_bus_pci_mmap(struct file
 
 	/* Make sure the caller is mapping a real resource for this device */
 	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
-		if (pci_mmap_fits(dev, i, vma))
+		if (pci_mmap_fits(dev, i, vma,  1))
 			break;
 	}
 
--- linux-2.6.32-71.el6.x86_64/drivers/pci/pci-sysfs.c	2010-09-01 06:57:17.000000000 +0200
+++ linux-2.6.32-71.el6.x86_64/drivers/pci/pci-sysfs.c.new	2010-10-21 01:34:58.000000000 +0200
@@ -675,17 +675,18 @@ void pci_remove_legacy_files(struct pci_
 
 #ifdef HAVE_PCI_MMAP
 
-int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma)
+int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma, int is_proc)
 {
-	unsigned long nr, start, size;
+	unsigned long nr, start, size, pci_start;
 
+	if (pci_resource_len(pdev, resno) == 0)
+		return 0;
 	nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	start = vma->vm_pgoff;
 	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
-	if (start < size && size - start >= nr)
+	pci_start = is_proc ? pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
+	if (start >= pci_start && start < pci_start + size && start + nr <= pci_start + size)
 		return 1;
-	WARN(1, "process \"%s\" tried to map 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",
-		current->comm, start, start+nr, pci_name(pdev), resno, size);
 	return 0;
 }
 
@@ -715,8 +716,12 @@ pci_mmap_resource(struct kobject *kobj, 
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
-	if (!pci_mmap_fits(pdev, i, vma))
+	if (!pci_mmap_fits(pdev, i, vma, 0)) {
+		WARN(1, "process \"%s\" tried to map 0x%08lx bytes at page 0x%08lx on %s BAR %d (start 0x%16Lx, size 0x%16Lx)\n",
+			current->comm, vma->vm_end-vma->vm_start, vma->vm_pgoff, pci_name(pdev), i,
+			pci_resource_start(pdev, i), pci_resource_len(pdev, i));
 		return -EINVAL;
+	}
 
 	/* pci_mmap_page_range() expects the same kind of entry as coming
 	 * from /proc/bus/pci/ which is a "user visible" value. If this is

--=_4cbffbf8.3Qsa1gI4/ms1FkUIi/Bi5ckTo9I6z6O86Vyj5kOcynWQD8Mh
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="proc_pci_mmap_fits-1.patch"

[PATCH] fix size checks for mmap() on /proc/bus/pci files

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

The following patch addresses all 3 issues. Please review.

Signed-off-by: Martin Wilck <Martin.Wilck@ts.fujitsu,com>

--- a/drivers/pci/pci.h.orig	2010-09-01 06:57:20.000000000 +0200
+++ a/drivers/pci/pci.h	2010-10-20 18:44:22.000000000 +0200
@@ -14,7 +14,7 @@ extern void pci_remove_sysfs_dev_files(s
 extern void pci_cleanup_rom(struct pci_dev *dev);
 #ifdef HAVE_PCI_MMAP
 extern int pci_mmap_fits(struct pci_dev *pdev, int resno,
-			 struct vm_area_struct *vma);
+			 struct vm_area_struct *vmai, int is_proc);
 #endif
 int pci_probe_reset_function(struct pci_dev *dev);
 
--- a/drivers/pci/proc.c.orig	2010-09-01 06:57:17.000000000 +0200
+++ a/drivers/pci/proc.c	2010-10-20 18:53:37.000000000 +0200
@@ -259,7 +259,7 @@ static int proc_bus_pci_mmap(struct file
 
 	/* Make sure the caller is mapping a real resource for this device */
 	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
-		if (pci_mmap_fits(dev, i, vma))
+		if (pci_mmap_fits(dev, i, vma,  1))
 			break;
 	}
 
--- linux-2.6.32-71.el6.x86_64/drivers/pci/pci-sysfs.c	2010-09-01 06:57:17.000000000 +0200
+++ linux-2.6.32-71.el6.x86_64/drivers/pci/pci-sysfs.c.new	2010-10-21 01:34:58.000000000 +0200
@@ -675,17 +675,18 @@ void pci_remove_legacy_files(struct pci_
 
 #ifdef HAVE_PCI_MMAP
 
-int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma)
+int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vma, int is_proc)
 {
-	unsigned long nr, start, size;
+	unsigned long nr, start, size, pci_start;
 
+	if (pci_resource_len(pdev, resno) == 0)
+		return 0;
 	nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	start = vma->vm_pgoff;
 	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
-	if (start < size && size - start >= nr)
+	pci_start = is_proc ? pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
+	if (start >= pci_start && start < pci_start + size && start + nr <= pci_start + size)
 		return 1;
-	WARN(1, "process \"%s\" tried to map 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",
-		current->comm, start, start+nr, pci_name(pdev), resno, size);
 	return 0;
 }
 
@@ -715,8 +716,12 @@ pci_mmap_resource(struct kobject *kobj, 
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
-	if (!pci_mmap_fits(pdev, i, vma))
+	if (!pci_mmap_fits(pdev, i, vma, 0)) {
+		WARN(1, "process \"%s\" tried to map 0x%08lx bytes at page 0x%08lx on %s BAR %d (start 0x%16Lx, size 0x%16Lx)\n",
+			current->comm, vma->vm_end-vma->vm_start, vma->vm_pgoff, pci_name(pdev), i,
+			pci_resource_start(pdev, i), pci_resource_len(pdev, i));
 		return -EINVAL;
+	}
 
 	/* pci_mmap_page_range() expects the same kind of entry as coming
 	 * from /proc/bus/pci/ which is a "user visible" value. If this is

--=_4cbffbf8.3Qsa1gI4/ms1FkUIi/Bi5ckTo9I6z6O86Vyj5kOcynWQD8Mh--
