Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab2AZNcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:32:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2AZNck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:32:40 -0500
Date: Thu, 26 Jan 2012 05:32:15 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-800eb01484b3ca1eaf4eb5186df13fb24de2db19@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4F16D728020000780006D732@nat28.tlf.novell.com>
References: <4F16D728020000780006D732@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench:
  Also allow measuring alternative memcpy implementations
Git-Commit-ID: 800eb01484b3ca1eaf4eb5186df13fb24de2db19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:32:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  800eb01484b3ca1eaf4eb5186df13fb24de2db19
Gitweb:     http://git.kernel.org/tip/800eb01484b3ca1eaf4eb5186df13fb24de2db19
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 18 Jan 2012 13:28:56 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 24 Jan 2012 19:51:01 -0200

perf bench: Also allow measuring alternative memcpy implementations

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
