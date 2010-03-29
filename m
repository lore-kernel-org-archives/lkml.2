Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0C2Pk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:40:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41507 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab0C2Pk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:40:56 -0400
Date: Mon, 29 Mar 2010 17:41:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf, probe-finder: Build fix on Debian
Message-ID: <20100329154132.GA16223@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

This happens on current -git: v2.6.34-rc2-288-gb72c409

 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8a8f52d..19c34a5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -508,7 +508,7 @@ ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; e
 	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
 	BASIC_CFLAGS += -DNO_DWARF_SUPPORT
 else
-	BASIC_CFLAGS += -I/usr/include/elfutils
+	BASIC_CFLAGS += -I/usr/include/elfutils -D_LARGEFILE64_SOURCE
 	EXTLIBS += -lelf -ldw
 	LIB_OBJS += util/probe-finder.o
 endif
-- 
1.5.6.5


-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
