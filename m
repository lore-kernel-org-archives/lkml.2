Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0EKEyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 00:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0EKEyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 00:54:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip] perf probe: Check older elfutils and set NO_DWARF
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Robert Richter <robert.richter@amd.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 11 May 2010 00:59:53 -0400
Message-ID: <20100511045953.9913.19485.stgit@localhost6.localdomain6>
In-Reply-To: <4BE85C51.704@redhat.com>
References: <4BE85C51.704@redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether elfutils is older than 0.138 (from which version checking
routine has been introduced). And if so, set NO_DWARF because it is hard
to check the API dependency without version checking.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
Masami Hiramatsu
e-mail: mhiramat@redhat.com
