Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2JDSZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:25:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:39662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2JDSI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:08:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/42] perf tools: Convert to LIBAUDIT_SUPPORT
Date: Thu,  4 Oct 2012 15:08:05 -0300
Message-Id: <1349374122-27806-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For building perf without libaudit, we can set NO_LIBAUDIT=1 as a
argument of make.  It then defines NO_LIBAUDIT_SUPPORT macro for C code
to do the proper handling.  However it usually used in a negative
semantics - e.g. #ifndef - so we saw double negations which can be
misleading.  Convert it to a positive form to make it more readable.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348824728-14025-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    6 ++----
 tools/perf/perf.c   |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6763024..99b2bb3 100644
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
index dacae4b..6d50eb0 100644
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
1.7.1

