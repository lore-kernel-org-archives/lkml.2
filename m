Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807Ab0JVTNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:13:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759783Ab0JVTNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=faEOK9SaWErvV/s3urqSLrt7GslncylK4f99XlZc4CLiVCxeJ5Hp8ggLa28Z1/xGEM
         oWU5TbDaPHXwULdMIqEmSqJzAuKgfndXjF0rLvYXqg6mvJzsaB38IrQoNeRjCajkTUPQ
         8Hu8zQVa+OWQjmFcPsU0ChxyN8XxBVXjw9Hog=
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
        Robert Richter <robert.richter@amd.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC PATCH 09/11] perf: Add libunwind dependency for dwarf cfi unwinding
Date: Fri, 22 Oct 2010 21:13:10 +0200
Message-Id: <1287774792-23123-10-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
References: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
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
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---
 tools/perf/Makefile          |   19 +++++++++++++++++++
 tools/perf/feature-tests.mak |   14 ++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index addef2f..0c46ac7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -518,6 +518,20 @@ ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
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
@@ -564,6 +578,11 @@ else
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

