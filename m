Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098Ab2IGGDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:03:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759138Ab2IGGC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:02:59 -0400
Date: Thu, 6 Sep 2012 23:02:42 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-09a2f16a916178489fc4bf439de668d81fda7616@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1346094354-74356-1-git-send-email-dsahern@gmail.com>
References: <1346094354-74356-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix x86 builds with ARCH specified on the command line
Git-Commit-ID: 09a2f16a916178489fc4bf439de668d81fda7616
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:02:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09a2f16a916178489fc4bf439de668d81fda7616
Gitweb:     http://git.kernel.org/tip/09a2f16a916178489fc4bf439de668d81fda7616
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 27 Aug 2012 13:05:54 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:23:30 -0300

perf tools: Fix x86 builds with ARCH specified on the command line

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
