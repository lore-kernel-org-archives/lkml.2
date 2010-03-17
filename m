Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0CQDpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:45:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61601 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0CQDpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:45:09 -0400
Message-ID: <4BA04FCA.40308@cn.fujitsu.com>
Date: Wed, 17 Mar 2010 11:43:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Sheng Yang <sheng@linux.intel.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] KVM MMU: check reserved bits only when CR4.PSE=1 or CR4.PAE=1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- The RSV bit is possibility set in error code when #PF occurred
  only if CR4.PSE=1 or CR4.PAE=1
  
- context->rsvd_bits_mask[1][0] is always 0

Changlog:
Move this operation to reset_rsvds_bits_mask() address Avi Kivity's suggestion

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b137515..c49f8ec 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2288,18 +2288,26 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 
 	if (!is_nx(vcpu))
 		exb_bit_rsvd = rsvd_bits(63, 63);
+
+	context->rsvd_bits_mask[1][0] = 0;
 	switch (level) {
 	case PT32_ROOT_LEVEL:
 		/* no rsvd bits for 2 level 4K page table entries */
 		context->rsvd_bits_mask[0][1] = 0;
 		context->rsvd_bits_mask[0][0] = 0;
+
+		/* check rsvd bits only when CR4.PSE=1 or CR4.PAE=1 */
+		if (!is_pse(vcpu)) {
+			context->rsvd_bits_mask[1][1] = 0;
+			break;
+		}
+
 		if (is_cpuid_PSE36())
 			/* 36bits PSE 4MB page */
 			context->rsvd_bits_mask[1][1] = rsvd_bits(17, 21);
 		else
 			/* 32 bits PSE 4MB page */
 			context->rsvd_bits_mask[1][1] = rsvd_bits(13, 21);
-		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[1][0];
 		break;
 	case PT32E_ROOT_LEVEL:
 		context->rsvd_bits_mask[0][2] =
@@ -2312,7 +2320,6 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 62) |
 			rsvd_bits(13, 20);		/* large page */
-		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[1][0];
 		break;
 	case PT64_ROOT_LEVEL:
 		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
@@ -2330,7 +2337,6 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51) |
 			rsvd_bits(13, 20);		/* large page */
-		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[1][0];
 		break;
 	}
 }
-- 
1.6.1.2

