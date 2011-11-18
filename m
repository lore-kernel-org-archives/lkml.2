Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab1KRXSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:18:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1KRXSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:18:21 -0500
Date: Fri, 18 Nov 2011 15:16:40 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-1ec454baf1245df4fdb5dae728da3363630ce6de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        andi@firstfloor.org, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111020140109.20938.92572.stgit@localhost.localdomain>
References: <20111020140109.20938.92572.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: Add a build-time sanity test to the x86 decoder
Git-Commit-ID: 1ec454baf1245df4fdb5dae728da3363630ce6de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:16:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ec454baf1245df4fdb5dae728da3363630ce6de
Gitweb:     http://git.kernel.org/tip/1ec454baf1245df4fdb5dae728da3363630ce6de
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 20 Oct 2011 23:01:09 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Nov 2011 12:38:51 +0100

x86, perf: Add a build-time sanity test to the x86 decoder

Add a sanity test of x86 insn decoder against a stream
of randomly generated input, at build time.

This test is also able to reproduce any bug that might
trigger by allowing the passing of random-seed and
iteration-number to the test, or by passing input
which has invalid byte code.

Changes in V2:
 - Code cleanup.
 - Show how to reproduce the error by insn_sanity test.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com
Cc: ming.m.lin@intel.com
Cc: robert.richter@amd.com
Cc: ravitillo@lbl.gov
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20111020140109.20938.92572.stgit@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/insn.h  |    7 +
 arch/x86/tools/Makefile      |   10 ++-
 arch/x86/tools/insn_sanity.c |  275 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 291 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 88c765e..74df3f1 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -137,6 +137,13 @@ static inline int insn_is_avx(struct insn *insn)
 	return (insn->vex_prefix.value != 0);
 }
 
+/* Ensure this instruction is decoded completely */
+static inline int insn_complete(struct insn *insn)
+{
+	return insn->opcode.got && insn->modrm.got && insn->sib.got &&
+		insn->displacement.got && insn->immediate.got;
+}
+
 static inline insn_byte_t insn_vex_m_bits(struct insn *insn)
 {
 	if (insn->vex_prefix.nbytes == 2)	/* 2 bytes VEX */
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
index 0000000..334d9de
--- /dev/null
+++ b/arch/x86/tools/insn_sanity.c
@@ -0,0 +1,275 @@
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
+#define ARRAY_SIZE(a)	(sizeof(a)/sizeof(a[0]))
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
+static const char	*prog;		/* Program name */
+static int		verbose;	/* Verbosity */
+static int		x86_64;		/* x86-64 bit mode flag */
+static unsigned int	seed;		/* Random seed */
+static unsigned long	iter_start;	/* Start of iteration number */
+static unsigned long	iter_end = DEFAULT_MAX_ITER;	/* End of iteration number */
+static FILE		*input_file;	/* Input file name */
+
+static void usage(const char *err)
+{
+	if (err)
+		fprintf(stderr, "Error: %s\n\n", err);
+	fprintf(stderr, "Usage: %s [-y|-n|-v] [-s seed[,no]] [-m max] [-i input]\n", prog);
+	fprintf(stderr, "\t-y	64bit mode\n");
+	fprintf(stderr, "\t-n	32bit mode\n");
+	fprintf(stderr, "\t-v	Verbose mode\n");
+	fprintf(stderr, "\t-s	Give a random seed (and iteration number)\n");
+	fprintf(stderr, "\t-m	Give a maximum iteration number\n");
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
+static void dump_stream(FILE *fp, const char *msg, unsigned long nr_iter,
+			unsigned char *insn_buf, struct insn *insn)
+{
+	int i;
+
+	fprintf(fp, "%s:\n", msg);
+
+	dump_insn(stderr, insn);
+
+	fprintf(fp, "You can reproduce this with below command(s);\n");
+
+	/* Input a decoded instruction sequence directly */
+	fprintf(fp, " $ echo ");
+	for (i = 0; i < MAX_INSN_SIZE; i++)
+		fprintf(fp, " %02x", insn_buf[i]);
+	fprintf(fp, " | %s -i -\n", prog);
+
+	if (!input_file) {
+		fprintf(fp, "Or \n");
+		/* Give a seed and iteration number */
+		fprintf(fp, " $ %s -s 0x%x,%lu\n", prog, seed, nr_iter);
+	}
+}
+
+static void init_random_seed(void)
+{
+	int fd;
+
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd < 0)
+		goto fail;
+
+	if (read(fd, &seed, sizeof(seed)) != sizeof(seed))
+		goto fail;
+
+	close(fd);
+	return;
+fail:
+	usage("Failed to open /dev/urandom");
+}
+
+/* Read given instruction sequence from the input file */
+static int read_next_insn(unsigned char *insn_buf)
+{
+	char buf[256]  = "", *tmp;
+	int i;
+
+	tmp = fgets(buf, ARRAY_SIZE(buf), input_file);
+	if (tmp == NULL || feof(input_file))
+		return 0;
+
+	for (i = 0; i < MAX_INSN_SIZE; i++) {
+		insn_buf[i] = (unsigned char)strtoul(tmp, &tmp, 16);
+		if (*tmp != ' ')
+			break;
+	}
+
+	return i;
+}
+
+static int generate_insn(unsigned char *insn_buf)
+{
+	int i;
+
+	if (input_file)
+		return read_next_insn(insn_buf);
+
+	/* Fills buffer with random binary up to MAX_INSN_SIZE */
+	for (i = 0; i < MAX_INSN_SIZE - 1; i += 2)
+		*(unsigned short *)(&insn_buf[i]) = random() & 0xffff;
+
+	while (i < MAX_INSN_SIZE)
+		insn_buf[i++] = random() & 0xff;
+
+	return i;
+}
+
+static void parse_args(int argc, char **argv)
+{
+	int c;
+	char *tmp = NULL;
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
+				iter_start = strtoul(optarg, &tmp, 0);
+			}
+			if (*tmp != '\0' || tmp == optarg)
+				usage("Failed to parse seed");
+			set_seed = 1;
+			break;
+		case 'm':
+			iter_end = strtoul(optarg, &tmp, 0);
+			if (*tmp != '\0' || tmp == optarg)
+				usage("Failed to parse max_iter");
+			break;
+		default:
+			usage(NULL);
+		}
+	}
+
+	/* Check errors */
+	if (iter_end < iter_start)
+		usage("Max iteration number must be bigger than iter-num");
+
+	if (set_seed && input_file)
+		usage("Don't use input file (-i) with random seed (-s)");
+
+	/* Initialize random seed */
+	if (!input_file) {
+		if (!set_seed)	/* No seed is given */
+			init_random_seed();
+		srand(seed);
+	}
+}
+
+int main(int argc, char **argv)
+{
+	struct insn insn;
+	int insns = 0;
+	int errors = 0;
+	unsigned long i;
+	unsigned char insn_buf[MAX_INSN_SIZE * 2];
+
+	parse_args(argc, argv);
+
+	/* Prepare stop bytes with NOPs */
+	memset(insn_buf + MAX_INSN_SIZE, INSN_NOP, MAX_INSN_SIZE);
+
+	for (i = 0; i < iter_end; i++) {
+		if (generate_insn(insn_buf) <= 0)
+			break;
+
+		if (i < iter_start)	/* Skip to given iteration number */
+			continue;
+
+		/* Decode an instruction */
+		insn_init(&insn, insn_buf, x86_64);
+		insn_get_length(&insn);
+
+		if (verbose && !insn_complete(&insn))
+			dump_stream(stdout, "Info: Found an undecodable input", i, insn_buf, &insn);
+
+		if (insn.next_byte <= insn.kaddr ||
+		    insn.kaddr + MAX_INSN_SIZE < insn.next_byte) {
+			/* Access out-of-range memory */
+			dump_stream(stdout, "Error: Found an access violation", i, insn_buf, &insn);
+			errors++;
+		}
+		insns++;
+	}
+
+	fprintf(stdout, "%s: decoded and checked %d %s instructions with %d errors (seed:0x%x)\n", (errors) ? "Failure" : "Success", insns, (input_file) ? "given" : "random", errors, seed);
+
+	return errors ? 1 : 0;
+}
