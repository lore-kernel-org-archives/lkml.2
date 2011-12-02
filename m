Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1LBEsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 23:48:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50256 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab1LBEsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 23:48:10 -0500
Date: Fri, 2 Dec 2011 05:48:25 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@infradead.org, dsahern@gmail.com, peterz@infradead.org, mingo@elte.hu,
        fweisbec@gmail.com
Subject: [PATCH] perf: fix handling of .debug cache for kernel symbols
Message-ID: <20111202044825.GA21751@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a bug in the way perf was looking for
kernel symbols when the .debug cache was not in $HOME.

With the /etc/perfconfig or $HOME/.perfconfig files, it
is possible to use an alternate location for the .debug
buildid + binary cache.

The problem is that the alternate location was ignored
for kernel symbols, leading to partial profiles in case
the host kernel was  not the one used to collect the profile,
e.g., with remote profiling.

This patch fixes the problem by adding the buildi_dir prefix
to the lookup path used in dso__load_kernel_sym().

The change to util.h is necessary to avoid a redefinition
of _GNU_SOURCE.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 632b50c..8ace954 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -16,6 +16,7 @@
 #include "debug.h"
 #include "symbol.h"
 #include "strlist.h"
+#include "util.h"
 
 #include <libelf.h>
 #include <gelf.h>
@@ -2082,8 +2083,8 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				  sbuild_id);
 
 		if (asprintf(&kallsyms_allocated_filename,
-			     "%s/.debug/[kernel.kallsyms]/%s",
-			     getenv("HOME"), sbuild_id) == -1) {
+			     "%s/[kernel.kallsyms]/%s",
+			     buildid_dir, sbuild_id) == -1) {
 			pr_err("Not enough memory for kallsyms file lookup\n");
 			return -1;
 		}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 0128906..4b90e93 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -40,7 +40,9 @@
 #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
 
 #define _ALL_SOURCE 1
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE 1
+#endif
 #define _BSD_SOURCE 1
 #define HAS_BOOL
 
