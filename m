Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab2IEXJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51599 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759821Ab2IEXJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/17] perf tools: Fix x86 builds with ARCH specified on the command line
Date: Wed,  5 Sep 2012 20:08:49 -0300
Message-Id: <1346886537-11621-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346094354-74356-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
1.7.1

