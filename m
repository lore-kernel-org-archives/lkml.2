Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0GMCLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:11:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab0GMCJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:09:09 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 08/18] Fix deep C-state TSC desynchronization
Date: Mon, 12 Jul 2010 16:08:02 -1000
Message-Id: <1278986892-11733-9-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278986892-11733-1-git-send-email-zamsden@redhat.com>
References: <1278986892-11733-1-git-send-email-zamsden@redhat.com>
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
index 9e71222..0ad6419 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1872,7 +1872,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
-	if (unlikely(vcpu->cpu != cpu)) {
+	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
 		/* Make sure TSC doesn't go backwards */
 		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 : 
 				native_read_tsc() - vcpu->arch.last_host_tsc;
-- 
1.7.1

