Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1JMLBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:01:55 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35398 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab1JMLBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:01:53 -0400
X-AuditID: b753bd60-a0ca5ba000005c89-45-4e96c51e69f7
X-AuditID: b753bd60-a0ca5ba000005c89-45-4e96c51e69f7
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC PATCH] x86: Add a sanity test of x86 decoder
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, robert.richter@amd.com, ravitillo@lbl.gov,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Date: Thu, 13 Oct 2011 20:01:27 +0900
Message-ID: <20111013110127.28099.19162.stgit@localhost.localdomain>
In-Reply-To: <20111012070601.GC18618@elte.hu>
References: <20111012070601.GC18618@elte.hu>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sanity test of x86 insn decoder against the random
input. This test is also able to reproduce the bug by
passing random-seed and iteration-number, or by passing
input while which has invalid byte code.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---

 arch/x86/tools/Makefile      |   10 +-
 arch/x86/tools/insn_sanity.c |  253 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 262 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/tools/insn_sanity.c

diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index f820826..3255c3d 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -18,14 +18,22 @@ chkobjdump = $(srctree)/arch/x86/tools/chkobjdump.awk
 quiet_cmd_posttest = TEST    $@
       cmd_posttest = ($(OBJDUMP) -v | $(AWK) -f $(chkobjdump)) || $(OBJDUMP) -d -j .text $(objtree)/vmlinux | $(AWK) -f $(distill_awk) | $(obj)/test_get_len $(posttest_64bit) $(posttest_verbose)
 
-posttest: $(obj)/test_get_len vmlinux
+quiet_cmd_sanitytest = TEST    $@
+      cmd_sanitytest = $(obj)/insn_sanity $(posttest_64bit) -m 1000000
+
+posttest: $(obj)/test_get_len vmlinux $(obj)/insn_sanity
 	$(call cmd,posttest)
+	$(call cmd,sanitytest)
 
 hostprogs-y	:= test_get_len
+hostprogs-y	:= insn_sanity
 
 # -I needed for generated C source and C source which in the kernel tree.
 HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/
 
+HOSTCFLAGS_insn_sanity.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/
+
 # Dependencies are also needed.
 $(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
 
+$(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
diff --git a/arch/x86/tools/insn_sanity.c b/arch/x86/tools/insn_sanity.c
new file mode 100644
index 0000000..9ba74fe
--- /dev/null
+++ b/arch/x86/tools/insn_sanity.c
@@ -0,0 +1,253 @@
+/*
+ * x86 decoder sanity test - based on test_get_insn.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2009
+ * Copyright (C) Hitachi, Ltd., 2011
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <assert.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#define unlikely(cond) (cond)
+
+#include <asm/insn.h>
+#include <inat.c>
+#include <insn.c>
+
+/*
+ * Test of instruction analysis against tampering.
+ * Feed random binary to instruction decoder and ensure not to
+ * access out-of-instruction-buffer.
+ */
+
+#define DEFAULT_MAX_ITER	10000
+#define INSN_NOP 0x90
+
+static const char *prog;
+static int verbose;
+static int x86_64;
+static unsigned int seed;
+static unsigned long nr_iter;
+static unsigned long max_iter = DEFAULT_MAX_ITER;
+static char insn_buf[MAX_INSN_SIZE * 2];
+static FILE *input_file;
+
+static void usage(const char *err)
+{
+	if (err)
+		fprintf(stderr, "Error: %s\n\n", err);
+	fprintf(stderr, "Usage: %s [-y|-n|-v] [-s seed[,no]] [-m max] [-i input]\n", prog);
+	fprintf(stderr, "\t-y	64bit mode\n");
+	fprintf(stderr, "\t-n	32bit mode\n");
+	fprintf(stderr, "\t-v	Verbose mode\n");
+	fprintf(stderr, "\t-s	Give a random seed (and iter number)\n");
+	fprintf(stderr, "\t-m	Give a max iteration number\n");
+	fprintf(stderr, "\t-i	Give an input file with decoded binary\n");
+	exit(1);
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
+static void dump_stream(FILE *fp, const char *msg, struct insn *insn)
+{
+	int i;
+	fprintf(fp, "%s:\n code:", msg);
+	for (i = 0; i < MAX_INSN_SIZE; i++)
+		fprintf(fp, " %02x", insn_buf[i]);
+	fprintf(fp, "\n");
+	dump_insn(stderr, insn);
+	fprintf(fp, "\n This can be reproduced with \"-s 0x%x,%lu\" option\n",
+		seed, nr_iter);
+}
+
+static void get_seed(void)
+{
+	int fd;
+
+	fd = open("/dev/urandom", O_RDONLY);
+	if (!fd)
+		usage("Failed to open /dev/urandom");
+	if (read(fd, &seed, sizeof(seed)) != sizeof(seed))
+		usage("Failed to read /dev/urandom");
+	close(fd);
+}
+
+static int get_next_insn(void)
+{
+	char buf[256]  = "", *tmp;
+	int i;
+
+	tmp = fgets(buf, 256, input_file);
+	if (tmp == NULL || feof(input_file))
+		return 0;
+
+	for (i = 0; i < MAX_INSN_SIZE; i++) {
+		((unsigned char *)insn_buf)[i] = (unsigned char)strtoul(tmp, &tmp, 16);
+		if (*tmp != ' ')
+			break;
+	}
+	return ++nr_iter;
+}
+
+/* generate a random instruction binary */
+static int generate_random_insn(void)
+{
+	int i;
+	if (nr_iter >= max_iter)
+		return 0;
+
+	if (input_file)
+		return get_next_insn();
+
+	/* Fills buffer with random binary up to MAX_INSN_SIZE */
+	if (nr_iter == 0)
+		srand(seed);
+	for (i = 0; i < MAX_INSN_SIZE; i += 2)
+		*(unsigned short *)(&insn_buf[i]) = random() & 0xffff;
+	return ++nr_iter;
+}
+
+static void init_test(int argc, char **argv)
+{
+	int c;
+	char *tmp = NULL;
+	unsigned long iter = 0;
+	int set_seed = 0;
+
+	prog = argv[0];
+	while ((c = getopt(argc, argv, "ynvs:m:i:")) != -1) {
+		switch (c) {
+		case 'y':
+			x86_64 = 1;
+			break;
+		case 'n':
+			x86_64 = 0;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 'i':
+			if (strcmp("-", optarg) == 0)
+				input_file = stdin;
+			else
+				input_file = fopen(optarg, "r");
+			if (!input_file)
+				usage("Failed to open input file");
+			break;
+		case 's':
+			seed = (unsigned int)strtoul(optarg, &tmp, 0);
+			if (*tmp == ',') {
+				optarg = tmp + 1;
+				iter = strtoul(optarg, &tmp, 0);
+			}
+			if (*tmp != '\0' || tmp == optarg)
+				usage("Failed to parse seed");
+			set_seed = 1;
+			break;
+		case 'm':
+			max_iter = strtoul(optarg, &tmp, 0);
+			if (*tmp != '\0' || tmp == optarg)
+				usage("Failed to parse max_iter");
+			break;
+		default:
+			usage(NULL);
+		}
+	}
+
+	if (max_iter < iter)
+		usage("Max iteration number must be bigger than iter-num");
+
+	if (!set_seed && !input_file)	/* Don't get a seed */
+		get_seed();
+	if (set_seed && input_file)
+		usage("Don't use input file (-i) with random seed (-s)");
+
+	/* Prepare stop bytes with NOPs */
+	memset(insn_buf + MAX_INSN_SIZE, INSN_NOP, MAX_INSN_SIZE);
+	/* Skip first nth states */
+	for (; iter > 0; iter--)
+		if (!generate_random_insn())
+			usage("Failed to generate random insns\n");
+}
+
+#define insn_complete(insn)	\
+	(insn.opcode.got && insn.modrm.got && insn.sib.got && \
+	 insn.displacement.got && insn.immediate.got)
+
+int main(int argc, char **argv)
+{
+	struct insn insn;
+	int insns = 0;
+	int warnings = 0;
+
+	init_test(argc, argv);
+
+	while (generate_random_insn()) {
+		/* Decode an instruction */
+		insn_init(&insn, insn_buf, x86_64);
+		insn_get_length(&insn);
+
+		if (verbose && !insn_complete(insn))
+			dump_stream(stdout, "Undecodable input", &insn);
+
+		if (insn.next_byte <= insn.kaddr ||
+		    insn.kaddr + MAX_INSN_SIZE < insn.next_byte) {
+			/* Access out-of-range memory */
+			dump_stream(stdout, "Find access violation", &insn);
+			warnings++;
+		}
+		insns++;
+	}
+	if (warnings)
+		fprintf(stdout, "Warning: decoded and checked %d insns with %d warnings (seed:0x%x)\n", insns, warnings, seed);
+	else
+		fprintf(stdout, "Succeed: decoded and checked %d insns (seed:0x%x)\n", insns, seed);
+	return 0;
+}

