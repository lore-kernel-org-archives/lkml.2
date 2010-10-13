Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0JMFH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:07:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0JMFHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=hhWAYJP20a1Qp6NjDCewElrzYxrCS3AMuXfYSYIwbQ4vyzVl+R1tP1lncVGx3nWy3O
         sc8GzMaykwgcOQqUkV3XXXCPO75k1fkHRG64D/NA0SQA7cHUfhbfK2w6/g1FQbN+cWwb
         6WH+BRaQ++vGfdUuoMog8/nq5dqrisl5+gu5I=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [RFC PATCH 8/9] perf: Add libunwind dependency for dwarf cfi unwinding
Date: Wed, 13 Oct 2010 07:07:00 +0200
Message-Id: <1286946421-32202-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not mandatory, but required to get dwarf cfi unwinding
support.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
---
 tools/perf/Makefile          |   19 +++++++++++++++++++
 tools/perf/feature-tests.mak |   14 ++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1146195..ca4cde1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -515,6 +515,20 @@ ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
 endif # Dwarf support
 endif # NO_DWARF
 
+
+# Only x86-32 is supported for now
+ifneq ($(ARCH),x86)
+	NO_LIBUNWIND := 1
+endif
+
+ifndef NO_LIBUNWIND
+FLAGS_UNWIND=$(ALL_CFLAGS) -lunwind-x86 -lunwind-ptrace $(ALL_LDFLAGS) $(EXTLIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
+	msg := $(warning No libunwind found. Please install libunwind >= 0.99);
+	NO_LIBUNWIND := 1
+endif # Libunwind support
+endif # NO_LIBUNWIND
+
 -include arch/$(ARCH)/Makefile
 
 ifeq ($(uname_S),Darwin)
@@ -561,6 +575,11 @@ else
 endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 
+ifndef NO_LIBUNWIND
+	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
+	EXTLIBS += -lunwind-ptrace -lunwind-x86
+endif
+
 ifdef NO_NEWT
 	BASIC_CFLAGS += -DNO_NEWT_SUPPORT
 else
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index b253db6..367b213 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -90,6 +90,20 @@ int main(void)
 endef
 endif
 
+ifndef NO_LIBUNWIND
+define SOURCE_LIBUNWIND
+#include <libunwind.h>
+#include <stdlib.h>
+
+int main(void)
+{
+	unw_addr_space_t addr_space;
+	addr_space = unw_create_addr_space(NULL, 0);
+	return 0;
+}
+endef
+endif
+
 define SOURCE_BFD
 #include <bfd.h>
 
-- 
1.6.2.3

