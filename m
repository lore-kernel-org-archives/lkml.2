Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2BGTn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:43:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2BGTn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:43:26 -0500
Date: Tue, 7 Feb 2012 11:37:00 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-e89cef136a8b56eef1acf702591fd3039fc3385d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, eric.dumazet@gmail.com,
        a.p.zijlstra@chello.nl, williams@redhat.com, jolsa@redhat.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eric.dumazet@gmail.com,
        williams@redhat.com, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1328100848-5630-1-git-send-email-jolsa@redhat.com>
References: <1328100848-5630-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tool:
  Fix perf stack to non executable on x86_64
Git-Commit-ID: e89cef136a8b56eef1acf702591fd3039fc3385d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:37:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e89cef136a8b56eef1acf702591fd3039fc3385d
Gitweb:     http://git.kernel.org/tip/e89cef136a8b56eef1acf702591fd3039fc3385d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 1 Feb 2012 13:54:08 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Feb 2012 19:14:17 -0200

perf tool: Fix perf stack to non executable on x86_64

By adding following objects:
  bench/mem-memset-x86-64-asm.o
  bench/mem-memcpy-x86-64-asm.o
the x86_64 perf binary ended up with executable stack.

The reason was that above objects are assembler sourced and are missing the
GNU-stack note section. In such case the linker assumes that the final binary
should not be restricted at all and mark the stack as RWX.

Adding section ".note.GNU-stack" definition to mentioned objects, with all
flags disabled, thus omiting those objects from linker stack flags decision.

Reported-at: https://bugzilla.redhat.com/show_bug.cgi?id=783570
Reported-by: Clark Williams <williams@redhat.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328100848-5630-1-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
[ committer note: Remaining bits after what was already added to perf/urgent ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memset-x86-64-asm.S |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/mem-memset-x86-64-asm.S b/tools/perf/bench/mem-memset-x86-64-asm.S
index cb92170..9e5af89 100644
--- a/tools/perf/bench/mem-memset-x86-64-asm.S
+++ b/tools/perf/bench/mem-memset-x86-64-asm.S
@@ -4,3 +4,10 @@
 #define Lmemset_c globl memset_c; memset_c
 #define Lmemset_c_e globl memset_c_e; memset_c_e
 #include "../../../arch/x86/lib/memset_64.S"
+
+/*
+ * We need to provide note.GNU-stack section, saying that we want
+ * NOT executable stack. Otherwise the final linking will assume that
+ * the ELF stack should not be restricted at all and set it RWX.
+ */
+.section .note.GNU-stack,"",@progbits
