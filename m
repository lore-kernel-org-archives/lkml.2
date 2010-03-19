Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0CSCA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 22:00:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53019 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab0CSCA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 22:00:58 -0400
Message-ID: <4BA34ADD.9040903@cn.fujitsu.com>
Date: Fri, 19 Mar 2010 17:58:53 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: [PATCH v3] KVM MMU:  check reserved bits only  if CR4.PSE=1 or CR4.PAE=1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Check reserved bits only if CR4.PAE=1 or CR4.PSE=1 when guest #PF occurs
- Fix a typo in reset_rsvds_bits_mask()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b137515..d6c1f03 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2293,13 +2293,19 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 		/* no rsvd bits for 2 level 4K page table entries */
 		context->rsvd_bits_mask[0][1] = 0;
 		context->rsvd_bits_mask[0][0] = 0;
+		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[0][0];
+
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
@@ -2312,7 +2318,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 62) |
 			rsvd_bits(13, 20);		/* large page */
-		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[1][0];
+		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[0][0];
 		break;
 	case PT64_ROOT_LEVEL:
 		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
@@ -2330,7 +2336,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51) |
 			rsvd_bits(13, 20);		/* large page */
-		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[1][0];
+		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[0][0];
 		break;
 	}
 }
-- 
1.6.6.1
