Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab2I1JmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:42:24 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59302 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab2I1JkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:21 -0400
X-AuditID: 9c930197-b7b6dae000000e70-69-506570824788
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 05/12] perf tools: Convert to LIBAUDIT_SUPPORT
Date: Fri, 28 Sep 2012 18:32:01 +0900
Message-Id: <1348824728-14025-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For building perf without libaudit, we can set NO_LIBAUDIT=1 as a
argument of make.  It then defines NO_LIBAUDIT_SUPPORT macro for C
code to do the proper handling.  However it usually used in a negative
semantics - e.g. #ifndef - so we saw double negations which can be
misleading.  Convert it to a positive form to make it more readable.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile | 6 ++----
 tools/perf/perf.c   | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 676302441e14..99b2bb371bcd 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -543,14 +543,12 @@ ifndef NO_LIBUNWIND
 	LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
-ifdef NO_LIBAUDIT
-	BASIC_CFLAGS += -DNO_LIBAUDIT_SUPPORT
-else
+ifndef NO_LIBAUDIT
 	FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
 	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT)),y)
 		msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
-		BASIC_CFLAGS += -DNO_LIBAUDIT_SUPPORT
 	else
+		BASIC_CFLAGS += -DLIBAUDIT_SUPPORT
 		BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
 		EXTLIBS += -laudit
 	endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index dacae4b8bcb4..6d50eb0b4251 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -55,7 +55,7 @@ static struct cmd_struct commands[] = {
 	{ "lock",	cmd_lock,	0 },
 	{ "kvm",	cmd_kvm,	0 },
 	{ "test",	cmd_test,	0 },
-#ifndef NO_LIBAUDIT_SUPPORT
+#ifdef LIBAUDIT_SUPPORT
 	{ "trace",	cmd_trace,	0 },
 #endif
 	{ "inject",	cmd_inject,	0 },
-- 
1.7.11.4

