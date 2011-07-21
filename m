Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1GUPha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:37:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:60664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab1GUPh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:37:27 -0400
Date: Thu, 21 Jul 2011 15:36:50 GMT
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-08a4a43fc407d780bdde36d98f89c0dbb2a6be6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, stable@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, stable@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1310420304-21452-1-git-send-email-dsahern@gmail.com>
References: <1310420304-21452-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools, x86: Fix 32-bit compile on 64-bit system
Git-Commit-ID: 08a4a43fc407d780bdde36d98f89c0dbb2a6be6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 15:36:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08a4a43fc407d780bdde36d98f89c0dbb2a6be6b
Gitweb:     http://git.kernel.org/tip/08a4a43fc407d780bdde36d98f89c0dbb2a6be6b
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 11 Jul 2011 15:38:24 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 13:42:30 +0200

perf tools, x86: Fix 32-bit compile on 64-bit system

Builds for 32-bit perf binaries on a 64-bit host currently fail
with this error:

 [...]
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
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1310420304-21452-1-git-send-email-dsahern@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
