Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab1GDRKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:10:22 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:41602 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985Ab1GDRKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:10:06 -0400
Message-Id: <20110704170959.387574073@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Mon, 04 Jul 2011 19:09:27 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: ebiederm@xmission.com, vgoyal@redhat.com, hbabu@us.ibm.com,
        mahesh@linux.vnet.ibm.com
Cc: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 5/9] kdump: Allow vmcore ELF header to be created in new kernel
References: <20110704170922.976299676@linux.vnet.ibm.com>
Content-Disposition: inline; filename=05-s390-kdump-common-vmcore-newmem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

For s390 we create the ELF header for /proc/vmcore in the second (kdump)
kernel. Currently vmcore gets the ELF header from oldmem using the global
variable "elfcorehdr_addr". This patch introduces a new value
ELFCORE_ADDR_NEWMEM for "elfcorehdr_addr" that indicates that the ELF header
is allocated in the new kernel. In this case a new architecture function
"arch_vmcore_get_elf_hdr()" is called to obtain address and length of the
ELF header.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 fs/proc/vmcore.c           |   66 ++++++++++++++++++++++++++++++++++++---------
 include/linux/crash_dump.h |    1 
 2 files changed, 55 insertions(+), 12 deletions(-)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -494,14 +494,10 @@ static void __init set_vmcore_list_offse
 						struct list_head *vc_list)
 {
 	loff_t vmcore_off;
-	Elf64_Ehdr *ehdr_ptr;
 	struct vmcore *m;
 
-	ehdr_ptr = (Elf64_Ehdr *)elfptr;
-
 	/* Skip Elf header and program headers. */
-	vmcore_off = sizeof(Elf64_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr);
+	vmcore_off = elfcorebuf_sz;
 
 	list_for_each_entry(m, vc_list, list) {
 		m->offset = vmcore_off;
@@ -514,14 +510,10 @@ static void __init set_vmcore_list_offse
 						struct list_head *vc_list)
 {
 	loff_t vmcore_off;
-	Elf32_Ehdr *ehdr_ptr;
 	struct vmcore *m;
 
-	ehdr_ptr = (Elf32_Ehdr *)elfptr;
-
 	/* Skip Elf header and program headers. */
-	vmcore_off = sizeof(Elf32_Ehdr) +
-			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr);
+	vmcore_off = elfcorebuf_sz;
 
 	list_for_each_entry(m, vc_list, list) {
 		m->offset = vmcore_off;
@@ -641,7 +633,7 @@ static int __init parse_crash_elf32_head
 	return 0;
 }
 
-static int __init parse_crash_elf_headers(void)
+static int __init parse_crash_elf_headers_oldmem(void)
 {
 	unsigned char e_ident[EI_NIDENT];
 	u64 addr;
@@ -679,6 +671,53 @@ static int __init parse_crash_elf_header
 	return 0;
 }
 
+/*
+ * provide an empty default implementation here -- architecture
+ * code may override this
+ */
+int __weak arch_vmcore_get_elf_hdr(char **elfcorebuf, size_t *elfcorebuf_sz)
+{
+	return -EOPNOTSUPP;
+}
+
+static int __init parse_crash_elf_headers_newmem(void)
+{
+	unsigned char e_ident[EI_NIDENT];
+	int rc;
+
+	rc = arch_vmcore_get_elf_hdr(&elfcorebuf, &elfcorebuf_sz);
+	if (rc)
+		return rc;
+	memcpy(e_ident, elfcorebuf, EI_NIDENT);
+	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
+		printk(KERN_WARNING "Warning: Core image elf header "
+		       "not found\n");
+		rc = -EINVAL;
+		goto fail;
+	}
+	if (e_ident[EI_CLASS] == ELFCLASS64) {
+		rc = process_ptload_program_headers_elf64(elfcorebuf,
+							  elfcorebuf_sz,
+							  &vmcore_list);
+		if (rc)
+			goto fail;
+		set_vmcore_list_offsets_elf64(elfcorebuf, &vmcore_list);
+		vmcore_size = get_vmcore_size_elf64(elfcorebuf);
+	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
+		rc = process_ptload_program_headers_elf32(elfcorebuf,
+							  elfcorebuf_sz,
+							  &vmcore_list);
+		if (rc)
+			goto fail;
+		set_vmcore_list_offsets_elf32(elfcorebuf, &vmcore_list);
+		vmcore_size = get_vmcore_size_elf32(elfcorebuf);
+	}
+	return 0;
+fail:
+	kfree(elfcorebuf);
+	return rc;
+}
+
 /* Init function for vmcore module. */
 static int __init vmcore_init(void)
 {
@@ -687,7 +726,10 @@ static int __init vmcore_init(void)
 	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
 	if (!(is_vmcore_usable()))
 		return rc;
-	rc = parse_crash_elf_headers();
+	if (elfcorehdr_addr == ELFCORE_ADDR_NEWMEM)
+		rc = parse_crash_elf_headers_newmem();
+	else
+		rc = parse_crash_elf_headers_oldmem();
 	if (rc) {
 		printk(KERN_WARNING "Kdump: vmcore not initialized\n");
 		return rc;
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -8,6 +8,7 @@
 
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
+#define ELFCORE_ADDR_NEWMEM	(-3ULL)
 
 extern unsigned long long elfcorehdr_addr;
 

