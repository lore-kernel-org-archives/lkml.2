Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1AEJgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:36:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60978 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1AEJgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:36:18 -0500
Message-ID: <4D243B95.3070203@cn.fujitsu.com>
Date: Wed, 05 Jan 2011 17:36:21 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/3] KVM: fix rcu usage warning in kvm_arch_vcpu_ioctl_set_sregs()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 17:35:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 17:35:58,
	Serialize complete at 2011-01-05 17:35:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:
[ 1001.499596] ===================================================
[ 1001.499599] [ INFO: suspicious rcu_dereference_check() usage. ]
[ 1001.499601] ---------------------------------------------------
	......
[ 1001.499633] stack backtrace:
[ 1001.499636] Pid: 6035, comm: qemu-system-x86 Not tainted 2.6.37-rc6+ #62
[ 1001.499638] Call Trace:
[ 1001.499644]  [<ffffffff81076cf6>] lockdep_rcu_dereference+0x9d/0xa5
[ 1001.499653]  [<ffffffffa02567a6>] gfn_to_memslot+0x8d/0xc8 [kvm]
[ 1001.499661]  [<ffffffffa0256824>] gfn_to_hva+0x16/0x3f [kvm]
[ 1001.499669]  [<ffffffffa02568f5>] kvm_read_guest_page+0x1e/0x5e [kvm]
[ 1001.499681]  [<ffffffffa026c24a>] kvm_read_guest_page_mmu+0x53/0x5e [kvm]
[ 1001.499699]  [<ffffffffa026c294>] load_pdptrs+0x3f/0x9c [kvm]
[ 1001.499705]  [<ffffffffa00d825e>] ? vmx_set_cr0+0x507/0x517 [kvm_intel]
[ 1001.499717]  [<ffffffffa026ca56>] kvm_arch_vcpu_ioctl_set_sregs+0x1f3/0x3c0 [kvm]
[ 1001.499727]  [<ffffffffa025a410>] kvm_vcpu_ioctl+0x6a5/0xbc5 [kvm]

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fa708c9..0b77e9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5571,7 +5571,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
 	int mmu_reset_needed = 0;
-	int pending_vec, max_bits;
+	int pending_vec, max_bits, idx;
 	struct desc_ptr dt;
 
 	dt.size = sregs->idt.limit;
@@ -5600,10 +5600,13 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
 	if (sregs->cr4 & X86_CR4_OSXSAVE)
 		update_cpuid(vcpu);
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (!is_long_mode(vcpu) && is_pae(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		mmu_reset_needed = 1;
 	}
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
-- 
1.7.3.4
