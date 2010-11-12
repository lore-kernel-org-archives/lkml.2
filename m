Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0KLHAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 02:00:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0KLG7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:59:48 -0500
Message-ID: <4CDCE393.9040408@cn.fujitsu.com>
Date: Fri, 12 Nov 2010 14:49:55 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 4/5] KVM: MMU: fix apf prefault if nested guest is enabled
References: <4CDCE2B0.7000601@cn.fujitsu.com>
In-Reply-To: <4CDCE2B0.7000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 14:46:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 15:00:13,
	Serialize complete at 2010-11-12 15:00:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If apf is generated in L2 guest and is completed in L1 guest, it will
prefault this apf in L1 guest's mmu context.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    1 +
 arch/x86/kvm/x86.c              |    3 ++-
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7f20f2c..b04c0fa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -600,6 +600,7 @@ struct kvm_x86_ops {
 struct kvm_arch_async_pf {
 	u32 token;
 	gfn_t gfn;
+	bool direct_map;
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5ee5b97..bdb9fa9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2608,6 +2608,7 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
 	struct kvm_arch_async_pf arch;
 	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 	arch.gfn = gfn;
+	arch.direct_map = vcpu->arch.mmu.direct_map;
 
 	return kvm_setup_async_pf(vcpu, gva, gfn, &arch);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c071d73..003a0ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6169,7 +6169,8 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
-	if (!vcpu->arch.mmu.direct_map || is_error_page(work->page))
+	if (!vcpu->arch.mmu.direct_map || !work->arch.direct_map ||
+	      is_error_page(work->page))
 		return;
 
 	r = kvm_mmu_reload(vcpu);
-- 
1.7.0.4

