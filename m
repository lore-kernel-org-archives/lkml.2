Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657Ab0J0I51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:57:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57486 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760621Ab0J0I5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:57:23 -0400
Message-ID: <4CC7EA7D.5020901@cn.fujitsu.com>
Date: Wed, 27 Oct 2010 17:01:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/8] KVM: fix tracing kvm_try_async_get_page
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracing 'async' and *pfn is useless, since 'async' is always true,
and '*pfn' is always "fault_pfn'

We can trace 'gva' and 'gfn' instead, it can help us to see the
life-cycle of an async_pf

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    2 +-
 include/trace/events/kvm.h |   12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7ab734d..7449803 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2618,7 +2618,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool no_apf, gfn_t gfn,
 	put_page(pfn_to_page(*pfn));
 
 	if (!no_apf && can_do_async_pf(vcpu)) {
-		trace_kvm_try_async_get_page(async, *pfn);
+		trace_kvm_try_async_get_page(gva, gfn);
 		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
 			trace_kvm_async_pf_doublefault(gva, gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 9c2cc6a..30063c6 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -188,18 +188,20 @@ TRACE_EVENT(kvm_age_page,
 #ifdef CONFIG_KVM_ASYNC_PF
 TRACE_EVENT(
 	kvm_try_async_get_page,
-	TP_PROTO(bool async, u64 pfn),
-	TP_ARGS(async, pfn),
+	TP_PROTO(u64 gva, u64 gfn),
+	TP_ARGS(gva, gfn),
 
 	TP_STRUCT__entry(
-		__field(__u64, pfn)
+		__field(u64, gva)
+		__field(u64, gfn)
 		),
 
 	TP_fast_assign(
-		__entry->pfn = (!async) ? pfn : (u64)-1;
+		__entry->gva = gva;
+		__entry->gfn = gfn;
 		),
 
-	TP_printk("pfn %#llx", __entry->pfn)
+	TP_printk("gva = %#llx, gfn = %#llx", __entry->gva, __entry->gfn)
 );
 
 TRACE_EVENT(
-- 
1.7.0.4
