Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2DTVcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:32:09 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62742 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab2DTVaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:30:09 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@redhat.com>, <masami.hiramatsu.pt@hitachi.com>,
        <rusty@rustcorp.com.au>
Subject: [RFC PATCH 6/8] kallsyms: Add kallsyms kallsyms_line_loc_lookup and print function
Date: Fri, 20 Apr 2012 16:29:52 -0500
Message-ID: <1334957394-12086-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
References: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new kallsyms symbol type called a line location.  A
line location will get encoded as a symbol with the type '0xff'.  Line
locations will be excluded from the /proc/kallsyms such that the user
space interface will remain unchanged.

The line locations come from:
   scripts/readelf -q --debug-dump=line vmlinux

The output is processed by scripts/kallsyms in a similar manner to the
output from nm -n vmlinux in order to construct the assembly file
which has all original kallsyms data.

In order to make all the original kallsyms functions return the same
expected values while allowing extra data in the kallsyms tables, the
get_symbol_pos() was modified to take an additional argument.  The new
4th argument is called "is_line_loc". That argument controls if
get_symbol_pos() should return a symbol or a line location.

kallsyms_line_loc_lookup() was added for the purpose of looking up a
line location and will call get_symbol_pos() with the 4th argument
being true.  This function was introduced in order to call it from
__sprint_symbol() so that the kernel can emit a file and line number
when providing a backtrace / oops output to an end user.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Makefile                 |    9 +++-
 include/linux/kallsyms.h |   12 +++++
 init/Kconfig             |   11 +++++
 kernel/kallsyms.c        |  112 +++++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 131 insertions(+), 13 deletions(-)

diff --git a/Makefile b/Makefile
index f6578f4..ea87304 100644
--- a/Makefile
+++ b/Makefile
@@ -342,6 +342,7 @@ GENKSYMS	= scripts/genksyms/genksyms
 INSTALLKERNEL  := installkernel
 DEPMOD		= /sbin/depmod
 KALLSYMS	= scripts/kallsyms
+READELF		= scripts/readelf
 PERL		= perl
 CHECK		= sparse
 
@@ -857,10 +858,14 @@ define rule_ksym_ld
 	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd
 endef
 
+KALLSYMS_INPUT_CMD = ($(NM) -n $<; \
+	$(if $(CONFIG_KALLSYMS_LINE_LOCATIONS), \
+	 $(READELF) --debug-dump=line -q $<))
 # Generate .S file with all kernel symbols
 quiet_cmd_kallsyms = KSYM    $@
-      cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
-                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
+      cmd_kallsyms = $(KALLSYMS_INPUT_CMD) | $(KALLSYMS) \
+                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) \
+		     $(if $(CONFIG_KALLSYMS_LINE_LOCATIONS), --ll-symbols) > $@
 
 .tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
 	$(call if_changed_dep,as_o_S)
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 3875719..39125d0 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -33,6 +33,10 @@ const char *kallsyms_lookup(unsigned long addr,
 			    unsigned long *symbolsize,
 			    unsigned long *offset,
 			    char **modname, char *namebuf);
+const char *kallsyms_line_loc_lookup(unsigned long addr,
+			    unsigned long *symbolsize,
+			    unsigned long *offset,
+			    char **modname, char *namebuf);
 
 /* Look up a kernel symbol and return it in a text buffer. */
 extern int sprint_symbol(char *buffer, unsigned long address);
@@ -73,6 +77,14 @@ static inline const char *kallsyms_lookup(unsigned long addr,
 {
 	return NULL;
 }
+static inline const char *kallsyms_line_loc_lookup(unsigned long addr,
+					  unsigned long *symbolsize,
+					  unsigned long *offset,
+					  char **modname, char *namebuf)
+{
+	return NULL;
+}
+
 
 static inline int sprint_symbol(char *buffer, unsigned long addr)
 {
diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..20f537a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1012,6 +1012,17 @@ config KALLSYMS_ALL
 
 	   Say N unless you really need all symbols.
 
+config KALLSYMS_LINE_LOCATIONS
+	bool "Load source line information debugging kernel with kallsyms"
+	depends on DEBUG_KERNEL && KALLSYMS
+	default n
+	help
+	   Say Y here to let the kernel print out symbolic crash
+	   information which also contains source line information.
+	   This increases the size of the kernel somewhat, as all the
+	   lines for locations tables have to be loaded into the
+	   kernel image to allow address to line lookups.
+
 config HOTPLUG
 	bool "Support for hot-pluggable devices" if EXPERT
 	default y
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 550f273..921f2b3 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -32,6 +32,9 @@
 #define all_var 0
 #endif
 
+/* Is this a line location type? */
+#define IS_LLOC(pos) (kallsyms_type_table[pos] == 0xff)
+
 /*
  * These will be re-linked against their real values
  * during the second link stage.
@@ -188,9 +191,39 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 }
 EXPORT_SYMBOL_GPL(kallsyms_on_each_symbol);
 
+static void first_aliased_symbol(unsigned long *low)
+{
+find_alias:
+	while (*low && kallsyms_addresses[*low-1] == kallsyms_addresses[*low])
+		--*low;
+
+	if (*low) {
+		if (*low < kallsyms_num_syms && IS_LLOC(*low) &&
+		    kallsyms_addresses[*low+1] == kallsyms_addresses[*low]) {
+			++*low;
+		} else if (IS_LLOC(*low)) {
+			while (*low && IS_LLOC(*low))
+				--*low;
+			goto find_alias;
+		}
+	}
+}
+
+static void first_aliased_line_loc(unsigned long *low)
+{
+	while (*low && kallsyms_addresses[*low-1] == kallsyms_addresses[*low])
+		--*low;
+	while (*low < kallsyms_num_syms && !IS_LLOC(*low) &&
+	       kallsyms_addresses[*low] == kallsyms_addresses[*low+1])
+		++*low;
+	while (*low && !(IS_LLOC(*low)))
+		--*low;
+}
+
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
-				    unsigned long *offset)
+				    unsigned long *offset,
+				    bool is_line_loc)
 {
 	unsigned long symbol_start = 0, symbol_end = 0;
 	unsigned long i, low, high, mid;
@@ -214,14 +247,16 @@ static unsigned long get_symbol_pos(unsigned long addr,
 	 * Search for the first aliased symbol. Aliased
 	 * symbols are symbols with the same address.
 	 */
-	while (low && kallsyms_addresses[low-1] == kallsyms_addresses[low])
-		--low;
+	if (is_line_loc)
+		first_aliased_line_loc(&low);
+	else
+		first_aliased_symbol(&low);
 
 	symbol_start = kallsyms_addresses[low];
 
 	/* Search for next non-aliased symbol. */
 	for (i = low + 1; i < kallsyms_num_syms; i++) {
-		if (kallsyms_addresses[i] > symbol_start) {
+		if (kallsyms_addresses[i] > symbol_start && !IS_LLOC(low)) {
 			symbol_end = kallsyms_addresses[i];
 			break;
 		}
@@ -253,11 +288,52 @@ int kallsyms_lookup_size_offset(unsigned long addr, unsigned long *symbolsize,
 {
 	char namebuf[KSYM_NAME_LEN];
 	if (is_ksym_addr(addr))
-		return !!get_symbol_pos(addr, symbolsize, offset);
+		return !!get_symbol_pos(addr, symbolsize, offset, false);
 
 	return !!module_address_lookup(addr, symbolsize, offset, NULL, namebuf);
 }
 
+#ifdef CONFIG_KALLSYMS_LINE_LOCATIONS
+/*
+ * Lookup an address
+ * - modname is set to NULL if it's in the kernel.
+ * - We guarantee that the returned name is valid until we reschedule even if.
+ *   It resides in a module.
+ * - We also guarantee that modname will be valid until rescheduled.
+ */
+const char *kallsyms_line_loc_lookup(unsigned long addr,
+			    unsigned long *symbolsize,
+			    unsigned long *offset,
+			    char **modname, char *namebuf)
+{
+	namebuf[KSYM_NAME_LEN - 1] = 0;
+	namebuf[0] = 0;
+
+	if (modname)
+		*modname = NULL;
+	if (is_ksym_addr(addr)) {
+		unsigned long pos;
+
+		pos = get_symbol_pos(addr, symbolsize, offset, true);
+		if (!IS_LLOC(pos))
+			return NULL;
+		/* Grab name */
+		kallsyms_expand_symbol(get_symbol_offset(pos), namebuf);
+		return namebuf;
+	}
+
+	return NULL;
+}
+#else /* !CONFIG_KALLSYMS_LINE_LOCATIONS */
+const char *kallsyms_line_loc_lookup(unsigned long addr,
+			    unsigned long *symbolsize,
+			    unsigned long *offset,
+			    char **modname, char *namebuf)
+{
+	return NULL;
+}
+#endif /* CONFIG_KALLSYMS_LINE_LOCATIONS */
+
 /*
  * Lookup an address
  * - modname is set to NULL if it's in the kernel.
@@ -276,7 +352,7 @@ const char *kallsyms_lookup(unsigned long addr,
 	if (is_ksym_addr(addr)) {
 		unsigned long pos;
 
-		pos = get_symbol_pos(addr, symbolsize, offset);
+		pos = get_symbol_pos(addr, symbolsize, offset, false);
 		/* Grab name */
 		kallsyms_expand_symbol(get_symbol_offset(pos), namebuf);
 		if (modname)
@@ -297,7 +373,7 @@ int lookup_symbol_name(unsigned long addr, char *symname)
 	if (is_ksym_addr(addr)) {
 		unsigned long pos;
 
-		pos = get_symbol_pos(addr, NULL, NULL);
+		pos = get_symbol_pos(addr, NULL, NULL, false);
 		/* Grab name */
 		kallsyms_expand_symbol(get_symbol_offset(pos), symname);
 		return 0;
@@ -315,7 +391,7 @@ int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
 	if (is_ksym_addr(addr)) {
 		unsigned long pos;
 
-		pos = get_symbol_pos(addr, size, offset);
+		pos = get_symbol_pos(addr, size, offset, false);
 		/* Grab name */
 		kallsyms_expand_symbol(get_symbol_offset(pos), name);
 		modname[0] = '\0';
@@ -332,7 +408,7 @@ static int __sprint_symbol(char *buffer, unsigned long address,
 	char *modname;
 	const char *name;
 	unsigned long offset, size;
-	int len;
+	int len, extra;
 
 	address += symbol_offset;
 	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
@@ -346,9 +422,19 @@ static int __sprint_symbol(char *buffer, unsigned long address,
 	offset -= symbol_offset;
 
 	if (modname)
-		len += sprintf(buffer, "+%#lx/%#lx [%s]", offset, size, modname);
+		extra = sprintf(buffer, "+%#lx/%#lx [%s]", offset,
+				size, modname);
 	else
-		len += sprintf(buffer, "+%#lx/%#lx", offset, size);
+		extra = sprintf(buffer, "+%#lx/%#lx", offset, size);
+	buffer += extra;
+	len += extra;
+	name = kallsyms_line_loc_lookup(address - symbol_offset, &size,
+					&offset, &modname, buffer + 1);
+
+	if (name) {
+		*buffer = ' ';
+		len = strlen(buffer);
+	}
 
 	return len;
 }
@@ -490,6 +576,10 @@ static int s_show(struct seq_file *m, void *p)
 	if (!iter->name[0])
 		return 0;
 
+	/* Ignore any src/line information */
+	if (iter->type == (char)0xff)
+		return 0;
+
 	if (iter->module_name[0]) {
 		char type;
 
-- 
1.7.10

