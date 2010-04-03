Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0DCJ30 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 05:29:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:60885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab0DCJ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 05:29:23 -0400
Date: Sat, 3 Apr 2010 09:28:42 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       bp@amd64.org, tglx@linutronix.de, mhiramat@redhat.com,
       borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       bp@amd64.org, tglx@linutronix.de, mhiramat@redhat.com,
       borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <20100329164755.GA16034@aftab>
References: <20100329164755.GA16034@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, probe-finder: Build fix on Debian
Message-ID: <tip-b0f86f5a169c758a82b0e23eef6795356f6d5a25@git.kernel.org>
Git-Commit-ID: b0f86f5a169c758a82b0e23eef6795356f6d5a25
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 03 Apr 2010 09:28:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0f86f5a169c758a82b0e23eef6795356f6d5a25
Gitweb:     http://git.kernel.org/tip/b0f86f5a169c758a82b0e23eef6795356f6d5a25
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Mon, 29 Mar 2010 18:47:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 22:46:26 +0200

perf, probe-finder: Build fix on Debian

Building chokes with:

 In file included from /usr/include/gelf.h:53,
                 from /usr/include/elfutils/libdw.h:53,
                 from util/probe-finder.h:61,
                 from util/probe-finder.c:39:
 /usr/include/libelf.h:98: error: expected specifier-qualifier-list before 'off64_t'
 [...]

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <20100329164755.GA16034@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8a8f52d..bc0f670 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -200,7 +200,7 @@ endif
 
 CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
-ALL_CFLAGS = $(CFLAGS)
+ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
 
@@ -492,19 +492,19 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
-ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
-ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
 endif
 
-	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 		BASIC_CFLAGS += -DLIBELF_NO_MMAP
 	endif
 else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
 	BASIC_CFLAGS += -DNO_DWARF_SUPPORT
 else
