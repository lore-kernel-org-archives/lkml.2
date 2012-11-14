Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2KNHeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:34:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2KNHeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:34:12 -0500
Date: Tue, 13 Nov 2012 23:33:10 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-n2uv8c9ti6b26fioaw2rq5yv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add LIBDW_DIR Makefile variable to for alternate libdw
Git-Commit-ID: 1fa0bc3f8d4f9bbcde5b1f962b006906cc80b2dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:33:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1fa0bc3f8d4f9bbcde5b1f962b006906cc80b2dc
Gitweb:     http://git.kernel.org/tip/1fa0bc3f8d4f9bbcde5b1f962b006906cc80b2dc
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 3 Nov 2012 19:27:57 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Nov 2012 16:01:37 -0300

perf tools: Add LIBDW_DIR Makefile variable to for alternate libdw

Adding LIBDW_DIR Makefile variable to be able to specify
alternate libdw library location.

To use it run make like:
  $ make LIBDW_DIR=/opt/libdw/

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-n2uv8c9ti6b26fioaw2rq5yv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4ffcd02..cca5bb8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -501,7 +501,14 @@ ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
 		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
 	endif
 else
-	FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
+	# for linking with debug library, run like:
+	# make DEBUG=1 LIBDW_DIR=/opt/libdw/
+	ifdef LIBDW_DIR
+		LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
+		LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+	endif
+
+	FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
 	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
 		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
 		NO_DWARF := 1
@@ -556,7 +563,8 @@ ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
 else
-	BASIC_CFLAGS += -DDWARF_SUPPORT
+	BASIC_CFLAGS := -DDWARF_SUPPORT $(LIBDW_CFLAGS) $(BASIC_CFLAGS)
+	BASIC_LDFLAGS := $(LIBDW_LDFLAGS) $(BASIC_LDFLAGS)
 	EXTLIBS += -lelf -ldw
 	LIB_OBJS += $(OUTPUT)util/probe-finder.o
 	LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
