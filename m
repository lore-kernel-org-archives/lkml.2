Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab1GKVic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:38:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58583 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1GKVib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:38:31 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools, x86: fix 32-bit compile on 64-bit system
Date: Mon, 11 Jul 2011 15:38:24 -0600
Message-Id: <1310420304-21452-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Builds for 32-bit binaries on a 64-bit host currently fail with the error:

gcc -o /tmp/perf-ppc/bench/mem-memcpy-x86-64-asm.o -c -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement -m32 -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Iutil/include -Iarch/x86/include -I/tmp/perf-ppc/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_NEWT_SUPPORT -DNO_LIBPERL -DNO_LIBPYTHON -DHAVE_CPLUS_DEMANGLE -DNO_STRLCPY -DARCH_X86_64 bench/mem-memcpy-x86-64-asm.S
bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
bench/../../../arch/x86/lib/memcpy_64.S:29: Error: bad register name `%rdi'
bench/../../../arch/x86/lib/memcpy_64.S:34: Error: invalid instruction suffix for `movs'
bench/../../../arch/x86/lib/memcpy_64.S:50: Error: bad register name `%rdi'
bench/../../../arch/x86/lib/memcpy_64.S:61: Error: bad register name `%rdi'
...

The problem is the detection of the host arch without considering passed in
flags. This change fixes 32-bit builds via:

make EXTRA_CFLAGS=-m32 

and 64-bit builds still reference the memcpy_64.S.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 940257b..c168366 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -52,7 +52,10 @@ ifeq ($(ARCH),i386)
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH := x86
-	IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+	IS_X86_64 := 0
+	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
+		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+	endif
 	ifeq (${IS_X86_64}, 1)
 		RAW_ARCH := x86_64
 		ARCH_CFLAGS := -DARCH_X86_64
-- 
1.7.6

