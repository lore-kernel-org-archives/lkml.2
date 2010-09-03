Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab0ICEHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 00:07:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54722 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab0ICEHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 00:07:49 -0400
Message-ID: <4C807593.1050903@cn.fujitsu.com>
Date: Fri, 03 Sep 2010 12:12:03 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: don't sent IPI if the vcpu is not online
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's no need sent IPI to the vcpu which is schedule out

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f2ecdd5..a2682cf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -86,6 +86,7 @@ struct kvm_vcpu {
 	unsigned long requests;
 	unsigned long guest_debug;
 	int srcu_idx;
+	bool online;
 
 	int fpu_active;
 	int guest_fpu_loaded, guest_xcr0_loaded;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9a73b98..998cbc8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -148,8 +148,9 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	raw_spin_lock(&kvm->requests_lock);
 	me = smp_processor_id();
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (kvm_make_check_request(req, vcpu))
+		if (kvm_make_check_request(req, vcpu) || !vcpu->online)
 			continue;
+
 		cpu = vcpu->cpu;
 		if (cpus != NULL && cpu != -1 && cpu != me)
 			cpumask_set_cpu(cpu, cpus);
@@ -2245,6 +2246,7 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
+	vcpu->online = true;
 	kvm_arch_vcpu_load(vcpu, cpu);
 }
 
@@ -2253,6 +2255,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
+	vcpu->online = false;
 	kvm_arch_vcpu_put(vcpu);
 }
 
-- 
1.7.0.4
