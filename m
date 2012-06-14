Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2FNNxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:53:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277Ab2FNNxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:53:08 -0400
Date: Thu, 14 Jun 2012 16:53:33 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv7 6/8] kvm: only sync when attention bits set
Message-ID: <c241f455b4d02acfc257f62d53aeec7b7b778416.1339681762.git.mst@redhat.com>
References: <cover.1339681762.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1339681762.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit eb0dc6d0368072236dcd086d7fdc17fd3c4574d4 introduced apic
attention bitmask but kvm still syncs lapic unconditionally.
As that commit suggested and in anticipation of adding more attention
bits, only sync lapic if(apic_attention).

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index be6d549..4e582c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5388,7 +5388,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (unlikely(vcpu->arch.tsc_always_catchup))
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
-	kvm_lapic_sync_from_vapic(vcpu);
+	if (vcpu->arch.apic_attention)
+		kvm_lapic_sync_from_vapic(vcpu);
 
 	r = kvm_x86_ops->handle_exit(vcpu);
 out:
-- 
MST

