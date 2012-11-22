Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab2KVVSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:18:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:49646 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab2KVSkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [ 46/83] KVM: x86: Fix invalid secondary exec controls in vmx_cpuid_update()
Date: Wed, 21 Nov 2012 16:42:08 -0800
Message-Id: <20121122004217.678398057@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 29282fde80d44e587f8c152b10049a56e61659f0 upstream.

The commit [ad756a16: KVM: VMX: Implement PCID/INVPCID for guests with
EPT] introduced the unconditional access to SECONDARY_VM_EXEC_CONTROL,
and this triggers kernel warnings like below on old CPUs:

    vmwrite error: reg 401e value a0568000 (err 12)
    Pid: 13649, comm: qemu-kvm Not tainted 3.7.0-rc4-test2+ #154
    Call Trace:
     [<ffffffffa0558d86>] vmwrite_error+0x27/0x29 [kvm_intel]
     [<ffffffffa054e8cb>] vmcs_writel+0x1b/0x20 [kvm_intel]
     [<ffffffffa054f114>] vmx_cpuid_update+0x74/0x170 [kvm_intel]
     [<ffffffffa03629b6>] kvm_vcpu_ioctl_set_cpuid2+0x76/0x90 [kvm]
     [<ffffffffa0341c67>] kvm_arch_vcpu_ioctl+0xc37/0xed0 [kvm]
     [<ffffffff81143f7c>] ? __vunmap+0x9c/0x110
     [<ffffffffa0551489>] ? vmx_vcpu_load+0x39/0x1a0 [kvm_intel]
     [<ffffffffa0340ee2>] ? kvm_arch_vcpu_load+0x52/0x1a0 [kvm]
     [<ffffffffa032dcd4>] ? vcpu_load+0x74/0xd0 [kvm]
     [<ffffffffa032deb0>] kvm_vcpu_ioctl+0x110/0x5e0 [kvm]
     [<ffffffffa032e93d>] ? kvm_dev_ioctl+0x4d/0x4a0 [kvm]
     [<ffffffff8117dc6f>] do_vfs_ioctl+0x8f/0x530
     [<ffffffff81139d76>] ? remove_vma+0x56/0x60
     [<ffffffff8113b708>] ? do_munmap+0x328/0x400
     [<ffffffff81187c8c>] ? fget_light+0x4c/0x100
     [<ffffffff8117e1a1>] sys_ioctl+0x91/0xb0
     [<ffffffff815a942d>] system_call_fastpath+0x1a/0x1f

This patch adds a check for the availability of secondary exec
control to avoid these warnings.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6584,19 +6584,22 @@ static void vmx_cpuid_update(struct kvm_
 		}
 	}
 
-	exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
 	/* Exposing INVPCID only when PCID is exposed */
 	best = kvm_find_cpuid_entry(vcpu, 0x7, 0);
 	if (vmx_invpcid_supported() &&
 	    best && (best->ebx & bit(X86_FEATURE_INVPCID)) &&
 	    guest_cpuid_has_pcid(vcpu)) {
+		exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
 		exec_control |= SECONDARY_EXEC_ENABLE_INVPCID;
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
 			     exec_control);
 	} else {
-		exec_control &= ~SECONDARY_EXEC_ENABLE_INVPCID;
-		vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
-			     exec_control);
+		if (cpu_has_secondary_exec_ctrls()) {
+			exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
+			exec_control &= ~SECONDARY_EXEC_ENABLE_INVPCID;
+			vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
+				     exec_control);
+		}
 		if (best)
 			best->ebx &= ~bit(X86_FEATURE_INVPCID);
 	}


