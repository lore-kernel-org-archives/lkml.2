Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2F1GIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:08:32 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37429 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab2F1GIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:08:17 -0400
X-AuditID: 0ac90646-9a0c6ba000003485-9b-4febf4ce1369
X-AuditID: 0ac90646-9a0c6ba000003485-9b-4febf4ce1369
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 09/18] KVM: Go back to online CPU on VM exit by external
 interrupt
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:08:06 +0900
Message-ID: <20120628060806.19298.3623.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the slave CPU receives an interrupt in running a guest, current
implementation must once go back to onilne CPUs to handle the interupt.

This behavior will be replaced by later patch, which introduces direct
interrupt handling mechanism by the guest.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx.c              |    1 +
 arch/x86/kvm/x86.c              |    6 ++++++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6ae43ef..f8fd1a1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -350,6 +350,7 @@ struct kvm_vcpu_arch {
 	int sipi_vector;
 	u64 ia32_misc_enable_msr;
 	bool tpr_access_reporting;
+	bool interrupted;
 
 #ifdef CONFIG_SLAVE_CPU
 	/* slave cpu dedicated to this vcpu */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 42655a5..e24392c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4328,6 +4328,7 @@ static int handle_exception(struct kvm_vcpu *vcpu)
 
 static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.interrupted = true;
 	++vcpu->stat.irq_exits;
 	return 1;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4216d55..1558ec2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5553,6 +5553,12 @@ static void __vcpu_enter_guest_slave(void *_arg)
 			break;
 
 		/* determine if slave cpu can handle the exit alone */
+		if (vcpu->arch.interrupted) {
+			vcpu->arch.interrupted = false;
+			arg->ret = LOOP_ONLINE;
+			break;
+		}
+
 		r = vcpu_post_run(vcpu, arg->task, &arg->apf_pending);
 
 		if (arg->ret == LOOP_SLAVE &&


