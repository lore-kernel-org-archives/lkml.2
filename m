Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0D0Klg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:41:36 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:52699
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754781Ab0D0KjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:39:08 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WK-02-NOV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/22] KVM: MMU: Track page fault data in struct vcpu
Date: Tue, 27 Apr 2010 12:38:26 +0200
Message-ID: <1272364712-17425-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:36.0058 (UTC) FILETIME=[CA7F77A0:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two fields in vcpu_arch for x86:

	* fault_address
	* fault_error_code

This will be used to correctly propagate page faults back
into the guest when we could have either an ordinary page
fault or a nested page fault. In the case of a nested page
fault the fault-address is different from the original
address that should be walked. So we need to keep track
about the real fault-address.
We could also remove the current path of the error_code to
the fault. But this change is too invasive and outside the
scope of this patch set. It will be changed and tested
seperatly.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/paging_tmpl.h      |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d9dfc8c..8426870 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -298,6 +298,9 @@ struct kvm_vcpu_arch {
 	/* Used for two dimensional paging emulation */
 	struct kvm_mmu nested_mmu;
 
+	unsigned long fault_address;
+	int fault_error_code;
+
 	/* only needed in kvm_pv_mmu_op() path, but it's hot so
 	 * put it here to avoid allocation */
 	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 8b27026..df92ce2 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -266,6 +266,10 @@ err:
 		walker->error_code |= PFERR_FETCH_MASK;
 	if (rsvd_fault)
 		walker->error_code |= PFERR_RSVD_MASK;
+
+	vcpu->arch.fault_address    = addr;
+	vcpu->arch.fault_error_code = walker->error_code;
+
 	trace_kvm_mmu_walker_error(walker->error_code);
 	return 0;
 }
-- 
1.7.0.4


