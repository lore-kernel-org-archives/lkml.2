Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0INMvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:51:19 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:29588 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab0INMuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:50:52 -0400
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Sep 2010 08:50:52 EDT
X-Spam-Processed: digidescorp.com, Tue, 14 Sep 2010 07:42:58 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=18730c7c8b=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] nommu: add anonymous page memcg accounting
Date: Tue, 14 Sep 2010 07:42:49 -0500
Message-Id: <1284468169-9037-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary calls to track VM anonymous page usage.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/mm/nommu.c b/mm/nommu.c
--- a/mm/nommu.c	2010-09-02 19:47:43.000000000 -0500
+++ b/mm/nommu.c	2010-09-02 20:07:02.000000000 -0500
@@ -524,8 +524,10 @@ static void delete_nommu_region(struct v
 /*
  * free a contiguous series of pages
  */
-static void free_page_series(unsigned long from, unsigned long to)
+static void free_page_series(unsigned long from, unsigned long to,
+			     const struct file *file)
 {
+	mem_cgroup_uncharge_start();
 	for (; from < to; from += PAGE_SIZE) {
 		struct page *page = virt_to_page(from);
 
@@ -534,8 +536,12 @@ static void free_page_series(unsigned lo
 		if (page_count(page) != 1)
 			kdebug("free page %p: refcount not one: %d",
 			       page, page_count(page));
+		if (!file)
+			mem_cgroup_uncharge_page(page);
+
 		put_page(page);
 	}
+	mem_cgroup_uncharge_end();
 }
 
 /*
@@ -563,7 +569,8 @@ static void __put_nommu_region(struct vm
 		 * from ramfs/tmpfs mustn't be released here */
 		if (region->vm_flags & VM_MAPPED_COPY) {
 			kdebug("free series");
-			free_page_series(region->vm_start, region->vm_top);
+			free_page_series(region->vm_start, region->vm_top,
+					 region->vm_file);
 		}
 		kmem_cache_free(vm_region_jar, region);
 	} else {
@@ -1117,9 +1124,26 @@ static int do_mmap_private(struct vm_are
 		set_page_refcounted(&pages[point]);
 
 	base = page_address(pages);
-	region->vm_flags = vma->vm_flags |= VM_MAPPED_COPY;
+
 	region->vm_start = (unsigned long) base;
 	region->vm_end   = region->vm_start + rlen;
+
+	if (!vma->vm_file) {
+		for (point = 0; point < total; point++) {
+			int charge_failed =
+				mem_cgroup_newpage_charge(&pages[point],
+							  current->mm,
+							  GFP_KERNEL);
+			if (charge_failed) {
+				free_page_series(region->vm_start,
+						 region->vm_end, NULL);
+				region->vm_start = region->vm_end = 0;
+				goto enomem;
+			}
+		}
+	}
+
+	region->vm_flags = vma->vm_flags |= VM_MAPPED_COPY;
 	region->vm_top   = region->vm_start + (total << PAGE_SHIFT);
 
 	vma->vm_start = region->vm_start;
@@ -1150,7 +1174,7 @@ static int do_mmap_private(struct vm_are
 	return 0;
 
 error_free:
-	free_page_series(region->vm_start, region->vm_end);
+	free_page_series(region->vm_start, region->vm_end, vma->vm_file);
 	region->vm_start = vma->vm_start = 0;
 	region->vm_end   = vma->vm_end = 0;
 	region->vm_top   = 0;
@@ -1555,7 +1579,7 @@ static int shrink_vma(struct mm_struct *
 	add_nommu_region(region);
 	up_write(&nommu_region_sem);
 
-	free_page_series(from, to);
+	free_page_series(from, to, vma->vm_file);
 	return 0;
 }
 

