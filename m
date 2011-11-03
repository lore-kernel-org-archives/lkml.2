Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab1KCMeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933250Ab1KCMeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:34:18 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCHv2 0/9] KVM in-guest performance monitoring
Date: Thu,  3 Nov 2011 14:33:29 +0200
Message-Id: <1320323618-10375-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset exposes an emulated version 2 architectural performance
monitoring unit to KVM guests.  The PMU is emulated using perf_events,
so the host kernel can multiplex host-wide, host-user, and the
guest on available resources.

The patches are against next branch on kvm.git.

If you want to try running perf in a guest you need to apply the patch
below to qemu-kvm and use -cpu host on qemu command line. But DO NOT
TRY those patches without applying [1][2] to the host kernel first.
Don't tell me I didn't warn you!

[1] https://lkml.org/lkml/2011/10/18/390
[2] https://lkml.org/lkml/2011/10/23/163

Changelog:
 v1->v2
  - put index into struct kvm_pmc instead of calculating it
  - use locked version of bitops
  - inject pmi from irq work if vcpu was not in a guest mode during NMI
  - providing stub for perf_get_x86_pmu_capability() for !PERF_EVENTS

Avi Kivity (6):
  KVM: Expose kvm_lapic_local_deliver()
  KVM: Add generic RDPMC support
  KVM: SVM: Intercept RDPMC
  KVM: VMX: Intercept RDPMC
  KVM: x86 emulator: fix RDPMC privilege check
  KVM: x86 emulator: implement RDPMC (0F 33)

Gleb Natapov (3):
  KVM: Expose a version 2 architectural PMU to a guests
  perf: expose perf capability to other modules.
  KVM: Expose the architectural performance monitoring CPUID leaf

 arch/x86/include/asm/kvm_emulate.h     |    1 +
 arch/x86/include/asm/kvm_host.h        |   49 +++
 arch/x86/include/asm/perf_event.h      |   15 +
 arch/x86/kernel/cpu/perf_event.c       |   11 +
 arch/x86/kernel/cpu/perf_event.h       |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c |    3 +
 arch/x86/kvm/Kconfig                   |    1 +
 arch/x86/kvm/Makefile                  |    2 +-
 arch/x86/kvm/emulate.c                 |   13 +-
 arch/x86/kvm/lapic.c                   |    2 +-
 arch/x86/kvm/lapic.h                   |    1 +
 arch/x86/kvm/pmu.c                     |  529 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm.c                     |   15 +
 arch/x86/kvm/vmx.c                     |   15 +-
 arch/x86/kvm/x86.c                     |   69 ++++-
 include/linux/kvm_host.h               |    2 +
 16 files changed, 716 insertions(+), 14 deletions(-)
 create mode 100644 arch/x86/kvm/pmu.c


diff --git a/roms/seabios b/roms/seabios
index 8e30147..e0f87ce 160000
--- a/roms/seabios
+++ b/roms/seabios
@@ -1 +1 @@
-Subproject commit 8e301472e324b6d6496d8b4ffc66863e99d7a505
+Subproject commit e0f87ce6610a0f341ff79c2c40ddc29f26932353-dirty
diff --git a/roms/vgabios b/roms/vgabios
index ca056d8..19ea12c 160000
--- a/roms/vgabios
+++ b/roms/vgabios
@@ -1 +1 @@
-Subproject commit ca056d8e77a534f4f90548bc8cee166a378c1454
+Subproject commit 19ea12c230ded95928ecaef0db47a82231c2e485-dirty
diff --git a/target-i386/cpuid.c b/target-i386/cpuid.c
index f179999..ff2a0ca 100644
--- a/target-i386/cpuid.c
+++ b/target-i386/cpuid.c
@@ -1178,11 +1178,20 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *edx = 0;
         break;
     case 0xA:
-        /* Architectural Performance Monitoring Leaf */
-        *eax = 0;
-        *ebx = 0;
-        *ecx = 0;
-        *edx = 0;
+	if (kvm_enabled()) {
+            KVMState *s = env->kvm_state;
+
+            *eax = kvm_arch_get_supported_cpuid(s, 0xA, count, R_EAX);
+            *ebx = kvm_arch_get_supported_cpuid(s, 0xA, count, R_EBX);
+            *ecx = kvm_arch_get_supported_cpuid(s, 0xA, count, R_ECX);
+            *edx = kvm_arch_get_supported_cpuid(s, 0xA, count, R_EDX);
+	} else {
+		/* Architectural Performance Monitoring Leaf */
+		*eax = 0; //0x07280402;
+		*ebx = 0;
+		*ecx = 0;
+		*edx = 0; //0x00000503;
+	}
         break;
     case 0xD:
         /* Processor Extended State */
-- 
1.7.5.3

