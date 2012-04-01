Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2DAQFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:05:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46444 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab2DAQFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:05:11 -0400
Subject: [RFC PATCH -tip 16/16] tools/bogodis: Add bogus disassembler tool in
 userspace
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:05:08 +0900
Message-ID: <20120401160507.4502.84715.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a tiny bogus disassembler tool.
Currently, only x86 is supported.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/lib/disasm.c   |    9 ++
 tools/bogodis/Makefile  |   51 ++++++++++++
 tools/bogodis/bogodis.c |  202 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 262 insertions(+), 0 deletions(-)
 create mode 100644 tools/bogodis/Makefile
 create mode 100644 tools/bogodis/bogodis.c

diff --git a/arch/x86/lib/disasm.c b/arch/x86/lib/disasm.c
index fc5e493..c6f2aef 100644
--- a/arch/x86/lib/disasm.c
+++ b/arch/x86/lib/disasm.c
@@ -7,7 +7,9 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
+#ifdef __KERNEL__
 #include <linux/kallsyms.h>
+#endif
 
 #include <asm/disasm.h>
 
@@ -30,6 +32,7 @@ static int psnprintf(char **buf, size_t *len, const char *fmt, ...)
 	return ret;
 }
 
+#ifdef __KERNEL__
 /* Print address with symbol */
 static int psnprint_symbol(char **buf, size_t *len, unsigned long addr)
 {
@@ -50,6 +53,12 @@ static int psnprint_symbol(char **buf, size_t *len, unsigned long addr)
 
 	return psnprintf(buf, len, ">");
 }
+#else
+static int psnprint_symbol(char **buf, size_t *len, unsigned long addr)
+{
+	return psnprintf(buf, len, "%lx", addr);
+}
+#endif
 
 /* Operand classifiers */
 static bool operand_is_register(const char *p)
diff --git a/tools/bogodis/Makefile b/tools/bogodis/Makefile
new file mode 100644
index 0000000..3ef5a26d
--- /dev/null
+++ b/tools/bogodis/Makefile
@@ -0,0 +1,51 @@
+AWK := LC_ALL=C awk
+
+# Architecture identifying: copied from tools/perf/Makefile
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+				  -e s/arm.*/arm/ -e s/sa110/arm/ \
+				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
+				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
+				  -e s/sh[234].*/sh/ )
+
+# Additional ARCH settings for x86
+ifeq ($(ARCH),i386)
+        ARCH := x86
+endif
+ifeq ($(ARCH),x86_64)
+	ARCH := x86
+endif
+
+ifneq ($(ARCH),x86)
+	$(echo "This architecture is not supported yet.")
+endif
+
+topdir := ../..
+archdir := $(topdir)/arch/$(ARCH)
+tooldir := $(archdir)/tools
+libdir := $(archdir)/lib
+incdir := $(archdir)/include/asm
+
+CFLAGS := -g -Wall -I$(topdir)/include -I$(archdir)/include
+
+SRC += $(libdir)/insn.c
+SRC += $(libdir)/inat.c
+SRC += $(libdir)/disasm.c
+SRC += $(libdir)/mnemonic.c
+SRC += $(incdir)/inat_types.h
+SRC += $(incdir)/inat.h
+SRC += $(incdir)/insn.h
+SRC += $(incdir)/disasm.h
+
+bogodis: bogodis.c inat-tables.c mnemonic-tables.c $(SRC)
+	$(CC) $(CFLAGS) -o $@ bogodis.c -I$(libdir) -I./
+
+inat-tables.c: $(libdir)/x86-opcode-map.txt $(tooldir)/gen-insn-attr-x86.awk
+	$(AWK) -f $(tooldir)/gen-insn-attr-x86.awk $< > $@
+
+mnemonic-tables.c: $(libdir)/x86-opcode-map.txt $(tooldir)/gen-insn-mnemonic-x86.awk
+	$(AWK) -f $(tooldir)/gen-insn-mnemonic-x86.awk $< > $@
+
+clean:
+	rm -f bogodis *.o inat-tables.c mnemonic-tables.c
diff --git a/tools/bogodis/bogodis.c b/tools/bogodis/bogodis.c
new file mode 100644
index 0000000..1454547
--- /dev/null
+++ b/tools/bogodis/bogodis.c
@@ -0,0 +1,202 @@
+/* bogodis - A Bogus Disassember
+ * Written by Masami Hiramatsu <masami.hiramatsu@gmail.com>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <stdarg.h>
+#include <unistd.h>
+#include <ctype.h>
+#define _LINUX_CTYPE_H	/* Dummy for avoiding build error */
+#define _LINUX_KERNEL_H	/* Ditto */
+#include <errno.h>
+#define BUG_ON(a)	\
+	do { fprintf(stderr, "BUG at %s:%d\n", __FILE__, __LINE__); exit(1); } while (1)
+
+/* These are for compiling instruction decoder in user space */
+#define unlikely(cond) (cond)
+
+#include <asm/insn.h>
+#include <asm/disasm.h>
+
+/* Decoder code */
+#include <inat.c>
+#include <insn.c>
+
+/* Disassembler code */
+#include <mnemonic.c>
+#include <disasm.c>
+
+static int verbose;
+static bool x86_64 = (sizeof(long) == 8);
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: bogodis [-6|-3] [-v]\n");
+	fprintf(stderr, "\t-6	64bit mode %s\n", (x86_64) ? "(default)" : "");
+	fprintf(stderr, "\t-3	32bit mode %s\n", (x86_64) ? "" : "(default)");
+	fprintf(stderr, "\t-v	Increment verbosity\n");
+	exit(1);
+}
+
+static void parse_args(int argc, char *argv[])
+{
+	int c;
+
+	while ((c = getopt(argc, argv, "63v")) != -1) {
+		switch (c) {
+		case '6':
+			x86_64 = true;
+			break;
+		case '3':
+			x86_64 = false;
+			break;
+		case 'v':
+			verbose++;
+			break;
+		default:
+			usage();
+		}
+	}
+}
+
+static void dump_field(FILE *fp, const char *name, const char *indent,
+		       struct insn_field *field)
+{
+	fprintf(fp, "%s.%s = {\n", indent, name);
+	fprintf(fp, "%s\t.value = %d, bytes[] = {%x, %x, %x, %x},\n",
+		indent, field->value, field->bytes[0], field->bytes[1],
+		field->bytes[2], field->bytes[3]);
+	fprintf(fp, "%s\t.got = %d, .nbytes = %d},\n", indent,
+		field->got, field->nbytes);
+}
+
+static void dump_insn(FILE *fp, struct insn *insn)
+{
+	fprintf(fp, "Instruction = {\n");
+	dump_field(fp, "prefixes", "\t",	&insn->prefixes);
+	dump_field(fp, "rex_prefix", "\t",	&insn->rex_prefix);
+	dump_field(fp, "vex_prefix", "\t",	&insn->vex_prefix);
+	dump_field(fp, "opcode", "\t",		&insn->opcode);
+	dump_field(fp, "modrm", "\t",		&insn->modrm);
+	dump_field(fp, "sib", "\t",		&insn->sib);
+	dump_field(fp, "displacement", "\t",	&insn->displacement);
+	dump_field(fp, "immediate1", "\t",	&insn->immediate1);
+	dump_field(fp, "immediate2", "\t",	&insn->immediate2);
+	fprintf(fp, "\t.attr = %x, .opnd_bytes = %d, .addr_bytes = %d,\n",
+		insn->attr, insn->opnd_bytes, insn->addr_bytes);
+	fprintf(fp, "\t.length = %d, .x86_64 = %d, .kaddr = %p}\n",
+		insn->length, insn->x86_64, insn->kaddr);
+}
+
+static int read_instruction(FILE *fp, insn_byte_t *insn_buf, size_t size)
+{
+	char *buf = NULL, *p;
+	size_t dummy;
+	int i;
+
+	memset(insn_buf, 0, size);
+
+	if (getline(&buf, &dummy, fp) < 0)
+		return -errno;
+	p = buf;
+	i = 0;
+	while (i < size) {
+		insn_buf[i++] = (insn_byte_t)strtoul(p, &p, 16);
+		if (*p == '\0' || *p == '\n' || !isspace(*p))
+			break;
+	}
+	free(buf);
+	return i;
+}
+
+/* Disassemble options */
+#define DISASM_PR_ADDR	1	/* Print address */
+#define DISASM_PR_RAW	2	/* Print raw code */
+#define DISASM_PR_ALL	(DISASM_PR_ADDR | DISASM_PR_RAW)
+
+/**
+ * snprint_assembly() - Disassemble given instruction with headers
+ * @buf:	A buffer in which assembly code is stored
+ * @len:	The size of @buf
+ * @insn:	An instruction which will be disassembled
+ * @opts:	Options
+ *
+ * This disassembles given instruction and put it into buffer with
+ * some optional information. Available option flagss are;
+ * DISASM_PR_ADDR: the address of given instruction is added.
+ * DISASM_PR_RAW:  the raw bytes of given instruction are added.
+ * Caller must initialize @insn but don't need to decode (ex insn_get_length).
+ */
+int snprint_assembly(char *buf, size_t len, struct insn *insn, int opts)
+{
+	int i = 0, ret;
+
+	insn_get_length(insn);
+	if (!insn_complete(insn))
+		return -EINVAL;
+
+	if (opts & DISASM_PR_ADDR)	/* print address */
+		psnprintf(&buf, &len, "%p: ", insn->kaddr);
+
+	if (opts & DISASM_PR_RAW) {	/* print raw instruction */
+		for (i = 0; i < MAX_INSN_SIZE / 2 && i < insn->length; i++)
+			psnprintf(&buf, &len, "%02x ", insn->kaddr[i]);
+		if (i != MAX_INSN_SIZE / 2)
+			psnprintf(&buf, &len, "%*s",
+				3 * (MAX_INSN_SIZE / 2 - i), " ");
+	}
+
+	/* print assembly code */
+	ret = disassemble(buf, len, insn);
+	if (ret < 0)
+		return ret;
+	len -= ret;
+	buf += ret;
+	psnprintf(&buf, &len, "\n");
+
+	/* print rest of raw instruction if exist */
+	if ((opts & DISASM_PR_RAW) && (i < insn->length)) {
+		if (opts & DISASM_PR_ADDR) /* print address */
+			psnprintf(&buf, &len, "%p: ", insn->kaddr + i);
+		for (; i < insn->length - 1; i++)
+			psnprintf(&buf, &len, "%02x ", insn->kaddr[i]);
+		psnprintf(&buf, &len, "%02x\n", insn->kaddr[i]);
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	insn_byte_t insn_buf[MAX_INSN_SIZE];
+	struct insn insn;
+	char buf[128];
+	const char *grp;
+	int ret;
+
+	parse_args(argc, argv);
+
+	while ((ret = read_instruction(stdin, insn_buf, MAX_INSN_SIZE)) > 0) {
+		insn_init(&insn, insn_buf, x86_64);
+		ret = snprint_assembly(buf, sizeof(buf), &insn, DISASM_PR_ALL);
+		if (ret < 0) {
+			printf("Error: reason %d\n", ret);
+			if (verbose)
+				dump_insn(stdout, &insn);
+		} else {
+			printf("%s", buf);
+			if (verbose >= 2) {
+				printf("format: %s\n",
+					get_mnemonic_format(&insn, &grp));
+				dump_insn(stdout, &insn);
+			}
+		}
+	}
+	if (verbose)
+		printf("ret = %d\n", ret);
+
+	return 0;
+}

