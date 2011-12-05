Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab1LESBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:01:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59018 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab1LESBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:01:16 -0500
Date: Mon, 5 Dec 2011 10:01:01 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-39e9543344fa3179e346d2b381c6e0cd17b516de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, JBeulich@suse.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4ED4CA230200007800064065@nat28.tlf.novell.com>
References: <4ED4CA230200007800064065@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Reduce amount of redundant code generated for invalidate_interruptNN
Git-Commit-ID: 39e9543344fa3179e346d2b381c6e0cd17b516de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:01:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39e9543344fa3179e346d2b381c6e0cd17b516de
Gitweb:     http://git.kernel.org/tip/39e9543344fa3179e346d2b381c6e0cd17b516de
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 29 Nov 2011 11:03:46 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 17:24:39 +0100

x86-64: Reduce amount of redundant code generated for invalidate_interruptNN

Previously these up to 32 entry points, consisting of all the
same code except for their very first instruction, consumed 0x70
bytes per instance. Just like for device interrupt entry points,
fold them together so that they all use a single instance of the
code after having pushed their vector indicator (resulting in
0x10 bytes per instance, to retain 16-byte alignment of the
individual entry points).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/4ED4CA230200007800064065@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index ab4b7ff..1581f19 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -951,6 +951,7 @@ END(common_interrupt)
 ENTRY(\sym)
 	INTR_FRAME
 	pushq_cfi $~(\num)
+.Lcommon_\sym:
 	interrupt \do_sym
 	jmp ret_from_intr
 	CFI_ENDPROC
@@ -974,13 +975,21 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_SMP
-.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
+	ALIGN
+	INTR_FRAME
+.irp idx,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
 	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
 .if NUM_INVALIDATE_TLB_VECTORS > \idx
-apicinterrupt (INVALIDATE_TLB_VECTOR_START)+\idx \
-	invalidate_interrupt\idx smp_invalidate_interrupt
+ENTRY(invalidate_interrupt\idx)
+	pushq_cfi $~(INVALIDATE_TLB_VECTOR_START+\idx)
+	jmp .Lcommon_invalidate_interrupt0
+	CFI_ADJUST_CFA_OFFSET -8
+END(invalidate_interrupt\idx)
 .endif
 .endr
+	CFI_ENDPROC
+apicinterrupt INVALIDATE_TLB_VECTOR_START, \
+	invalidate_interrupt0, smp_invalidate_interrupt
 #endif
 
 apicinterrupt THRESHOLD_APIC_VECTOR \
