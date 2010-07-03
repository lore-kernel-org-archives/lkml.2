Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab0GCIGp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:06:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55980 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab0GCIGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:06:33 -0400
Message-ID: <4C2EEEA2.5090305@cn.fujitsu.com>
Date: Sat, 03 Jul 2010 16:02:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH] KVM: VMX: fix tlb flush with invalid root
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 341d9b535b6c simplify reload logic while entry guest mode, it
can avoid unnecessary sync-root if KVM_REQ_MMU_RELOAD and
KVM_REQ_MMU_SYNC both set.

But, it cause a issue that when we handle 'KVM_REQ_TLB_FLUSH', the
root is invalid, it is triggered during my test:

Kernel BUG at ffffffffa00212b8 [verbose debug info unavailable]
......

 [<ffffffff810f5caf>] ? fget_light+0x111/0x28e
 [<ffffffff81103963>] sys_ioctl+0x47/0x6a
 [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b
Code: f0 eb 21 f7 c2 00 00 00 04 74 22 48 8d 45 f0 48 c7 45 f0 00 00 00 00 48 c7 45 f8 00 00 00 00 b9 02 00 00 00 66 0f 38 80 08 77 02 <0f> 0b c9 c3 55 48 89 e5 0f 1f 44 00 00 ba 00 68 00 00 48 8b 8f 
RIP  [<ffffffffa00212b8>] vmx_flush_tlb+0xdf/0xe3 [kvm_intel]
 RSP <ffff8800be269ca8>

Fixed by directly return if the root is not ready.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/mmu.c              |    2 --
 arch/x86/kvm/vmx.c              |    5 ++++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2bda624..8f522ec 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -40,6 +40,8 @@
 				  0xFFFFFF0000000000ULL)
 
 #define INVALID_PAGE (~(hpa_t)0)
+#define VALID_PAGE(x) ((x) != INVALID_PAGE)
+
 #define UNMAPPED_GVA (~(gpa_t)0)
 
 /* KVM Hugepage definitions for x86 */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a0c5c31..399ddb0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -92,8 +92,6 @@ module_param(oos_shadow, bool, 0644);
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
 
-#define VALID_PAGE(x) ((x) != INVALID_PAGE)
-
 #define PT64_LEVEL_BITS 9
 
 #define PT64_LEVEL_SHIFT(level) \
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 806ab12..ebaaeaf 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1831,8 +1831,11 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	vpid_sync_context(to_vmx(vcpu));
-	if (enable_ept)
+	if (enable_ept) {
+		if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+			return;
 		ept_sync_context(construct_eptp(vcpu->arch.mmu.root_hpa));
+	}
 }
 
 static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
-- 
1.6.1.2

