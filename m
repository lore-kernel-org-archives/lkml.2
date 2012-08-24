Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab2HXWPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:15:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40012 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2HXWP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:15:28 -0400
Date: Fri, 24 Aug 2012 15:15:14 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-98700fa647b3572f7fa55485570ab9fc53b91d23@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        avi@redhat.com
In-Reply-To: <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, kvm: use kernel_fpu_begin/end() in kvm_load/
 put_guest_fpu()
Git-Commit-ID: 98700fa647b3572f7fa55485570ab9fc53b91d23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 24 Aug 2012 15:15:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98700fa647b3572f7fa55485570ab9fc53b91d23
Gitweb:     http://git.kernel.org/tip/98700fa647b3572f7fa55485570ab9fc53b91d23
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 24 Aug 2012 14:12:59 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 24 Aug 2012 14:26:49 -0700

x86, kvm: use kernel_fpu_begin/end() in kvm_load/put_guest_fpu()

kvm's guest fpu save/restore should be wrapped around
kernel_fpu_begin/end(). This will avoid for example taking a DNA
in kvm_load_guest_fpu() when it tries to load the fpu immediately
after doing unlazy_fpu() on the host side.

More importantly this will prevent the host process fpu from being
corrupted.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index be6d549..b92cc39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5954,7 +5954,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
-	unlazy_fpu(current);
+	kernel_fpu_begin();
 	fpu_restore_checking(&vcpu->arch.guest_fpu);
 	trace_kvm_fpu(1);
 }
@@ -5968,6 +5968,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	vcpu->guest_fpu_loaded = 0;
 	fpu_save_init(&vcpu->arch.guest_fpu);
+	kernel_fpu_end();
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);
