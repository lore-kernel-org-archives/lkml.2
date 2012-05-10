Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827Ab2EJRhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:37:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37922 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680Ab2EJRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:37:10 -0400
Message-Id: <20120510173136.631086068@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Jones <davej@redhat.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [ 43/52] KVM: VMX: Fix kvm_set_shared_msr() called in preemptible context
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

(cherry picked from commit 2225fd56049643c1a7d645c0ce9d499d43c7974e)

kvm_set_shared_msr() may not be called in preemptible context,
but vmx_set_msr() does so:

  BUG: using smp_processor_id() in preemptible [00000000] code: qemu-kvm/22713
  caller is kvm_set_shared_msr+0x32/0xa0 [kvm]
  Pid: 22713, comm: qemu-kvm Not tainted 3.4.0-rc3+ #39
  Call Trace:
   [<ffffffff8131fa82>] debug_smp_processor_id+0xe2/0x100
   [<ffffffffa0328ae2>] kvm_set_shared_msr+0x32/0xa0 [kvm]
   [<ffffffffa03a103b>] vmx_set_msr+0x28b/0x2d0 [kvm_intel]
   ...

Making kvm_set_shared_msr() work in preemptible is cleaner, but
it's used in the fast path.  Making two variants is overkill, so
this patch just disables preemption around the call.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2219,9 +2219,12 @@ static int vmx_set_msr(struct kvm_vcpu *
 		msr = find_msr_entry(vmx, msr_index);
 		if (msr) {
 			msr->data = data;
-			if (msr - vmx->guest_msrs < vmx->save_nmsrs)
+			if (msr - vmx->guest_msrs < vmx->save_nmsrs) {
+				preempt_disable();
 				kvm_set_shared_msr(msr->index, msr->data,
 						   msr->mask);
+				preempt_enable();
+			}
 			break;
 		}
 		ret = kvm_set_msr_common(vcpu, msr_index, data);


