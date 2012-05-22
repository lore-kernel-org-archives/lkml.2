Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab2EVOFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:05:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126Ab2EVOFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:05:50 -0400
Date: Tue, 22 May 2012 17:05:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv5 4/5] kvm: only sync when attention bits set
Message-ID: <2118cb532b2029eb2f2c44cdca00e8ce8198e29b.1337695416.git.mst@redhat.com>
References: <cover.1337695416.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1337695416.git.mst@redhat.com>
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
 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 185a2b8..3e57566 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5370,7 +5370,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (unlikely(vcpu->arch.tsc_always_catchup))
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
-	kvm_lapic_sync_from_vapic(vcpu);
+	if (unlikely(vcpu->arch.apic_attention))
+		kvm_lapic_sync_from_vapic(vcpu);
 
 	r = kvm_x86_ops->handle_exit(vcpu);
 out:
-- 
MST

