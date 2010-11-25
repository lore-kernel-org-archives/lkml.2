Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0KYENf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 23:13:35 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57354 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0KYENe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 23:13:34 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: tom.leiming@gmail.com, Ian Munsie <imunsie@au1.ibm.com>
Subject: =?UTF-8?q?=5BPATCH=203/3=5D=20perf=2C=20powerpc=3A=20Allow=20perf=20test=20to=20handle=20PowerPC=20symbol=20naming?=
Date: Thu, 25 Nov 2010 15:12:55 +1100
Message-Id: <1290658375-10342-3-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com>
References: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

The PowerPC ABI prefixes symbol names with periods, which causes perf
test to fail when it compares the symbol from the vmlinux file with the
symbol names from kallsyms. This patch adds the infrastructure to allow
archs to override how symbol names are compared and implements the
PowerPC function to disregard any prefixed periods, allowing perf test
to pass.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/arch/powerpc/Makefile      |    5 +++++
 tools/perf/arch/powerpc/util/symbol.c |   22 ++++++++++++++++++++++
 tools/perf/builtin-test.c             |    2 +-
 tools/perf/util/symbol.c              |    5 +++++
 tools/perf/util/symbol.h              |    2 ++
 5 files changed, 35 insertions(+), 1 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/util/symbol.c

diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 15130b5..b3e211e 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -2,3 +2,8 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/symbol.o
+
+$(OUTPUT)arch/powerpc/util/%.o : arch/powerpc/util/%.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -I util/ $<
diff --git a/tools/perf/arch/powerpc/util/symbol.c b/tools/perf/arch/powerpc/util/symbol.c
new file mode 100644
index 0000000..db56913
--- /dev/null
+++ b/tools/perf/arch/powerpc/util/symbol.c
@@ -0,0 +1,22 @@
+/*
+ * Functions to handle PowerPC symbol naming
+ *
+ * Copyright © 2010 Ian Munsie, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <string.h>
+#include <symbol.h>
+
+/* Overrides the definition in the generic code */
+int arch_sym_strcmp(const char *s1, const char *s2)
+{
+	const char *ts1, *ts2;
+	ts1 = (*s1 == '.' ? s1+1 : s1);
+	ts2 = (*s2 == '.' ? s2+1 : s2);
+	return strcmp(ts1, ts2);
+}
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 035b9fa..9c0301b 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -126,7 +126,7 @@ static int test__vmlinux_matches_kallsyms(void)
 
 		if (pair && pair->start == sym->start) {
 next_pair:
-			if (strcmp(sym->name, pair->name) == 0) {
+			if (arch_sym_strcmp(sym->name, pair->name) == 0) {
 				/*
 				 * kallsyms don't have the symbol end, so we
 				 * set that by using the next symbol start - 1,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a348906..180683e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2473,3 +2473,8 @@ int machine__load_vmlinux_path(struct machine *self, enum map_type type,
 
 	return ret;
 }
+
+int __attribute__((weak)) arch_sym_strcmp(const char *s1, const char *s2)
+{
+	return strcmp(s1, s2);
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 038f220..6f4daae 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -229,4 +229,6 @@ bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
 size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp);
 
+int arch_sym_strcmp(const char *s1, const char *s2);
+
 #endif /* __PERF_SYMBOL */
-- 
1.7.2.3

