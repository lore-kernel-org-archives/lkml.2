Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1AXSIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:08:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab1AXSIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:08:02 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 06/16] KVM-HDR: Implement wallclock over KVM - KVM Virtual Memory
Date: Mon, 24 Jan 2011 13:06:27 -0500
Message-Id: <1295892397-11354-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a proof of concept to KVM - Kernel Virtual Memory, this patch
implements wallclock grabbing on top of it. At first, it may seem
as a waste of work to just redo it, since it is working well. But over the
time, other MSRs were added - think ASYNC_PF - and more will probably come.
After this patch, we won't need to ever add another virtual MSR to KVM.

If the hypervisor fails to register the memory area, we switch back to legacy
behavior on things that were already present - like kvm clock.

This patch contains the hypervisor implementation for it. I am keeping it
separate from the headers to facilitate backports to people who wants to backport
the kernel part but not the hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4ee9c87..a232a36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1540,16 +1540,26 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 	case MSR_KVM_REGISTER_MEM_AREA: {
 		struct kvm_memory_area area_desc;
+		u64 wall_data;
 
 		kvm_read_guest(vcpu->kvm, data, &area_desc, sizeof(area_desc));
 		area_desc.result = 0xF;
 
+		if (area_desc.type == KVM_AREA_WALLCLOCK) {
+			kvm_read_guest(vcpu->kvm, area_desc.base,
+				       &wall_data, area_desc.size);
+			vcpu->kvm->arch.wall_clock = wall_data;
+			kvm_write_wall_clock(vcpu->kvm, wall_data);
+			goto rma_out;
+		}
+
 		if (vcpu->kvm->register_mem_area_uspace) {
 			vcpu->run->exit_reason = KVM_EXIT_X86_MSR_OP;
 			vcpu->run->msr.msr_data = data;
 			return 1;
 		}
 rma_out:
+		area_desc.result = 0;
 		kvm_write_guest(vcpu->kvm, data, &area_desc, sizeof(area_desc));
 		break;
 	}
-- 
1.7.2.3

