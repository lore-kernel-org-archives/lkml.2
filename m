Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab0JAHJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:09:46 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45863 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab0JAHGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:24 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 03/18] powerpc: Support parsing a little endian kernel from zImage wrapper
Date: Fri,  1 Oct 2010 17:05:56 +1000
Message-Id: <1285916771-18033-4-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch adds support to the PowerPC zImage wrapper (which always runs
in big endian mode) to detect if the zImage is little endian and parse
it's ELF header to enable it's successful extraction.

It also provides some infrastructure for executing a little endian
kernel - PowerPC platforms that support little endian should fill
platform_ops.le_kentry with a function pointer to the routine
responsible for switching the CPU to little endian and executing the
kernel. This routing takes the same arguments in the same positions as
kentry to allow them to easily be passed onto the kernel, with the
kentry pointer itself tacked on as argument 4.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/boot/elf.h       |    2 +-
 arch/powerpc/boot/elf_util.c  |   48 +++++++++++++++++++++++++++++++++++++---
 arch/powerpc/boot/main.c      |   26 +++++++++++++++++-----
 arch/powerpc/boot/ops.h       |    3 ++
 arch/powerpc/boot/prpmc2800.c |    5 +++-
 arch/powerpc/boot/swab.h      |   26 ++++++++++++++++++++++
 6 files changed, 98 insertions(+), 12 deletions(-)
 create mode 100644 arch/powerpc/boot/swab.h

diff --git a/arch/powerpc/boot/elf.h b/arch/powerpc/boot/elf.h
index 1941bc5..9de8105 100644
--- a/arch/powerpc/boot/elf.h
+++ b/arch/powerpc/boot/elf.h
@@ -152,6 +152,6 @@ struct elf_info {
 	unsigned long elfoffset;
 };
 int parse_elf64(void *hdr, struct elf_info *info);
-int parse_elf32(void *hdr, struct elf_info *info);
+int parse_elf32(void *hdr, struct elf_info *info, int *little_endian);
 
 #endif				/* _PPC_BOOT_ELF_H_ */
diff --git a/arch/powerpc/boot/elf_util.c b/arch/powerpc/boot/elf_util.c
index 1567a0c..67bba80 100644
--- a/arch/powerpc/boot/elf_util.c
+++ b/arch/powerpc/boot/elf_util.c
@@ -14,6 +14,7 @@
 #include "page.h"
 #include "string.h"
 #include "stdio.h"
+#include "swab.h"
 
 int parse_elf64(void *hdr, struct elf_info *info)
 {
@@ -47,7 +48,35 @@ int parse_elf64(void *hdr, struct elf_info *info)
 	return 1;
 }
 
-int parse_elf32(void *hdr, struct elf_info *info)
+void byteswap_elf32(Elf32_Ehdr *elf32) {
+	Elf32_Phdr *elf32ph;
+
+	swab16s(&elf32->e_type);
+	swab16s(&elf32->e_machine);
+	swab32s(&elf32->e_version);
+	swab32s(&elf32->e_entry);
+	swab32s(&elf32->e_phoff);
+	swab32s(&elf32->e_shoff);
+	swab32s(&elf32->e_flags);
+	swab16s(&elf32->e_ehsize);
+	swab16s(&elf32->e_phentsize);
+	swab16s(&elf32->e_phnum);
+	swab16s(&elf32->e_shentsize);
+	swab16s(&elf32->e_shnum);
+	swab16s(&elf32->e_shstrndx);
+
+	elf32ph = (Elf32_Phdr *) ((unsigned long)elf32 + elf32->e_phoff);
+	swab32s(&elf32ph->p_type);
+	swab32s(&elf32ph->p_offset);
+	swab32s(&elf32ph->p_vaddr);
+	swab32s(&elf32ph->p_paddr);
+	swab32s(&elf32ph->p_filesz);
+	swab32s(&elf32ph->p_memsz);
+	swab32s(&elf32ph->p_flags);
+	swab32s(&elf32ph->p_align);
+}
+
+int parse_elf32(void *hdr, struct elf_info *info, int *little_endian)
 {
 	Elf32_Ehdr *elf32 = hdr;
 	Elf32_Phdr *elf32ph;
@@ -57,9 +86,20 @@ int parse_elf32(void *hdr, struct elf_info *info)
 	      elf32->e_ident[EI_MAG1]  == ELFMAG1	&&
 	      elf32->e_ident[EI_MAG2]  == ELFMAG2	&&
 	      elf32->e_ident[EI_MAG3]  == ELFMAG3	&&
-	      elf32->e_ident[EI_CLASS] == ELFCLASS32	&&
-	      elf32->e_ident[EI_DATA]  == ELFDATA2MSB	&&
-	      (elf32->e_type            == ET_EXEC ||
+	      elf32->e_ident[EI_CLASS] == ELFCLASS32))
+		return 0;
+	switch(elf32->e_ident[EI_DATA]) {
+		case ELFDATA2MSB:
+			*little_endian = 0;
+			break;
+		case ELFDATA2LSB:
+			*little_endian = 1;
+			byteswap_elf32(elf32);
+			break;
+		default:
+			return 0;
+	}
+	if (!((elf32->e_type            == ET_EXEC ||
 	       elf32->e_type            == ET_DYN)      &&
 	      elf32->e_machine         == EM_PPC))
 		return 0;
diff --git a/arch/powerpc/boot/main.c b/arch/powerpc/boot/main.c
index a28f021..36dd2b6 100644
--- a/arch/powerpc/boot/main.c
+++ b/arch/powerpc/boot/main.c
@@ -27,7 +27,7 @@ struct addr_range {
 
 #undef DEBUG
 
-static struct addr_range prep_kernel(void)
+static struct addr_range prep_kernel(int *little_endian)
 {
 	char elfheader[256];
 	void *vmlinuz_addr = _vmlinux_start;
@@ -40,8 +40,10 @@ static struct addr_range prep_kernel(void)
 	gunzip_start(&gzstate, vmlinuz_addr, vmlinuz_size);
 	gunzip_exactly(&gzstate, elfheader, sizeof(elfheader));
 
-	if (!parse_elf64(elfheader, &ei) && !parse_elf32(elfheader, &ei))
+	if (!parse_elf64(elfheader, &ei) && !parse_elf32(elfheader, &ei, little_endian))
 		fatal("Error: not a valid PPC32 or PPC64 ELF file!\n\r");
+	if (*little_endian && !platform_ops.le_kentry)
+		fatal("Little Endian kernel unsupported on this platform!");
 
 	if (platform_ops.image_hdr)
 		platform_ops.image_hdr(elfheader);
@@ -166,8 +168,10 @@ void start(void)
 {
 	struct addr_range vmlinux, initrd;
 	kernel_entry_t kentry;
+	le_kernel_entry_t le_kentry;
 	unsigned long ft_addr = 0;
 	void *chosen;
+	int little_endian = 0;
 
 	/* Do this first, because malloc() could clobber the loader's
 	 * command line.  Only use the loader command line if a
@@ -189,7 +193,7 @@ void start(void)
 	if (!chosen)
 		chosen = create_node(NULL, "chosen");
 
-	vmlinux = prep_kernel();
+	vmlinux = prep_kernel(&little_endian);
 	initrd = prep_initrd(vmlinux, chosen,
 			     loader_info.initrd_addr, loader_info.initrd_size);
 	prep_cmdline(chosen);
@@ -206,11 +210,21 @@ void start(void)
 		console_ops.close();
 
 	kentry = (kernel_entry_t) vmlinux.addr;
+	le_kentry = (le_kernel_entry_t)platform_ops.le_kentry;
 	if (ft_addr)
-		kentry(ft_addr, 0, NULL);
+		if (little_endian)
+			le_kentry(ft_addr, 0, NULL, kentry);
+		else
+			kentry(ft_addr, 0, NULL);
 	else
-		kentry((unsigned long)initrd.addr, initrd.size,
-		       loader_info.promptr);
+		if (little_endian)
+			le_kentry((unsigned long)initrd.addr, initrd.size,
+			       loader_info.promptr, kentry);
+		else
+			kentry((unsigned long)initrd.addr, initrd.size,
+			       loader_info.promptr);
+
+	kentry(ft_addr, 0, NULL);
 
 	/* console closed so printf in fatal below may not work */
 	fatal("Error: Linux kernel returned to zImage boot wrapper!\n\r");
diff --git a/arch/powerpc/boot/ops.h b/arch/powerpc/boot/ops.h
index b3218ce..cd6c7bf 100644
--- a/arch/powerpc/boot/ops.h
+++ b/arch/powerpc/boot/ops.h
@@ -20,6 +20,8 @@
 #define	MAX_PROP_LEN		256 /* What should this be? */
 
 typedef void (*kernel_entry_t)(unsigned long r3, unsigned long r4, void *r5);
+typedef void (*le_kernel_entry_t)(unsigned long r3, unsigned long r4, void *r5,
+				  kernel_entry_t kentry);
 
 /* Platform specific operations */
 struct platform_ops {
@@ -30,6 +32,7 @@ struct platform_ops {
 	void *	(*realloc)(void *ptr, unsigned long size);
 	void	(*exit)(void);
 	void *	(*vmlinux_alloc)(unsigned long size);
+	le_kernel_entry_t le_kentry;
 };
 extern struct platform_ops platform_ops;
 
diff --git a/arch/powerpc/boot/prpmc2800.c b/arch/powerpc/boot/prpmc2800.c
index da31d60..6bad899 100644
--- a/arch/powerpc/boot/prpmc2800.c
+++ b/arch/powerpc/boot/prpmc2800.c
@@ -519,6 +519,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	void *vmlinuz_addr = _vmlinux_start;
 	unsigned long vmlinuz_size = _vmlinux_end - _vmlinux_start;
 	char elfheader[256];
+	int little_endian;
 
 	if (dt_size <= 0) /* No fdt */
 		exit();
@@ -533,7 +534,9 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	gunzip_start(&gzstate, vmlinuz_addr, vmlinuz_size);
 	gunzip_exactly(&gzstate, elfheader, sizeof(elfheader));
 
-	if (!parse_elf32(elfheader, &ei))
+	if (!parse_elf32(elfheader, &ei, &little_endian))
+		exit();
+	if (little_endian)
 		exit();
 
 	heap_start = (char *)(ei.memsize + ei.elfoffset); /* end of kernel*/
diff --git a/arch/powerpc/boot/swab.h b/arch/powerpc/boot/swab.h
new file mode 100644
index 0000000..b122c2d
--- /dev/null
+++ b/arch/powerpc/boot/swab.h
@@ -0,0 +1,26 @@
+#ifndef _SWAB_H_
+#define _SWAB_H_
+
+#include "types.h"
+
+static __inline__ void st_le16(volatile u16 *addr, const u16 val)
+{
+	__asm__ __volatile__ ("sthbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
+}
+
+static inline void swab16s(u16 *addr)
+{
+	st_le16(addr, *addr);
+}
+
+static __inline__ void st_le32(volatile u32 *addr, const u32 val)
+{
+	__asm__ __volatile__ ("stwbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
+}
+
+static inline void swab32s(u32 *addr)
+{
+	st_le32(addr, *addr);
+}
+
+#endif
-- 
1.7.1

