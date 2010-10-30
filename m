Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab0J3OLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:11:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65375 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0J3OLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:11:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rQtnKWAZ49cK8lCQImkJ/ITCoz9t19NdCNTF0Yq3PmpGqvX3Fummwn3zcXg6chP9H+
         1yIDhqaKyEdpmyUmtrg4TNpW1PGGXy3Fan33WA8+mLjFrLtQMK0Oqi7vI0heOCoR3mBW
         wiDt5GA192f/vfenkAZAjAGlshYa3eO3b1NCE=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: kvm: fix information leak to userland
Date: Sat, 30 Oct 2010 18:11:11 +0400
Message-Id: <1288447871-7715-1-git-send-email-segooon@gmail.com>
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

 As it is not compilable, I've missed and typed wrong var name in v1, sorry.

 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0818f6..261f3d0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2896,6 +2896,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_DEBUGREGS: {
 		struct kvm_debugregs dbgregs;
 
+		memset(&dbgregs, 0, sizeof(dbgregs));
 		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
 
 		r = -EFAULT;
@@ -3481,11 +3482,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		struct kvm_clock_data user_ns;
 		u64 now_ns;
 
+		memset(&user_ns, 0, sizeof(user_ns));
 		local_irq_disable();
 		now_ns = get_kernel_ns();
 		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
 		local_irq_enable();
-		user_ns.flags = 0;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
-- 
1.7.0.4

