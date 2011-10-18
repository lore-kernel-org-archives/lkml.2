Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1JRHwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:52:12 -0400
Received: from smail6.alcatel.fr ([64.208.49.42]:47777 "EHLO smail6.alcatel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757253Ab1JRHwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:52:08 -0400
Message-ID: <4E9D3020.5070404@alcatel-lucent.com>
Date: Tue, 18 Oct 2011 09:52:00 +0200
From: Thanh-Lam NGUYEN <thanh-lam.nguyen@alcatel-lucent.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf.c: core file shrinking
References: <4E946279.8090800@alcatel-lucent.com>
In-Reply-To: <4E946279.8090800@alcatel-lucent.com>
Content-Type: multipart/mixed;
 boundary="------------030107020901060302090300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030107020901060302090300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here is the patch with the fix on the variable name.
To be sure that the mailer does not screw the patch, it is attached and
not inlined.

-- 
=~=~=~=~=~=~=~=~=~=~=~=~==~=~=~=~=~=~=~=~=~=~=~=~=~=~=
Thanh lam NGUYEN
Prestataire externe ALTEN        | ALTEN Subcontractor
pour ALCATEL-LUCENT              | in ALCATEL-LUCENT

Equipe/Team: SWINT
email: tlnguyen@webmail.alten.fr

--------------030107020901060302090300
Content-Type: text/plain;
 name="vma_shrink.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="vma_shrink.patch"

The vma_shrink function looks for the 1st allocated and the last allocated page.
Only this part is dumped to the disk (the virual start address and the size are
updated to reflect the new dumped information).

Signed-off-by: Thanh Lam NGUYEN <thanh-lam.nguyen@alcatel-lucent.com>
Signed-off-by: Benjamin ZORES <Benjamin.Zores@alcatel-lucent.com>
---
 linux/fs/binfmt_elf.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

--- linux/fs/binfmt_elf.c
+++ linux/fs/binfmt_elf.c
@@ -1085,6 +1085,48 @@
  * Jeremy Fitzhardinge <jeremy@sw.oz.au>
  */

+/*
+ * Search for 1st and last allocated page from vma_start to vma_end.
+ * Update vma_start and vma_end to reflect the result.
+ */
+void vma_shrink(struct vm_area_struct *vma, unsigned long *vma_start,
+		unsigned long *vma_end)
+{
+	int allocated;
+	unsigned long start, addr, end;
+
+	allocated = 0;
+	start = end = *vma_start;
+	for (addr = *vma_start; addr < *vma_end; addr += PAGE_SIZE) {
+		struct page *page;
+		if (get_user_pages(current, current->mm, addr, 1, 0, 1,
+				   &page, NULL) <= 0) {
+			/* NO PAGE */
+			if (!allocated)
+				start = addr;
+		} else {
+			if (page == ZERO_PAGE(0)) {
+				/* ZERO PAGE */
+				if (!allocated)
+					start = addr;
+			} else {
+				/* ALLOCATED PAGE */
+				if (!allocated)
+					start = addr;
+				end = addr;
+				allocated = 1;
+			}
+			page_cache_release(page);
+		}
+	}
+	if (end < start)
+		end = start;
+	if (allocated)
+		end += PAGE_SIZE;
+	*vma_start = start;
+	*vma_end = end;
+}
+
 /*
  * Decide what to dump of a segment, part, all or none.
  */
@@ -1980,13 +2022,19 @@ static int elf_core_dump(struct coredump_params *cprm)
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
 		struct elf_phdr phdr;
+		unsigned long start = vma->vm_start;
+		unsigned long end = vma->vm_end;
 
 		phdr.p_type = PT_LOAD;
 		phdr.p_offset = offset;
-		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
 		phdr.p_filesz = vma_dump_size(vma, cprm->mm_flags);
-		phdr.p_memsz = vma->vm_end - vma->vm_start;
+		if (phdr.p_filesz) {
+			vma_shrink(vma, &start, &end);
+			phdr.p_filesz = end-start;
+		}
+		phdr.p_vaddr = start;
+		phdr.p_memsz = vma->vm_end - phdr.p_vaddr;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
 		if (vma->vm_flags & VM_WRITE)
@@ -2018,11 +2066,15 @@ static int elf_core_dump(struct coredump_params *cprm)
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 			vma = next_vma(vma, gate_vma)) {
 		unsigned long addr;
+		unsigned long start;
 		unsigned long end;
 
-		end = vma->vm_start + vma_dump_size(vma, cprm->mm_flags);
+		start = vma->vm_start;
+		end = start + vma_dump_size(vma, cprm->mm_flags);
+		if (start < end)
+			vma_shrink(vma, &start, &end);
 
-		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
+		for (addr = start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
 			int stop;
 

--------------030107020901060302090300--
