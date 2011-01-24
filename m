Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1AXSIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:08:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab1AXSIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:08:13 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 12/16] KVM-HV: KVM Steal time implementation
Date: Mon, 24 Jan 2011 13:06:33 -0500
Message-Id: <1295892397-11354-13-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement steal time, we need the hypervisor to pass the guest information
about how much time was spent running other processes outside the VM.
This is per-vcpu, and using the kvmclock structure for that is an abuse
we decided not to make.

This patch contains the hypervisor part for it. I am keeping it separate from
the headers to facilitate backports to people who wants to backport the kernel
part but not the hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 81b2f34..f129ea1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1564,6 +1564,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			goto rma_out;
 		}
 
+		if (area_desc.type == KVM_AREA_STEAL_TIME) {
+			vcpu->arch.stime = area_desc.base;
+			goto rma_out;
+		}
+
 		if (vcpu->kvm->register_mem_area_uspace) {
 			vcpu->run->exit_reason = KVM_EXIT_X86_MSR_OP;
 			vcpu->run->msr.msr_data = data;
-- 
1.7.2.3

