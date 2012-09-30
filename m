Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab2I3X00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 19:26:26 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:38243 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab2I3X0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 19:26:24 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2012 19:26:24 EDT
Date: Sun, 30 Sep 2012 17:26:19 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] PPC: Do not make the entire heap executable
Message-ID: <20120930232619.GE30637@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PPC the ELF PLT sections look like this:

  [17] .sbss             NOBITS          0002aff8 01aff8 000014 00  WA  0   0  4
  [18] .plt              NOBITS          0002b00c 01aff8 000084 00 WAX  0   0  4
  [19] .bss              NOBITS          0002b090 01aff8 0000a4 00  WA  0   0  4

Which results in an ELF load header:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x019c70 0x00029c70 0x00029c70 0x01388 0x014c4 RWE 0x10000

This is all correct, the load region containing the PLT is marked as
executable. Note that the PLT starts at 0002b00c but the file mapping ends at
0002aff8, so the PLT falls in the 0 fill section described by the load header,
and after a page boundary.

Unfortunately the generic ELF loader ignores the X bit in the load headers
when it creates the 0 filled non-file backed mappings. It assumes all of these
mappings are RW BSS sections, which is not the case for PPC.

Teach the ELF loader to check the X bit in the relevant load header and
create 0 filled anonymous mappings that are executable if the load header
requests that.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 arch/powerpc/include/asm/page.h    |   10 +--------
 arch/powerpc/include/asm/page_32.h |    2 -
 arch/powerpc/include/asm/page_64.h |    4 ---
 fs/binfmt_elf.c                    |   37 ++++++++++++++++++++++++++++-------
 4 files changed, 30 insertions(+), 23 deletions(-)

Please consider this a proposal to solve this issue.. 

diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index f072e97..61e46fc 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -215,15 +215,7 @@ extern long long virt_phys_offset;
 #define __pa(x) ((unsigned long)(x) - PAGE_OFFSET + MEMORY_START)
 #endif
 
-/*
- * Unfortunately the PLT is in the BSS in the PPC32 ELF ABI,
- * and needs to be executable.  This means the whole heap ends
- * up being executable.
- */
-#define VM_DATA_DEFAULT_FLAGS32	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-
-#define VM_DATA_DEFAULT_FLAGS64	(VM_READ | VM_WRITE | \
+#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #ifdef __powerpc64__
diff --git a/arch/powerpc/include/asm/page_32.h b/arch/powerpc/include/asm/page_32.h
index 68d73b2..aaae5a6 100644
--- a/arch/powerpc/include/asm/page_32.h
+++ b/arch/powerpc/include/asm/page_32.h
@@ -7,8 +7,6 @@
 #endif
 #endif
 
-#define VM_DATA_DEFAULT_FLAGS	VM_DATA_DEFAULT_FLAGS32
-
 #ifdef CONFIG_NOT_COHERENT_CACHE
 #define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 #endif
diff --git a/arch/powerpc/include/asm/page_64.h b/arch/powerpc/include/asm/page_64.h
index fed85e6..615d88b 100644
--- a/arch/powerpc/include/asm/page_64.h
+++ b/arch/powerpc/include/asm/page_64.h
@@ -136,10 +136,6 @@ do {						\
 
 #endif /* !CONFIG_HUGETLB_PAGE */
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(is_32bit_task() ? \
-	 VM_DATA_DEFAULT_FLAGS32 : VM_DATA_DEFAULT_FLAGS64)
-
 /*
  * This is the default if a program doesn't have a PT_GNU_STACK
  * program header entry. The PPC64 ELF ABI has a non executable stack
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 1b52956..e5a432b 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -76,13 +76,20 @@ static struct linux_binfmt elf_format = {
 
 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
 
-static int set_brk(unsigned long start, unsigned long end)
+static int set_brk(unsigned long start, unsigned long end, int prot)
 {
 	start = ELF_PAGEALIGN(start);
 	end = ELF_PAGEALIGN(end);
 	if (end > start) {
 		unsigned long addr;
-		addr = vm_brk(start, end - start);
+		/* Map the non-file portion of the last load header. If the
+		   header is requesting these pages to be executeable then
+		   we have to honour that, otherwise assume they are bss. */
+		if (prot & PROT_EXEC)
+			addr = vm_mmap(0, start, end - start, prot,
+				MAP_PRIVATE | MAP_FIXED, 0);
+		else
+			addr = vm_brk(start, end - start);
 		if (BAD_ADDR(addr))
 			return addr;
 	}
@@ -381,6 +388,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 	unsigned long load_addr = 0;
 	int load_addr_set = 0;
 	unsigned long last_bss = 0, elf_bss = 0;
+	int bss_prot = 0;
 	unsigned long error = ~0UL;
 	unsigned long total_size;
 	int retval, i, size;
@@ -489,8 +497,10 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 			 * elf_bss and last_bss is the bss section.
 			 */
 			k = load_addr + eppnt->p_memsz + eppnt->p_vaddr;
-			if (k > last_bss)
+			if (k > last_bss) {
 				last_bss = k;
+				bss_prot = elf_prot;
+			}
 		}
 	}
 
@@ -509,8 +519,15 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 		/* What we have mapped so far */
 		elf_bss = ELF_PAGESTART(elf_bss + ELF_MIN_ALIGN - 1);
 
-		/* Map the last of the bss segment */
-		error = vm_brk(elf_bss, last_bss - elf_bss);
+		/* Map the non-file portion of the last load header. If the
+		   header is requesting these pages to be executeable then
+		   we have to honour that, otherwise assume they are bss. */
+		if (bss_prot & PROT_EXEC)
+			error = vm_mmap(0, elf_bss, last_bss - elf_bss,
+					bss_prot, MAP_PRIVATE | MAP_FIXED, 0);
+		else
+			error = vm_brk(elf_bss, last_bss - elf_bss);
+
 		if (BAD_ADDR(error))
 			goto out_close;
 	}
@@ -560,6 +577,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata;
 	unsigned long elf_bss, elf_brk;
+	int bss_prot = 0;
 	int retval, i;
 	unsigned int size;
 	unsigned long elf_entry;
@@ -750,7 +768,8 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			   before this one. Map anonymous pages, if needed,
 			   and clear the area.  */
 			retval = set_brk(elf_bss + load_bias,
-					 elf_brk + load_bias);
+					 elf_brk + load_bias,
+					 bss_prot);
 			if (retval) {
 				send_sig(SIGKILL, current, 0);
 				goto out_free_dentry;
@@ -852,8 +871,10 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		if (end_data < k)
 			end_data = k;
 		k = elf_ppnt->p_vaddr + elf_ppnt->p_memsz;
-		if (k > elf_brk)
+		if (k > elf_brk) {
+			bss_prot = elf_prot;
 			elf_brk = k;
+		}
 	}
 
 	loc->elf_ex.e_entry += load_bias;
@@ -869,7 +890,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	 * mapping in the interpreter, to make sure it doesn't wind
 	 * up getting placed where the bss needs to go.
 	 */
-	retval = set_brk(elf_bss, elf_brk);
+	retval = set_brk(elf_bss, elf_brk, bss_prot);
 	if (retval) {
 		send_sig(SIGKILL, current, 0);
 		goto out_free_dentry;
-- 
1.7.4.1

