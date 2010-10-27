Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637Ab0J0I6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:58:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50020 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab0J0I6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:58:24 -0400
Message-ID: <4CC7EABA.3040302@cn.fujitsu.com>
Date: Wed, 27 Oct 2010 17:02:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/8] KVM: cleanup aysnc_pf tracepoints
References: <4CC7EA7D.5020901@cn.fujitsu.com>
In-Reply-To: <4CC7EA7D.5020901@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'DECLARE_EVENT_CLASS' to cleanup async_pf tracepoints

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/kvm.h |   76 ++++++++++++++++++++-----------------------
 1 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 30063c6..7bec396 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -186,59 +186,71 @@ TRACE_EVENT(kvm_age_page,
 );
 
 #ifdef CONFIG_KVM_ASYNC_PF
-TRACE_EVENT(
-	kvm_try_async_get_page,
+DECLARE_EVENT_CLASS(kvm_async_get_page_class,
+
 	TP_PROTO(u64 gva, u64 gfn),
+
 	TP_ARGS(gva, gfn),
 
 	TP_STRUCT__entry(
-		__field(u64, gva)
+		__field(__u64, gva)
 		__field(u64, gfn)
-		),
+	),
 
 	TP_fast_assign(
 		__entry->gva = gva;
 		__entry->gfn = gfn;
-		),
+	),
 
 	TP_printk("gva = %#llx, gfn = %#llx", __entry->gva, __entry->gfn)
 );
 
-TRACE_EVENT(
-	kvm_async_pf_not_present,
+DEFINE_EVENT(kvm_async_get_page_class, kvm_try_async_get_page,
+
+	TP_PROTO(u64 gva, u64 gfn),
+
+	TP_ARGS(gva, gfn)
+);
+
+DEFINE_EVENT(kvm_async_get_page_class, kvm_async_pf_doublefault,
+
+	TP_PROTO(u64 gva, u64 gfn),
+
+	TP_ARGS(gva, gfn)
+);
+
+DECLARE_EVENT_CLASS(kvm_async_pf_nopresent_ready,
+
 	TP_PROTO(u64 token, u64 gva),
+
 	TP_ARGS(token, gva),
 
 	TP_STRUCT__entry(
 		__field(__u64, token)
 		__field(__u64, gva)
-		),
+	),
 
 	TP_fast_assign(
 		__entry->token = token;
 		__entry->gva = gva;
-		),
+	),
+
+	TP_printk("token %#llx gva %#llx", __entry->token, __entry->gva)
 
-	TP_printk("token %#llx gva %#llx not present", __entry->token,
-		  __entry->gva)
 );
 
-TRACE_EVENT(
-	kvm_async_pf_ready,
+DEFINE_EVENT(kvm_async_pf_nopresent_ready, kvm_async_pf_not_present,
+
 	TP_PROTO(u64 token, u64 gva),
-	TP_ARGS(token, gva),
 
-	TP_STRUCT__entry(
-		__field(__u64, token)
-		__field(__u64, gva)
-		),
+	TP_ARGS(token, gva)
+);
 
-	TP_fast_assign(
-		__entry->token = token;
-		__entry->gva = gva;
-		),
+DEFINE_EVENT(kvm_async_pf_nopresent_ready, kvm_async_pf_ready,
+
+	TP_PROTO(u64 token, u64 gva),
 
-	TP_printk("token %#llx gva %#llx ready", __entry->token, __entry->gva)
+	TP_ARGS(token, gva)
 );
 
 TRACE_EVENT(
@@ -262,24 +274,6 @@ TRACE_EVENT(
 		  __entry->address, __entry->pfn)
 );
 
-TRACE_EVENT(
-	kvm_async_pf_doublefault,
-	TP_PROTO(u64 gva, u64 gfn),
-	TP_ARGS(gva, gfn),
-
-	TP_STRUCT__entry(
-		__field(u64, gva)
-		__field(u64, gfn)
-		),
-
-	TP_fast_assign(
-		__entry->gva = gva;
-		__entry->gfn = gfn;
-		),
-
-	TP_printk("gva = %#llx, gfn = %#llx", __entry->gva, __entry->gfn)
-);
-
 #endif
 
 #endif /* _TRACE_KVM_MAIN_H */
-- 
1.7.0.4

