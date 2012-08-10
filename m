Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab2HJKef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 06:34:35 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41655 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab2HJKee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 06:34:34 -0400
From: Florian Westphal <fw@strlen.de>
To: kvm@vger.kernel.org
Cc: avi@redhat.com, linux-kernel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH] kvm: disable stealtime via reboot notifier to avoid mem corruption
Date: Fri, 10 Aug 2012 12:36:22 +0200
Message-Id: <1344594982-8516-1-git-send-email-fw@strlen.de>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

else, we get memory corruption on reboot; found when tracking down
initramfs unpack error on initial reboot (with qemu-kvm -smp 2,
no problem with single-core).

problem with doing it via kvm_shutdown() is that this file
depends on CONFIG_KVM_CLOCK, also its not enough to call it for one
cpu only.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 not subscribed, please CC on replies.
 Also, I don't know much about kvm or kexec, so its possible
 that i missed something.

 In any case, this seems to fix the initramfs corruption for me.
 patch is against virt/kvm/kvm.git.

 arch/x86/kernel/kvm.c      |    1 +
 arch/x86/kernel/kvmclock.c |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index c1d61ee..1596cc8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -354,6 +354,7 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
 	kvm_pv_disable_apf();
+	kvm_disable_steal_time();
 }
 
 static int kvm_pv_reboot_notify(struct notifier_block *nb,
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index f1b42b3..5a2fa7d 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -191,7 +191,6 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
 static void kvm_shutdown(void)
 {
 	native_write_msr(msr_kvm_system_time, 0, 0);
-	kvm_disable_steal_time();
 	native_machine_shutdown();
 }
 
-- 
1.7.8.6

