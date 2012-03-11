Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2CKP6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 11:58:00 -0400
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:57818 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752676Ab2CKP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 11:57:57 -0400
Subject: [PATCH] KVM: VMX: add tracepoint for vpids
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Sun, 11 Mar 2012 16:57:52 +0100
Message-ID: <1331481472.17316.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Add a new tracepoint for vpid allocation and freeing associated to all vCPUs.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kvm/trace.h |   23 +++++++++++++++++++++++
 arch/x86/kvm/vmx.c   |    5 ++++-
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 911d264..2106a37 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -27,6 +27,29 @@ TRACE_EVENT(kvm_entry,
 );
 
 /*
+ * Tracepoint for VMX vpid management
+ */
+TRACE_EVENT(kvm_vpid,
+	TP_PROTO(int vpid, bool allocate),
+	TP_ARGS(vpid, allocate),
+
+	TP_STRUCT__entry(
+		__field(         int,	vpid		        )
+		__field(         bool,	allocate       	        )
+	),
+
+	TP_fast_assign(
+		__entry->vpid	  = vpid;
+		__entry->allocate = allocate;
+	),
+
+	TP_printk("%s vpid %d",  __entry->allocate ? 
+		  "allocate" : "free", __entry->vpid)
+);
+#define trace_kvm_free_vpid(vpid)	trace_kvm_vpid(vpid, 0)
+#define trace_kvm_alloc_vpid(vpid)	trace_kvm_vpid(vpid, 1)
+
+/*
  * Tracepoint for hypercall.
  */
 TRACE_EVENT(kvm_hypercall,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2c22fc7..5647805 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3571,6 +3571,7 @@ static void allocate_vpid(struct vcpu_vmx *vmx)
 		vmx->vpid = vpid;
 		__set_bit(vpid, vmx_vpid_bitmap);
 	}
+	trace_kvm_alloc_vpid(vpid);
 	spin_unlock(&vmx_vpid_lock);
 }
 
@@ -3579,8 +3580,10 @@ static void free_vpid(struct vcpu_vmx *vmx)
 	if (!enable_vpid)
 		return;
 	spin_lock(&vmx_vpid_lock);
-	if (vmx->vpid != 0)
+	if (vmx->vpid != 0) {
+		trace_kvm_free_vpid(vmx->vpid);
 		__clear_bit(vmx->vpid, vmx_vpid_bitmap);
+	}
 	spin_unlock(&vmx_vpid_lock);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ce5878..8a20512 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6606,3 +6606,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vpid);
-- 
1.7.4.1



