Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2JEI30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:29:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60585 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2JEI3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:29:23 -0400
Date: Fri, 5 Oct 2012 01:28:59 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-fee9e3732a377275a99b6f3c8b4e1f1569f17575@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1348824728-14025-2-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Move libdw availability check before arch Makefile
Git-Commit-ID: fee9e3732a377275a99b6f3c8b4e1f1569f17575
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:29:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fee9e3732a377275a99b6f3c8b4e1f1569f17575
Gitweb:     http://git.kernel.org/tip/fee9e3732a377275a99b6f3c8b4e1f1569f17575
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 28 Sep 2012 18:31:57 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 28 Sep 2012 21:07:36 -0300

perf tools: Move libdw availability check before arch Makefile

Since NO_DWARF is used in arch/$(ARCH)/Makefiles, it should be checked
before including those files.  It was moved by mistake during libelf
dependency removal work by me, sorry.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348824728-14025-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e5e71e7..834f09f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -486,7 +486,13 @@ ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 		NO_DWARF := 1
 		NO_DEMANGLE := 1
 	endif
-endif
+else
+	FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
+	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
+		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+		NO_DWARF := 1
+	endif # Dwarf support
+endif # SOURCE_LIBELF
 endif # NO_LIBELF
 
 ifndef NO_LIBUNWIND
@@ -532,12 +538,6 @@ ifneq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_COMMON)),y)
 	BASIC_CFLAGS += -DLIBELF_NO_MMAP
 endif
 
-FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
-	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-	NO_DWARF := 1
-endif # Dwarf support
-
 ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
