Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1ALHlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 02:41:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65336 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab1ALHlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 02:41:22 -0500
Message-ID: <4D2D5B22.8070104@cn.fujitsu.com>
Date: Wed, 12 Jan 2011 15:41:22 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 3/3] KVM: make make_all_cpus_request() lockless
References: <4D2D5AA6.9080804@cn.fujitsu.com>
In-Reply-To: <4D2D5AA6.9080804@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-12 15:40:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-12 15:40:56,
	Serialize complete at 2011-01-12 15:40:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we have 'vcpu->mode' to judge whether need to send ipi to other
cpus, this way is very exact, so checking request bit is needless,
then we can drop the spinlock let it's collateral

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    6 ------
 virt/kvm/kvm_main.c      |    9 +++------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b99eacd..c8dee22 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -224,7 +224,6 @@ struct kvm_memslots {
 
 struct kvm {
 	spinlock_t mmu_lock;
-	raw_spinlock_t requests_lock;
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots *memslots;
@@ -731,11 +730,6 @@ static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
 	set_bit(req, &vcpu->requests);
 }
 
-static inline bool kvm_make_check_request(int req, struct kvm_vcpu *vcpu)
-{
-	return test_and_set_bit(req, &vcpu->requests);
-}
-
 static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 {
 	if (test_bit(req, &vcpu->requests)) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 71a4eaf..c9eed53 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -147,11 +147,9 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
-	raw_spin_lock(&kvm->requests_lock);
-	me = smp_processor_id();
+	me = get_cpu();
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (kvm_make_check_request(req, vcpu))
-			continue;
+		kvm_make_request(req, vcpu);
 		cpu = vcpu->cpu;
 
 		/* Set ->requests bit before we read ->mode */
@@ -167,7 +165,7 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 		smp_call_function_many(cpus, ack_flush, NULL, 1);
 	else
 		called = false;
-	raw_spin_unlock(&kvm->requests_lock);
+	put_cpu();
 	free_cpumask_var(cpus);
 	return called;
 }
@@ -433,7 +431,6 @@ static struct kvm *kvm_create_vm(void)
 	kvm->mm = current->mm;
 	atomic_inc(&kvm->mm->mm_count);
 	spin_lock_init(&kvm->mmu_lock);
-	raw_spin_lock_init(&kvm->requests_lock);
 	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
-- 
1.7.3.4
