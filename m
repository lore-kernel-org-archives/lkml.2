Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0ELIkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:40:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:43311 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab0ELIkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:40:31 -0400
Date: Wed, 12 May 2010 08:40:04 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100511045953.9913.19485.stgit@localhost6.localdomain6>
References: <20100511045953.9913.19485.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Check older elfutils and set NO_DWARF
Message-ID: <tip-6b3c4ef50441e85dc9b2c9b67e95e8ad1185c15e@git.kernel.org>
Git-Commit-ID: 6b3c4ef50441e85dc9b2c9b67e95e8ad1185c15e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 May 2010 08:40:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b3c4ef50441e85dc9b2c9b67e95e8ad1185c15e
Gitweb:     http://git.kernel.org/tip/6b3c4ef50441e85dc9b2c9b67e95e8ad1185c15e
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 11 May 2010 00:59:53 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 May 2010 12:43:11 -0300

perf probe: Check older elfutils and set NO_DWARF

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
