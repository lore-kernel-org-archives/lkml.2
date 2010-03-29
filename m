Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0C2QrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:47:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37577 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab0C2QrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:47:19 -0400
Date: Mon, 29 Mar 2010 18:47:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2] perf, probe-finder: Build fix on Debian
Message-ID: <20100329164755.GA16034@aftab>
References: <20100329154132.GA16223@aftab>
 <4BB0CC60.8010604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB0CC60.8010604@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building chokes with

In file included from /usr/include/gelf.h:53,
                 from /usr/include/elfutils/libdw.h:53,
                 from util/probe-finder.h:61,
                 from util/probe-finder.c:39:
/usr/include/libelf.h:98: error: expected specifier-qualifier-list before 'off64_t'
/usr/include/libelf.h:160: error: expected specifier-qualifier-list before 'off64_t'
/usr/include/libelf.h:201: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'elf_update'
/usr/include/libelf.h:207: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'elf_getbase'
/usr/include/libelf.h:305: error: expected declaration specifiers or '...' before 'off64_t'
/usr/include/libelf.h:317: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'elf_getaroff'
make: *** [util/probe-finder.o] Error 1
make: *** Waiting for unfinished jobs....
rm .perf.dev.null

which is due to the fact that </usr/include/libelf.h> isn't seeing
off64_t from <sys/types.h>

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
-- 
1.5.6.5

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
