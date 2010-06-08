Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0FHCTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 22:19:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52045 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab0FHCTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 22:19:19 -0400
Message-ID: <4C0DA7D7.5@cn.fujitsu.com>
Date: Tue, 08 Jun 2010 10:15:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH] KVM: VMX: fix rcu usage warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:

[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
include/linux/kvm_host.h:258 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
1 lock held by qemu-system-x86/3796:
 #0:  (&vcpu->mutex){+.+.+.}, at: [<ffffffffa0217fd8>] vcpu_load+0x1a/0x66 [kvm]

stack backtrace:
Pid: 3796, comm: qemu-system-x86 Not tainted 2.6.34 #25
Call Trace:
 [<ffffffff81070ed1>] lockdep_rcu_dereference+0x9d/0xa5
 [<ffffffffa0214fdf>] gfn_to_memslot_unaliased+0x65/0xa0 [kvm]
 [<ffffffffa0216139>] gfn_to_hva+0x22/0x4c [kvm]
 [<ffffffffa0216217>] kvm_write_guest_page+0x2a/0x7f [kvm]
 [<ffffffffa0216286>] kvm_clear_guest_page+0x1a/0x1c [kvm]
 [<ffffffffa0278239>] init_rmode+0x3b/0x180 [kvm_intel]
 [<ffffffffa02786ce>] vmx_set_cr0+0x350/0x4d3 [kvm_intel]
 [<ffffffffa02274ff>] kvm_arch_vcpu_ioctl_set_sregs+0x122/0x31a [kvm]
 [<ffffffffa021859c>] kvm_vcpu_ioctl+0x578/0xa3d [kvm]
 [<ffffffff8106624c>] ? cpu_clock+0x2d/0x40
 [<ffffffff810f7d86>] ? fget_light+0x244/0x28e
 [<ffffffff810709b9>] ? trace_hardirqs_off_caller+0x1f/0x10e
 [<ffffffff8110501b>] vfs_ioctl+0x32/0xa6
 [<ffffffff81105597>] do_vfs_ioctl+0x47f/0x4b8
 [<ffffffff813ae654>] ? sub_preempt_count+0xa3/0xb7
 [<ffffffff810f7da8>] ? fget_light+0x266/0x28e
 [<ffffffff810f7c53>] ? fget_light+0x111/0x28e
 [<ffffffff81105617>] sys_ioctl+0x47/0x6a
 [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fdb18cf..ad8a38e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2643,21 +2643,27 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 
 static int init_rmode(struct kvm *kvm)
 {
+	int idx, ret = 0;
+
+	idx = srcu_read_lock(&kvm->srcu);
 	if (!init_rmode_tss(kvm))
-		return 0;
+		goto exit;
 	if (!init_rmode_identity_map(kvm))
-		return 0;
-	return 1;
+		goto exit;
+
+	ret = 1;
+exit:
+	srcu_read_unlock(&kvm->srcu, idx);
+	return ret;
 }
 
 static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u64 msr;
-	int ret, idx;
+	int ret;
 
 	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP));
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (!init_rmode(vmx->vcpu.kvm)) {
 		ret = -ENOMEM;
 		goto out;
@@ -2767,7 +2773,6 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->emulation_required = 0;
 
 out:
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	return ret;
 }
 
-- 
1.6.1.2

