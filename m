Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab1CDK5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:57:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58583 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1CDK5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:57:45 -0500
Message-ID: <4D70C5DE.6000906@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 18:58:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/10] KVM: fix rcu usage in init_rmode_* functions
References: <4D70C569.1030107@cn.fujitsu.com>
In-Reply-To: <4D70C569.1030107@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:56:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:56:32,
	Serialize complete at 2011-03-04 18:56:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:
[ 3494.671786] stack backtrace:
[ 3494.671789] Pid: 10527, comm: qemu-system-x86 Not tainted 2.6.38-rc6+ #23
[ 3494.671790] Call Trace:
[ 3494.671796]  [<ffffffff8107d15f>] ? lockdep_rcu_dereference+0x9d/0xa5
[ 3494.671826]  [<ffffffffa03498be>] ? kvm_memslots+0x6b/0x73 [kvm]
[ 3494.671834]  [<ffffffffa03499be>] ? gfn_to_memslot+0x16/0x4f [kvm]
[ 3494.671843]  [<ffffffffa0349a0d>] ? gfn_to_hva+0x16/0x27 [kvm]
[ 3494.671851]  [<ffffffffa034c1c4>] ? kvm_write_guest_page+0x31/0x83 [kvm]
[ 3494.671861]  [<ffffffffa034c230>] ? kvm_clear_guest_page+0x1a/0x1c [kvm]
[ 3494.671867]  [<ffffffffa015e321>] ? vmx_set_tss_addr+0x83/0x122 [kvm_intel]

and:
[ 8328.789599] stack backtrace:
[ 8328.789601] Pid: 18736, comm: qemu-system-x86 Not tainted 2.6.38-rc6+ #23
[ 8328.789603] Call Trace:
[ 8328.789609]  [<ffffffff8107d15f>] ? lockdep_rcu_dereference+0x9d/0xa5
[ 8328.789621]  [<ffffffffa03988be>] ? kvm_memslots+0x6b/0x73 [kvm]
[ 8328.789628]  [<ffffffffa03989be>] ? gfn_to_memslot+0x16/0x4f [kvm]
[ 8328.789635]  [<ffffffffa0398a0d>] ? gfn_to_hva+0x16/0x27 [kvm]
[ 8328.789643]  [<ffffffffa039b1c4>] ? kvm_write_guest_page+0x31/0x83 [kvm]
[ 8328.789699]  [<ffffffffa039b230>] ? kvm_clear_guest_page+0x1a/0x1c [kvm]
[ 8328.789713]  [<ffffffffa0206d0e>] ? vmx_create_vcpu+0x316/0x3c8 [kvm_intel]

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e2b8c6b..d871ced 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2399,9 +2399,10 @@ static int init_rmode_tss(struct kvm *kvm)
 {
 	gfn_t fn = rmode_tss_base(kvm) >> PAGE_SHIFT;
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

