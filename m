Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab0DVUGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:06:54 -0400
Received: from kroah.org ([198.145.64.141]:60144 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758076Ab0DVUCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:02:14 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:19 2010
Message-Id: <20100422195419.039231393@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kiszka <jan.kiszka@siemens.com>, Avi Kivity <avi@redhat.com>
Subject: [137/139] KVM: x86: Fix TSS size check for 16-bit tasks
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

(Cherry-picked from commit e8861cfe2c75bdce36655b64d7ce02c2b31b604d)

A 16-bit TSS is only 44 bytes long. So make sure to test for the correct
size on task switch.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4576,6 +4576,7 @@ int kvm_task_switch(struct kvm_vcpu *vcp
 	int ret = 0;
 	u32 old_tss_base = get_segment_base(vcpu, VCPU_SREG_TR);
 	u16 old_tss_sel = get_segment_selector(vcpu, VCPU_SREG_TR);
+	u32 desc_limit;
 
 	old_tss_base = vcpu->arch.mmu.gva_to_gpa(vcpu, old_tss_base);
 
@@ -4598,7 +4599,10 @@ int kvm_task_switch(struct kvm_vcpu *vcp
 		}
 	}
 
-	if (!nseg_desc.p || get_desc_limit(&nseg_desc) < 0x67) {
+	desc_limit = get_desc_limit(&nseg_desc);
+	if (!nseg_desc.p ||
+	    ((desc_limit < 0x67 && (nseg_desc.type & 8)) ||
+	     desc_limit < 0x2b)) {
 		kvm_queue_exception_e(vcpu, TS_VECTOR, tss_selector & 0xfffc);
 		return 1;
 	}


