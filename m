Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2BFWKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:10:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51226 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2BFWKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:10:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/8] perf tool: Fix perf stack to non executable on x86_64
Date: Mon,  6 Feb 2012 20:10:20 -0200
Message-Id: <1328566223-27218-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1328566223-27218-1-git-send-email-acme@infradead.org>
References: <1328566223-27218-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
-- 
1.7.9.123.g65da0

