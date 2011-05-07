Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1EGJrC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 05:47:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:40211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab1EGJrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 05:47:00 -0400
Date: Sat, 7 May 2011 09:46:30 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Message-ID: <tip-174a7b1f9692acad7f0ca2b02f696894201a6d94@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, riccardo.magliocchetti@gmail.com,
        acme@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: riccardo.magliocchetti@gmail.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1304743274.3132.17.camel@localhost>
References: <1304743274.3132.17.camel@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Makefile: Use gcc to determine ARCH
Git-Commit-ID: 174a7b1f9692acad7f0ca2b02f696894201a6d94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 May 2011 09:46:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  174a7b1f9692acad7f0ca2b02f696894201a6d94
Gitweb:     http://git.kernel.org/tip/174a7b1f9692acad7f0ca2b02f696894201a6d94
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Sat, 7 May 2011 12:41:14 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 7 May 2011 11:40:59 +0200

perf tools: Makefile: Use gcc to determine ARCH

The original Makefile uses "uname -m" to determine ARCH.
This causes problem on x86 when compile perf tool on 32 bit
userspace with a 64 bit kernel.

 bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
 bench/../../../arch/x86/lib/memcpy_64.S:28: Error: bad register name `%rdi'

This is because "uname -m" returns x86_64 and memcpy_64.S is
included in 32 bit build.

Reported-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Link: http://lkml.kernel.org/r/1304743274.3132.17.camel@localhost
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 207dee5..0c54256 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -35,15 +35,21 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
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
@@ -119,8 +125,6 @@ lib = lib
 
 export prefix bindir sharedir sysconfdir
 
-CC = $(CROSS_COMPILE)gcc
-AR = $(CROSS_COMPILE)ar
 RM = rm -f
 MKDIR = mkdir
 FIND = find
