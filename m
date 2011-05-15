Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055Ab1EOPUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 11:20:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61927 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab1EOPUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 11:20:21 -0400
Message-ID: <4DCFEF9C.8030309@cn.fujitsu.com>
Date: Sun, 15 May 2011 23:22:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 2/7] KVM: use __copy_to_user/__clear_user to write guest
 page
References: <4DCFEF3B.5060806@cn.fujitsu.com>
In-Reply-To: <4DCFEF3B.5060806@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 23:20:27,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 23:20:27,
	Serialize complete at 2011-05-15 23:20:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply use __copy_to_user/__clear_user to write guest page since we have
already verified the user address when the memslot is set

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c  |    4 ++--
 virt/kvm/kvm_main.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77c9d86..a419bd1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1388,7 +1388,7 @@ static int set_msr_hyperv_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			return 1;
 		kvm_x86_ops->patch_hypercall(vcpu, instructions);
 		((unsigned char *)instructions)[3] = 0xc3; /* ret */
-		if (copy_to_user((void __user *)addr, instructions, 4))
+		if (__copy_to_user((void __user *)addr, instructions, 4))
 			return 1;
 		kvm->arch.hv_hypercall = data;
 		break;
@@ -1415,7 +1415,7 @@ static int set_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 				  HV_X64_MSR_APIC_ASSIST_PAGE_ADDRESS_SHIFT);
 		if (kvm_is_error_hva(addr))
 			return 1;
-		if (clear_user((void __user *)addr, PAGE_SIZE))
+		if (__clear_user((void __user *)addr, PAGE_SIZE))
 			return 1;
 		vcpu->arch.hv_vapic = data;
 		break;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 22cdb96..3962899 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1342,7 +1342,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
 	addr = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = copy_to_user((void __user *)addr + offset, data, len);
+	r = __copy_to_user((void __user *)addr + offset, data, len);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty(kvm, gfn);
@@ -1402,7 +1402,7 @@ int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
 
-	r = copy_to_user((void __user *)ghc->hva, data, len);
+	r = __copy_to_user((void __user *)ghc->hva, data, len);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty_in_slot(kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
-- 
1.7.4.4

