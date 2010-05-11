Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab0EKQaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:30:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:37540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0EKQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:30:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf probe: Check older elfutils and set NO_DWARF
Date: Tue, 11 May 2010 13:29:49 -0300
Message-Id: <1273595390-6486-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273595390-6486-1-git-send-email-acme@infradead.org>
References: <1273595390-6486-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Check whether elfutils is older than 0.138 (from which version checking
routine has been introduced). And if so, set NO_DWARF because it is hard
to check the API dependency without version checking.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Robert Richter <robert.richter@amd.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100511045953.9913.19485.stgit@localhost6.localdomain6>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0ef5cfe..b28bb73 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -506,8 +506,8 @@ PERFLIBS = $(LIB_FILE)
 -include config.mak
 
 ifndef NO_DWARF
-ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
-	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/libdw-dev);
+ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo '\#include <version.h>'; echo '\#ifndef _ELFUTILS_PREREQ'; echo '\#error'; echo '\#endif'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
 	NO_DWARF := 1
 endif # Dwarf support
 endif # NO_DWARF
-- 
1.6.2.5

