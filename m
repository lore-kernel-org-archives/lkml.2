Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2AXXIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:08:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59162 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab2AXXIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@suse.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jan Beulich <jbeulich@suse.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/9] perf bench: Also allow measuring alternative memcpy implementations
Date: Tue, 24 Jan 2012 21:07:56 -0200
Message-Id: <1327446481-5505-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327446481-5505-1-git-send-email-acme@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

Intended to be able to support the current selection of the preferred
memcpy() implementation, this patch adds the ability to also measure the
two alternative implementations, again by way of using some
pre-processsor replacement.

While on my Westmere system this proves that the movsb based variant is
worse than the movsq based one (since the ERMS feature isn't there), it
also shows that here for the default as well as small sizes the unrolled
variant outperforms the movsq one.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4F16D728020000780006D732@nat28.tlf.novell.com
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy-x86-64-asm-def.h |    8 ++++++++
 tools/perf/bench/mem-memcpy-x86-64-asm.S     |    4 ++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm-def.h b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
index d588b87..d66ab79 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
@@ -2,3 +2,11 @@
 MEMCPY_FN(__memcpy,
 	"x86-64-unrolled",
 	"unrolled memcpy() in arch/x86/lib/memcpy_64.S")
+
+MEMCPY_FN(memcpy_c,
+	"x86-64-movsq",
+	"movsq-based memcpy() in arch/x86/lib/memcpy_64.S")
+
+MEMCPY_FN(memcpy_c_e,
+	"x86-64-movsb",
+	"movsb-based memcpy() in arch/x86/lib/memcpy_64.S")
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
index 384b607..a20780b 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -1,2 +1,6 @@
 #define memcpy MEMCPY /* don't hide glibc's memcpy() */
+#define altinstr_replacement text
+#define globl p2align 4; .globl
+#define Lmemcpy_c globl memcpy_c; memcpy_c
+#define Lmemcpy_c_e globl memcpy_c_e; memcpy_c_e
 #include "../../../arch/x86/lib/memcpy_64.S"
-- 
1.7.9.rc2.1.g69204

