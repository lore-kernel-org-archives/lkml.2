Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab0CPWAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:00:46 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:50830 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0CPWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:00:42 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KZEAGW-01-8NR-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org, Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH] x86: Fix AMD feature bits for XOP and FMA4 instructions
Date: Tue, 16 Mar 2010 23:00:41 +0100
Message-ID: <1268776841-28753-1-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.6.4
X-OriginalArrivalTime: 16 Mar 2010 22:00:29.0055 (UTC) FILETIME=[1731E0F0:01CAC554]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD SSE5 feature set as-it has been replaced by some extensions
to the AVX instruction set. Thus the bit formerly advertised as SSE5
is re-used for one of these extensions (XOP).
Replace the name and add another one described in the new AMD APM6
manual (doc #43479, p. 25). Although this changes the /proc/cpuinfo
output, it is not user visible, as there are no CPUs (yet) having
either of these features.
Additionally as long as AVX is not sane for KVM to pass-through,
XOP and FMA4 are neither.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 arch/x86/include/asm/cpufeature.h |    3 ++-
 arch/x86/kvm/x86.c                |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0cd82d0..1af4708 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -150,9 +150,10 @@
 #define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions */
 #define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
 #define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
-#define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
+#define X86_FEATURE_XOP		(6*32+11) /* extended AVX instructions */
 #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
+#define X86_FEATURE_FMA4	(6*32+16) /* 4 operands MAC instructions */
 #define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e46282a..67541a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1859,8 +1859,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	const u32 kvm_supported_word6_x86_features =
 		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
-		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(SSE5) |
-		0 /* SKINIT */ | 0 /* WDT */;
+		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | 0 /* XOP */ |
+		0 /* SKINIT, WDT */ | 0 /* FMA4 */;
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
-- 
1.6.4


