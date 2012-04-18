Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2DRMDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 08:03:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2DRMDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:03:09 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com
Subject: [PATCH 3.4-rc] KVM: VMX: Fix kvm_set_shared_msr() called in preemptible context
Date: Wed, 18 Apr 2012 15:03:04 +0300
Message-Id: <1334750584-10884-1-git-send-email-avi@redhat.com>
In-Reply-To: <20120418025822.GA22660@redhat.com>
References: <20120418025822.GA22660@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_set_shared_msr() may not be called in preemptible context,
but vmx_set_msr() does so:

  BUG: using smp_processor_id() in preemptible [00000000] code: qemu-kvm/22713
  caller is kvm_set_shared_msr+0x32/0xa0 [kvm]
  Pid: 22713, comm: qemu-kvm Not tainted 3.4.0-rc3+ #39
  Call Trace:
   [<ffffffff8131fa82>] debug_smp_processor_id+0xe2/0x100
   [<ffffffffa0328ae2>] kvm_set_shared_msr+0x32/0xa0 [kvm]
   [<ffffffffa03a103b>] vmx_set_msr+0x28b/0x2d0 [kvm_intel]
   ...

Making kvm_set_shared_msr() work in preemptible is cleaner, but
it's used in the fast path.  Making two variants is overkill, so
this patch just disables preemption around the call.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ad85adf..4ff0ab9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2210,9 +2210,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		msr = find_msr_entry(vmx, msr_index);
 		if (msr) {
 			msr->data = data;
-			if (msr - vmx->guest_msrs < vmx->save_nmsrs)
+			if (msr - vmx->guest_msrs < vmx->save_nmsrs) {
+				preempt_disable();
 				kvm_set_shared_msr(msr->index, msr->data,
 						   msr->mask);
+				preempt_enable();
+			}
 			break;
 		}
 		ret = kvm_set_msr_common(vcpu, msr_index, data);
-- 
1.7.10

