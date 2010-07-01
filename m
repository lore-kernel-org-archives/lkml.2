Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab0GAU6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:58:11 -0400
Received: from kroah.org ([198.145.64.141]:47992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735Ab0GAUvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:36 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:40 2010
Message-Id: <20100701173440.040849875@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 157/164] KVM: x86: Add missing locking to arch specific vcpu ioctls
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit 8fbf065d625617bbbf6b72d5f78f84ad13c8b547)
---
 arch/x86/kvm/x86.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1550,6 +1550,7 @@ static int kvm_vcpu_ioctl_get_cpuid2(str
 {
 	int r;
 
+	vcpu_load(vcpu);
 	r = -E2BIG;
 	if (cpuid->nent < vcpu->arch.cpuid_nent)
 		goto out;
@@ -1561,6 +1562,7 @@ static int kvm_vcpu_ioctl_get_cpuid2(str
 
 out:
 	cpuid->nent = vcpu->arch.cpuid_nent;
+	vcpu_put(vcpu);
 	return r;
 }
 
@@ -1813,6 +1815,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(
 	int r;
 	unsigned bank_num = mcg_cap & 0xff, bank;
 
+	vcpu_load(vcpu);
 	r = -EINVAL;
 	if (!bank_num || bank_num >= KVM_MAX_MCE_BANKS)
 		goto out;
@@ -1827,6 +1830,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(
 	for (bank = 0; bank < bank_num; bank++)
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
 out:
+	vcpu_put(vcpu);
 	return r;
 }
 
@@ -2094,7 +2098,9 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&mce, argp, sizeof mce))
 			goto out;
+		vcpu_load(vcpu);
 		r = kvm_vcpu_ioctl_x86_set_mce(vcpu, &mce);
+		vcpu_put(vcpu);
 		break;
 	}
 	case KVM_GET_VCPU_EVENTS: {


