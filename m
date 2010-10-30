Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0J3JEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 05:04:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42409 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0J3JEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 05:04:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lmdnKxAuLpoMK5cLWNDJtqjumLTv2t0BCUTXa4C8ugHk+SG4Ckhl2O+BsPA3vPisrM
         oWL8D6B7SfRxKQ/Tk2haqmB7Sqbg03cY6NF/GT+XZWoHaoIwqP+NGFwrs7/ox5Fvp5sy
         DfhbFff2Dkfyg8EyFGzSf1qcUpvZe005Lg4v4=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: kvm: fix information leak to userland
Date: Sat, 30 Oct 2010 13:04:29 +0400
Message-Id: <1288429469-21807-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure kvm_ppc_pvinfo is copied to userland with pad field
unitialized.  Structure kvm_clock_data is copied to userland with
flags and pad fields unitialized.  It leads to leaking of contents
of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver, so it is not tested at all.

 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0818f6..261f3d0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2896,6 +2896,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_DEBUGREGS: {
 		struct kvm_debugregs dbgregs;
 
+		memset(&gdgr, 0, sizeof(gdgr));
 		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
 
 		r = -EFAULT;
@@ -3481,11 +3482,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		struct kvm_clock_data user_ns;
 		u64 now_ns;
 
+		memset(&user_ns, 0, sizefo(user_ns));
 		local_irq_disable();
 		now_ns = get_kernel_ns();
 		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
 		local_irq_enable();
-		user_ns.flags = 0;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
-- 
1.7.0.4

