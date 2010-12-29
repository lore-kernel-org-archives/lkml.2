Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0L2VVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:21:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60445 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0L2VVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Wz8VFrW97mTJGW9CXEIhaCGyVzLFmTbNem7ymMnkpGW7q+K6mpN6L0GIN0J28TuKkp
         Y4IadeEzmtebVqjHpuf7/jcBOv1mS9O1pYwX3y+ZlCGkYd+8cJiTyTyynbJrWIF20sR3
         FczJGWI7Dmf7mMSjpzFVkWyJGyevw/3SdRPgg=
MIME-Version: 1.0
Date: Thu, 30 Dec 2010 06:21:46 +0900
Message-ID: <AANLkTindXiXSozMp5NRkTUV0P6z7OcrDY=cX_EJO4tHP@mail.gmail.com>
Subject: [PATCH 2/4] elf core: Remove unused functions
From: HATAYAMA Daisuke <d.hatayama@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, jdike@addtoit.com, dhowells@redhat.com,
        gerg@snapgear.com, roland@redhat.com, oleg@redhat.com, mingo@elte.hu,
        viro@zeniv.linux.org.uk, andi@firstfloor.org, alan@lxorguk.ukuu.org.uk,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, suzuki@in.ibm.com,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused function to calculate vma data size.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/ia64/kernel/elfcore.c |   16 ----------------
 arch/um/sys-i386/elfcore.c |   16 ----------------
 fs/binfmt_elf.c            |   12 ------------
 fs/binfmt_elf_fdpic.c      |   11 -----------
 include/linux/elfcore.h    |    1 -
 kernel/elfcore.c           |    5 -----
 6 files changed, 0 insertions(+), 61 deletions(-)

diff --git a/arch/ia64/kernel/elfcore.c b/arch/ia64/kernel/elfcore.c
index bac1639..57a2298 100644
--- a/arch/ia64/kernel/elfcore.c
+++ b/arch/ia64/kernel/elfcore.c
@@ -62,19 +62,3 @@ int elf_core_write_extra_data(struct file *file,
size_t *size,
 	}
 	return 1;
 }
-
-size_t elf_core_extra_data_size(void)
-{
-	const struct elf_phdr *const gate_phdrs =
-		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
-	int i;
-	size_t size = 0;
-
-	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {
-		if (gate_phdrs[i].p_type == PT_LOAD) {
-			size += PAGE_ALIGN(gate_phdrs[i].p_memsz);
-			break;
-		}
-	}
-	return size;
-}
diff --git a/arch/um/sys-i386/elfcore.c b/arch/um/sys-i386/elfcore.c
index 6bb49b6..30cac52 100644
--- a/arch/um/sys-i386/elfcore.c
+++ b/arch/um/sys-i386/elfcore.c
@@ -65,19 +65,3 @@ int elf_core_write_extra_data(struct file *file,
size_t *size,
 	}
 	return 1;
 }
-
-size_t elf_core_extra_data_size(void)
-{
-	if ( vsyscall_ehdr ) {
-		const struct elfhdr *const ehdrp =
-			(struct elfhdr *)vsyscall_ehdr;
-		const struct elf_phdr *const phdrp =
-			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
-		int i;
-
-		for (i = 0; i < ehdrp->e_phnum; ++i)
-			if (phdrp[i].p_type == PT_LOAD)
-				return (size_t) phdrp[i].p_filesz;
-	}
-	return 0;
-}
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 5ab062c..f311276 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1861,18 +1861,6 @@ static void fill_extnum_info(struct elfhdr
*elf, struct elf_shdr *shdr4extnum,
 	shdr4extnum->sh_info = segs;
 }

-static size_t elf_core_vma_data_size(struct vm_area_struct *gate_vma,
-				     unsigned long mm_flags)
-{
-	struct vm_area_struct *vma;
-	size_t size = 0;
-
-	for (vma = first_vma(current, gate_vma); vma != NULL;
-	     vma = next_vma(vma, gate_vma))
-		size += vma_dump_size(vma, mm_flags);
-	return size;
-}
-
 /*
  * Actual dumper
  *
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 9ff6bef..715d12d 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1582,17 +1582,6 @@ static int elf_fdpic_dump_segments(struct file
*file, size_t *size,
 }
 #endif

-static size_t elf_core_vma_data_size(unsigned long mm_flags)
-{
-	struct vm_area_struct *vma;
-	size_t size = 0;
-
-	for (vma = current->mm->mmap; vma; vma = vma->vm_next)
-		if (maydump(vma, mm_flags))
-			size += vma->vm_end - vma->vm_start;
-	return size;
-}
-
 /*
  * Actual dumper
  *
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 394a3e0..1f096d4 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -164,7 +164,6 @@ elf_core_write_extra_phdrs(struct file *file,
loff_t offset, size_t *size,
 			   unsigned long limit);
 extern int
 elf_core_write_extra_data(struct file *file, size_t *size, unsigned
long limit);
-extern size_t elf_core_extra_data_size(void);

 #endif /* __KERNEL__ */

diff --git a/kernel/elfcore.c b/kernel/elfcore.c
index ff915ef..5445741 100644
--- a/kernel/elfcore.c
+++ b/kernel/elfcore.c
@@ -21,8 +21,3 @@ int __weak elf_core_write_extra_data(struct file
*file, size_t *size,
 {
 	return 1;
 }
-
-size_t __weak elf_core_extra_data_size(void)
-{
-	return 0;
-}
-- 
1.7.1
