Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab0KSVvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:51:43 -0500
Received: from kroah.org ([198.145.64.141]:51784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241Ab0KSVpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:30 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:11 2010
Message-Id: <20101119214410.989076838@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:42:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [19/45] KVM: SVM: Adjust tsc_offset only if tsc_unstable
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 953899b659adce62cbe83d6a7527550ab8797c48 upstream.

The tsc_offset adjustment in svm_vcpu_load is executed
unconditionally even if Linux considers the host tsc as
stable. This causes a Linux guest detecting an unstable tsc
in any case.
This patch removes the tsc_offset adjustment if the host tsc
is stable. The guest will now get the benefit of a stable
tsc too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -795,17 +795,18 @@ static void svm_vcpu_load(struct kvm_vcp
 	int i;
 
 	if (unlikely(cpu != vcpu->cpu)) {
-		u64 tsc_this, delta;
+		u64 delta;
 
-		/*
-		 * Make sure that the guest sees a monotonically
-		 * increasing TSC.
-		 */
-		rdtscll(tsc_this);
-		delta = vcpu->arch.host_tsc - tsc_this;
-		svm->vmcb->control.tsc_offset += delta;
-		if (is_nested(svm))
-			svm->nested.hsave->control.tsc_offset += delta;
+		if (check_tsc_unstable()) {
+			/*
+			 * Make sure that the guest sees a monotonically
+			 * increasing TSC.
+			 */
+			delta = vcpu->arch.host_tsc - native_read_tsc();
+			svm->vmcb->control.tsc_offset += delta;
+			if (is_nested(svm))
+				svm->nested.hsave->control.tsc_offset += delta;
+		}
 		vcpu->cpu = cpu;
 		kvm_migrate_timers(vcpu);
 		svm->asid_generation = 0;


