Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2EBKJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:09:32 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:57713 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2EBKJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:09:28 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, linux-doc@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 May 2012 15:39:11 +0530
Message-Id: <20120502100911.13206.63174.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com>
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V8 14/17] kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration
x-cbid: 12050210-2000-0000-0000-0000075188D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

During migration, any vcpu that got kicked but did not become runnable
 (still in halted state) should be runnable after migration.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f188cdc..5b09b67 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5691,7 +5691,12 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	mp_state->mp_state = vcpu->arch.mp_state;
+	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
+					vcpu->arch.pv.pv_unhalted)
+		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
+	else
+		mp_state->mp_state = vcpu->arch.mp_state;
+
 	return 0;
 }
 

