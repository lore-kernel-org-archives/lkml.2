Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1AXSIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:08:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab1AXSH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:07:58 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 02/16] KVM-HV: KVM - KVM Virtual Memory hypervisor implementation
Date: Mon, 24 Jan 2011 13:06:23 -0500
Message-Id: <1295892397-11354-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM, which stands for KVM Virtual Memory (I wanted to call it KVM Virtual Mojito),
is a piece of shared memory that is visible to both the hypervisor and the guest
kernel - but not the guest userspace.

The basic idea is that the guest can tell the hypervisor about a specific
piece of memory, and what it expects to find in there. This is a generic
abstraction, that goes to userspace (qemu) if KVM (the hypervisor) can't
handle a specific request, thus giving us flexibility in some features
in the future.

KVM (The hypervisor) can change the contents of this piece of memory at
will. This works well with paravirtual information, and hopefully
normal guest memory - like last update time for the watchdog, for
instance.

This is basic KVM registration implementation, that just returns an error
code for every operation. I am keeping it separate from the headers
to facilitate backports to people who wants to backport
the kernel part but not the hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bcc0efc..6206fd3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1538,6 +1538,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
 		break;
+	case MSR_KVM_REGISTER_MEM_AREA: {
+		struct kvm_memory_area area_desc;
+
+		kvm_read_guest(vcpu->kvm, data, &area_desc, sizeof(area_desc));
+		area_desc.result = 0xF;
+		kvm_write_guest(vcpu->kvm, data, &area_desc, sizeof(area_desc));
+		break;
+	}
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
@@ -2391,6 +2399,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->eax = (1 << KVM_FEATURE_CLOCKSOURCE) |
 			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
+			     (1 << KVM_FEATURE_MEMORY_AREA) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
 		entry->ebx = 0;
 		entry->ecx = 0;
-- 
1.7.2.3

