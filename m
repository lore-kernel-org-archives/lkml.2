Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab0C3XJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:09:27 -0400
Received: from kroah.org ([198.145.64.141]:48537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab0C3XJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:11 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:59 2010
Message-Id: <20100330224958.628538485@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [28/45] KVM: VMX: Check cpl before emulating debug register access
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit 0a79b009525b160081d75cef5dbf45817956acf2 upstream.

Debug registers may only be accessed from cpl 0.  Unfortunately, vmx will
code to emulate the instruction even though it was issued from guest
userspace, possibly leading to an unexpected trap later.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/kvm/vmx.c         |    3 +++
 arch/x86/kvm/x86.c         |   13 +++++++++++++
 include/asm-x86/kvm_host.h |    1 +
 3 files changed, 17 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2464,6 +2464,9 @@ static int handle_dr(struct kvm_vcpu *vc
 	unsigned long val;
 	int dr, reg;
 
+	if (!kvm_require_cpl(vcpu, 0))
+		return 1;
+
 	/*
 	 * FIXME: this code assumes the host is debugging the guest.
 	 *        need to deal with guest debugging itself too.
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -198,6 +198,19 @@ static void __queue_exception(struct kvm
 }
 
 /*
+ * Checks if cpl <= required_cpl; if true, return true.  Otherwise queue
+ * a #GP and return false.
+ */
+bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
+{
+	if (kvm_x86_ops->get_cpl(vcpu) <= required_cpl)
+		return true;
+	kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
+	return false;
+}
+EXPORT_SYMBOL_GPL(kvm_require_cpl);
+
+/*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -537,6 +537,7 @@ void kvm_queue_exception(struct kvm_vcpu
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
 			   u32 error_code);
+bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 


