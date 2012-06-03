Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2FCH3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 03:29:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131Ab2FCH2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 03:28:39 -0400
Date: Sun, 3 Jun 2012 10:28:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv6 7/8] kvm: rearrange injection cancelling code
Message-ID: <ccea8fbf496a240b66d4b5bb2ccf75b6f7411bb4.1338474301.git.mst@redhat.com>
References: <cover.1338474301.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1338474301.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each time we need to cancel injection we invoke same code
(cancel_injection callback).  Move it towards the end of function using
the familiar goto on error pattern.

Will make it easier to do more cleanups for PV EOI.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/x86.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2f70861..67824f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5296,8 +5296,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	r = kvm_mmu_reload(vcpu);
 	if (unlikely(r)) {
-		kvm_x86_ops->cancel_injection(vcpu);
-		goto out;
+		goto cancel_injection;
 	}
 
 	preempt_disable();
@@ -5322,9 +5321,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		smp_wmb();
 		local_irq_enable();
 		preempt_enable();
-		kvm_x86_ops->cancel_injection(vcpu);
 		r = 1;
-		goto out;
+		goto cancel_injection;
 	}
 
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
@@ -5392,6 +5390,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_lapic_sync_from_vapic(vcpu);
 
 	r = kvm_x86_ops->handle_exit(vcpu);
+	return r;
+
+cancel_injection:
+	kvm_x86_ops->cancel_injection(vcpu);
 out:
 	return r;
 }
-- 
MST

