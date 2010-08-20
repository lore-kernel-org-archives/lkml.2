Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab0HTIPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:15:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0HTIIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:25 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
Date: Thu, 19 Aug 2010 22:07:24 -1000
Message-Id: <1282291669-25709-11-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
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
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7fc4a55..52b6c21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1866,7 +1866,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
-	if (unlikely(vcpu->cpu != cpu)) {
+	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
 		/* Make sure TSC doesn't go backwards */
 		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
 				native_read_tsc() - vcpu->arch.last_host_tsc;
-- 
1.7.1

