Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab1ANPpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:45:51 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31720 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab1ANPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:45:31 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bh8275dhz32i668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LF0RRN-01-IN4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 1/2] KVM: SVM: Make sure KERNEL_GS_BASE is valid when loading gs_index
Date: Fri, 14 Jan 2011 16:45:01 +0100
Message-ID: <1295019902-31339-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295019902-31339-1-git-send-email-joerg.roedel@amd.com>
References: <1295019902-31339-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gs_index loading code uses the swapgs instruction to
switch to the user gs_base temporarily. This is unsave in an
lightweight exit-path in KVM on AMD because the
KERNEL_GS_BASE MSR is switches lazily. An NMI happening in
the critical path of load_gs_index may use the wrong GS_BASE
value then leading to unpredictable behavior, e.g. a
triple-fault.
This patch fixes the issue by making sure that load_gs_index
is called only with a valid KERNEL_GS_BASE value loaded in
KVM.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 25bd1bc..54ce246 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1150,8 +1150,8 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_load_ldt(svm->host.ldt);
 #ifdef CONFIG_X86_64
 	loadsegment(fs, svm->host.fs);
-	load_gs_index(svm->host.gs);
 	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
+	load_gs_index(svm->host.gs);
 #else
 	loadsegment(gs, svm->host.gs);
 #endif
-- 
1.7.1


