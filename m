Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab0FIVjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:39:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758444Ab0FIVjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:39:45 -0400
Date: Wed, 9 Jun 2010 17:39:16 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Message-Id: <1d5ebadd771a004d9d12de0faaa7c668428cd4de.1276116186.git.jbaron@redhat.com>
In-Reply-To: <cover.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
Subject: [PATCH 07/13] jump label v9: sort jump table at build-time
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The jump label table is more optimal accessed if the entries are continguous.
Sorting the table accomplishes this. Do the sort at build-time. Adds a '-j'
option to 'modpost' which replaces the vmlinux, with a sorted jump label
section vmlinux. I've tested this on x86 with relocatable and it works fine
there as well. Note that I have not sorted the jump label table in modules.
The module tables tend to be smaller, and thus their is less value to this.
The kernel continues to do the sort, just in case, but at least for the vmlinux,
this is just a verfication that the jump label table has already been sorted.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 Makefile                          |    6 ++-
 include/asm-generic/vmlinux.lds.h |   18 +++++++-
 scripts/mod/Makefile              |    1 +
 scripts/mod/modpost.c             |   83 +++++++++++++++++++++++++++++++++++-
 scripts/mod/modpost.h             |    2 +
 5 files changed, 103 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index bf9955d..6c6e608 100644
--- a/Makefile
+++ b/Makefile
@@ -152,7 +152,7 @@ obj		:= $(objtree)
 
 VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
 
-export srctree objtree VPATH
+export srctree objtree VPATH hdr-arch
 
 
 # SUBARCH tells the usermode build what the underlying arch is.  That is set
@@ -850,6 +850,9 @@ define rule_vmlinux-modpost
 	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
 endef
 
+quiet_cmd_sort-jump-label = SORT    $@
+      cmd_sort-jump-label = $(srctree)/scripts/mod/modpost -j -s $@
+
 # vmlinux image - including updated kernel symbols
 vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o) FORCE
 ifdef CONFIG_HEADERS_CHECK
@@ -863,6 +866,7 @@ ifdef CONFIG_BUILD_DOCSRC
 endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
+	$(call cmd,sort-jump-label)
 	$(Q)rm -f .old_version
 
 # build vmlinux.o first to catch section mismatch errors early
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f6137ba..457c11d 100644
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
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index ff954f8..a6dbbe6 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -1,4 +1,5 @@
 hostprogs-y	:= modpost mk_elfconfig
+HOST_EXTRACFLAGS += -iquote "$(srctree)/arch/$(hdr-arch)/include/asm"
 always		:= $(hostprogs-y) empty.o
 
 modpost-objs	:= modpost.o file2alias.o sumversion.o
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 3318692..1ed8380 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -17,6 +17,7 @@
 #include "modpost.h"
 #include "../../include/generated/autoconf.h"
 #include "../../include/linux/license.h"
+#include <linux/types.h>
 
 /* Some toolchains use a `_' prefix for all user symbols. */
 #ifdef CONFIG_SYMBOL_PREFIX
@@ -41,6 +42,8 @@ static int warn_unresolved = 0;
 /* How a symbol is exported */
 static int sec_mismatch_count = 0;
 static int sec_mismatch_verbose = 1;
+/* jump label */
+static int enable_jump_label = 0;
 
 enum export {
 	export_plain,      export_unused,     export_gpl,
@@ -315,12 +318,18 @@ void *grab_file(const char *filename, unsigned long *size)
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
@@ -367,6 +376,63 @@ void release_file(void *file, unsigned long size)
 	munmap(file, size);
 }
 
+#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL
+
+#include "jump_label.h"
+
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
+			name = (char *)(jump_strings + (iter->name - jump_strings_addr));
+			next_name = (char *)(jump_strings +
+					(iter_next->name - jump_strings_addr));
+			if (strcmp(name, next_name) > 0) {
+				swap_jump_label_entries(iter, iter_next);
+				swapped = 1;
+			}
+		}
+	} while (swapped == 1);
+}
+
+#else
+
+static inline void sort_jump_label_table(struct elf_info *info, Elf_Ehdr *hdr)
+{
+	return;
+}
+
+#endif
+
 static int parse_elf(struct elf_info *info, const char *filename)
 {
 	unsigned int i;
@@ -460,6 +526,10 @@ static int parse_elf(struct elf_info *info, const char *filename)
 			info->export_unused_gpl_sec = i;
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
+		else if (strcmp(secname, "__jump_table") == 0)
+			info->jump_sec = i;
+		else if (strcmp(secname, "__jump_strings") == 0)
+			info->jump_strings_sec = i;
 
 		if (sechdrs[i].sh_type != SHT_SYMTAB)
 			continue;
@@ -480,6 +550,10 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		sym->st_value = TO_NATIVE(sym->st_value);
 		sym->st_size  = TO_NATIVE(sym->st_size);
 	}
+
+	if (enable_jump_label)
+		sort_jump_label_table(info, hdr);
+
 	return 1;
 }
 
@@ -1965,7 +2039,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:j")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2003,6 +2077,9 @@ int main(int argc, char **argv)
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
index be987a4..0875d4b 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -126,6 +126,8 @@ struct elf_info {
 	Elf_Section  export_gpl_sec;
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
+	Elf_Section  jump_sec;
+	Elf_Section  jump_strings_sec;
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
-- 
1.7.1

