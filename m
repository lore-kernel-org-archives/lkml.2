Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0HMHTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:19:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0HMHTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:19:37 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Brian Gerst <brgerst@gmail.com>, Avi Kivity <avi@redhat.com>,
        Robert Richter <robert.richter@amd.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH] kvm: fix poison overwritten caused by using wrong xstate size
Date: Fri, 13 Aug 2010 15:19:11 +0800
Message-Id: <1281683951-19814-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <AANLkTikx35Sp0GR4c_REYGcZV4bMgS+T-1cugen45d58@mail.gmail.com>
References: <AANLkTikx35Sp0GR4c_REYGcZV4bMgS+T-1cugen45d58@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fpu.state is allocated from task_xstate_cachep, the size of task_xstate_cachep
is xstate_size. xstate_size is set from cpuid instruction, which is often
smaller than sizeof(struct xsave_struct). kvm is using sizeof(struct xsave_struct)
to fill in/out fpu.state.xsave, as what we allocated for fpu.state is
xstate_size, kernel will write out of memory and caused poison/redzone/padding
overwritten warnings.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Sheng Yang <sheng@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/kernel/i387.c |    1 +
 arch/x86/kvm/x86.c     |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 1f11f5c..a46cb35 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -40,6 +40,7 @@
 
 static unsigned int		mxcsr_feature_mask __read_mostly = 0xffffffffu;
 unsigned int xstate_size;
+EXPORT_SYMBOL_GPL(xstate_size);
 unsigned int sig_xstate_ia32_size = sizeof(struct _fpstate_ia32);
 static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 25f1907..3a09c62 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2387,7 +2387,7 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 	if (cpu_has_xsave)
 		memcpy(guest_xsave->region,
 			&vcpu->arch.guest_fpu.state->xsave,
-			sizeof(struct xsave_struct));
+			xstate_size);
 	else {
 		memcpy(guest_xsave->region,
 			&vcpu->arch.guest_fpu.state->fxsave,
@@ -2405,7 +2405,7 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 
 	if (cpu_has_xsave)
 		memcpy(&vcpu->arch.guest_fpu.state->xsave,
-			guest_xsave->region, sizeof(struct xsave_struct));
+			guest_xsave->region, xstate_size);
 	else {
 		if (xstate_bv & ~XSTATE_FPSSE)
 			return -EINVAL;
-- 
1.7.2.1

