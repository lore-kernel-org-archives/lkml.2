Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927Ab2EJRmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:42:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46175 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760702Ab2EJRg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:26 -0400
Message-Id: <20120510173136.374401782@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>
Subject: [ 40/52] KVM: VMX: Fix delayed load of shared MSRs
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

(cherry picked from commit 9ee73970c03edb68146ceb1ba2a7033c99a5e017)

Shared MSRs (MSR_*STAR and related) are stored in both vmx->guest_msrs
and in the CPU registers, but vmx_set_msr() only updated memory. Prior
to 46199f33c2953, this didn't matter, since we called vmx_load_host_state(),
which scheduled a vmx_save_host_state(), which re-synchronized the CPU
state, but now we don't, so the CPU state will not be synchronized until
the next exit to host userspace.  This mostly affects nested vmx workloads,
which play with these MSRs a lot.

Fix by loading the MSR eagerly.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2219,6 +2219,9 @@ static int vmx_set_msr(struct kvm_vcpu *
 		msr = find_msr_entry(vmx, msr_index);
 		if (msr) {
 			msr->data = data;
+			if (msr - vmx->guest_msrs < vmx->save_nmsrs)
+				kvm_set_shared_msr(msr->index, msr->data,
+						   msr->mask);
 			break;
 		}
 		ret = kvm_set_msr_common(vcpu, msr_index, data);


