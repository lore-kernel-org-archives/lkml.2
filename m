Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132Ab2I1XtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:49:21 -0400
Received: from nm3-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.154]:37631 "HELO
	nm3-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964916Ab2I1XtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:49:12 -0400
X-Yahoo-Newman-Id: 385396.40552.bm@smtp101.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pQPYukcVM1nII1gGTzRYPO32qL4QEASaN0CtgI62mquBiKD
 l8N2DKRBaPhwsHJ1rVAVvdXGcAp1Tq79cN7TRVkGU5z1rAEKYhJ8VzlE7xJI
 nvrM0FhguBCUFJva_eqqKhnNuKAUHhR.dujO2YqDh2OoH2LwMBuCo_dkTAFs
 Qjkpi6E7S7aKR6P9IA0kvs9BEySmA3NZL9lfHQX04fCQJU7aAIRigriaFAUj
 .3dc8JCAkNQ1POoK4ioSR6IQ3Q9.2d9gXpcH_1yMQ68phNA8_mW9UnQWJYit
 nv31eFsV3xrz7ZgBFpgwfYKWUfTW8noZrrhD9824V.63UYg.qoY3ffxjuIBN
 cK2LFbs7weGiYwFfZJW0q411d5Xw3LkpIAMKEQ1fGTqnwInt2.jKe9uGfJeD
 9PqRwxQnzQAIjs8EiZHqnYyGyzNxNjXQX1hCqeplXMNF5N9CDeBc9mQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-doc@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v6 7/10] selftest: Add userspace test program.
Date: Fri, 28 Sep 2012 18:48:43 -0500
Message-Id: <1348876126-28792-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
References: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace test program using code from common.{c,h}.  Userspace
compliation is accomplished by ovreriding a few kernel headers in the
overrides directory.  This is an invasive hack (involving many internals
of kernel headers) that is expected to require fairly frequent
maintainence as kernel headers change.

The program grbtest can be run with -h option for help and outputs both
a human-readable format as well as a delimited text for more extensive
processing.

The exact behavior of the grbtest program depends upon the following
pre-processor variables, which the Makefile expects to be -Defined in a
CONFIG variable. Each variable should be assigned a value of 1 or 0, as
documented in common.h. If CONFIG is not set, a default is assigned in
the Makefile.

GRBTEST_KEY_TYPE
GRBTEST_PAYLOAD
GRBTEST_BUILD_GENERIC
GRBTEST_USE_LEFTMOST
GRBTEST_USE_RIGHTMOST
GRBTEST_USE_COUNT
GRBTEST_UNIQUE_KEYS
GRBTEST_INSERT_REPLACES

Generation of the resultant executable is also dependent upon the below
.config values.

DEBUG_GRBTREE
DEBUG_GRBTREE_VALIDATE

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 tools/testing/selftests/grbtree/user/Makefile      |   68 +++
 tools/testing/selftests/grbtree/user/facilities.c  |   58 ++
 tools/testing/selftests/grbtree/user/main.c        |  621 ++++++++++++++++++++
 .../grbtree/user/overrides/linux/export.h          |   31 +
 .../grbtree/user/overrides/linux/kernel.h          |   83 +++
 5 files changed, 861 insertions(+), 0 deletions(-)
 create mode 100644 tools/testing/selftests/grbtree/user/Makefile
 create mode 100644 tools/testing/selftests/grbtree/user/facilities.c
 create mode 100644 tools/testing/selftests/grbtree/user/main.c
 create mode 100644 tools/testing/selftests/grbtree/user/overrides/linux/export.h
 create mode 100644 tools/testing/selftests/grbtree/user/overrides/linux/kernel.h

diff --git a/tools/testing/selftests/grbtree/user/Makefile b/tools/testing/selftests/grbtree/user/Makefile
new file mode 100644
index 0000000..14380c2
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/Makefile
@@ -0,0 +1,68 @@
+# Default configuration (used if CONFIG not supplied)
+# See common.h for docs
+CONFIG ?= -DGRBTEST_KEY_TYPE=u32	\
+	  -DGRBTEST_PAYLOAD=0		\
+	  -DGRBTEST_BUILD_GENERIC=0	\
+	  -DGRBTEST_USE_LEFTMOST=1	\
+	  -DGRBTEST_USE_RIGHTMOST=1	\
+	  -DGRBTEST_USE_COUNT=1		\
+	  -DGRBTEST_UNIQUE_KEYS=1	\
+	  -DGRBTEST_INSERT_REPLACES=1
+
+ifeq ($(KERNELRELEASE),)
+    # Assume the source tree is where the running kernel was built
+    # You should set KERNELDIR in the environment if it's elsewhere
+    KERNELDIR ?= /lib/modules/$(shell uname -r)/build
+endif
+
+PWD := $(shell pwd)
+
+# The below KERNEL_ARCH works on x86_64, but hasn't been tested elsewhere
+# (e.g., x86 32-bit, ARM, etc.)
+KERNEL_ARCH	 = $(shell uname -m | sed 's/x86_64/x86/')
+
+# Kernel include directories
+KERNEL_INCLUDES	 = -I$(KERNELDIR)/include \
+		   -I$(KERNELDIR)/arch/$(KERNEL_ARCH)/include
+CPPFLAGS	+= -DGRBTEST_USERLAND=1 -D__KERNEL__ -I$(PWD)/.. \
+		   -I$(PWD)/overrides $(KERNEL_INCLUDES) $(CONFIG)
+WARN_FLAGS	 = -Wall -Wundef -Wstrict-prototypes -Wno-unused-variable \
+		   -Werror-implicit-function-declaration -Wno-trigraphs \
+		   -Wno-format-security -Wno-unused-variable
+# on gcc 4.3.6 and prior, we get some warnings for __rb_erase_color declared
+# inline after being called, so remove -Werror for now
+
+# Standard CFLAGS if not already set
+CFLAGS		?= -O2 -pipe
+# FIXME: breaks glibc
+#CFLAGS		+= -mno-see
+# TODO: Can get tese from KBUILD_CFLAGS in arch/<arch>/Makefile?
+#CFLAGS		+= -march=native -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
+CFLAGS		+= $(WARN_FLAGS) -fno-strict-aliasing -fno-common \
+		   -fno-delete-null-pointer-checks
+CC		?= gcc
+CPPFLAGS	+= -DGRBTEST_CFLAGS="$(CFLAGS)" -DGRBTEST_CONFIG="$(CONFIG)" \
+		   -DGRBTEST_CC="$(CC)" \
+		   -DGRBTEST_ARCH="$(KERNEL_ARCH)" \
+		   -DGRBTEST_ARCH_FLAGS="-march=k8 -m64" \
+		   -DGRBTEST_PROCESSOR="$(shell uname -p)" \
+
+all: grbtest
+
+OBJ_FILES = main.o rbtree.o common.o facilities.o
+HEADER_FILES = $(KERNELDIR)/include/linux/rbtree.h ../common.h
+
+rbtree.c:
+	ln -s $(KERNELDIR)/lib/rbtree.c $(PWD)/rbtree.c
+
+common.c:
+	ln -s ../common.c common.c
+
+rbtree.o: rbtree.c $(KERNELDIR)/include/linux/rbtree.h
+
+grbtest: $(OBJ_FILES) $(HEADER_FILES)
+	$(CC) $(CFLAGS) $(OBJ_FILES) -o grbtest
+
+clean:
+	rm -f grbtest *.o rbtree.c common.c
+
diff --git a/tools/testing/selftests/grbtree/user/facilities.c b/tools/testing/selftests/grbtree/user/facilities.c
new file mode 100644
index 0000000..63c29aa
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/facilities.c
@@ -0,0 +1,58 @@
+/* facilities.c - userspace facilities used by common.c/h
+ * Copyright (C) 2012  Daniel Santos <daniel.santos@pobox.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include "common.h"
+
+long run_test(unsigned int count);
+
+static struct timezone tz;
+
+void facilities_init(void)
+{
+	tz.tz_minuteswest = 0;
+	tz.tz_dsttime = 0;
+
+	memset(&objects, 0, sizeof(objects));
+}
+
+u64 getCurTicks(void) {
+	struct timeval now;
+	gettimeofday(&now, &tz);
+	return 1000000LL * now.tv_sec + now.tv_usec;
+}
+
+/* We aren't actually allocating anything here, unlike the kernelspace version
+ * but a null pointer means error, so we'll return one instead.
+ */
+void *rand_init(u64 *seed)
+{
+	BUG_ON(!seed);
+
+	if (!*seed)
+		*seed = getCurTicks();
+
+	/* reduce to 32 bits */
+	*seed = (*seed & 0xffffffff) ^ (*seed >> 32);
+	srand(*seed & 0xffffffff);
+
+	return (void*)1;
+}
diff --git a/tools/testing/selftests/grbtree/user/main.c b/tools/testing/selftests/grbtree/user/main.c
new file mode 100644
index 0000000..89132b8
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/main.c
@@ -0,0 +1,621 @@
+/* main.c - userspace generic red-black tree test program.
+ * Copyright (C) 2012  Daniel Santos <daniel.santos@pobox.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <sys/time.h>
+#include <getopt.h>
+#include <libgen.h>
+
+#include "common.h"
+
+long run_test(unsigned int count);
+
+struct timezone tz;
+struct object_pools objects;
+
+#define BAIL_ON_ERR(var, expr)			\
+do {						\
+	var = (expr);				\
+	if(IS_ERR_VALUE(var)) return var;	\
+} while(0)
+
+int process_args(struct grbtest_config *config, int argc, char *argv[]);
+void show_usage(void);
+void init_basename(void);
+void print_human_summary(const struct grbtest_config *config);
+void print_human_result(const struct grbtest_result *result);
+
+const char *argv0  = NULL;
+
+int main(int argc, char *argv[]) {
+	long		      ret;
+	struct grbtest_config config;
+	struct grbtest_result result;
+	struct container      cont;
+	char		     *argv0_copy = strdup(argv[0]);
+	argv0				 = basename(argv0_copy);
+
+	if (process_args(&config, argc, argv)) {
+		fprintf(stderr, "\n");
+		show_usage();
+		free(argv0_copy);
+		return -1;
+	}
+
+	facilities_init();
+	init_container(&cont);
+	grbtest_init_results(&config, &result);
+
+	BAIL_ON_ERR(ret, grbtest_init(&config));
+
+	if (config.human_readable)
+		print_human_summary(&config);
+	else if (config.print_header)
+		grbtest_print_result_header(&config);
+
+	grbtest_run_test(&config, &result, &cont);
+
+	if (config.human_readable)
+		print_human_result(&result);
+	else
+		grbtest_print_result_row(&config, &result);
+
+	grbtest_cleanup();
+	free(config.delimiter);
+	free(config.text_enclosure);
+	free(argv0_copy);
+
+	return 0;
+}
+
+void print_human_summary(const struct grbtest_config *config)
+{
+	unsigned long long in_seed = (unsigned long long)config->in_seed;
+	unsigned long long seed = (unsigned long long)config->seed;
+
+	print_msg("Build Configuration\n%s\n", grbtest_config());
+
+	print_msg(
+		"Execution Parameters\n"
+		"test            %u (%s)\n"
+		"in_seed         %llu (0x%llx)\n"
+		"seed            %llu (0x%llx)\n"
+		"key_mask        %u (0x%x)\n"
+		"count           %u (0x%x)\n"
+		"pool_count      %u\n"
+		"reps            %u (0x%x)\n"
+		"human_readable  %u\n"
+		"delimiter       %s\n"
+		"text_enclosure  %s\n"
+		"print_header    %u\n"
+		"\n",
+		config->test, grbtest_type_desc[config->test],
+		in_seed, in_seed,
+		seed, seed,
+		config->key_mask, config->key_mask,
+		config->object_count, config->object_count,
+		config->pool_count,
+		config->reps, config->reps,
+		config->human_readable,
+		config->delimiter,
+		config->text_enclosure,
+		config->print_header);
+
+	print_msg("Running test...");
+}
+
+void print_human_result(const struct grbtest_result *result)
+{
+	print_msg("completed!\n\n");
+	print_msg(
+		"Test Results\n"
+		"node_size        %u\n"
+		"object_size      %u\n"
+		"pool_size        %u\n"
+		"insertions       %llu\n"
+		"insertion_time   %llu\n"
+		"evictions        %llu\n"
+		"deletions        %llu\n"
+		"deletion_time    %llu\n",
+		result->node_size,
+		result->object_size,
+		result->pool_size,
+		(unsigned long long)result->insertions,
+		(unsigned long long)result->insertion_time,
+		(unsigned long long)result->evictions,
+		(unsigned long long)result->deletions,
+		(unsigned long long)result->deletion_time);
+
+}
+
+/**
+ * Determine base by prefix and offset to number. Uses standard rules
+ * (expressed in regex below):
+ * 0[xX][0-9a-fA-F]+ denotes a hexidecimal number
+ * 0[0-7]+           denotes an octal number
+ * (0|[1-9][0-9]*)   denotes a decimal number
+ */
+int get_param_base_and_start(const char **str)
+{
+	assert(*str);
+
+	/* Parse an "0x", "0X" or "0" -prefixed string, but not the string
+	 * "0" (which will be treated as base ten). */
+	if (**str == '0' && *(*str + 1)) {
+		++*str;
+		if (**str == 'x' || **str == 'X') {
+			++*str;
+			return 16;
+		} else {
+			return 8;
+		}
+	} else {
+		return 10;
+	}
+}
+
+/**
+ * @returns zero on success, non-zero if the string didn't represent a clean
+ *          number
+ *
+ * FIXME: wont be correct for u32 on platforms where sizeof(int) == 2
+ */
+int get_uint_param(const char *str, unsigned int *dest)
+{
+	const char *start = str;
+	char *endptr;
+	int base = get_param_base_and_start(&start);
+
+	*dest = strtoul(start, &endptr, base);
+	if (*endptr) {
+		fprintf(stderr, "bad number: %s\n", str);
+		exit (1);
+	}
+
+	return *endptr;
+}
+
+/**
+ * @returns zero on success, non-zero if the string didn't represent a clean
+ *          number
+ * FIXME: assumes u64 is unsigned long long
+ */
+int get_u64_param(const char *str, u64 *dest)
+{
+	char *endptr;
+	int base = get_param_base_and_start(&str);
+
+	*dest = strtoull(str, &endptr, base);
+	if (*endptr) {
+		fprintf(stderr, "bad number: %s\n", str);
+		exit (1);
+	}
+
+	return *endptr;
+}
+
+void show_usage()
+{
+	fprintf(stderr,
+"Usage: %s [options]\n"
+"Options:\n"
+"  -h,     --help    Show this help\n"
+"  -t=NUM, --test    The test to run\n"
+"                    0 Performance: Insert\n"
+"                    1 Performance: Insert & Delete\n"
+"                    2 Validation\n"
+"  -s=NUM, --seed    Seed for random key generation (zero to use current\n"
+"                    time)\n"
+"  -m=NUM, --keymask Bitmask for keys (key range)\n"
+"  -c=NUM, --count   Number of objects to use\n"
+"  -r=NUM, --reps    Number of times to repeat test(s)\n"
+"  -p=NUM, --pools   Number of pools of objects to use\n"
+"  -u,     --human   Output in human-readable form\n"
+"  -d=STR, --delim   Use the string STR to delimit fields\n"
+"  -H,     --header  Output a row header\n"
+"\n"
+"Fields:\n"
+"  compiler        the compiler used\n"
+"  use_generic     value of GRBTEST_BUILD_GENERIC\n"
+"  use_leftmost    value of GRBTEST_USE_LEFTMOST\n"
+"  use_rightmost   value of GRBTEST_USE_RIGHTMOST\n"
+"  use_count       value of GRBTEST_USE_COUNT\n"
+"  unique_keys     value of GRBTEST_UNIQUE_KEYS\n"
+"  insert_replaces value of GRBTEST_INSERT_REPLACES\n"
+"  debug           if CONFIG_DEBUG_RBTREE is enabled (.config)\n"
+"  debug_validate  if CONFIG_DEBUG_RBTREE_VALIDATE is enabled (.config)\n"
+"  test            \n"
+"  in_seed         input seed\n"
+"  seed            result seed (differs if supplied seed is zero)\n"
+"  key_mask        \n"
+"  object_count    number of objects used for test\n"
+"  pool_count      \n"
+"  reps            number of times test is repeated\n"
+"  node_size       sizeof(struct rb_node)\n"
+"  object_size     sizeof(struct object)\n"
+"  pool_size       \n"
+"  time            time in microseconds\n"
+"  insertions      number of insertions\n"
+"  deletions       number of deletions\n"
+"  evictions       number of evictions (Always zero if GRBTEST_UNIQUE_KEYS\n"
+"                  is not set. If GRBTEST_UNIQUE_KEYS is set, but\n"
+"                  GRBTEST_INSERT_REPLACES is not, this is the number of\n"
+"                  objects not inserted because a duplicate key already\n"
+"                  existed in the tree.)\n"
+"\n"
+"Example:\n"
+"%s -s 1 --reps 0x8000 --count 0x800 --keymask 0xfff\n"
+"\n",
+		argv0, argv0);
+}
+
+int process_args(struct grbtest_config *config, int argc, char *argv[])
+{
+	int c;
+
+	memset(config, 0, sizeof(*config));
+	config->test		= 0;
+	config->in_seed		= 0;
+	config->seed		= 0;
+	config->key_mask	= 0xff;
+	config->object_count	= 0x100;
+	config->pool_count	= 1;
+	config->reps		= 1;
+	config->human_readable	= 0;
+	config->delimiter	= strdup(",");
+	config->text_enclosure	= strdup("'");
+	config->print_header	= 0;
+
+	while (1) {
+		static struct option long_options[] = {
+			{"help",    no_argument,       0, 'h'},
+			{"test",    required_argument, 0, 't'},
+			{"seed",    required_argument, 0, 's'},
+			{"keymask", required_argument, 0, 'm'},
+			{"count",   required_argument, 0, 'c'},
+			{"reps",    required_argument, 0, 'r'},
+			{"pools",   required_argument, 0, 'p'},
+			{"human",   no_argument,       0, 'u'},
+			{"delim",   required_argument, 0, 'd'},
+			{"quote",   required_argument, 0, 'q'},
+			{"header",  no_argument,       0, 'H'},
+			{0,         0,                 0, 0}
+		};
+
+		/* getopt_long stores the option index here. */
+		int option_index = 0;
+		c = getopt_long(argc, argv, "ht:s:c:r:p:m:ud:q:H", long_options, &option_index);
+
+		/* Detect the end of the options. */
+		if (c == -1)
+		break;
+
+		switch (c) {
+		case 'h': show_usage();			exit(1);
+		case 't': get_uint_param(optarg, &config->test);	break;
+		case 's': get_u64_param(optarg, &config->in_seed);	break;
+		case 'm': get_uint_param(optarg, &config->key_mask);	break;
+		case 'c': get_uint_param(optarg, &config->object_count);break;
+		case 'r': get_uint_param(optarg, &config->reps);	break;
+		case 'p': get_uint_param(optarg, &config->pool_count);	break;
+		case 'u': config->human_readable = 1;			break;
+		case 'd': free(config->delimiter);
+			  config->delimiter = strdup(optarg);		break;
+		case 'q': free(config->text_enclosure);
+			  config->text_enclosure = strdup(optarg);	break;
+		case 'H': config->print_header = 1;			break;
+		default : return -1;
+		}
+	}
+
+	if (optind < argc) {
+		fprintf(stderr, "Invalid argument: %s\n", argv[optind]);
+		return -1;
+	}
+
+	if (config->test >= GRBTEST_TYPE_COUNT) {
+		fprintf(stderr, "Invalid test specified.\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+
+
+#if 0
+/****************************************************************************
+ * rbtree & container-related functions
+ */
+
+static __always_inline long compare_long(const long *a, const long *b) {
+	return *a - *b;
+}
+
+static __always_inline long compare_u32(const u32 *a, const u32 *b) {
+	return (long)*a - (long)*b;
+}
+
+static inline void init_container(struct container *cunt) {
+	cunt->tree = RB_ROOT;
+	cunt->count = 0;
+}
+
+/****************************************************************************
+ * rb_relationship definition
+ */
+RB_DEFINE_INTERFACE(
+	mytree,
+	struct container, tree, leftmost, rightmost, count,
+	struct object, node, id,
+	RB_UNIQUE_KEYS | RB_INSERT_REPLACES, compare_u32, ,
+	,
+	static __flatten noinline,
+	static __flatten,
+	static __flatten __maybe_unused);
+
+void dumpNode(struct rb_node *node) {
+	fprintf(stderr, "rb_parent_color = 0x%lu (parent = 0x%p, color = %d)\n",
+		node->rb_parent_color, rb_parent(node), (int)rb_color(node));
+	fprintf(stderr, "rb_right        = %p\n", node->rb_right);
+	fprintf(stderr, "rb_left         = %p\n", node->rb_left);
+}
+
+void printObj(struct object *obj) {
+
+}
+
+struct obj_display {
+	struct object *o;
+	char text[64];
+};
+
+void populateDisp(struct rb_node *node, struct obj_display *disp_arr, unsigned *index, unsigned target_depth) {
+	struct rb_node *left = NULL;
+	struct rb_node *right = NULL;
+
+	if (target_depth == 0) {
+		struct obj_display *disp = &disp_arr[*index];
+
+		if (node) {
+			struct object *obj = rb_entry(node, struct object, node);
+			disp->o = obj;
+			snprintf(disp->text, sizeof(disp->text),
+				"%p=%02d", obj, obj->id);
+		} else {
+			disp->o = 0;
+			snprintf(disp->text, sizeof(disp->text),
+				"empty      ");
+		}
+		++(*index);
+	}
+
+	if (target_depth > 0) {
+		if (node) {
+			left = node->rb_left;
+			right = node->rb_right;
+		}
+		populateDisp(left, disp_arr, index, target_depth - 1);
+		populateDisp(right, disp_arr, index, target_depth - 1);
+	}
+}
+
+void dumpTree(struct rb_root *root, size_t obj_count) {
+	int max_depth = 5;
+	int max_nodes = 1 << max_depth;
+	unsigned index = 0u;
+	int i;
+	size_t item_text_size;
+	struct obj_display *disp = (struct obj_display *)malloc(max_nodes * sizeof(struct obj_display));
+
+	for (i = 0; i < max_depth; ++i) {
+		populateDisp(root->rb_node, disp, &index, i);
+	}
+	item_text_size = strlen(disp[0].text);
+
+	for (i = 0; i < max_nodes; ++i) {
+		if (i == 1 || i == 3 || i == 7 || i == 15 || i == 31) {
+			int bity;
+			fprintf(stderr, "\n");
+			for (bity = i + 1; !(bity & 32); bity <<= 1) {
+				const char spaces[257] = {[0 ... 255] = ' ', [256] = 0};
+				fprintf(stderr, "%s", &spaces[256 - item_text_size]);
+			}
+
+		} else {
+			fprintf(stderr, "  ");
+		}
+		fprintf(stderr, "%s", disp[i].text);
+	}
+	fprintf(stderr, "\n");
+
+}
+
+__attribute__((flatten))
+long run_test(unsigned int count) {
+	size_t buf_size = sizeof(struct object) * count;
+	struct container cont;
+	struct object *obj_pools[2];
+	struct object **tree_contents;
+	size_t pool_size;
+	int pool_in_use;
+	long i, j, k;
+	struct object *found;
+	struct rb_node *node;
+	long long start, end;
+
+	long long now = getCurTicks();
+
+	srand((now & 0xffffffff) ^ (now >> 32));
+
+	if (count < 1 || count > 0x1000000) { /* 16.8 million should be a reasonable limit */
+		return -1;
+	}
+
+	fprintf(stderr, "allocating two pools of %u objects each\n", count);
+
+	cont.tree      = RB_ROOT;
+	cont.count     = 0;
+	cont.leftmost  = 0;
+	cont.rightmost = 0;
+	pool_in_use      = 0;
+	obj_pools[0]     = (struct object *)malloc(buf_size);
+	obj_pools[1]     = (struct object *)malloc(buf_size);
+
+	fprintf(stderr, "initializing objects\n");
+
+	/* init a psudo-random using a real-random seed */
+//	get_random_bytes(&seed, sizeof(seed));
+//	prandom32_seed(&grbtest.rand, seed);
+
+	for (i = 0; i < 2; ++i) {
+		struct object *p = obj_pools[i];
+		struct object *end = &p[count];
+
+		for (; p != end; ++p) {
+			p->id = rand() & 0xfffff;
+			rb_init_node(&p->node);
+		}
+	}
+	pool_size = count;
+
+	for (j = 0; j < 2; ++j) {
+		struct object *pool = obj_pools[j];
+		start = getCurTicks();
+
+		for (i = count; i; ) {
+			struct object *new = &pool[--i];
+
+			mytree_insert(&cont, new);
+		}
+		pool_in_use ^= 1;
+		end = getCurTicks();
+		fprintf(stderr, "Inserted %u objects in %llu\n", count, end - start);
+	}
+
+	fprintf(stderr, "walking tree now...\n");
+	tree_contents = (struct object **)malloc(sizeof(void*) * cont.count);
+	start = getCurTicks();
+	for (i = 0, node = cont.leftmost; node; node = rb_next(node), ++i) {
+		tree_contents[i] = rb_entry(node, struct object, node);
+	}
+	end = getCurTicks();
+	fprintf(stderr, "Finished walking tree of %u in %llu\n", cont.count, end - start);
+
+	fprintf(stderr, "root = %p, count = %u\n", cont.tree.rb_node, cont.count);
+	//dumpNode(cont.tree.rb_node);
+
+	//dumpTree(&cont.tree, 16);
+	start = getCurTicks();
+#define NEAR_RANGE 8
+#if 0
+	for (i = 0; i < cont.count; ++i) {
+		for (j = 0; j < cont.count; ++j) {
+			found = mytree_find_near(tree_contents[i], &tree_contents[j]->id);
+			if (found != tree_contents[j]) {
+				fprintf(stderr, "find_near found %p near %p (expected %p)\n",
+					found, tree_contents[i], tree_contents[j]);
+				found = mytree_find_near(tree_contents[i], &tree_contents[j]->id);
+			}
+		}
+	}
+#else
+for (k = 0; k < 8; ++k) {
+	for (i = 0; i < cont.count; ++i) {
+		int max = i + NEAR_RANGE;
+		if (max > cont.count)
+			max = cont.count;
+		for (j = i > NEAR_RANGE ? i - NEAR_RANGE : 0;
+		     j < max; ++j) {
+			found = mytree_find_near(tree_contents[i], &tree_contents[j]->id);
+			if (found != tree_contents[j]) {
+				fprintf(stderr, "find_near found %p near %p (expected %p)\n",
+					found, tree_contents[i], tree_contents[j]);
+				found = mytree_find_near(tree_contents[i], &tree_contents[j]->id);
+			}
+		}
+	}
+}
+
+#endif
+	end = getCurTicks();
+	fprintf(stderr, "find_near duration = %llu\n", end - start);
+
+	start = getCurTicks();
+for (k = 0; k < 8; ++k) {
+	for (i = 0; i < cont.count; ++i) {
+		int max = i + NEAR_RANGE;
+		if (max > cont.count)
+			max = cont.count;
+		for (j = i > NEAR_RANGE ? i - NEAR_RANGE : 0;
+		     j < max; ++j) {
+			found = mytree_find(&cont, &tree_contents[j]->id);
+			if (found != tree_contents[j]) {
+				fprintf(stderr, "find_near found %p near %p (expected %p)\n",
+					found, tree_contents[i], tree_contents[j]);
+				found = mytree_find_near(tree_contents[i], &tree_contents[j]->id);
+			}
+		}
+	}
+}
+
+	end = getCurTicks();
+	fprintf(stderr, "find duration = %llu\n", end - start);
+
+	// cleanup
+
+	fprintf(stderr, "Forward iteration (%u objects)\n", cont.count);
+	for (node = cont.leftmost; node ; node = rb_next(node)) {
+		struct object *obj = (struct object *)__rb_node_to_obj(node, &mytree_rel);
+		//fprintf(stderr, "id = 0x%08x\n", obj->id);
+	}
+
+	fprintf(stderr, "Reverse iteration (%u objects)\n", cont.count);
+	for (node = cont.rightmost; node ; node = rb_prev(node)) {
+		struct object *obj = (struct object *)__rb_node_to_obj(node, &mytree_rel);
+		//fprintf(stderr, "id = 0x%08x\n", obj->id);
+	}
+
+
+	fprintf(stderr, "Starting cleanup, %u objects\n", cont.count);
+	while (cont.leftmost) {
+		struct object *obj = (struct object *)__rb_node_to_obj(cont.leftmost, &mytree_rel);
+		//fprintf(stderr, "Removing object at 0x%p id = 0x%04x\n", obj, obj->id);
+		mytree_remove(&cont, obj);
+		//--cont.count;
+	}
+
+	if(obj_pools[0]) {
+		free(obj_pools[0]);
+		free(obj_pools[1]);
+		obj_pools[0] = 0;
+		obj_pools[1] = 0;
+		free(tree_contents);
+	}
+	pool_in_use = 0;
+	cont.leftmost = 0;
+	cont.rightmost = 0;
+
+
+	fprintf(stderr, "Cleanup complete, %u objects left in container.\n", cont.count);
+
+	return 0;
+}
+#endif
diff --git a/tools/testing/selftests/grbtree/user/overrides/linux/export.h b/tools/testing/selftests/grbtree/user/overrides/linux/export.h
new file mode 100644
index 0000000..911be60
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/overrides/linux/export.h
@@ -0,0 +1,31 @@
+/* export.h userspace override hack
+ * Copyright (C) 2012  Daniel Santos <daniel.santos@pobox.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * This file is an override hack for the file normally found at
+ * include/linux/export.h in the kernel tree.
+ */
+
+#ifndef _LINUX_EXPORT_H
+#define _LINUX_EXPORT_H
+
+#define EXPORT_SYMBOL(sym)
+#define EXPORT_SYMBOL_GPL(sym)
+#define EXPORT_SYMBOL_GPL_FUTURE(sym)
+#define EXPORT_UNUSED_SYMBOL(sym)
+#define EXPORT_UNUSED_SYMBOL_GPL(sym)
+
+#endif /* _LINUX_EXPORT_H */
diff --git a/tools/testing/selftests/grbtree/user/overrides/linux/kernel.h b/tools/testing/selftests/grbtree/user/overrides/linux/kernel.h
new file mode 100644
index 0000000..d696e78
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/overrides/linux/kernel.h
@@ -0,0 +1,83 @@
+/* kernel.h userspace override hack
+ * Copyright (C) 2012  Daniel Santos <daniel.santos@pobox.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * This file is an override hack for the file normally found at
+ * include/linux/kernel.h in the kernel tree (not /usr) to allow you to compile
+ * some portions of the Linux kernel code in user-space and is expected to
+ * break fairly often as the internals of the kernel tree change.  It's
+ * designed for use with GNU libc and is generally not expected to work
+ * elsewhere as-is.
+ */
+
+#ifndef _LINUX_KERNEL_H
+#define _LINUX_KERNEL_H
+
+/* avoid warning: __always_inline defined in both /usr/include/sys/cdefs.h as
+ * well as linux/compiler.h.  So we include cdefs.h now, #undef it and let
+ * linux/compiler.h redefine it.
+ */
+#include <sys/cdefs.h>
+#if defined(__always_inline) && !defined(__LINUX_COMPILER_H)
+# undef __always_inline
+#endif
+#if defined(__attribute_const__) && !defined(__LINUX_COMPILER_H)
+# undef __attribute_const__
+#endif
+#include <linux/compiler.h>
+
+#include <assert.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <sys/types.h>
+#include <linux/err.h>
+#include <linux/bug.h>
+
+#ifndef __GNU_LIBRARY__
+# warning This file is a hack written to compile with the GNU C Library and \
+	  is not generally expected to work elsewhere.
+#endif
+
+/* glibc-backed versions of BUG{,_ON} */
+#undef BUG
+#undef BUG_ON
+#define BUG()		assert(0)
+#define BUG_ON(arg)	assert(!(arg))
+
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+typedef int8_t   s8;
+typedef uint8_t  u8;
+typedef int16_t  s16;
+typedef uint16_t u16;
+typedef int32_t  s32;
+typedef uint32_t u32;
+typedef int64_t  s64;
+typedef uint64_t u64;
+
+#endif /* _LINUX_KERNEL_H */
-- 
1.7.3.4

