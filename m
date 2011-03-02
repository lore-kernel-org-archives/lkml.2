Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1CBInY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:43:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:45337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab1CBInX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:43:23 -0500
Date: Wed, 2 Mar 2011 08:42:23 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, akpm@linux-foundation.org, shaohua.li@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, jbeulich@novell.com, tglx@linutronix.de,
        shaohua.li@intel.com, mingo@elte.hu
In-Reply-To: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
References: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Work around old gas bug
Message-ID: <tip-253d89d3dd6b65595f317e5f1ecef43aa207a3a0@git.kernel.org>
Git-Commit-ID: 253d89d3dd6b65595f317e5f1ecef43aa207a3a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Mar 2011 08:42:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  253d89d3dd6b65595f317e5f1ecef43aa207a3a0
Gitweb:     http://git.kernel.org/tip/253d89d3dd6b65595f317e5f1ecef43aa207a3a0
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Tue, 1 Mar 2011 15:52:26 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Mar 2011 08:16:23 +0100

x86: Work around old gas bug

pre-2.16 binutils works fine, post-2.16 binutils works fine, but 2.16 broke again:

 > arch/x86/kernel/entry_64.S: Assembler messages:
 > arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first unrecognized character is `1'
 > [...]

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/entry_arch.h |  164 +++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/entry_64.S        |  133 ++++++++++++++++++++++++++++--
 2 files changed, 285 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 1cd6d26..374c641 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -16,14 +16,166 @@ BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
 BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
 
-.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
-	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
-.if NUM_INVALIDATE_TLB_VECTORS > \idx
-BUILD_INTERRUPT3(invalidate_interrupt\idx,
-		 (INVALIDATE_TLB_VECTOR_START)+\idx,
+.if NUM_INVALIDATE_TLB_VECTORS > 0
+BUILD_INTERRUPT3(invalidate_interrupt0,
+		 (INVALIDATE_TLB_VECTOR_START)+0,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 1
+BUILD_INTERRUPT3(invalidate_interrupt1,
+		 (INVALIDATE_TLB_VECTOR_START)+1,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 2
+BUILD_INTERRUPT3(invalidate_interrupt2,
+		 (INVALIDATE_TLB_VECTOR_START)+2,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 3
+BUILD_INTERRUPT3(invalidate_interrupt3,
+		 (INVALIDATE_TLB_VECTOR_START)+3,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 4
+BUILD_INTERRUPT3(invalidate_interrupt4,
+		 (INVALIDATE_TLB_VECTOR_START)+4,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 5
+BUILD_INTERRUPT3(invalidate_interrupt5,
+		 (INVALIDATE_TLB_VECTOR_START)+5,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 6
+BUILD_INTERRUPT3(invalidate_interrupt6,
+		 (INVALIDATE_TLB_VECTOR_START)+6,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 7
+BUILD_INTERRUPT3(invalidate_interrupt7,
+		 (INVALIDATE_TLB_VECTOR_START)+7,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 8
+BUILD_INTERRUPT3(invalidate_interrupt8,
+		 (INVALIDATE_TLB_VECTOR_START)+8,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 9
+BUILD_INTERRUPT3(invalidate_interrupt9,
+		 (INVALIDATE_TLB_VECTOR_START)+9,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 10
+BUILD_INTERRUPT3(invalidate_interrupt10,
+		 (INVALIDATE_TLB_VECTOR_START)+10,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 11
+BUILD_INTERRUPT3(invalidate_interrupt11,
+		 (INVALIDATE_TLB_VECTOR_START)+11,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 12
+BUILD_INTERRUPT3(invalidate_interrupt12,
+		 (INVALIDATE_TLB_VECTOR_START)+12,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 13
+BUILD_INTERRUPT3(invalidate_interrupt13,
+		 (INVALIDATE_TLB_VECTOR_START)+13,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 14
+BUILD_INTERRUPT3(invalidate_interrupt14,
+		 (INVALIDATE_TLB_VECTOR_START)+14,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 15
+BUILD_INTERRUPT3(invalidate_interrupt15,
+		 (INVALIDATE_TLB_VECTOR_START)+15,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 16
+BUILD_INTERRUPT3(invalidate_interrupt16,
+		 (INVALIDATE_TLB_VECTOR_START)+16,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 17
+BUILD_INTERRUPT3(invalidate_interrupt17,
+		 (INVALIDATE_TLB_VECTOR_START)+17,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 18
+BUILD_INTERRUPT3(invalidate_interrupt18,
+		 (INVALIDATE_TLB_VECTOR_START)+18,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 19
+BUILD_INTERRUPT3(invalidate_interrupt19,
+		 (INVALIDATE_TLB_VECTOR_START)+19,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 20
+BUILD_INTERRUPT3(invalidate_interrupt20,
+		 (INVALIDATE_TLB_VECTOR_START)+20,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 21
+BUILD_INTERRUPT3(invalidate_interrupt21,
+		 (INVALIDATE_TLB_VECTOR_START)+21,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 22
+BUILD_INTERRUPT3(invalidate_interrupt22,
+		 (INVALIDATE_TLB_VECTOR_START)+22,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 23
+BUILD_INTERRUPT3(invalidate_interrupt23,
+		 (INVALIDATE_TLB_VECTOR_START)+23,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 24
+BUILD_INTERRUPT3(invalidate_interrupt24,
+		 (INVALIDATE_TLB_VECTOR_START)+24,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 25
+BUILD_INTERRUPT3(invalidate_interrupt25,
+		 (INVALIDATE_TLB_VECTOR_START)+25,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 26
+BUILD_INTERRUPT3(invalidate_interrupt26,
+		 (INVALIDATE_TLB_VECTOR_START)+26,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 27
+BUILD_INTERRUPT3(invalidate_interrupt27,
+		 (INVALIDATE_TLB_VECTOR_START)+27,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 28
+BUILD_INTERRUPT3(invalidate_interrupt28,
+		 (INVALIDATE_TLB_VECTOR_START)+28,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 29
+BUILD_INTERRUPT3(invalidate_interrupt29,
+		 (INVALIDATE_TLB_VECTOR_START)+29,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 30
+BUILD_INTERRUPT3(invalidate_interrupt30,
+		 (INVALIDATE_TLB_VECTOR_START)+30,
+		 smp_invalidate_interrupt)
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 31
+BUILD_INTERRUPT3(invalidate_interrupt31,
+		 (INVALIDATE_TLB_VECTOR_START)+31,
 		 smp_invalidate_interrupt)
 .endif
-.endr
 #endif
 
 BUILD_INTERRUPT(x86_platform_ipi, X86_PLATFORM_IPI_VECTOR)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 891268c..1705021 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -975,13 +975,134 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_SMP
-.irp idx,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, \
-	16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
-.if NUM_INVALIDATE_TLB_VECTORS > \idx
-apicinterrupt (INVALIDATE_TLB_VECTOR_START)+\idx \
-	invalidate_interrupt\idx smp_invalidate_interrupt
+.if NUM_INVALIDATE_TLB_VECTORS > 0
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+0 \
+	invalidate_interrupt0 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 1
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+1 \
+	invalidate_interrupt1 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 2
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+2 \
+	invalidate_interrupt2 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 3
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+3 \
+	invalidate_interrupt3 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 4
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+4 \
+	invalidate_interrupt4 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 5
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+5 \
+	invalidate_interrupt5 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 6
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+6 \
+	invalidate_interrupt6 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 7
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+7 \
+	invalidate_interrupt7 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 8
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+8 \
+	invalidate_interrupt8 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 9
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+9 \
+	invalidate_interrupt9 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 10
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+10 \
+	invalidate_interrupt10 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 11
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+11 \
+	invalidate_interrupt11 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 12
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+12 \
+	invalidate_interrupt12 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 13
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+13 \
+	invalidate_interrupt13 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 14
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+14 \
+	invalidate_interrupt14 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 15
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+15 \
+	invalidate_interrupt15 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 16
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+16 \
+	invalidate_interrupt16 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 17
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+17 \
+	invalidate_interrupt17 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 18
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+18 \
+	invalidate_interrupt18 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 19
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+19 \
+	invalidate_interrupt19 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 20
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+20 \
+	invalidate_interrupt20 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 21
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+21 \
+	invalidate_interrupt21 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 22
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+22 \
+	invalidate_interrupt22 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 23
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+23 \
+	invalidate_interrupt23 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 24
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+24 \
+	invalidate_interrupt24 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 25
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+25 \
+	invalidate_interrupt25 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 26
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+26 \
+	invalidate_interrupt26 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 27
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+27 \
+	invalidate_interrupt27 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 28
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+28 \
+	invalidate_interrupt28 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 29
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+29 \
+	invalidate_interrupt29 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 30
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+30 \
+	invalidate_interrupt30 smp_invalidate_interrupt
+.endif
+.if NUM_INVALIDATE_TLB_VECTORS > 31
+apicinterrupt (INVALIDATE_TLB_VECTOR_START)+31 \
+	invalidate_interrupt31 smp_invalidate_interrupt
 .endif
-.endr
 #endif
 
 apicinterrupt THRESHOLD_APIC_VECTOR \
