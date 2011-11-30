Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab1K3JpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:45:17 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47477 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab1K3JpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:45:14 -0500
Message-ID: <4ED5FABC.1080705@linux.vnet.ibm.com>
Date: Wed, 30 Nov 2011 17:43:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jason Baron <jbaron@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: audit: replace mmu audit tracepoint with
 jump-lable
References: <4ED3811F.1070101@linux.vnet.ibm.com> <4ED3815C.9060901@linux.vnet.ibm.com> <20111128223305.GB2519@redhat.com> <4ED457D0.3010400@linux.vnet.ibm.com> <4ED4AD9E.1010604@redhat.com>
In-Reply-To: <4ED4AD9E.1010604@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11113009-2674-0000-0000-00000220042A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 06:02 PM, Avi Kivity wrote:

> On 11/29/2011 05:56 AM, Xiao Guangrong wrote:
>> Subject: [PATCH v2 2/5] KVM: MMU: audit: replace mmu audit tracepoint with jump-lable
>>
>> The tracepoint is only used to audit mmu code, it should not be exposed to
>> user, let us replace it with jump-lable
>>
>>
>>  static bool mmu_audit;
>> +static struct jump_label_key mmu_audit_key;
>> +
>> +#define kvm_mmu_audit(vcpu, point)		\
>> +	if (static_branch((&mmu_audit_key))) {	\
>> +		__kvm_mmu_audit(vcpu, point);	\
>> +	}
>>
>>
> 
> 
> static inline function, please, and as an incremental against next. I'll
> fold it to the parent patch.
> 


OK, this is the new one. Thanks!

Subject: [PATCH] KVM: MMU: audit: inline audit function

inline audit function and little cleanup

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |   28 +++++++---------------------
 arch/x86/kvm/mmu_audit.c |   29 +++++++++++++++++++++--------
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b1178d1..7a8e99c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -59,21 +59,6 @@ enum {
 	AUDIT_POST_SYNC
 };

-char *audit_point_name[] = {
-	"pre page fault",
-	"post page fault",
-	"pre pte write",
-	"post pte write",
-	"pre sync",
-	"post sync"
-};
-
-#ifdef CONFIG_KVM_MMU_AUDIT
-static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point);
-#else
-static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point) { }
-#endif
-
 #undef MMU_DEBUG

 #ifdef MMU_DEBUG
@@ -1539,6 +1524,13 @@ static int kvm_sync_page_transient(struct kvm_vcpu *vcpu,
 	return ret;
 }

+#ifdef CONFIG_KVM_MMU_AUDIT
+#include "mmu_audit.c"
+#else
+static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point) { }
+static void mmu_audit_disable(void) { }
+#endif
+
 static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
 {
@@ -4035,12 +4027,6 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	mmu_free_memory_caches(vcpu);
 }

-#ifdef CONFIG_KVM_MMU_AUDIT
-#include "mmu_audit.c"
-#else
-static void mmu_audit_disable(void) { }
-#endif
-
 void kvm_mmu_module_exit(void)
 {
 	mmu_destroy_caches();
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index 5df6736..fe15dcc 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -19,6 +19,15 @@

 #include <linux/ratelimit.h>

+char const *audit_point_name[] = {
+	"pre page fault",
+	"post page fault",
+	"pre pte write",
+	"post pte write",
+	"pre sync",
+	"post sync"
+};
+
 #define audit_printk(kvm, fmt, args...)		\
 	printk(KERN_ERR "audit: (%s) error: "	\
 		fmt, audit_point_name[kvm->arch.audit_point], ##args)
@@ -227,18 +236,22 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
 static bool mmu_audit;
 static struct jump_label_key mmu_audit_key;

-static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
+static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
 	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);

-	if (static_branch((&mmu_audit_key))) {
-		if (!__ratelimit(&ratelimit_state))
-			return;
+	if (!__ratelimit(&ratelimit_state))
+		return;

-		vcpu->kvm->arch.audit_point = point;
-		audit_all_active_sps(vcpu->kvm);
-		audit_vcpu_spte(vcpu);
-	}
+	vcpu->kvm->arch.audit_point = point;
+	audit_all_active_sps(vcpu->kvm);
+	audit_vcpu_spte(vcpu);
+}
+
+static inline void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
+{
+	if (static_branch((&mmu_audit_key)))
+		__kvm_mmu_audit(vcpu, point);
 }

 static void mmu_audit_enable(void)
-- 
1.7.7.3

