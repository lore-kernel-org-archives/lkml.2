Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0DITvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:51:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493Ab0DITuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:50:23 -0400
Date: Fri, 9 Apr 2010 15:49:57 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com
Message-Id: <9cd6a0307ac55f2090c5b75a26ee9ca6a167cc8d.1270839564.git.jbaron@redhat.com>
In-Reply-To: <cover.1270839564.git.jbaron@redhat.com>
References: <cover.1270839564.git.jbaron@redhat.com>
Subject: [PATCH 7/9] jump label: sort jump table at build-time
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The jump label table is more optimal accessed if the entries are continguous.
Sorting the table accomplishes this. Do the sort at build-time. Adds a '-j'
option to 'modpost' which replaces the vmlinux, with a sorted jump label
section vmlinux. I've tested this on x86 with relocatable and it works fine
there as well. Note that I have not sorted the jump label table in modules.
This is b/c the jump label names can be exported by the core kernel, and thus
I don't have them available at buildtime. This could be solved by either
finding the correct ones in the vmlinux, or by embedding the name of the jump
label in the module tables (and not just a pointer), but the module tables
tend to be smaller, and thus their is less value to this kind of change
anyway. The kernel continues to do the sort, just in case, but at least for
the vmlinux, this is just a verfication that the jump label table has
already been sorted.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 Makefile                          |    4 ++
 include/asm-generic/vmlinux.lds.h |   18 ++++++++--
 include/linux/jump_label.h        |    1 +
 scripts/mod/modpost.c             |   69 +++++++++++++++++++++++++++++++++++--
 scripts/mod/modpost.h             |    9 +++++
 5 files changed, 95 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 558ddec..f59dd57 100644
--- a/Makefile
+++ b/Makefile
@@ -845,6 +845,9 @@ define rule_vmlinux-modpost
 	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
 endef
 
+quiet_cmd_sort-jump-label = SORT    $@
+      cmd_sort-jump-label = $(srctree)/scripts/mod/modpost -j $@
+
 # vmlinux image - including updated kernel symbols
 vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o) FORCE
 ifdef CONFIG_HEADERS_CHECK
@@ -858,6 +861,7 @@ ifdef CONFIG_BUILD_DOCSRC
 endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
+	$(call cmd,sort-jump-label)
 	$(Q)rm -f .old_version
 
 # build vmlinux.o first to catch section mismatch errors early
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 83a469d..f9d8188 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -168,7 +168,6 @@
 	TRACE_PRINTKS()							\
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()						\
-	JUMP_TABLE()							\
 
 /*
  * Data section helpers
@@ -207,7 +206,6 @@
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
-		*(__jump_strings)/* Jump: strings */	\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
@@ -216,6 +214,10 @@
 									\
 	BUG_TABLE							\
 									\
+	JUMP_TABLE							\
+									\
+	JUMP_STRINGS							\
+									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
@@ -559,11 +561,21 @@
 #define BUG_TABLE
 #endif
 
-#define JUMP_TABLE()							\
+#define JUMP_TABLE							\
 	. = ALIGN(64);							\
+	__jump_table : AT(ADDR(__jump_table) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___jump_table) = .;		\
 		*(__jump_table)						\
 		VMLINUX_SYMBOL(__stop___jump_table) = .;		\
+	}
+
+#define JUMP_STRINGS							\
+	. = ALIGN(64);							\
+	__jump_strings : AT(ADDR(__jump_strings) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__start___jump_strings) = .;		\
+		*(__jump_strings)					\
+		VMLINUX_SYMBOL(__stop___jump_strings) = .;		\
+	}
 
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 9868c43..7238805 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -3,6 +3,7 @@
 
 #include <asm/jump_label.h>
 
+/* struct jump_entry must match scripts/mod/mopost.h */
 struct jump_entry {
 	unsigned long code;
 	unsigned long target;
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 2092361..1a5f543 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -41,6 +41,8 @@ static int warn_unresolved = 0;
 /* How a symbol is exported */
 static int sec_mismatch_count = 0;
 static int sec_mismatch_verbose = 1;
+/* jump label */
+static int enable_jump_label = 0;
 
 enum export {
 	export_plain,      export_unused,     export_gpl,
@@ -315,12 +317,18 @@ void *grab_file(const char *filename, unsigned long *size)
 	void *map;
 	int fd;
 
-	fd = open(filename, O_RDONLY);
+	if (!enable_jump_label)
+		fd = open(filename, O_RDONLY);
+	else
+		fd = open(filename, O_RDWR);
 	if (fd < 0 || fstat(fd, &st) != 0)
 		return NULL;
 
 	*size = st.st_size;
-	map = mmap(NULL, *size, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (!enable_jump_label)
+		map = mmap(NULL, *size, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
+	else
+		map = mmap(NULL, *size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
 	close(fd);
 
 	if (map == MAP_FAILED)
@@ -367,6 +375,50 @@ void release_file(void *file, unsigned long size)
 	munmap(file, size);
 }
 
+static void swap_jump_label_entries(struct jump_entry *previous, struct jump_entry *next)
+{
+	struct jump_entry tmp;
+
+	tmp = *next;
+	*next = *previous;
+	*previous = tmp;
+}
+
+static void sort_jump_label_table(struct elf_info *info, Elf_Ehdr *hdr)
+{
+	int swapped = 0;
+	struct jump_entry *iter, *iter_next;
+	char *name, *next_name;
+	Elf_Shdr *sechdrs = info->sechdrs;
+	unsigned long jump_table, jump_table_end;
+	unsigned long jump_strings, jump_strings_addr;
+
+	if ((info->jump_sec == 0) && (info->jump_strings_sec == 0))
+		return;
+
+	jump_table = (unsigned long)hdr + sechdrs[info->jump_sec].sh_offset;
+	jump_table_end = jump_table + sechdrs[info->jump_sec].sh_size;
+	jump_strings = (unsigned long)hdr +
+				sechdrs[info->jump_strings_sec].sh_offset;
+	jump_strings_addr = sechdrs[info->jump_strings_sec].sh_addr;
+
+	do {
+		swapped = 0;
+		iter = iter_next = (struct jump_entry *)jump_table;
+		iter_next++;
+		for (; iter_next < (struct jump_entry *)jump_table_end;
+							iter++, iter_next++) {
+			name = jump_strings + (iter->name - jump_strings_addr);
+			next_name = jump_strings +
+					(iter_next->name - jump_strings_addr);
+			if (strcmp(name, next_name) > 0) {
+				swap_jump_label_entries(iter, iter_next);
+				swapped = 1;
+			}
+		}
+	} while (swapped == 1);
+}
+
 static int parse_elf(struct elf_info *info, const char *filename)
 {
 	unsigned int i;
@@ -460,6 +512,10 @@ static int parse_elf(struct elf_info *info, const char *filename)
 			info->export_unused_gpl_sec = i;
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
+		else if (strcmp(secname, "__jump_table") == 0)
+			info->jump_sec = i;
+		else if (strcmp(secname, "__jump_strings") == 0)
+			info->jump_strings_sec = i;
 
 		if (sechdrs[i].sh_type != SHT_SYMTAB)
 			continue;
@@ -480,6 +536,10 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		sym->st_value = TO_NATIVE(sym->st_value);
 		sym->st_size  = TO_NATIVE(sym->st_size);
 	}
+
+	if (enable_jump_label)
+		sort_jump_label_table(info, hdr);
+
 	return 1;
 }
 
@@ -1941,7 +2001,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:j")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -1979,6 +2039,9 @@ int main(int argc, char **argv)
 		case 'w':
 			warn_unresolved = 1;
 			break;
+		case 'j':
+			enable_jump_label = 1;
+			break;
 		default:
 			exit(1);
 		}
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index be987a4..312b6db 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -126,11 +126,20 @@ struct elf_info {
 	Elf_Section  export_gpl_sec;
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
+	Elf_Section  jump_sec;
+	Elf_Section  jump_strings_sec;
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
 };
 
+/* struct jump_entry must match include/linux/jump_labal.h */
+struct jump_entry {
+	unsigned long code;
+	unsigned long target;
+	char *name;
+};
+
 /* file2alias.c */
 extern unsigned int cross_build;
 void handle_moddevtable(struct module *mod, struct elf_info *info,
-- 
1.7.0.1

