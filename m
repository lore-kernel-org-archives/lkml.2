Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab1AMPXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:23:16 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:41123 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab1AMPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:23:08 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bh8275dhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEYW2B-01-NNN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 1/2] KVM: SVM: Fix NMI path when NMI happens in guest mode
Date: Thu, 13 Jan 2011 16:22:57 +0100
Message-ID: <1294932178-26866-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com>
References: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmexit path on SVM needs to restore the KERNEL_GS_BASE
MSR in order to savely execute the NMI handler. Otherwise a
pending NMI can occur after the STGI instruction and crash
the machine.
This makes it impossible to run perf and kvm in parallel on
an AMD machine in a stable way.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 25bd1bc..8b9bc72 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3637,6 +3637,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
+	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
 #else
 	loadsegment(fs, svm->host.fs);
 #endif
-- 
1.7.1


