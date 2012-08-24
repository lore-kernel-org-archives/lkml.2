Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab2HXVQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:16:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:7595 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab2HXVPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:15:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="scan'208";a="190967387"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 3/6] x86, kvm: use kernel_fpu_begin/end() in kvm_load/put_guest_fpu()
Date: Fri, 24 Aug 2012 14:12:59 -0700
Message-Id: <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm's guest fpu save/restore should be wrapped around
kernel_fpu_begin/end(). This will avoid for example taking a DNA
in kvm_load_guest_fpu() when it tries to load the fpu immediately
after doing unlazy_fpu() on the host side.

More importantly this will prevent the host process fpu from being
corrupted.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42bce48..67e773c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5969,7 +5969,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
-	unlazy_fpu(current);
+	kernel_fpu_begin();
 	fpu_restore_checking(&vcpu->arch.guest_fpu);
 	trace_kvm_fpu(1);
 }
@@ -5983,6 +5983,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	vcpu->guest_fpu_loaded = 0;
 	fpu_save_init(&vcpu->arch.guest_fpu);
+	kernel_fpu_end();
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);
-- 
1.7.6.5

