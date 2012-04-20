Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab2DTVaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:30:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:35363 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab2DTVaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:30:12 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@redhat.com>, <masami.hiramatsu.pt@hitachi.com>,
        <rusty@rustcorp.com.au>
Subject: [RFC PATCH 7/8] modules: decode .debug_line sections if provided by insmod
Date: Fri, 20 Apr 2012 16:29:53 -0500
Message-ID: <1334957394-12086-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
References: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user space provided a kernel module with elf .debug_line section
data, it can be decoded and stored in a table so as to print source
line information when ever a kallsyms is also enabled.

Example:
Call Trace:
 [<ffffffff815f2e23>] panic+0xbd/0x1c3
 [<ffffffff815f3014>] ? printk+0x68/0x6c
 [<ffffffffa0000175>] panic_write+0x25/0x30 [test_panic] test_panic.c:189

The .debug_line parser from binutils 2.14 was converted to work with in
the kernel.  The actual .debug_line section is not kept beyond the
module load.  The kernel keeps a linked list of the decoded
compilation units from the kernel module's .debug_line section.  With
in the compilation unit there are two arrays.  One is the array of
strings representing the file names in the compilation unit.  Other
other is the address table which uses 3 32 bit unsigned integers to
represent:

  1) The address offset from the where the module is loaded
  2) Line number the address represents in the source file
  3) The index in to the first array to find the file name

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/module.h |   32 +++
 kernel/module.c        |  549 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 581 insertions(+)

diff --git a/include/linux/module.h b/include/linux/module.h
index fbcafe2..03e302f 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -217,6 +217,22 @@ struct module_ref {
 	unsigned long decs;
 } __attribute((aligned(2 * sizeof(unsigned long))));
 
+/* Individual line entry data */
+struct module_cu_entry {
+	unsigned int off;	/* Offset address from kernel module base */
+	unsigned int line;	/* Source line number */
+	unsigned int file;	/* Source file lookup number */
+};
+
+/* Module compilation unit linked list for line addr2line data */
+struct module_cu {
+	unsigned char **filetab;
+	unsigned int maxfiletab;
+	struct module_cu_entry *ent;
+	unsigned int maxent;
+	struct module_cu *next;
+};
+
 struct module
 {
 	enum module_state state;
@@ -299,6 +315,8 @@ struct module
 	struct bug_entry *bug_table;
 #endif
 
+	struct module_cu *dlinedb;
+
 #ifdef CONFIG_KALLSYMS
 	/*
 	 * We keep the symbol and string tables for kallsyms.
@@ -490,6 +508,11 @@ const char *module_address_lookup(unsigned long addr,
 			    unsigned long *offset,
 			    char **modname,
 			    char *namebuf);
+const char *module_address_line_lookup(unsigned long addr,
+			    unsigned long *symbolsize,
+			    unsigned long *offset,
+			    char **modname,
+			    char *namebuf);
 int lookup_module_symbol_name(unsigned long addr, char *symname);
 int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 
@@ -565,6 +588,15 @@ static inline const char *module_address_lookup(unsigned long addr,
 	return NULL;
 }
 
+static inline const char *module_address_line_lookup(unsigned long addr,
+					  unsigned long *symbolsize,
+					  unsigned long *offset,
+					  char **modname,
+					  char *namebuf)
+{
+	return NULL;
+}
+
 static inline int lookup_module_symbol_name(unsigned long addr, char *symname)
 {
 	return -ERANGE;
diff --git a/kernel/module.c b/kernel/module.c
index 78ac6ec..478a44b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -138,6 +138,7 @@ struct load_info {
 	unsigned int num_debug;
 	struct {
 		unsigned int sym, str, mod, vers, info, pcpu;
+		unsigned int dline;
 	} index;
 };
 
@@ -1786,6 +1787,22 @@ static void unset_module_core_ro_nx(struct module *mod) { }
 static void unset_module_init_ro_nx(struct module *mod) { }
 #endif
 
+static void free_dlinedb(struct module *mod)
+{
+	while (mod->dlinedb) {
+		struct module_cu *to_free = mod->dlinedb;
+
+		while (mod->dlinedb->maxfiletab) {
+			mod->dlinedb->maxfiletab--;
+			kfree(mod->dlinedb->filetab[mod->dlinedb->maxfiletab]);
+		}
+		kfree(mod->dlinedb->filetab);
+		kfree(mod->dlinedb->ent);
+		mod->dlinedb = mod->dlinedb->next;
+		kfree(to_free);
+	}
+}
+
 void __weak module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
@@ -1809,6 +1826,9 @@ static void free_module(struct module *mod)
 	/* Remove dynamic debug info */
 	ddebug_remove_module(mod->name);
 
+	/* Free module debug lines database */
+	free_dlinedb(mod);
+
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 
@@ -2844,6 +2864,488 @@ int __weak module_finalize(const Elf_Ehdr *hdr,
 	return 0;
 }
 
+static unsigned long get_bytes(unsigned char **ptr, int sz)
+{
+	unsigned char *addr = *ptr;
+	*ptr += sz;
+	/* Assume un-aligned ok */
+	if (sz == 4)
+		return *(__u32 *)addr;
+	else if (sz == 8)
+		return *(__u64 *)addr;
+	else if (sz == 2)
+		return *(__u16 *)addr;
+	else if (sz == 1)
+		return *(__u8 *)addr;
+
+	pr_err("bad btye_cpy");
+	WARN_ON(1);
+	return 0;
+}
+
+/* read_leb128 taken from binutils 2.14 */
+static unsigned long int
+read_leb128(unsigned char *data, int *length_return, int sign)
+{
+	unsigned long int result = 0;
+	unsigned int num_read = 0;
+	int shift = 0;
+	unsigned char byte;
+
+	do {
+		byte = *data++;
+		num_read++;
+		result |= (byte & 0x7f) << shift;
+		shift += 7;
+	} while (byte & 0x80);
+
+	if (length_return != NULL)
+		*length_return = num_read;
+
+	if (sign && (shift < 32) && (byte & 0x40))
+		result |= -1 << shift;
+
+	return result;
+}
+
+enum dwarf_line_number_x_ops {
+	DW_LNE_end_sequence = 1,
+	DW_LNE_set_address = 2,
+	DW_LNE_define_file = 3
+};
+
+enum dwarf_line_number_ops {
+	DW_LNS_extended_op = 0,
+	DW_LNS_copy = 1,
+	DW_LNS_advance_pc = 2,
+	DW_LNS_advance_line = 3,
+	DW_LNS_set_file = 4,
+	DW_LNS_set_column = 5,
+	DW_LNS_negate_stmt = 6,
+	DW_LNS_set_basic_block = 7,
+	DW_LNS_const_add_pc = 8,
+	DW_LNS_fixed_advance_pc = 9,
+	/* DWARF 3.  */
+	DW_LNS_set_prologue_end = 10,
+	DW_LNS_set_epilogue_begin = 11,
+	DW_LNS_set_isa = 12
+};
+
+static int
+process_extended_line_op(unsigned char *data, int cu_stmt,
+			 unsigned long *address, int *line, int *fileidx,
+			 int *is_stmt)
+{
+	unsigned char op_code;
+	int bytes_read;
+	unsigned int len;
+	unsigned long adr;
+
+	len = read_leb128(data, &bytes_read, 0);
+	data += bytes_read;
+
+	if (len == 0)
+		return bytes_read; /* Op not supported if len is 0 */
+
+	len += bytes_read;
+	op_code = *data++;
+
+	pr_debug("  Extended opcode %d: ", op_code);
+
+	switch (op_code) {
+	case DW_LNE_end_sequence:
+		pr_debug("End of Sequence\n\n");
+		if (cu_stmt) {
+			*address = 0;
+			*fileidx = 1;
+			*line = 1;
+			*is_stmt = cu_stmt;
+		}
+		break;
+
+	case DW_LNE_set_address:
+		adr = get_bytes(&data, sizeof(unsigned long));
+		pr_debug("set Address to 0x%lx\n", adr);
+		*address = adr;
+		break;
+
+	case DW_LNE_define_file:
+		/* Adding extra files not supported! */
+		pr_err("Extra file table dwarf entries not supported\n");
+		WARN_ON(1);
+		break;
+
+	default:
+		pr_debug("UNKNOWN: length %d\n", len - bytes_read);
+		break;
+	}
+
+	return len;
+}
+
+static void
+build_lineloc_tables(struct module *mod, const struct load_info *info,
+		     unsigned char *dlinetab_start, unsigned char *dlinetab_end)
+{
+	unsigned long mod_base = (unsigned long)mod->module_core;
+	unsigned char *start = dlinetab_start;
+	unsigned char *end = dlinetab_end;
+	unsigned char *ptr;
+	int offset;
+	unsigned int cu_len;
+	unsigned int cu_len_offset;
+	unsigned char *cu_end;
+
+	int cu_dwarf_ver;
+	int cu_prolog_len;
+	unsigned char cu_min_inst_len, cu_max_ops_per_inst;
+	unsigned char cu_stmt;
+	int cu_line_base;
+	unsigned char cu_line_range;
+	unsigned char cu_opcode_base;
+	unsigned char *cu_opcode_tbl;
+	unsigned int count;
+
+	unsigned long address;
+	unsigned int line;
+	unsigned int fileidx;
+	unsigned char op_code;
+	unsigned int is_stmt;
+	struct module_cu *n_cu;
+	int first_pass;
+
+	if (start >= end)
+		return;
+
+	/* Check that there is at least 64 bytes for processing the header */
+	if (end - start < 64) {
+		pr_err("%s: not enough bytes in CU\n", mod->name);
+		goto error_out;
+	}
+
+	/* Process a single compilation unit in the .debug_line section */
+another_cu:
+	ptr = start;
+	/* check for dwarf 3 */
+	cu_len = get_bytes(&ptr, 4);
+	/* XXX need check for 32 bit host here... */
+	if (cu_len == 0xffffffff) {
+		cu_len = get_bytes(&ptr, 8);
+		cu_len_offset = 12;
+		offset = 8;
+	} else {
+		cu_len_offset = 4;
+		offset = 4;
+	}
+
+	if (start + cu_len + cu_len_offset > end) {
+		pr_err("%s: Compile Unit too large\n", mod->name);
+		return; /* No more to process */
+	}
+	/* Check for version for dwarf 2-4 */
+	cu_dwarf_ver = get_bytes(&ptr, 2);
+	if (cu_dwarf_ver < 2 || cu_dwarf_ver > 4) {
+		pr_err("%s: bad dwarf version: %i\n", mod->name, cu_dwarf_ver);
+		goto error_out;
+	}
+
+	/* CU prologue */
+	cu_prolog_len = get_bytes(&ptr, offset);
+	cu_min_inst_len = get_bytes(&ptr, 1);
+	if (cu_dwarf_ver == 4)
+		cu_max_ops_per_inst = get_bytes(&ptr, 1);
+	else
+		cu_max_ops_per_inst	= 1;
+	if (cu_max_ops_per_inst == 0) {
+		pr_err("%s: invalid cu_max_ops_per_inst\n", mod->name);
+		goto error_out;
+	}
+
+	cu_stmt = get_bytes(&ptr, 1);
+	cu_line_base = get_bytes(&ptr, 1);
+	cu_line_base <<= 24; /* Sign extend */
+	cu_line_base >>= 24;
+	cu_line_range = get_bytes(&ptr, 1);
+	cu_opcode_base = get_bytes(&ptr, 1);
+	cu_opcode_tbl = ptr;
+
+	if (cu_line_range == 0) {
+		pr_err("%s: line range 0\n", mod->name);
+		goto error_out;
+	}
+
+	cu_end = start + cu_len + cu_len_offset;
+
+	/* check directory table */
+	start = cu_opcode_tbl + cu_opcode_base - 1;
+	if (start < dlinetab_start || start > end) {
+		pr_err("%s: directory table bound exception", mod->name);
+		goto error_out;
+	}
+	if (start[0]) {
+		while (start[0]) {
+			pr_debug("dir: %s\n", start);
+			start += strlen((char *) start) + 1;
+			if (start > end) {
+				pr_err("%s: dwarf error table corrupt",
+				       mod->name);
+				goto error_out;
+			}
+		}
+	}
+	start++;
+	if (start > end) {
+		pr_err("%s: No file table\n", mod->name);
+		goto error_out;
+	}
+
+	/* Add the compilation unit to the module struct */
+	n_cu = kzalloc(sizeof(struct module_cu), GFP_KERNEL);
+	if (!n_cu)
+		goto error_out;
+	n_cu->next = mod->dlinedb;
+	mod->dlinedb = n_cu;
+
+	/* Walk file table */
+	count = 0;
+	ptr = start;
+	while (ptr[0]) {
+		int bytes_read;
+		pr_debug("file: %s\n", ptr);
+		ptr += strlen((char *) ptr) + 1;
+		read_leb128(ptr, &bytes_read, 0); /* index */
+		ptr += bytes_read;
+		read_leb128(ptr, &bytes_read, 0); /* last mod time */
+		ptr += bytes_read;
+		read_leb128(ptr, &bytes_read, 0); /* file length */
+		ptr += bytes_read;
+		count++;
+	}
+	n_cu->filetab = kmalloc(sizeof(char *)*count, GFP_KERNEL);
+	if (!n_cu->filetab)
+		goto error_out;
+	count = 0;
+	while (start[0]) {
+		int bytes_read;
+		n_cu->filetab[count] = kstrdup(start, GFP_KERNEL);
+		if (!n_cu->filetab[count])
+			goto error_out;
+		start += strlen((char *) start) + 1;
+		read_leb128(start, &bytes_read, 0); /* index */
+		start += bytes_read;
+		read_leb128(start, &bytes_read, 0); /* last mod time */
+		start += bytes_read;
+		read_leb128(start, &bytes_read, 0); /* file length */
+		start += bytes_read;
+		count++;
+	}
+	n_cu->maxfiletab = count;
+	start++;
+
+
+	/*
+	 * Walk the line number table entirely one time to
+	 * compute and allocate an array for the addresses and
+	 * line locations.  A second pass will get executed to
+	 * assign all the data to the allocated array.
+	 */
+	first_pass = 1;
+	ptr = start;
+second_pass:
+	/* Reset Line Information state */
+	address = 0;
+	fileidx = 1;
+	line = 1;
+	is_stmt = cu_stmt;
+
+	start = ptr;
+	count = 0;
+	/* walk line number table */
+	while (start < cu_end) {
+		int adv;
+		int bytes_read;
+
+		op_code = *start++;
+		if (op_code >= cu_opcode_base) {
+			op_code -= cu_opcode_base;
+			adv = (op_code / cu_line_range) *
+				cu_min_inst_len;
+			address += adv;
+			adv = (op_code % cu_line_range) + cu_line_base;
+			line += adv;
+			pr_debug("%u:%u 0x%lx\n",
+				 fileidx, line, address);
+			if (first_pass) {
+				count++;
+				continue;
+			}
+			n_cu->ent[count].off = address - mod_base;
+			n_cu->ent[count].line = line;
+			n_cu->ent[count].file = fileidx - 1;
+			count++;
+			continue;
+		}
+		switch (op_code) {
+		case DW_LNS_extended_op:
+			start += process_extended_line_op(start, cu_stmt,
+				   &address, &line, &fileidx, &is_stmt);
+			break;
+		case DW_LNS_copy:
+			pr_debug("  Copy\n");
+			break;
+
+		case DW_LNS_advance_pc:
+			adv = cu_min_inst_len * read_leb128(start,
+							    &bytes_read, 0);
+			start += bytes_read;
+			address += adv;
+			pr_debug("  Advance PC by %d to %lx\n",
+				 adv, address);
+			break;
+
+		case DW_LNS_advance_line:
+			adv = read_leb128(start, &bytes_read, 1);
+			start += bytes_read;
+			line += adv;
+			pr_debug("  Advance Line by %d to %d\n",
+				 adv, line);
+			break;
+
+		case DW_LNS_set_file:
+			adv = read_leb128(start, &bytes_read, 0);
+			start += bytes_read;
+			pr_debug("  Set File Name to entry %d in the " \
+				"File Name Table\n", adv);
+			fileidx = adv;
+			break;
+
+		case DW_LNS_set_column:
+			adv = read_leb128(start, &bytes_read, 0);
+			start += bytes_read;
+			pr_debug("  Set column to %d\n", adv);
+			break;
+
+		case DW_LNS_negate_stmt:
+			adv = is_stmt;
+			adv = !adv;
+			pr_debug("  Set is_stmt to %d\n", adv);
+			is_stmt = adv;
+			break;
+
+		case DW_LNS_set_basic_block:
+			pr_debug("  Set basic block\n");
+			break;
+
+		case DW_LNS_const_add_pc:
+			adv = (((255 - cu_opcode_base) / cu_line_range)
+				   * cu_min_inst_len);
+			address += adv;
+			pr_debug("  Advance PC by constant %d to " \
+				 "0x%lx\n", adv, address);
+			break;
+
+		case DW_LNS_fixed_advance_pc:
+			adv = get_bytes(&start, 2);
+			address += adv;
+			pr_debug("  Advance PC by fixed size amount " \
+				 "%d to 0x%lx\n", adv, address);
+			break;
+
+		case DW_LNS_set_prologue_end:
+			pr_debug("  Set prologue_end to true\n");
+			break;
+
+		case DW_LNS_set_epilogue_begin:
+			pr_debug("  Set epilogue_begin to true\n");
+			break;
+
+		case DW_LNS_set_isa:
+			adv = read_leb128(start, &bytes_read, 0);
+			start += bytes_read;
+			pr_debug("  Set ISA to %d\n", adv);
+			break;
+
+		default:
+			pr_debug("  Unknown opcode %d with operands: ",
+				 op_code);
+			{
+				int i;
+				unsigned int ret;
+				for (i = cu_opcode_tbl[op_code - 1];
+				     i > 0 ; --i) {
+					ret = read_leb128(start,
+							  &bytes_read, 0);
+					pr_debug("0x%x%s", ret,
+						 i == 1 ? "" : ", ");
+					start += bytes_read;
+				}
+			}
+			break;
+		}
+	}
+	if (first_pass) {
+		first_pass = 0;
+		n_cu->ent = kmalloc(sizeof(struct module_cu_entry) * count,
+				    GFP_KERNEL);
+		if (!n_cu->ent)
+			goto error_out;
+		n_cu->maxent = count;
+		goto second_pass;
+	}
+	if (start < end)
+		goto another_cu;
+
+	return;
+
+error_out:
+	free_dlinedb(mod);
+	WARN_ON(1);
+}
+
+static void add_debugline_info(struct module *mod, const struct load_info *info)
+{
+	Elf_Shdr *symsec;
+	unsigned int i;
+	unsigned int dline_idx = 0;
+	unsigned char *dlinetab_start;
+	unsigned char *dlinetab_end;
+
+	/* find debug debug line section */
+	for (i = 1; i < info->hdr->e_shnum; i++) {
+		Elf_Shdr *shdr = &info->sechdrs[i];
+		char *name = info->secstrings + shdr->sh_name;
+
+		if (strcmp(name, ".debug_line") == 0) {
+			dline_idx = i;
+			break;
+		}
+	}
+
+	if (!dline_idx)
+		return;
+	/* Apply relocations */
+	for (i = 1; i < info->hdr->e_shnum; i++) {
+		Elf_Shdr *shdr = &info->sechdrs[i];
+		if (!strstr(info->secstrings + shdr->sh_name, ".debug_line"))
+			continue;
+		if (info->sechdrs[i].sh_type == SHT_REL) {
+			apply_relocate(info->sechdrs, info->strtab,
+				       info->index.sym, i, mod);
+			break;
+		} else if (info->sechdrs[i].sh_type == SHT_RELA) {
+			apply_relocate_add(info->sechdrs, info->strtab,
+					   info->index.sym, i, mod);
+			break;
+		}
+	}
+
+	symsec = &info->sechdrs[dline_idx];
+	dlinetab_start = (void *)symsec->sh_addr;
+	dlinetab_end = (void *)(symsec->sh_addr + symsec->sh_size);
+
+	build_lineloc_tables(mod, info, dlinetab_start, dlinetab_end);
+}
+
 static int post_relocation(struct module *mod, const struct load_info *info)
 {
 	/* Sort exception table now relocations are done. */
@@ -2856,6 +3358,9 @@ static int post_relocation(struct module *mod, const struct load_info *info)
 	/* Setup kallsyms-specific fields. */
 	add_kallsyms(mod, info);
 
+	/* Setup debug line information */
+	add_debugline_info(mod, info);
+
 	/* Arch-specific module finalizing. */
 	return module_finalize(info->hdr, info->sechdrs, mod);
 }
@@ -3150,6 +3655,50 @@ static const char *get_ksymbol(struct module *mod,
 	return mod->strtab + mod->symtab[best].st_name;
 }
 
+const char *module_address_line_lookup(unsigned long addr,
+			    unsigned long *size,
+			    unsigned long *offset,
+			    char **modname,
+			    char *namebuf)
+{
+	struct module *mod;
+	struct module_cu *cu, *near_cu = NULL;
+	unsigned int i, near_i = 0;
+	unsigned int m_off;
+	const char *ret = NULL;
+
+	preempt_disable();
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if (!(within_module_init(addr, mod) ||
+		      within_module_core(addr, mod)))
+			continue;
+		m_off = addr - (unsigned long)mod->module_core;
+		cu = mod->dlinedb;
+		while (cu) {
+			for (i = 0; i < cu->maxent; i++) {
+				if (cu->ent[i].off <= m_off) {
+					near_i = i;
+					near_cu = cu;
+					if (cu->ent[i].off == m_off)
+						goto found;
+				}
+			}
+			cu = cu->next;
+		}
+	}
+found:
+	if (near_cu) {
+		if (modname)
+			*modname = mod->name;
+		sprintf(namebuf, "%s:%u",
+			near_cu->filetab[near_cu->ent[near_i].file],
+			near_cu->ent[near_i].line);
+		ret = namebuf;
+	}
+	preempt_enable();
+	return ret;
+}
+
 /* For kallsyms to ask for address resolution.  NULL means not found.  Careful
  * not to lock to avoid deadlock on oopses, simply disable preemption. */
 const char *module_address_lookup(unsigned long addr,
-- 
1.7.10

