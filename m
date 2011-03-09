Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1CIHkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 02:40:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57546 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab1CIHkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 02:40:09 -0500
Message-ID: <4D772F10.3020302@cn.fujitsu.com>
Date: Wed, 09 Mar 2011 15:41:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 1/4] KVM: fix rcu usage in init_rmode_* functions
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-09 15:38:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-09 15:38:54,
	Serialize complete at 2011-03-09 15:38:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:
[ 3494.671786] stack backtrace:
[ 3494.671789] Pid: 10527, comm: qemu-system-x86 Not tainted 2.6.38-rc6+ #23
[ 3494.671790] Call Trace:
[ 3494.671796]  [] ? lockdep_rcu_dereference+0x9d/0xa5
[ 3494.671826]  [] ? kvm_memslots+0x6b/0x73 [kvm]
[ 3494.671834]  [] ? gfn_to_memslot+0x16/0x4f [kvm]
[ 3494.671843]  [] ? gfn_to_hva+0x16/0x27 [kvm]
[ 3494.671851]  [] ? kvm_write_guest_page+0x31/0x83 [kvm]
[ 3494.671861]  [] ? kvm_clear_guest_page+0x1a/0x1c [kvm]
[ 3494.671867]  [] ? vmx_set_tss_addr+0x83/0x122 [kvm_intel]

and:
[ 8328.789599] stack backtrace:
[ 8328.789601] Pid: 18736, comm: qemu-system-x86 Not tainted 2.6.38-rc6+ #23
[ 8328.789603] Call Trace:
[ 8328.789609]  [] ? lockdep_rcu_dereference+0x9d/0xa5
[ 8328.789621]  [] ? kvm_memslots+0x6b/0x73 [kvm]
[ 8328.789628]  [] ? gfn_to_memslot+0x16/0x4f [kvm]
[ 8328.789635]  [] ? gfn_to_hva+0x16/0x27 [kvm]
[ 8328.789643]  [] ? kvm_write_guest_page+0x31/0x83 [kvm]
[ 8328.789699]  [] ? kvm_clear_guest_page+0x1a/0x1c [kvm]
[ 8328.789713]  [] ? vmx_create_vcpu+0x316/0x3c8 [kvm_intel]

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3febb76..d8475a2 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2397,11 +2397,12 @@ static bool guest_state_valid(struct kvm_vcpu *vcpu)
 
 static int init_rmode_tss(struct kvm *kvm)
 {
-	gfn_t fn = rmode_tss_base(kvm) >> PAGE_SHIFT;
+	gfn_t fn;
 	u16 data = 0;
-	int ret = 0;
-	int r;
+	int r, idx, ret = 0;
 
+	idx = srcu_read_lock(&kvm->srcu);
+	fn = rmode_tss_base(kvm) >> PAGE_SHIFT;
 	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
 	if (r < 0)
 		goto out;
@@ -2425,12 +2426,13 @@ static int init_rmode_tss(struct kvm *kvm)
 
 	ret = 1;
 out:
+	srcu_read_unlock(&kvm->srcu, idx);
 	return ret;
 }
 
 static int init_rmode_identity_map(struct kvm *kvm)
 {
-	int i, r, ret;
+	int i, idx, r, ret;
 	pfn_t identity_map_pfn;
 	u32 tmp;
 
@@ -2445,6 +2447,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 		return 1;
 	ret = 0;
 	identity_map_pfn = kvm->arch.ept_identity_map_addr >> PAGE_SHIFT;
+	idx = srcu_read_lock(&kvm->srcu);
 	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
 	if (r < 0)
 		goto out;
@@ -2460,6 +2463,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	kvm->arch.ept_identity_pagetable_done = true;
 	ret = 1;
 out:
+	srcu_read_unlock(&kvm->srcu, idx);
 	return ret;
 }
 
-- 
1.7.4
