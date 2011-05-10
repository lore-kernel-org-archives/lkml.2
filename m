Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab1EJOQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:16:36 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:51844 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932557Ab1EJOQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:16:33 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-54-4dc9488a6a17
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 6/6] x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO
Date: Tue, 10 May 2011 10:15:08 -0400
Message-Id: <180ff42f281f136937840149d8c43384f00b69bd.1305035945.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
In-Reply-To: <cover.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsUixG6nrtvlcdLX4PlHKYuLbRfZLPquHGW3
	OHLtO7vFnPMtLBb73p9ls7i8aw6bxZZLzawWa6e+YbHYvGkqs8WjvrfsFj82PGZ14Pa48pTD
	Y8vKm0wet9r+MHvM3/mR0WPnrLvsHptWdbJ5vDt3jt3jxIzfLB6bT1d7fN4kF8AVxWWTkpqT
	WZZapG+XwJWxvH8Hc0EDV8XMNSfYGhgXcXQxcnJICJhIrPu5jw3CFpO4cG89kM3FISSwj1Hi
	/c8GZghnA6PE2onLmUCqhASeMUlc/BAAYrMJqEh0LH0AFOfgEBEQklh6tw4kzCywmFni630n
	EFtYIEpiUdt/RhCbRUBVYuO6jawg5bwCQRKfNxZA7FWQuHJlHguIzSlgIPH28D82iE36EouW
	HsMpPoFRYAEjwypG2ZTcKt3cxMyc4tRk3eLkxLy81CJdI73czBK91JTSTYygCOCU5N3B+O6g
	0iFGAQ5GJR5eif/HfYVYE8uKK3MPMUpyMCmJ8l52OekrxJeUn1KZkVicEV9UmpNafIhRgoNZ
	SYR33s8TvkK8KYmVValF+TApaQ4WJXHemZLqvkIC6YklqdmpqQWpRTBZGQ4OJQleeWCkCwkW
	paanVqRl5pQgpJk4OEGG8wANtwWp4S0uSMwtzkyHyJ9i1OWY3tZ8gFGIJS8/L1VKnFcbpEgA
	pCijNA9uDixxvWIUB3pLmNcVpIoHmPTgJr0CWsIEtMR8A8gHxSWJCCmpBsb6myr3L3hYb43i
	7AuVitby0v13pvTmJ93IN9dU8gQZrv868GT6r29BK3IrfvQfcvmt6z1pPtPJzQ8eyM93ut2j
	kz8vx3f3z0zf3bP9tdtXvnhy4O3s5nLWL45eG+wWHtsuab/Trdnx5NH6dsctimt2Tn/uKejl
	wipqv/m/5R3n3nb5MJ3w6++VWIozEg21mIuKEwHgtynvNwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vDSO isn't part of the kernel, so profiling and kernel
backtraces don't really matter.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/Makefile |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index a651861..bef0bc9 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -37,11 +37,24 @@ $(obj)/%.so: OBJCOPYFLAGS := -S
 $(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
+#
+# Don't omit frame pointers for ease of userspace debugging, but do
+# optimize sibling calls.
+#
 CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
-       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector)
+       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector) \
+       -fno-omit-frame-pointer -foptimize-sibling-calls
 
 $(vobjs): KBUILD_CFLAGS += $(CFL)
 
+#
+# vDSO code runs in userspace and -pg doesn't help with profiling anyway.
+#
+CFLAGS_REMOVE_vdso-note.o = -pg
+CFLAGS_REMOVE_vclock_gettime.o = -pg
+CFLAGS_REMOVE_vgetcpu.o = -pg
+CFLAGS_REMOVE_vvar.o = -pg
+
 targets += vdso-syms.lds
 obj-$(VDSO64-y)			+= vdso-syms.lds
 
-- 
1.7.5.1

