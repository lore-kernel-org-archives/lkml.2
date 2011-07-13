Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1GMNYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:24:49 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:62838 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922Ab1GMNYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:24:40 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-35-4e1d9c678f55
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 8/8] Document the vDSO and add a reference parser
Date: Wed, 13 Jul 2011 09:24:16 -0400
Message-Id: <a315a9514cd71bcf29436cc31e35aada21a5ff21.1310563276.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310563276.git.luto@mit.edu>
References: <cover.1310563276.git.luto@mit.edu>
In-Reply-To: <cover.1310563276.git.luto@mit.edu>
References: <cover.1310563276.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsUixG6nrps+R9bPYMprdYu+K0fZLS42bmOx
	aF07n93i8q45bBZbLjWzWmw68ZvR4seGx6wO7B7djz4xetxq+8PssXPWXXaPTas62TzOXetj
	9vi8SS6ALYrLJiU1J7MstUjfLoErY/005YKdyRWzmvQaGNf4dTFycEgImEisnhXYxcgJZIpJ
	XLi3nq2LkYtDSGAfo8TvqS+ZQBJCAhsYJfpmJUIknjFJTFh8EizBJqAi0bH0ARPIIBEBIYml
	d+tAwswCTxglJuzVB7GFBVwkXu99wwJiswioSlzf284IYvMKBEk0rl/EBrFYTuLI5edgIzkF
	DCTmLLjBDrFXX+J5x2FmXOITGAUWMDKsYpRNya3SzU3MzClOTdYtTk7My0st0jXWy80s0UtN
	Kd3ECApYTkm+HYxfDyodYhTgYFTi4ZWOl/ETYk0sK67MPcQoycGkJMqrOlvWT4gvKT+lMiOx
	OCO+qDQntfgQowQHs5IIb30DUI43JbGyKrUoHyYlzcGiJM4b5f3fV0ggPbEkNTs1tSC1CCYr
	w8GhJMF7A2SoYFFqempFWmZOCUKaiYMTZDgP0PBZIDW8xQWJucWZ6RD5U4y6HKfOLDjCKMSS
	l5+XKiXO+xmkSACkKKM0D24OLNG8YhQHekuY9yhIFQ8wScFNegW0hAloyTorsCUliQgpqQbG
	lW5HVtpsk9H50uXy01jqlIffpnNKx52t/r9RCHQ68k5cT1JXK3NTRTfbm78hv6xcp/C9Yney
	1fvG9qGXbU9vyyq2plmJ+Zpmuw55ifKeFX7y+VVj5zcvvuxHDLLrJqlUac+cGLgiSel7prbr
	jNfdubxuu9dMXjjfNeyPW4ifc9G05I0y5kVKLMUZiYZazEXFiQCS+KfuDwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that parsing the vDSO is nontrivial if you don't already
have an ELF dynamic loader around.  So document it in Documentation/ABI
and add a reference CC0-licenced parser.

This code is dedicated to Go issue 1933:
http://code.google.com/p/go/issues/detail?id=1933

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 Documentation/ABI/stable/vdso   |   27 ++++
 Documentation/vDSO/parse_vdso.c |  256 +++++++++++++++++++++++++++++++++++++++
 Documentation/vDSO/vdso_test.c  |  112 +++++++++++++++++
 3 files changed, 395 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/stable/vdso
 create mode 100644 Documentation/vDSO/parse_vdso.c
 create mode 100644 Documentation/vDSO/vdso_test.c

diff --git a/Documentation/ABI/stable/vdso b/Documentation/ABI/stable/vdso
new file mode 100644
index 0000000..8a1cbb5
--- /dev/null
+++ b/Documentation/ABI/stable/vdso
@@ -0,0 +1,27 @@
+On some architectures, when the kernel loads any userspace program it
+maps an ELF DSO into that program's address space.  This DSO is called
+the vDSO and it often contains useful and highly-optimized alternatives
+to real syscalls.
+
+These functions are called just like ordinary C function according to
+your platform's ABI.  Call them from a sensible context.  (For example,
+if you set CS on x86 to something strange, the vDSO functions are
+within their rights to crash.)  In addition, if you pass a bad
+pointer to a vDSO function, you might get SIGSEGV instead of -EFAULT.
+
+To find the DSO, parse the auxiliary vector passed to the program's
+entry point.  The AT_SYSINFO_EHDR entry will point to the vDSO.
+
+The vDSO uses symbol versioning; whenever you request a symbol from the
+vDSO, specify the version you are expecting.
+
+Programs that dynamically link to glibc will use the vDSO automatically.
+Otherwise, you can use the reference parser in Documentation/vDSO/parse_vdso.c.
+
+Unless otherwise noted, the set of symbols with any given version and the
+ABI of those symbols is considered stable.  It may vary across architectures,
+though.
+
+(As of this writing, this ABI documentation as been confirmed for x86_64.
+ The maintainers of the other vDSO-using architectures should confirm
+ that it is correct for their architecture.)
\ No newline at end of file
diff --git a/Documentation/vDSO/parse_vdso.c b/Documentation/vDSO/parse_vdso.c
new file mode 100644
index 0000000..8587020
--- /dev/null
+++ b/Documentation/vDSO/parse_vdso.c
@@ -0,0 +1,256 @@
+/*
+ * parse_vdso.c: Linux reference vDSO parser
+ * Written by Andrew Lutomirski, 2011.
+ *
+ * This code is meant to be linked in to various programs that run on Linux.
+ * As such, it is available with as few restrictions as possible.  This file
+ * is licensed under the Creative Commons Zero License, version 1.0,
+ * available at http://creativecommons.org/publicdomain/zero/1.0/legalcode
+ *
+ * The vDSO is a regular ELF DSO that the kernel maps into user space when
+ * it starts a program.  It works equally well in statically and dynamically
+ * linked binaries.
+ *
+ * This code is tested on x86_64.  In principle it should work on any 64-bit
+ * architecture that has a vDSO.
+ */
+
+#include <stdbool.h>
+#include <stdint.h>
+#include <string.h>
+#include <elf.h>
+
+/*
+ * To use this vDSO parser, first call one of the vdso_init_* functions.
+ * If you've already parsed auxv, then pass the value of AT_SYSINFO_EHDR
+ * to vdso_init_from_sysinfo_ehdr.  Otherwise pass auxv to vdso_init_from_auxv.
+ * Then call vdso_sym for each symbol you want.  For example, to look up
+ * gettimeofday on x86_64, use:
+ *
+ *     <some pointer> = vdso_sym("LINUX_2.6", "gettimeofday");
+ * or
+ *     <some pointer> = vdso_sym("LINUX_2.6", "__vdso_gettimeofday");
+ *
+ * vdso_sym will return 0 if the symbol doesn't exist or if the init function
+ * failed or was not called.  vdso_sym is a little slow, so its return value
+ * should be cached.
+ *
+ * vdso_sym is threadsafe; the init functions are not.
+ *
+ * These are the prototypes:
+ */
+extern void vdso_init_from_auxv(void *auxv);
+extern void vdso_init_from_sysinfo_ehdr(uintptr_t base);
+extern void *vdso_sym(const char *version, const char *name);
+
+
+/* And here's the code. */
+
+#ifndef __x86_64__
+# error Not yet ported to non-x86_64 architectures
+#endif
+
+static struct vdso_info
+{
+	bool valid;
+
+	/* Load information */
+	uintptr_t load_addr;
+	uintptr_t load_offset;  /* load_addr - recorded vaddr */
+
+	/* Symbol table */
+	Elf64_Sym *symtab;
+	const char *symstrings;
+	Elf64_Word *bucket, *chain;
+	Elf64_Word nbucket, nchain;
+
+	/* Version table */
+	Elf64_Versym *versym;
+	Elf64_Verdef *verdef;
+} vdso_info;
+
+/* Straight from the ELF specification. */
+static unsigned long elf_hash(const unsigned char *name)
+{
+	unsigned long h = 0, g;
+	while (*name)
+	{
+		h = (h << 4) + *name++;
+		if (g = h & 0xf0000000)
+			h ^= g >> 24;
+		h &= ~g;
+	}
+	return h;
+}
+
+void vdso_init_from_sysinfo_ehdr(uintptr_t base)
+{
+	size_t i;
+	bool found_vaddr = false;
+
+	vdso_info.valid = false;
+
+	vdso_info.load_addr = base;
+
+	Elf64_Ehdr *hdr = (Elf64_Ehdr*)base;
+	Elf64_Phdr *pt = (Elf64_Phdr*)(vdso_info.load_addr + hdr->e_phoff);
+	Elf64_Dyn *dyn = 0;
+
+	/*
+	 * We need two things from the segment table: the load offset
+	 * and the dynamic table.
+	 */
+	for (i = 0; i < hdr->e_phnum; i++)
+	{
+		if (pt[i].p_type == PT_LOAD && !found_vaddr) {
+			found_vaddr = true;
+			vdso_info.load_offset =	base
+				+ (uintptr_t)pt[i].p_offset
+				- (uintptr_t)pt[i].p_vaddr;
+		} else if (pt[i].p_type == PT_DYNAMIC) {
+			dyn = (Elf64_Dyn*)(base + pt[i].p_offset);
+		}
+	}
+
+	if (!found_vaddr || !dyn)
+		return;  /* Failed */
+
+	/*
+	 * Fish out the useful bits of the dynamic table.
+	 */
+	Elf64_Word *hash = 0;
+	vdso_info.symstrings = 0;
+	vdso_info.symtab = 0;
+	vdso_info.versym = 0;
+	vdso_info.verdef = 0;
+	for (i = 0; dyn[i].d_tag != DT_NULL; i++) {
+		switch (dyn[i].d_tag) {
+		case DT_STRTAB:
+			vdso_info.symstrings = (const char *)
+				((uintptr_t)dyn[i].d_un.d_ptr
+				 + vdso_info.load_offset);
+			break;
+		case DT_SYMTAB:
+			vdso_info.symtab = (Elf64_Sym *)
+				((uintptr_t)dyn[i].d_un.d_ptr
+				 + vdso_info.load_offset);
+			break;
+		case DT_HASH:
+			hash = (Elf64_Word *)
+				((uintptr_t)dyn[i].d_un.d_ptr
+				 + vdso_info.load_offset);
+			break;
+		case DT_VERSYM:
+			vdso_info.versym = (Elf64_Versym *)
+				((uintptr_t)dyn[i].d_un.d_ptr
+				 + vdso_info.load_offset);
+			break;
+		case DT_VERDEF:
+			vdso_info.verdef = (Elf64_Verdef *)
+				((uintptr_t)dyn[i].d_un.d_ptr
+				 + vdso_info.load_offset);
+			break;
+		}
+	}
+	if (!vdso_info.symstrings || !vdso_info.symtab || !hash)
+		return;  /* Failed */
+
+	if (!vdso_info.verdef)
+		vdso_info.versym = 0;
+
+	/* Parse the hash table header. */
+	vdso_info.nbucket = hash[0];
+	vdso_info.nchain = hash[1];
+	vdso_info.bucket = &hash[2];
+	vdso_info.chain = &hash[vdso_info.nbucket + 2];
+
+	/* That's all we need. */
+	vdso_info.valid = true;
+}
+
+static bool vdso_match_version(Elf64_Versym ver,
+			       const char *name, Elf64_Word hash)
+{
+	/*
+	 * This is a helper function to check if the version indexed by
+	 * ver matches name (which hashes to hash).
+	 *
+	 * The version definition table is a mess, and I don't know how
+	 * to do this in better than linear time without allocating memory
+	 * to build an index.  I also don't know why the table has
+	 * variable size entries in the first place.
+	 *
+	 * For added fun, I can't find a comprehensible specification of how
+	 * to parse all the weird flags in the table.
+	 *
+	 * So I just parse the whole table every time.
+	 */
+
+	/* First step: find the version definition */
+	ver &= 0x7fff;  /* Apparently bit 15 means "hidden" */
+	Elf64_Verdef *def = vdso_info.verdef;
+	while(true) {
+		if ((def->vd_flags & VER_FLG_BASE) == 0
+		    && (def->vd_ndx & 0x7fff) == ver)
+			break;
+
+		if (def->vd_next == 0)
+			return false;  /* No definition. */
+
+		def = (Elf64_Verdef *)((char *)def + def->vd_next);
+	}
+
+	/* Now figure out whether it matches. */
+	Elf64_Verdaux *aux = (Elf64_Verdaux*)((char *)def + def->vd_aux);
+	return def->vd_hash == hash
+		&& !strcmp(name, vdso_info.symstrings + aux->vda_name);
+}
+
+void *vdso_sym(const char *version, const char *name)
+{
+	unsigned long ver_hash;
+	if (!vdso_info.valid)
+		return 0;
+
+	ver_hash = elf_hash(version);
+	Elf64_Word chain = vdso_info.bucket[elf_hash(name) % vdso_info.nbucket];
+
+	for (; chain != STN_UNDEF; chain = vdso_info.chain[chain]) {
+		Elf64_Sym *sym = &vdso_info.symtab[chain];
+
+		/* Check for a defined global or weak function w/ right name. */
+		if (ELF64_ST_TYPE(sym->st_info) != STT_FUNC)
+			continue;
+		if (ELF64_ST_BIND(sym->st_info) != STB_GLOBAL &&
+		    ELF64_ST_BIND(sym->st_info) != STB_WEAK)
+			continue;
+		if (sym->st_shndx == SHN_UNDEF)
+			continue;
+		if (strcmp(name, vdso_info.symstrings + sym->st_name))
+			continue;
+
+		/* Check symbol version. */
+		if (vdso_info.versym
+		    && !vdso_match_version(vdso_info.versym[chain],
+					   version, ver_hash))
+			continue;
+
+		return (void *)(vdso_info.load_offset + sym->st_value);
+	}
+
+	return 0;
+}
+
+void vdso_init_from_auxv(void *auxv)
+{
+	Elf64_auxv_t *elf_auxv = auxv;
+	for (int i = 0; elf_auxv[i].a_type != AT_NULL; i++)
+	{
+		if (elf_auxv[i].a_type == AT_SYSINFO_EHDR) {
+			vdso_init_from_sysinfo_ehdr(elf_auxv[i].a_un.a_val);
+			return;
+		}
+	}
+
+	vdso_info.valid = false;
+}
diff --git a/Documentation/vDSO/vdso_test.c b/Documentation/vDSO/vdso_test.c
new file mode 100644
index 0000000..1f3a776
--- /dev/null
+++ b/Documentation/vDSO/vdso_test.c
@@ -0,0 +1,112 @@
+/*
+ * vdso_test.c: Sample code to test parse_vdso.c on x86_64
+ * Copyright (c) 2011 Andy Lutomirski
+ * Subject to the GNU General Public License, version 2
+ *
+ * You can amuse yourself by compiling with:
+ * gcc -std=gnu99 -nostdlib
+ *     -Os -fno-asynchronous-unwind-tables -flto
+ *      vdso_test.c parse_vdso.c -o vdso_test
+ * to generate a small binary with no dependencies at all.
+ */
+
+#include <sys/syscall.h>
+#include <sys/time.h>
+#include <unistd.h>
+#include <stdint.h>
+
+extern void *vdso_sym(const char *version, const char *name);
+extern void vdso_init_from_sysinfo_ehdr(uintptr_t base);
+extern void vdso_init_from_auxv(void *auxv);
+
+/* We need a libc functions... */
+int strcmp(const char *a, const char *b)
+{
+	/* This implementation is buggy: it never returns -1. */
+	while (*a || *b) {
+		if (*a != *b)
+			return 1;
+		if (*a == 0 || *b == 0)
+			return 1;
+		a++;
+		b++;
+	}
+
+	return 0;
+}
+
+/* ...and two syscalls.  This is x86_64-specific. */
+static inline long linux_write(int fd, const void *data, size_t len)
+{
+
+	long ret;
+	asm volatile ("syscall" : "=a" (ret) : "a" (__NR_write),
+		      "D" (fd), "S" (data), "d" (len) :
+		      "cc", "memory", "rcx",
+		      "r8", "r9", "r10", "r11" );
+	return ret;
+}
+
+static inline void linux_exit(int code)
+{
+	asm volatile ("syscall" : : "a" (__NR_exit), "D" (code));
+}
+
+void to_base10(char *lastdig, uint64_t n)
+{
+	while (n) {
+		*lastdig = (n % 10) + '0';
+		n /= 10;
+		lastdig--;
+	}
+}
+
+__attribute__((externally_visible)) void c_main(void **stack)
+{
+	/* Parse the stack */
+	long argc = (long)*stack;
+	stack += argc + 2;
+
+	/* Now we're pointing at the environment.  Skip it. */
+	while(*stack)
+		stack++;
+	stack++;
+
+	/* Now we're pointing at auxv.  Initialize the vDSO parser. */
+	vdso_init_from_auxv((void *)stack);
+
+	/* Find gettimeofday. */
+	typedef long (*gtod_t)(struct timeval *tv, struct timezone *tz);
+	gtod_t gtod = (gtod_t)vdso_sym("LINUX_2.6", "__vdso_gettimeofday");
+
+	if (!gtod)
+		linux_exit(1);
+
+	struct timeval tv;
+	long ret = gtod(&tv, 0);
+
+	if (ret == 0) {
+		char buf[] = "The time is                     .000000\n";
+		to_base10(buf + 31, tv.tv_sec);
+		to_base10(buf + 38, tv.tv_usec);
+		linux_write(1, buf, sizeof(buf) - 1);
+	} else {
+		linux_exit(ret);
+	}
+
+	linux_exit(0);
+}
+
+/*
+ * This is the real entry point.  It passes the initial stack into
+ * the C entry point.
+ */
+asm (
+	".text\n"
+	".global _start\n"
+        ".type _start,@function\n"
+        "_start:\n\t"
+        "mov %rsp,%rdi\n\t"
+        "jmp c_main"
+	);
+
-- 
1.7.6

