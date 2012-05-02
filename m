Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2EBME2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:04:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab2EBME1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:04:27 -0400
Date: Wed, 2 May 2012 15:04:02 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: async pf: INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order
 detected
Message-ID: <20120502120402.GM22191@redhat.com>
References: <CA+1xoqcPSCA+iNdMETZMhXpmGaVkC2ACCJZAt4CSBkaoVwVvGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqcPSCA+iNdMETZMhXpmGaVkC2ACCJZAt4CSBkaoVwVvGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 04:50:35PM +0200, Sasha Levin wrote:
> Hi all.
> 
> I got a "INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected" warning
> while running LTP inside a KVM guest using the recent -next kernel.
> 
> It seems that it was initially originated from rcu_torture_rea(), but I
> don't think that it's a problem with RCU itself (I'll cc. Paul just in
> case). RCU torture was indeed configured to run during the testing.
> 
> The output is attached since it's a bit long.
> 
The reason is mmdrop() called from irq context and in reality we do
not need to hold reference to mm at all, so the patch below drops it.
---

KVM: Do not take reference to mm during async #PF

It turned to be totally unneeded. The reason the code was introduced is
so that KVM can prefault swapped in page, but prefault can fail even
if mm is pinned since page table can change anyway. KVM handles this
situation correctly though and does not inject spurious page faults.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b8ba6e4..e554e5a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -79,7 +79,6 @@ struct kvm_task_sleep_node {
 	u32 token;
 	int cpu;
 	bool halted;
-	struct mm_struct *mm;
 };
 
 static struct kvm_task_sleep_head {
@@ -126,9 +125,7 @@ void kvm_async_pf_task_wait(u32 token)
 
 	n.token = token;
 	n.cpu = smp_processor_id();
-	n.mm = current->active_mm;
 	n.halted = idle || preempt_count() > 1;
-	atomic_inc(&n.mm->mm_count);
 	init_waitqueue_head(&n.wq);
 	hlist_add_head(&n.link, &b->list);
 	spin_unlock(&b->lock);
@@ -161,9 +158,6 @@ EXPORT_SYMBOL_GPL(kvm_async_pf_task_wait);
 static void apf_task_wake_one(struct kvm_task_sleep_node *n)
 {
 	hlist_del_init(&n->link);
-	if (!n->mm)
-		return;
-	mmdrop(n->mm);
 	if (n->halted)
 		smp_send_reschedule(n->cpu);
 	else if (waitqueue_active(&n->wq))
@@ -207,7 +201,7 @@ again:
 		 * async PF was not yet handled.
 		 * Add dummy entry for the token.
 		 */
-		n = kmalloc(sizeof(*n), GFP_ATOMIC);
+		n = kzalloc(sizeof(*n), GFP_ATOMIC);
 		if (!n) {
 			/*
 			 * Allocation failed! Busy wait while other cpu
@@ -219,7 +213,6 @@ again:
 		}
 		n->token = token;
 		n->cpu = smp_processor_id();
-		n->mm = NULL;
 		init_waitqueue_head(&n->wq);
 		hlist_add_head(&n->link, &b->list);
 	} else

--
			Gleb.
