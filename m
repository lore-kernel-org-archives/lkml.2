Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0IJPcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:32:53 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57705 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0IJPcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:48 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bh8275dhz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF42-02-JQ9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 29/29] KVM: X86: Report SVM bit to userspace only when supported
Date: Fri, 10 Sep 2010 17:31:06 +0200
Message-ID: <1284132667-18620-30-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in KVM where it _always_ reports the
support of the SVM feature to userspace. But KVM only
supports SVM on AMD hardware and only when it is enabled in
the kernel module. This patch fixes the wrong reporting.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    4 ++++
 arch/x86/kvm/x86.c |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 678602e..eeb08d6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3464,6 +3464,10 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 	switch (func) {
+	case 0x80000001:
+		if (nested)
+			entry->ecx |= (1 << 2); /* Set SVM bit */
+		break;
 	case 0x8000000A:
 		entry->eax = 1; /* SVM revision 1 */
 		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16f49c7..f7bab03 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2195,7 +2195,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		0 /* Reserved, AES */ | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX);
 	/* cpuid 0x80000001.ecx */
 	const u32 kvm_supported_word6_x86_features =
-		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
+		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
 		F(3DNOWPREFETCH) | 0 /* OSVW */ | 0 /* IBS */ | F(SSE5) |
 		0 /* SKINIT */ | 0 /* WDT */;
-- 
1.7.0.4


