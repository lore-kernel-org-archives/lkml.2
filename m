Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2IHLsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:48:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39687 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2IHLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:48:42 -0400
Date: Sat, 8 Sep 2012 04:48:21 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-c9f08bee50c71b06685ccff8110e56a7c05662b7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1347065004-15306-12-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-12-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  add NO_BACKTRACE for application self-debugging
Git-Commit-ID: c9f08bee50c71b06685ccff8110e56a7c05662b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:48:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9f08bee50c71b06685ccff8110e56a7c05662b7
Gitweb:     http://git.kernel.org/tip/c9f08bee50c71b06685ccff8110e56a7c05662b7
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Sat, 8 Sep 2012 03:43:23 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 22:12:30 -0300

perf tools: add NO_BACKTRACE for application self-debugging

perf has support for self-debugging by defining dump_stack function.
This function uses backtrace and backtrace_symbols functions defined as
GNU extensions.

In Android, bionic does not offer support for these functions and
compilation will fail with the following error:

target  C: libperf <= tools/perf/util/util.c
tools/perf/util/util.c:4:22: fatal error: execinfo.h: No such file or directory
compilation terminated.

Add a compile-time option (NO_BACKTRACE) to enable or disable
self-debugging functionality in perf. This can also help in debugging
since it offers the possibility to turn on/off printing the backtrace.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-12-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |    8 ++++++++
 tools/perf/config/feature-tests.mak |   14 ++++++++++++++
 tools/perf/util/util.c              |    6 ++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index afd5075..3eda492 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -755,6 +755,14 @@ else
 	endif
 endif
 
+ifdef NO_BACKTRACE
+       BASIC_CFLAGS += -DNO_BACKTRACE
+else
+       ifneq ($(call try-cc,$(SOURCE_BACKTRACE),),y)
+               BASIC_CFLAGS += -DNO_BACKTRACE
+       endif
+endif
+
 ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 2f1156a..116690a 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -179,3 +179,17 @@ int main(void)
 }
 endef
 endif
+
+ifndef NO_BACKTRACE
+define SOURCE_BACKTRACE
+#include <execinfo.h>
+#include <stdio.h>
+
+int main(void)
+{
+	backtrace(NULL, 0);
+	backtrace_symbols(NULL, 0);
+	return 0;
+}
+endef
+endif
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 1b8775c..2055cf3 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,7 +1,9 @@
 #include "../perf.h"
 #include "util.h"
 #include <sys/mman.h>
+#ifndef NO_BACKTRACE
 #include <execinfo.h>
+#endif
 #include <stdio.h>
 #include <stdlib.h>
 
@@ -163,6 +165,7 @@ size_t hex_width(u64 v)
 }
 
 /* Obtain a backtrace and print it to stdout. */
+#ifndef NO_BACKTRACE
 void dump_stack(void)
 {
 	void *array[16];
@@ -177,3 +180,6 @@ void dump_stack(void)
 
 	free(strings);
 }
+#else
+void dump_stack(void) {}
+#endif
