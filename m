Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab1EGElN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 00:41:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:36906 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab1EGElM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 00:41:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,329,1301900400"; 
   d="scan'208";a="743581802"
Subject: [PATCH] perf tools: Makefile: Use gcc to determine ARCH
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 12:41:14 +0800
Message-Id: <1304743274.3132.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original Makefile uses "uname -m" to determine ARCH.
This causes problem on x86 when compile perf tool on 32 bit userspace
with a 64 bit kernel.

bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
bench/../../../arch/x86/lib/memcpy_64.S:28: Error: bad register name `%rdi'

This is because "uname -m" returns x86_64 and memcpy_64.S is included in 32 bit build.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/Makefile |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 91ad5cc..1455413 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -43,15 +43,21 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ )
 
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
+
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
         ARCH := x86
 endif
 ifeq ($(ARCH),x86_64)
-	RAW_ARCH := x86_64
-        ARCH := x86
-	ARCH_CFLAGS := -DARCH_X86_64
-	ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
+	ARCH := x86
+	IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+	ifeq (${IS_X86_64}, 1)
+		RAW_ARCH := x86_64
+		ARCH_CFLAGS := -DARCH_X86_64
+		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
+	endif
 endif
 
 #
@@ -127,8 +133,6 @@ lib = lib
 
 export prefix bindir sharedir sysconfdir
 
-CC = $(CROSS_COMPILE)gcc
-AR = $(CROSS_COMPILE)ar
 RM = rm -f
 MKDIR = mkdir
 FIND = find
-- 
1.7.4.4



