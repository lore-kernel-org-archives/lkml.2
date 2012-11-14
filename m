Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2KNBj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:39:57 -0500
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:53243 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab2KNBjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:39:54 -0500
X-AuditID: b753bd60-97251ba000002f78-00-50a2f5e453b1
X-AuditID: b753bd60-97251ba000002f78-00-50a2f5e453b1
Subject: [RFC PATCH 1/2] kvm/vmx: Print TSC_OFFSET information when TSC
 offset value is written to VMCS
To: linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>, David Sharp <dhsharp@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Nov 2012 10:36:53 +0900
Message-ID: <20121114013643.5338.55452.stgit@yunodevel>
In-Reply-To: <20121114013611.5338.15086.stgit@yunodevel>
References: <20121114013611.5338.15086.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print TSC_OFFSET information when TSC offset value is written to VMCS for
measuring actual TSC of a guest.

TSC value on a guest is always the host TSC plus the guest's "TSC offset".
TSC offset is stored in the VMCS in vmx_write_tsc_offset() or
vmx_adjust_tsc_offset(). KVM executes the former function when a guest boots.
The latter function is executed when kvm clock is updated. On the other hand,
the host can read the TSC offset values from VMCS. So, if the host outputs the
TSC offset values, we can calculate an actual TSC value for each TSC timestamp
recorded trace data of the guest.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 arch/x86/kvm/vmx.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ad6b1dd..8edfe3c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1887,6 +1887,9 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 			 vmcs12->tsc_offset : 0));
 	} else {
 		vmcs_write64(TSC_OFFSET, offset);
+		pr_info("kvm: (%d) write TSC offset %llu, now clock %llu\n",
+			current->pid, vmcs_read64(TSC_OFFSET),
+			native_read_tsc());
 	}
 }
 
@@ -1894,6 +1897,8 @@ static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment, bool ho
 {
 	u64 offset = vmcs_read64(TSC_OFFSET);
 	vmcs_write64(TSC_OFFSET, offset + adjustment);
+	pr_info("kvm: (%d) adjust TSC offset %llu, now clock %llu\n",
+		current->pid, vmcs_read64(TSC_OFFSET), native_read_tsc());
 	if (is_guest_mode(vcpu)) {
 		/* Even when running L2, the adjustment needs to apply to L1 */
 		to_vmx(vcpu)->nested.vmcs01_tsc_offset += adjustment;


