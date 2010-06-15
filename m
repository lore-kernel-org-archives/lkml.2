Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0FOHeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab0FOHed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:33 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 04/17] Fix deep C-state TSC desynchronization
Date: Mon, 14 Jun 2010 21:34:06 -1000
Message-Id: <1276587259-32319-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CPUs with unstable TSCs enter deep C-state, TSC may stop
running.  This causes us to require resynchronization.  Since
we can't tell when this may potentially happen, we assume the
worst by forcing re-compensation for it at every point the VCPU
task is descheduled.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c8289d0..618c435 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1822,7 +1822,18 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
+
 	vcpu->arch.last_host_tsc = native_read_tsc();
+
+	/*
+	 * When potentially leaving a CPU with unstable TSCs, we risk
+	 * that the CPU enters deep C-state.  If it does, the TSC may
+	 * go out of sync but we will not recalibrate because the test
+	 * vcpu->cpu != cpu can not detect this condition.  So set
+	 * vcpu->cpu = -1 to force the recalibration above.
+	 */
+	if (check_tsc_unstable())
+		vcpu->cpu = -1;
 }
 
 static int is_efer_nx(void)
-- 
1.7.1

