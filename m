Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab0KAI5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:57:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64858 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab0KAI5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:57:06 -0400
Message-ID: <4CCE81E8.6020001@cn.fujitsu.com>
Date: Mon, 01 Nov 2010 17:01:28 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 4/7] KVM: avoid unnecessary wait for a async pf
References: <4CCE8143.3090105@cn.fujitsu.com>
In-Reply-To: <4CCE8143.3090105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, it checks async pf completion out of the wait context,
like this:

if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
		    !vcpu->arch.apf.halted)
			r = vcpu_enter_guest(vcpu);
		else {
			......
			kvm_vcpu_block(vcpu)
			 ^- waiting until 'async_pf.done' is not empty
}
	
kvm_check_async_pf_completion(vcpu)
 ^- delete list from async_pf.done

So, if we check aysnc pf completion first, it can be blocked at
kvm_vcpu_block

Fixed by mark the vcpu is unhalted in kvm_check_async_pf_completion()
path

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b543f4..4da8485 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6280,6 +6280,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 		vcpu->arch.fault.address = work->arch.token;
 		kvm_inject_page_fault(vcpu);
 	}
+	vcpu->arch.apf.halted = false;
 }
 
 bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
-- 
1.7.0.4

