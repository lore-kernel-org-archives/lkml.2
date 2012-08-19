Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2HSDAu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:00:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:60723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab2HSC5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415451"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, avi@redhat.com
Subject: [PATCH 37/74] lto, KVM: Don't assume asm statements end up in the same assembler file
Date: Sat, 18 Aug 2012 19:56:33 -0700
Message-Id: <1345345030-22211-38-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The VMX code references a local assembler label between two inline
assembler statements. This assumes they both end up in the same
assembler files. In some experimental builds of gcc this is not
necessarily true, causing linker failures.

Replace the local label reference with a more traditional asmlinkage
extern.

This also eliminates one assembler statement and
generates a bit better code on 64bit: the compiler can
use a RIP relative LEA instead of a movabs, saving
a few bytes.

Cc: avi@redhat.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kvm/vmx.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c00f03d..2fe1de3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3718,6 +3718,8 @@ static void vmx_disable_intercept_for_msr(u32 msr, bool longmode_only)
 	__vmx_disable_intercept_for_msr(vmx_msr_bitmap_longmode, msr);
 }
 
+extern __visible unsigned long kvm_vmx_return;
+
 /*
  * Set up the vmcs's constant host-state fields, i.e., host-state fields that
  * will not change in the lifetime of the guest.
@@ -3753,8 +3755,7 @@ static void vmx_set_constant_host_state(void)
 	native_store_idt(&dt);
 	vmcs_writel(HOST_IDTR_BASE, dt.address);   /* 22.2.4 */
 
-	asm("mov $.Lkvm_vmx_return, %0" : "=r"(tmpl));
-	vmcs_writel(HOST_RIP, tmpl); /* 22.2.5 */
+	vmcs_writel(HOST_RIP, (unsigned long)&kvm_vmx_return); /* 22.2.5 */
 
 	rdmsr(MSR_IA32_SYSENTER_CS, low32, high32);
 	vmcs_write32(HOST_IA32_SYSENTER_CS, low32);
@@ -6305,9 +6306,10 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		/* Enter guest mode */
 		"jne .Llaunched \n\t"
 		__ex(ASM_VMX_VMLAUNCH) "\n\t"
-		"jmp .Lkvm_vmx_return \n\t"
+		"jmp kvm_vmx_return \n\t"
 		".Llaunched: " __ex(ASM_VMX_VMRESUME) "\n\t"
-		".Lkvm_vmx_return: "
+	        ".globl kvm_vmx_return\n"
+		"kvm_vmx_return: "
 		/* Save guest registers, load host registers, keep flags */
 		"mov %0, %c[wordsize](%%"R"sp) \n\t"
 		"pop %0 \n\t"
-- 
1.7.7.6

