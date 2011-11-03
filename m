Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab1KCMhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:37:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933174Ab1KCMcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:32:21 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCH 0/9] KVM in-guest performance monitoring
Date: Thu,  3 Nov 2011 14:31:29 +0200
Message-Id: <1320323498-10233-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset exposes an emulated version 2 architectural performance
monitoring unit to KVM guests.  The PMU is emulated using perf_events,
so the host kernel can multiplex host-wide, host-user, and the
guest on available resources.

The patches should be applied on top of KVM patches from the patch series
"[PATCH v2 0/9] perf support for x86 guest/host-only bits" [1]

If you want to try running perf in a guest you need to apply the patch
below to qemu-kvm and use -cpu host on qemu command line. But DO NOT
TRY those patches without applying [2][3] to the host kernel first.
Don't tell me I didn't warn you!

[1] https://lkml.org/lkml/2011/10/5/153
[2] https://lkml.org/lkml/2011/10/18/390
[3] https://lkml.org/lkml/2011/10/23/163

Avi Kivity (8):
  KVM: Expose kvm_lapic_local_deliver()
  KVM: Expose a version 2 architectural PMU to a guests
  KVM: Add generic RDPMC support
  KVM: SVM: Intercept RDPMC
  KVM: VMX: Intercept RDPMC
  KVM: Expose the architectural performance monitoring CPUID leaf
  KVM: x86 emulator: fix RDPMC privilege check
  KVM: x86 emulator: implement RDPMC (0F 33)

Gleb Natapov (1):
  perf: expose perf capability to other modules.

 arch/x86/include/asm/kvm_emulate.h     |    1 +
 arch/x86/include/asm/kvm_host.h        |   44 +++
 arch/x86/include/asm/perf_event.h      |   11 +
 arch/x86/kernel/cpu/perf_event.c       |   11 +
 arch/x86/kernel/cpu/perf_event.h       |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c |    3 +
 arch/x86/kvm/Makefile                  |    2 +-
 arch/x86/kvm/emulate.c                 |   13 +-
 arch/x86/kvm/lapic.c                   |    2 +-
 arch/x86/kvm/lapic.h                   |    1 +
 arch/x86/kvm/pmu.c                     |  513 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm.c                     |   15 +
 arch/x86/kvm/vmx.c                     |   15 +-
 arch/x86/kvm/x86.c                     |   65 ++++-
 include/linux/kvm_host.h               |    1 +
 15 files changed, 686 insertions(+), 13 deletions(-)
 create mode 100644 arch/x86/kvm/pmu.c

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

