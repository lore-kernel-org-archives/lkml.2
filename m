Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0J3Q7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 12:59:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab0J3Q7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 12:59:45 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/5] vfio: Fix requested regions
To: pugs@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, chrisw@redhat.com, mst@redhat.com,
        alex.williamson@redhat.com
Date: Sat, 30 Oct 2010 10:59:23 -0600
Message-ID: <20101030165917.885.98984.stgit@s20.home>
In-Reply-To: <20101030164626.885.89216.stgit@s20.home>
References: <20101030164626.885.89216.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've already got a more descriptive name than "vfio" in vfio->name,
use it.  We also need to request regions for resources that are
only mmap'd.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/vfio_main.c |   12 ++++++++++++
 drivers/vfio/vfio_rdwr.c |    4 ++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 3b7d352..f671795 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -316,6 +316,18 @@ static int vfio_mmap(struct file *filep, struct vm_area_struct *vma)
 	if (requested > actual || actual == 0)
 		return -EINVAL;
 
+	/*
+	 * Even though we don't make use of the barmap for the mmap,
+	 * we need to request the region and the barmap tracks that.
+	 */
+	if (!vdev->barmap[pci_space]) {
+		ret = pci_request_selected_regions(pdev, (1 << pci_space),
+						   vdev->name);
+		if (ret)
+			return ret;
+		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
+	}
+
 	start = vma->vm_pgoff << PAGE_SHIFT;
 	len = vma->vm_end - vma->vm_start;
 	if (allow_unsafe_intrs && (vma->vm_flags & VM_WRITE)) {
diff --git a/drivers/vfio/vfio_rdwr.c b/drivers/vfio/vfio_rdwr.c
index b75bf92..83ae38a 100644
--- a/drivers/vfio/vfio_rdwr.c
+++ b/drivers/vfio/vfio_rdwr.c
@@ -67,7 +67,7 @@ ssize_t vfio_io_readwrite(
 		int ret;
 
 		ret = pci_request_selected_regions(pdev,
-			(1 << pci_space), "vfio");
+			(1 << pci_space), vdev->name);
 		if (ret)
 			return ret;
 		vdev->barmap[pci_space] = pci_iomap(pdev, pci_space, 0);
@@ -164,7 +164,7 @@ ssize_t vfio_mem_readwrite(
 			int ret;
 
 			ret = pci_request_selected_regions(pdev,
-				(1 << pci_space), "vfio");
+				(1 << pci_space), vdev->name);
 			if (ret)
 				return ret;
 			vdev->barmap[pci_space] =

