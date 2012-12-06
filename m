Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424247Ab2LFQMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:12:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55812 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424190Ab2LFQMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:12:08 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kexec@lists.infradead.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [RFC PATCH 5/8] mm, vmalloc: iterate vmap_area_list in get_vmalloc_info()
Date: Fri,  7 Dec 2012 01:09:32 +0900
Message-Id: <1354810175-4338-6-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354810175-4338-1-git-send-email-js1304@gmail.com>
References: <1354810175-4338-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparing step for removing vmlist entirely.
For above purpose, we change iterating a vmap_list codes to iterating a
vmap_area_list. It is somewhat trivial change, but just one thing
should be noticed.

vmlist is lack of information about some areas in vmalloc address space.
For example, vm_map_ram() allocate area in vmalloc address space,
but it doesn't make a link with vmlist. To provide full information about
vmalloc address space is better idea, so we don't use va->vm and use
vmap_area directly.
This makes get_vmalloc_info() more precise.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d21167f..f7f4a35 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2668,46 +2668,47 @@ module_init(proc_vmalloc_init);
 
 void get_vmalloc_info(struct vmalloc_info *vmi)
 {
-	struct vm_struct *vma;
+	struct vmap_area *va;
 	unsigned long free_area_size;
 	unsigned long prev_end;
 
 	vmi->used = 0;
+	vmi->largest_chunk = 0;
 
-	if (!vmlist) {
-		vmi->largest_chunk = VMALLOC_TOTAL;
-	} else {
-		vmi->largest_chunk = 0;
+	prev_end = VMALLOC_START;
 
-		prev_end = VMALLOC_START;
+	spin_lock(&vmap_area_lock);
 
-		read_lock(&vmlist_lock);
+	if (list_empty(&vmap_area_list)) {
+		vmi->largest_chunk = VMALLOC_TOTAL;
+		goto out;
+	}
 
-		for (vma = vmlist; vma; vma = vma->next) {
-			unsigned long addr = (unsigned long) vma->addr;
+	list_for_each_entry(va, &vmap_area_list, list) {
+		unsigned long addr = va->va_start;
 
-			/*
-			 * Some archs keep another range for modules in vmlist
-			 */
-			if (addr < VMALLOC_START)
-				continue;
-			if (addr >= VMALLOC_END)
-				break;
+		/*
+		 * Some archs keep another range for modules in vmalloc space
+		 */
+		if (addr < VMALLOC_START)
+			continue;
+		if (addr >= VMALLOC_END)
+			break;
 
-			vmi->used += vma->size;
+		vmi->used += (va->va_end - va->va_start);
 
-			free_area_size = addr - prev_end;
-			if (vmi->largest_chunk < free_area_size)
-				vmi->largest_chunk = free_area_size;
+		free_area_size = addr - prev_end;
+		if (vmi->largest_chunk < free_area_size)
+			vmi->largest_chunk = free_area_size;
 
-			prev_end = vma->size + addr;
-		}
+		prev_end = va->va_end;
+	}
 
-		if (VMALLOC_END - prev_end > vmi->largest_chunk)
-			vmi->largest_chunk = VMALLOC_END - prev_end;
+	if (VMALLOC_END - prev_end > vmi->largest_chunk)
+		vmi->largest_chunk = VMALLOC_END - prev_end;
 
-		read_unlock(&vmlist_lock);
-	}
+out:
+	spin_unlock(&vmap_area_lock);
 }
 #endif
 
-- 
1.7.9.5

