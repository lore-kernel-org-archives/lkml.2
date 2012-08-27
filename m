Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2H0TGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 15:06:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62355 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2H0TGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 15:06:05 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] perf: fix x86 builds with ARCH specified on the command line
Date: Mon, 27 Aug 2012 13:05:54 -0600
Message-Id: <1346094354-74356-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e.g., compiling i386 on x86_64 using:
$ make -C tools/perf ARCH=i386

fails with:

    CC /tmp/pbuild/util/evsel.o
In file included from util/evsel.c:21:0:
util/perf_regs.h:5:23: fatal error: perf_regs.h: No such file or directory
compilation terminated.

Adding V=1 you see that the include argument for the arch is
'-Iarch/i386/include' is wrong. It is supposed to be -Iarch/x86/include
per the redefinition of ARCH in the Makefile.

According to the make manual,
http://www.gnu.org/software/make/manual/make.html#Override-Directive:
  "If a variable has been set with a command argument (see Overriding
   Variables), then ordinary assignments in the makefile are ignored. If
   you want to set the variable in the makefile even though it was set
   with a command argument, you can use an override directive ..."

Make it so.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 722ddee..939cf6d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -64,12 +64,12 @@ AR = $(CROSS_COMPILE)ar
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
-	ARCH := x86
+	override ARCH := x86
 	NO_PERF_REGS := 0
 	LIBUNWIND_LIBS = -lunwind -lunwind-x86
 endif
 ifeq ($(ARCH),x86_64)
-	ARCH := x86
+	override ARCH := x86
 	IS_X86_64 := 0
 	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
 		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
-- 
1.7.10.1

