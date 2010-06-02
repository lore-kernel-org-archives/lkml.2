Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab0FBJp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:45:59 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:40664 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0FBJpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:45:51 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2010 05:45:51 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KZSwQ2jbZqbfFBGCE6J0LG5ciubxi1HiIPU973qmoUlnYKiz0rfjmBXuvg6v5lJLh9
         D2aeGtxWVtskz53GqLubbfFx4HgN27Z2MZoZiTwiAQ+4QeSJvwu5mQjLbiELN0unNOAW
         DtMHQWsGBDIJoaKuX0Cp9cHzpeJgfI+Y3787g=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 3/5] vmcore: Introduce dump_old_log()
Date: Wed,  2 Jun 2010 09:39:17 +0200
Message-Id: <1275464359-1566-4-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function digs up and prints kernel log and CPU registers from
captured vmcore.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 fs/proc/vmcore.c |  365 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 353 insertions(+), 12 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 91c817f..a2fc826 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm/kdebug.h>
 
 /* List representing chunks of contiguous memory areas and their offsets in
  * vmcore file.
@@ -35,6 +36,14 @@ static u64 vmcore_size;
 
 static struct proc_dir_entry *proc_vmcore = NULL;
 
+static int ei_class;
+
+static char *old_log_buf;
+static int old_log_len;
+static char print_log_buf[PAGE_SIZE];
+static struct pt_regs old_kernel_regs[NR_CPUS];
+static int old_kernel_nr_cpus;
+
 /* Reads a page from the oldmem device from given offset. */
 static ssize_t read_from_oldmem(char *buf, size_t count,
 				u64 *ppos, int userbuf)
@@ -69,7 +78,7 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
 	return read;
 }
 
-/* Maps vmcore file offset to respective physical address in memroy. */
+/* Maps vmcore file offset to respective physical address in memory. */
 static u64 map_offset_to_paddr(loff_t offset, struct list_head *vc_list,
 					struct vmcore **m_ptr)
 {
@@ -90,11 +99,8 @@ static u64 map_offset_to_paddr(loff_t offset, struct list_head *vc_list,
 	return 0;
 }
 
-/* Read from the ELF header and then the crash dump. On error, negative value is
- * returned otherwise number of bytes read are returned.
- */
-static ssize_t read_vmcore(struct file *file, char __user *buffer,
-				size_t buflen, loff_t *fpos)
+static ssize_t __read_vmcore(char *buffer, size_t buflen, loff_t *fpos,
+			     int user)
 {
 	ssize_t acc = 0, tmp;
 	size_t tsz;
@@ -113,8 +119,12 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 		tsz = elfcorebuf_sz - *fpos;
 		if (buflen < tsz)
 			tsz = buflen;
-		if (copy_to_user(buffer, elfcorebuf + *fpos, tsz))
-			return -EFAULT;
+		if (user) {
+			if (copy_to_user(buffer, elfcorebuf + *fpos, tsz))
+				return -EFAULT;
+		} else
+			memcpy(buffer, elfcorebuf + *fpos, tsz);
+
 		buflen -= tsz;
 		*fpos += tsz;
 		buffer += tsz;
@@ -137,7 +147,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 		tsz = nr_bytes;
 
 	while (buflen) {
-		tmp = read_from_oldmem(buffer, tsz, &start, 1);
+		tmp = read_from_oldmem(buffer, tsz, &start, user);
 		if (tmp < 0)
 			return tmp;
 		buflen -= tsz;
@@ -161,6 +171,15 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 	return acc;
 }
 
+/* Read from the ELF header and then the crash dump. On error, negative value is
+ * returned otherwise number of bytes read are returned.
+ */
+static ssize_t read_vmcore(struct file *file, char __user *buffer,
+				size_t buflen, loff_t *fpos)
+{
+	return __read_vmcore(buffer, buflen, fpos, 1);
+}
+
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
 	.llseek		= generic_file_llseek,
@@ -610,15 +629,15 @@ static int __init parse_crash_elf_headers(void)
 					" not found\n");
 		return -EINVAL;
 	}
-
-	if (e_ident[EI_CLASS] == ELFCLASS64) {
+	ei_class = e_ident[EI_CLASS];
+	if (ei_class == ELFCLASS64) {
 		rc = parse_crash_elf64_headers();
 		if (rc)
 			return rc;
 
 		/* Determine vmcore size. */
 		vmcore_size = get_vmcore_size_elf64(elfcorebuf);
-	} else if (e_ident[EI_CLASS] == ELFCLASS32) {
+	} else if (ei_class == ELFCLASS32) {
 		rc = parse_crash_elf32_headers();
 		if (rc)
 			return rc;
@@ -633,6 +652,283 @@ static int __init parse_crash_elf_headers(void)
 	return 0;
 }
 
+/* Search symbol in buffer and read value. */
+static long read_symbol(char *buffer, long buffer_sz, char *symbol)
+{
+	char _symbol[64];
+	char *ptr, *end;
+	unsigned long value = 0;
+
+	snprintf(_symbol, sizeof(_symbol), "SYMBOL(%s)=", symbol);
+	ptr = strnstr(buffer, _symbol, buffer_sz);
+
+	if (ptr)
+		value = simple_strtoul(ptr + strlen(_symbol), &end, 16);
+	return value;
+}
+
+/* Find offset for given virtual address in vmcore file. */
+static loff_t map_vaddr_to_offset_elf64(u64 addr)
+{
+	Elf64_Ehdr *ehdr = (Elf64_Ehdr *)elfcorebuf;
+	Elf64_Phdr *phdr = (Elf64_Phdr *)((char*)ehdr + ehdr->e_phoff);
+	int i;
+	loff_t offset = -1;
+
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
+		if (phdr->p_type == PT_LOAD &&
+		    addr >= phdr->p_vaddr &&
+		    addr < phdr->p_vaddr + phdr->p_memsz) {
+			offset = phdr->p_offset + addr - phdr->p_vaddr;
+			break;
+		}
+	}
+	return offset;
+}
+
+static loff_t map_vaddr_to_offset_elf32(u32 addr)
+{
+	Elf32_Ehdr *ehdr = (Elf32_Ehdr *)elfcorebuf;
+	Elf32_Phdr *phdr = (Elf32_Phdr *)((char*)ehdr + ehdr->e_phoff);
+	int i;
+	loff_t offset = -1;
+
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
+		if (phdr->p_type == PT_LOAD &&
+		    addr >= phdr->p_vaddr &&
+		    addr < phdr->p_vaddr + phdr->p_memsz) {
+			offset = phdr->p_offset + addr - phdr->p_vaddr;
+			break;
+		}
+	}
+	return offset;
+}
+
+static loff_t map_vaddr_to_offset(u64 addr)
+{
+	if (ei_class ==	ELFCLASS64)
+		return map_vaddr_to_offset_elf64(addr);
+	else if (ei_class == ELFCLASS32)
+		return map_vaddr_to_offset_elf32(addr);
+	return -1;
+}
+
+/* Read long at given address in old memory. */
+static long read_vmcore_long(u64 addr)
+{
+	loff_t off;
+	long tmp, value = 0;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		goto out;
+
+	off = map_vaddr_to_offset(addr);
+	if (off < 0)
+		goto fail;
+
+	tmp = __read_vmcore(buf, PAGE_SIZE, &off, 0);
+	if (tmp > 0) {
+		value = *(long *)buf;
+		goto out;
+	}
+fail:
+	kfree(buf);
+out:
+	return value;
+}
+
+/* Find PT_NOTE section in vmcore's elf header. */
+Elf64_Phdr *find_elf64_pt_note(void)
+{
+	Elf64_Ehdr *ehdr = (Elf64_Ehdr *)elfcorebuf;
+	Elf64_Phdr *phdr = (Elf64_Phdr *)((char*)ehdr + ehdr->e_phoff);
+	int i;
+
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
+		if (phdr->p_type == PT_NOTE)
+			return phdr;
+	}
+	return 0;
+}
+
+Elf32_Phdr *find_elf32_pt_note(void)
+{
+	Elf32_Ehdr *ehdr = (Elf32_Ehdr *)elfcorebuf;
+	Elf32_Phdr *phdr = (Elf32_Phdr *)((char*)ehdr + ehdr->e_phoff);
+	int i;
+
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
+		if (phdr->p_type == PT_NOTE)
+			return phdr;
+	}
+	return 0;
+}
+
+static long find_old_log_elf64(int *size)
+{
+	Elf64_Xword i;
+	char *buffer;
+	loff_t start;
+	long old_log = 0, sz;
+	Elf64_Nhdr *note;
+	Elf64_Phdr *phdr;
+
+	phdr = find_elf64_pt_note();
+	if (!phdr)
+		goto fail;
+
+	buffer = kmalloc(phdr->p_memsz, GFP_KERNEL);
+	if (!buffer)
+		goto fail;
+
+	note = (Elf64_Nhdr *)buffer;
+	start = phdr->p_offset;
+	sz = __read_vmcore(buffer, phdr->p_memsz, &start, 0);
+	if (sz < 0)
+		goto fail1;
+
+	for (i = 0; i < phdr->p_memsz; i += sz) {
+		char *ptr;
+
+		if (note->n_namesz == 0)
+			break;
+
+		ptr = (char *)note + sizeof(int) * 3;
+
+#ifdef ELF_CORE_EXTRACT_REGS
+		if (memcmp(ptr, KEXEC_CORE_NOTE_NAME,
+			   sizeof(KEXEC_CORE_NOTE_NAME)) == 0) {
+			struct elf_prstatus *prstatus =	(struct elf_prstatus *)
+				(ptr + ((note->n_namesz + 3) & ~3));
+			struct pt_regs regs;
+			ELF_CORE_EXTRACT_REGS(prstatus->pr_reg, &regs);
+			old_kernel_regs[old_kernel_nr_cpus++] = regs;
+		}
+#endif
+		if (memcmp(ptr, VMCOREINFO_NOTE_NAME,
+			   sizeof(VMCOREINFO_NOTE_NAME)) == 0) {
+			unsigned long symbol;
+			symbol = read_symbol(ptr, note->n_descsz,
+					     "log_buf");
+			old_log = read_vmcore_long(symbol);
+			symbol = read_symbol(ptr, note->n_descsz,
+					     "logged_chars");
+			*size = (int)read_vmcore_long(symbol);
+			break;
+		}
+		sz = sizeof(Elf64_Nhdr) +
+			((note->n_namesz + 3) & ~3) +
+			((note->n_descsz + 3) & ~3);
+		note = (Elf64_Nhdr *)((char*)note + sz);
+	}
+fail1:
+	kfree(buffer);
+fail:
+	return old_log;
+}
+
+static long find_old_log_elf32(int *size)
+{
+	Elf32_Word i;
+	char *buffer;
+	loff_t start;
+	long old_log = 0, sz;
+	Elf32_Nhdr *note;
+	Elf32_Phdr *phdr;
+
+	phdr = find_elf32_pt_note();
+	if (!phdr)
+		goto fail;
+
+	buffer = kmalloc(phdr->p_memsz, GFP_KERNEL);
+	if (!buffer)
+		goto fail;
+
+	note = (Elf32_Nhdr *)buffer;
+	start = phdr->p_offset;
+	sz = __read_vmcore(buffer, phdr->p_memsz, &start, 0);
+	if (sz < 0)
+		goto fail1;
+
+	for (i = 0; i < phdr->p_memsz; i += sz) {
+		char *ptr;
+
+		if (note->n_namesz == 0)
+			break;
+
+		ptr = (char *)note + sizeof(int) * 3;
+
+#ifdef ELF_CORE_EXTRACT_REGS
+		if (memcmp(ptr, KEXEC_CORE_NOTE_NAME,
+			   sizeof(KEXEC_CORE_NOTE_NAME)) == 0) {
+			struct elf_prstatus *prstatus = (struct elf_prstatus *)
+				(ptr + ((note->n_namesz + 3) & ~3));
+			struct pt_regs regs;
+			ELF_CORE_EXTRACT_REGS(prstatus->pr_reg, &regs);
+			old_kernel_regs[old_kernel_nr_cpus++] = regs;
+		}
+#endif
+		if (memcmp(ptr, VMCOREINFO_NOTE_NAME,
+			   sizeof(VMCOREINFO_NOTE_NAME)) == 0) {
+			unsigned long symbol;
+			symbol = read_symbol(ptr, note->n_descsz,
+					     "log_buf");
+			old_log = read_vmcore_long(symbol);
+			symbol = read_symbol(ptr, note->n_descsz,
+					     "logged_chars");
+			*size = (int)read_vmcore_long(symbol);
+			break;
+		}
+		sz = sizeof(Elf32_Nhdr) +
+			((note->n_namesz + 3) & ~3) +
+			((note->n_descsz + 3) & ~3);
+		note = (Elf32_Nhdr *)((char*)note + sz);
+	}
+fail1:
+	kfree(buffer);
+fail:
+	return old_log;
+}
+
+/* Prepare old log_buf for use */
+static long find_vmcore_old_log(int *size)
+{
+	if (ei_class ==	ELFCLASS64)
+		return find_old_log_elf64(size);
+	else if (ei_class == ELFCLASS32)
+		return find_old_log_elf32(size);
+	return 0;
+}
+
+static char *read_vmcore_old_log(int *len)
+{
+	loff_t offset;
+	unsigned long old_log_vaddr;
+	char *ptr = 0;
+
+	old_log_vaddr = find_vmcore_old_log(len);
+
+	if (!old_log_vaddr)
+		goto out;
+
+	ptr = vmalloc(*len);
+	if (!ptr)
+		goto out;
+
+	offset = map_vaddr_to_offset(old_log_vaddr);
+	if (!offset)
+		goto fail;
+
+	if (__read_vmcore(ptr, *len, &offset, 0) < 0)
+		goto fail;
+
+	goto out;
+fail:
+	vfree(ptr);
+out:
+	return ptr;
+}
+
 /* Init function for vmcore module. */
 static int __init vmcore_init(void)
 {
@@ -647,9 +943,54 @@ static int __init vmcore_init(void)
 		return rc;
 	}
 
+	old_log_buf = read_vmcore_old_log(&old_log_len);
+	if (!old_log_buf)
+		printk(KERN_WARNING "Kdump: can't read old log\n");
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 	if (proc_vmcore)
 		proc_vmcore->size = vmcore_size;
 	return 0;
 }
+
+static void print_log(char *ptr, long len)
+{
+	char *p, *ptr1;
+	long len1;
+
+	while (len > 0) {
+		p = print_log_buf;
+		ptr1 = ptr; len1 = len;
+		while (len > 0 && *ptr != 0x0a
+		       && p - print_log_buf < PAGE_SIZE) {
+			*p++ = *ptr++;
+			len--;
+		}
+		*p = 0; ptr++; len--;
+		printk(KERN_INFO "%s\n", print_log_buf);
+	}
+}
+
+void dump_old_log(void)
+{
+	int i;
+	console_verbose();
+	bust_spinlocks(1);
+
+#ifdef ELF_CORE_EXTRACT_REGS
+	if (old_kernel_nr_cpus) {
+		printk(KERN_INFO "--- old kernel registers begin here---\n");
+		for (i = 0; i < old_kernel_nr_cpus; i++) {
+			printk(KERN_INFO "CPU#%d:\n", i);
+			__show_main_regs(&old_kernel_regs[i]);
+		}
+		printk(KERN_INFO "--- old kernel registers end here---\n");
+	}
+#endif
+	if (old_log_buf) {
+		printk(KERN_INFO "--- old kernel log begins here ---\n");
+		print_log(old_log_buf, old_log_len);
+		printk(KERN_INFO "--- old kernel log ends here ---\n");
+	}
+}
+
 module_init(vmcore_init)
-- 
1.7.1

