Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab2JEIdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:33:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2JEIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:33:03 -0400
Date: Fri, 5 Oct 2012 01:32:46 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-f315e16850d00ae5b19f11810bc00bf68cf3c24a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1348824728-14025-6-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Convert to LIBAUDIT_SUPPORT
Git-Commit-ID: f315e16850d00ae5b19f11810bc00bf68cf3c24a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:32:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f315e16850d00ae5b19f11810bc00bf68cf3c24a
Gitweb:     http://git.kernel.org/tip/f315e16850d00ae5b19f11810bc00bf68cf3c24a
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 28 Sep 2012 18:32:01 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:21 -0300

perf tools: Convert to LIBAUDIT_SUPPORT

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
