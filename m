Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0IXI7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 04:59:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:35401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab0IXI7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 04:59:07 -0400
Date: Fri, 24 Sep 2010 08:58:49 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <04cfddf2ba77bcabfc3e524f1849d871d6a1cf9d.1284733808.git.jbaron@redhat.com>
References: <04cfddf2ba77bcabfc3e524f1849d871d6a1cf9d.1284733808.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Make text_poke_early() globally visible
Message-ID: <tip-fa6f2cc77081792e4edca9168420a3422299ef15@git.kernel.org>
Git-Commit-ID: fa6f2cc77081792e4edca9168420a3422299ef15
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 24 Sep 2010 08:58:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa6f2cc77081792e4edca9168420a3422299ef15
Gitweb:     http://git.kernel.org/tip/fa6f2cc77081792e4edca9168420a3422299ef15
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Fri, 17 Sep 2010 11:08:56 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 20 Sep 2010 18:19:51 -0400

jump label: Make text_poke_early() globally visible

Make text_poke_early available outside of alternative.c. The jump label
patchset wants to make use of it in order to set up the optimal no-op
sequences at run-time.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <04cfddf2ba77bcabfc3e524f1849d871d6a1cf9d.1284733808.git.jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/alternative.h |    2 ++
 arch/x86/kernel/alternative.c      |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 27a35b6..634bf78 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -160,6 +160,8 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_end	NULL
 #endif
 
+extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
  * Allows the kernel to edit read-only pages.
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1849d80..083bd01 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -195,7 +195,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
-static void *text_poke_early(void *addr, const void *opcode, size_t len);
+void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
@@ -522,7 +522,7 @@ void __init alternative_instructions(void)
  * instructions. And on the local CPU you need to be protected again NMI or MCE
  * handlers seeing an inconsistent instruction while you patch.
  */
-static void *__init_or_module text_poke_early(void *addr, const void *opcode,
+void *__init_or_module text_poke_early(void *addr, const void *opcode,
 					      size_t len)
 {
 	unsigned long flags;
