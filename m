Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2GIGzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:55:33 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38511 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2GIGzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:55:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, hacklu <embedway.linux@gmail.com>,
        linux-kernel@vger.kernel.org
References: <4FB492F7.8050401@gmail.com> <87obp0bxdv.fsf@xmission.com>
	<4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com>
	<877gvob0g4.fsf_-_@xmission.com> <4FF06701.6010004@zytor.com>
	<4FF06DF4.4000006@zytor.com> <87wr2nsbvi.fsf@xmission.com>
	<4FF0769F.8090105@zytor.com> <87sjdbsb0v.fsf@xmission.com>
	<4FF07E66.2020706@zytor.com> <87d34fs914.fsf@xmission.com>
	<4FF085B1.6070604@zytor.com> <87a9zj9w43.fsf@xmission.com>
	<4FF098E2.3040307@zytor.com> <87sjdb8f0m.fsf@xmission.com>
	<4FF0A399.8070207@zytor.com> <87txxr6wre.fsf@xmission.com>
	<4FF0B891.8080804@zytor.com> <87k3yd5sxt.fsf@xmission.com>
	<87fw915sv4.fsf_-_@xmission.com>
Date: Sun, 08 Jul 2012 23:55:22 -0700
In-Reply-To: <87fw915sv4.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sun, 08 Jul 2012 23:52:15 -0700")
Message-ID: <877gud5spx.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+3SyeY5lRKboiAfsYsSOffqMXFteGp22M=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0623]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: [PATCH 3/4] x86 boot: When building vmlinux.bin properly precompute the memory image
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The ELF loader in arch/x86/boot/compressed/misc.c is extremely
fragile, as it copies the ELF executable over itself to put the
code and data in their proper place.  Squeezing unneeded space
out of vmlinux by passing -z max-page-size 4096 to ld was enough
to render the kernel unbootable.

I explored creating a flush function for our current crop of kernel
decompressors.  While that works it has the very unfortunate side
effect of needing a much larger BOOT_HEAP_SIZE.  A couple of our
supported decompressors in that mode malloc 32MB for use during
decompression.

The other solution is to return to the original design where we
created a file known as vmlinux.bin with exactly what we wanted in
memory and compressed that.

At this point in time there are complications to going back to the
original design.

- We need to preserve the ELF headers inside the compresed image file
  for Xen and other interesting bootloaders that open up the bzImage
  and boot the ELF executable contained inside.

- ld will not uniformly produce a file where the file offsets have a
  constant offset from the in memory addresses.  In particular
  combinations of CONFIG_RODATA and CLONFIG_x86_64 && CONFIG_SMP
  play games with 2MB alignments and the virtual address of functions
  that cause ld to emit valid ELF executables that do not have
  a fixed differents betwen file offset and loaded physical address
  making the ELF executable something that must be procecessed to
  get an in memory image.

- The old solution to creating a memory image objcopy -O binary comes
  very close but it always strips the ELF header even when the ELF header
  is explicitly made part of the ELF file.

Since all of the prebuilt tools don't work I have written a small
program mkelfbin, that generates a memory image by loading an ELF
executable into an in memory array.  Then the ELF program headers
offset fields are adjusted to reflect where in the memory image each
program header is referring to.  By design this results in program
headers with a fixes offset between the file offset and the physical
memory address with the file be loaded in memory.

With the compressed data being a proper memory image misc.c no longer
needs an ELF loader or dangerous copies over itself so those are
removed.

The result is a simpler more robust boot process, that still retains
all of the modern bells and whistles.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/boot/compressed/Makefile   |   10 +-
 arch/x86/boot/compressed/misc.c     |   52 +-----
 arch/x86/boot/compressed/misc.h     |    8 +
 arch/x86/boot/compressed/mkelfbin.c |  323 +++++++++++++++++++++++++++++++++++
 4 files changed, 343 insertions(+), 50 deletions(-)
 create mode 100644 arch/x86/boot/compressed/mkelfbin.c

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index e398bb5..67b9ae4 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -21,7 +21,7 @@ GCOV_PROFILE := n
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
 
-hostprogs-y	:= mkpiggy
+hostprogs-y	:= mkpiggy mkelfbin
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
@@ -36,9 +36,11 @@ $(obj)/vmlinux: $(VMLINUX_OBJS) FORCE
 	$(call if_changed,ld)
 	@:
 
-OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
-$(obj)/vmlinux.bin: vmlinux FORCE
-	$(call if_changed,objcopy)
+quiet_cmd_mkelfbin = MKELFBIN $@
+      cmd_mkelfbin = $(obj)/mkelfbin $< > $@ || ( rm -f $@ ; false )
+
+$(obj)/vmlinux.bin: vmlinux $(obj)/mkelfbin FORCE
+	$(call if_changed,mkelfbin)
 
 targets += vmlinux.bin.all vmlinux.relocs
 
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index fc96c3e..cb374ff 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -275,55 +275,15 @@ static void error(char *x)
 
 static void *parse_elf(void *output)
 {
-#ifdef CONFIG_X86_64
-	Elf64_Ehdr ehdr;
-	Elf64_Phdr *phdrs, *phdr;
-#else
-	Elf32_Ehdr ehdr;
-	Elf32_Phdr *phdrs, *phdr;
-#endif
-	void *dest;
-	int i;
+	ehdr_t *ehdr = output;
 
-	memcpy(&ehdr, output, sizeof(ehdr));
-	if (ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
-	   ehdr.e_ident[EI_MAG1] != ELFMAG1 ||
-	   ehdr.e_ident[EI_MAG2] != ELFMAG2 ||
-	   ehdr.e_ident[EI_MAG3] != ELFMAG3) {
+	if (ehdr->e_ident[EI_MAG0] != ELFMAG0 ||
+	    ehdr->e_ident[EI_MAG1] != ELFMAG1 ||
+	    ehdr->e_ident[EI_MAG2] != ELFMAG2 ||
+	    ehdr->e_ident[EI_MAG3] != ELFMAG3)
 		error("Kernel is not a valid ELF file");
-		return;
-	}
-
-	if (!quiet)
-		putstr("Parsing ELF... ");
-
-	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
-	if (!phdrs)
-		error("Failed to allocate space for phdrs");
-
-	memcpy(phdrs, output + ehdr.e_phoff, sizeof(*phdrs) * ehdr.e_phnum);
-
-	for (i = 0; i < ehdr.e_phnum; i++) {
-		phdr = &phdrs[i];
-
-		switch (phdr->p_type) {
-		case PT_LOAD:
-#ifdef CONFIG_RELOCATABLE
-			dest = output;
-			dest += (phdr->p_paddr - LOAD_PHYSICAL_ADDR);
-#else
-			dest = (void *)(phdr->p_paddr);
-#endif
-			memcpy(dest,
-			       output + phdr->p_offset,
-			       phdr->p_filesz);
-			break;
-		default: /* Ignore other PT_* */ break;
-		}
-	}
 
-	free(phdrs);
-	return output + (ehdr.e_entry - LOAD_PHYSICAL_ADDR);
+	return output + (ehdr->e_entry - LOAD_PHYSICAL_ADDR);
 }
 
 asmlinkage void *decompress_kernel(void *rmode, memptr heap,
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 3f19c81..b7c3779 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -22,6 +22,14 @@
 #define BOOT_BOOT_H
 #include "../ctype.h"
 
+#ifdef CONFIG_X86_64
+typedef Elf64_Ehdr ehdr_t;
+typedef Elf64_Phdr phdr_t;
+#else
+typedef Elf32_Ehdr ehdr_t;
+typedef Elf32_Phdr phdr_t;
+#endif
+
 /* misc.c */
 extern struct boot_params *real_mode;		/* Pointer to real-mode data */
 void __putstr(int error, const char *s);
diff --git a/arch/x86/boot/compressed/mkelfbin.c b/arch/x86/boot/compressed/mkelfbin.c
new file mode 100644
index 0000000..3ccc6f6
--- /dev/null
+++ b/arch/x86/boot/compressed/mkelfbin.c
@@ -0,0 +1,323 @@
+/*
+ * Precompute the memory image of an elf executable and
+ * place it in a file, while retaining the ELF headers.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <stdarg.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <elf.h>
+
+#if BYTE_ORDER == LITTLE_ENDIAN
+#define le16_to_cpu(val) (val)
+#define le32_to_cpu(val) (val)
+#define le64_to_cpu(val) (val)
+#define cpu_to_le16(val) (val)
+#define cpu_to_le32(val) (val)
+#define cpu_to_le64(val) (val)
+#endif
+#if BYTE_ORDER == BIG_ENDIAN
+#define le16_to_cpu(val) bswap_16(val)
+#define le32_to_cpu(val) bswap_32(val)
+#define le64_to_cpu(val) bswap_64(val)
+#define cpu_to_le16(val) bswap_16(val)
+#define cpu_to_le32(val) bswap_32(val)
+#define cpu_to_le64(val) bswap_64(val)
+#endif
+
+static unsigned char *input; /* Entire contents of input file */
+static unsigned char *image; /* Memory image of loaded ELF file*/
+
+static Elf64_Ehdr ehdr;
+static Elf64_Phdr *phdrs;
+
+static void die(char *fmt, ...)
+{
+	va_list ap;
+	va_start(ap, fmt);
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+	exit(1);
+}
+
+static uint16_t elf16_to_cpu(uint16_t val)
+{
+	return le16_to_cpu(val);
+}
+
+static uint32_t elf32_to_cpu(uint32_t val)
+{
+	return le32_to_cpu(val);
+}
+
+static uint32_t elf64_to_cpu(uint32_t val)
+{
+	return le64_to_cpu(val);
+}
+
+static uint16_t cpu_to_elf16(uint16_t val)
+{
+	return cpu_to_le16(val);
+}
+
+static uint32_t cpu_to_elf32(uint32_t val)
+{
+	return cpu_to_le32(val);
+}
+
+static uint32_t cpu_to_elf64(uint32_t val)
+{
+	return cpu_to_le64(val);
+}
+
+static void read_ehdr(off_t size )
+{
+	if (size < sizeof(EI_NIDENT))
+		die("file too small to be an ELF file\n");
+	memcpy(ehdr.e_ident, input, EI_NIDENT);
+	if ((ehdr.e_ident[EI_MAG0] != ELFMAG0) ||
+	    (ehdr.e_ident[EI_MAG1] != ELFMAG1) ||
+	    (ehdr.e_ident[EI_MAG2] != ELFMAG2) ||
+	    (ehdr.e_ident[EI_MAG3] != ELFMAG3))
+		die("Not a valid ELF file\n");
+	if (ehdr.e_ident[EI_VERSION] != EV_CURRENT)
+		die("Unsupported ELF version\n");
+	if (ehdr.e_ident[EI_DATA] != ELFDATA2LSB)
+		die("Not a little endian ELF file\n");
+	if (ehdr.e_ident[EI_CLASS] == ELFCLASS32) {
+		Elf32_Ehdr *iehdr = (Elf32_Ehdr *)input;
+		if (size < sizeof(Elf32_Ehdr))
+			die("file too small for the ELF header\n");
+		ehdr.e_type = elf16_to_cpu(iehdr->e_type);
+		ehdr.e_machine = elf16_to_cpu(iehdr->e_machine);
+		ehdr.e_version = elf32_to_cpu(iehdr->e_version);
+		ehdr.e_entry = elf32_to_cpu(iehdr->e_entry);
+		ehdr.e_phoff = elf32_to_cpu(iehdr->e_phoff);
+		ehdr.e_shoff = elf32_to_cpu(iehdr->e_shoff);
+		ehdr.e_flags = elf32_to_cpu(iehdr->e_flags);
+		ehdr.e_ehsize = elf16_to_cpu(iehdr->e_ehsize);
+		ehdr.e_phentsize = elf16_to_cpu(iehdr->e_phentsize);
+		ehdr.e_phnum = elf16_to_cpu(iehdr->e_phnum);
+		ehdr.e_shentsize = elf16_to_cpu(iehdr->e_shentsize);
+		ehdr.e_shnum = elf16_to_cpu(iehdr->e_shnum);
+		ehdr.e_shstrndx = elf16_to_cpu(iehdr->e_shstrndx);
+		if (ehdr.e_ehsize != sizeof(Elf32_Ehdr))
+			die("Wrong ELF header size\n");
+		if (ehdr.e_phentsize != sizeof(Elf32_Phdr))
+			die("Wrong program header size\n");
+	} 
+	else if (ehdr.e_ident[EI_CLASS] == ELFCLASS64) {
+		Elf64_Ehdr *iehdr = (Elf64_Ehdr *)input;
+		if (size < sizeof(Elf64_Ehdr))
+			die("file too small for the ELF header\n");
+		ehdr.e_type = elf16_to_cpu(iehdr->e_type);
+		ehdr.e_machine = elf16_to_cpu(iehdr->e_machine);
+		ehdr.e_version = elf32_to_cpu(iehdr->e_version);
+		ehdr.e_entry = elf64_to_cpu(iehdr->e_entry);
+		ehdr.e_phoff = elf64_to_cpu(iehdr->e_phoff);
+		ehdr.e_shoff = elf64_to_cpu(iehdr->e_shoff);
+		ehdr.e_flags = elf32_to_cpu(iehdr->e_flags);
+		ehdr.e_ehsize = elf16_to_cpu(iehdr->e_ehsize);
+		ehdr.e_phentsize = elf16_to_cpu(iehdr->e_phentsize);
+		ehdr.e_phnum = elf16_to_cpu(iehdr->e_phnum);
+		ehdr.e_shentsize = elf16_to_cpu(iehdr->e_shentsize);
+		ehdr.e_shnum = elf16_to_cpu(iehdr->e_shnum);
+		ehdr.e_shstrndx = elf16_to_cpu(iehdr->e_shstrndx);
+		if (ehdr.e_ehsize != sizeof(Elf64_Ehdr))
+			die("Wrong ELF header size\n");
+		if (ehdr.e_phentsize != sizeof(Elf64_Phdr))
+			die("Wrong program header size\n");
+	}
+	else {
+		die("Unsupported ELF Class\n");
+	}
+	if (ehdr.e_version != EV_CURRENT)
+		die ("Unsupported ELF version\n");
+}
+
+static void read_phdrs(void)
+{
+	int i;
+	phdrs = calloc(1, ehdr.e_phnum * sizeof(Elf64_Phdr));
+	if (!phdrs)
+		die("calloc for program headers failed: %s\n", strerror(errno));
+
+	if (ehdr.e_ident[EI_CLASS] == ELFCLASS32) {
+		Elf32_Phdr *iphdr = (Elf32_Phdr *)(input + ehdr.e_phoff);
+		for (i = 0; i < ehdr.e_phnum; i++) {
+			phdrs[i].p_type   = elf32_to_cpu(iphdr[i].p_type);
+			phdrs[i].p_offset = elf32_to_cpu(iphdr[i].p_offset);
+			phdrs[i].p_vaddr  = elf32_to_cpu(iphdr[i].p_vaddr);
+			phdrs[i].p_paddr  = elf32_to_cpu(iphdr[i].p_paddr);
+			phdrs[i].p_filesz = elf32_to_cpu(iphdr[i].p_filesz);
+			phdrs[i].p_memsz  = elf32_to_cpu(iphdr[i].p_memsz);
+			phdrs[i].p_flags  = elf32_to_cpu(iphdr[i].p_flags);
+			phdrs[i].p_align  = elf32_to_cpu(iphdr[i].p_align);
+		}
+	} else {
+		Elf64_Phdr *iphdr = (Elf64_Phdr *)(input + ehdr.e_phoff);
+		for (i = 0; i < ehdr.e_phnum; i++) {
+			phdrs[i].p_type   = elf32_to_cpu(iphdr[i].p_type);
+			phdrs[i].p_flags  = elf32_to_cpu(iphdr[i].p_flags);
+			phdrs[i].p_offset = elf64_to_cpu(iphdr[i].p_offset);
+			phdrs[i].p_vaddr  = elf64_to_cpu(iphdr[i].p_vaddr);
+			phdrs[i].p_paddr  = elf64_to_cpu(iphdr[i].p_paddr);
+			phdrs[i].p_filesz = elf64_to_cpu(iphdr[i].p_filesz);
+			phdrs[i].p_memsz  = elf64_to_cpu(iphdr[i].p_memsz);
+			phdrs[i].p_align  = elf64_to_cpu(iphdr[i].p_align);
+		}
+	}
+}
+
+static bool file_chunk_loaded(uint64_t start, uint64_t len)
+{
+	uint64_t end = start + len;
+	Elf64_Phdr *load;
+	int i;
+
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		load = &phdrs[i];
+		if (load->p_type != PT_LOAD)
+			continue;
+
+		if ((start >= load->p_paddr) &&
+		    (end <= (load->p_paddr + load->p_filesz))) {
+			return true;
+		}
+	}
+	return false;
+}
+
+static void fixup_output_hdrs(uint64_t min_addr)
+{
+	int i;
+	/* There are no section headers */
+	if (ehdr.e_ident[EI_CLASS] == ELFCLASS32) {
+		Elf32_Ehdr *oehdr = (Elf32_Ehdr *)image;
+		oehdr->e_shoff = cpu_to_elf32(0);
+		oehdr->e_shnum = cpu_to_elf16(0);
+		oehdr->e_shstrndx = cpu_to_elf16(0);
+	} else {
+		Elf64_Ehdr *oehdr = (Elf64_Ehdr *)image;
+		oehdr->e_shoff = cpu_to_elf64(0);
+		oehdr->e_shnum = cpu_to_elf16(0);
+		oehdr->e_shstrndx = cpu_to_elf16(0);
+	}
+	/* Fixup the file offset */
+	if (ehdr.e_ident[EI_CLASS] == ELFCLASS32) {
+		Elf32_Phdr *ophdr = (Elf32_Phdr *)(image + ehdr.e_phoff);
+		for (i = 0; i < ehdr.e_phnum; i++) {
+			uint64_t new_offset = phdrs[i].p_paddr - min_addr;
+			ophdr[i].p_offset = cpu_to_elf32(new_offset);
+		}
+	} else {
+		Elf64_Phdr *ophdr = (Elf64_Phdr *)(image + ehdr.e_phoff);
+		for (i = 0; i < ehdr.e_phnum; i++) {
+			uint64_t new_offset = phdrs[i].p_paddr - min_addr;
+			ophdr[i].p_offset = cpu_to_elf64(new_offset);
+		}
+	}
+}
+
+int main(int argc, char **argv)
+{
+	uint64_t min_paddr, max_paddr;
+	uint64_t initial_offset;
+	uint64_t image_length, hdr_length;
+	Elf64_Phdr *phdr;
+	struct stat st;
+	int i;
+	ssize_t len;
+	int fd;
+
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s file\n", argv[0]);
+		return 1;
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0)
+		die("Unable to open %s: %s\n", argv[1], strerror(errno));
+	if (fstat(fd, &st) < 0)
+		die("fstat of %s failed: %s\n", argv[1], strerror(errno));
+	input = mmap(NULL, st.st_size, PROT_READ, MAP_SHARED, fd, 0);
+	if (input == MAP_FAILED)
+		die("mmap of %s failed: %s\n", argv[1], strerror(errno));
+	read_ehdr(st.st_size);
+	hdr_length = ehdr.e_phoff + ehdr.e_phnum * ehdr.e_phentsize;
+	if (hdr_length > st.st_size) {
+		fprintf(stderr, "Program headers extend past end of file\n");
+		return 9;
+	}
+	read_phdrs();
+
+	/* Gather up information about the file */
+	max_paddr = 0;
+	min_paddr = (uint64_t)-1;
+	initial_offset = (uint64_t)-1;
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		uint64_t p_start, p_end;
+		phdr = &phdrs[i];
+		if (phdr->p_type != PT_LOAD)
+			continue;
+		p_start = phdr->p_paddr;
+		p_end = p_start + phdr->p_filesz;
+		if (min_paddr > p_start) {
+			min_paddr = p_start;
+			initial_offset = phdr->p_offset;
+		}
+		if (max_paddr < p_end) {
+			max_paddr = p_end;
+		}
+	}
+	image_length = max_paddr - min_paddr;
+	/* Verify all data is loaded with PT_LOAD segments */
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		phdr = &phdrs[i];
+		if (phdr->p_type == PT_LOAD)
+			continue;
+		if (!file_chunk_loaded(phdr->p_paddr, phdr->p_filesz)) {
+			fprintf(stderr, "Program header data not loaded with PT_LOAD segment\n");
+			return 10;
+		}
+	}
+	/* Verify the elf header is loaded */
+	if ((initial_offset != 0) ||
+	    !file_chunk_loaded(min_paddr, hdr_length)) {
+		fprintf(stderr, "ELF header data not loaded with PT_LOAD segment\n");
+		return 11;
+	}
+	image = calloc(1, image_length);
+	if (!image) {
+		perror("Could not allocate memory for in kernel memory image");
+		return 12;
+	}
+	/* Load the kernel into the memory image */
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		void *src, *dst;
+		phdr = &phdrs[i];
+		if (phdr->p_type != PT_LOAD)
+			continue;
+		src = input + phdr->p_offset;
+		dst = image + (phdr->p_paddr - min_paddr);
+		memcpy(dst, src, phdr->p_filesz);
+	}
+
+	/* Fixup the elf and program headers in the image */
+	fixup_output_hdrs(min_paddr);
+
+	len = write(STDOUT_FILENO, image, image_length);
+	if (len != image_length) {
+		perror("Write of memory image failed");
+		return 20;
+	}
+	return 0;
+}
-- 
1.7.5.4

