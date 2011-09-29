Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab1I2Wu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:50:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60157 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab1I2WsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/16] perf buildid-list: Support showing the build id in an ELF file
Date: Thu, 29 Sep 2011 19:47:58 -0300
Message-Id: <1317336490-19437-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Try first reading the build id, validating that it is an ELF file, etc.
Cheap as libelf will bail out as soon as the magic number check fails.

Useful when investigating debuginfo packaging problems like this one:

[root@emilia ~]# perf buildid-list -i /usr/lib/debug/lib/modules/`uname -r`/vmlinux
77bb4ea591a602d455ace759a377c9adfff1aba3
[root@emilia ~]# perf buildid-list -k
07b0c016a2b30004e86132d0239945b1e88f5d75
[root@emilia ~]#

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4elot9oxwa0rr0d90dshca3a@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-list.txt |    3 +-
 tools/perf/builtin-buildid-list.c              |   27 +++++++++++++++++++++--
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-buildid-list.txt b/tools/perf/Documentation/perf-buildid-list.txt
index 770a7f3..cc22325 100644
--- a/tools/perf/Documentation/perf-buildid-list.txt
+++ b/tools/perf/Documentation/perf-buildid-list.txt
@@ -16,7 +16,8 @@ This command displays the buildids found in a perf.data file, so that other
 tools can be used to fetch packages with matching symbol tables for use by
 perf report.
 
-It can also be used to show the build id of the running kernel.
+It can also be used to show the build id of the running kernel or in an ELF
+file using -i/--input.
 
 OPTIONS
 -------
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 4102ead..cb690a6 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -1,8 +1,8 @@
 /*
  * builtin-buildid-list.c
  *
- * Builtin buildid-list command: list buildids in perf.data or in the running
- * kernel.
+ * Builtin buildid-list command: list buildids in perf.data, in the running
+ * kernel and in ELF files.
  *
  * Copyright (C) 2009, Red Hat Inc.
  * Copyright (C) 2009, Arnaldo Carvalho de Melo <acme@redhat.com>
@@ -16,6 +16,8 @@
 #include "util/session.h"
 #include "util/symbol.h"
 
+#include <libelf.h>
+
 static char const *input_name = "perf.data";
 static bool force;
 static bool show_kernel;
@@ -70,12 +72,31 @@ static int sysfs__fprintf_build_id(FILE *fp)
 	return 0;
 }
 
-static int __cmd_buildid_list(void)
+static int filename__fprintf_build_id(const char *name, FILE *fp)
 {
+	u8 build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 
+	if (filename__read_build_id(name, build_id,
+				    sizeof(build_id)) != sizeof(build_id))
+		return 0;
+
+	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
+	return fprintf(fp, "%s\n", sbuild_id);
+}
+
+static int __cmd_buildid_list(void)
+{
 	if (show_kernel)
 		return sysfs__fprintf_build_id(stdout);
 
+	elf_version(EV_CURRENT);
+	/*
+ 	 * See if this is an ELF file first:
+ 	 */
+	if (filename__fprintf_build_id(input_name, stdout))
+		return 0;
+
 	return perf_session__list_build_ids();
 }
 
-- 
1.6.2.5

