Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0HXJh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:37:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab0HXJhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:37:25 -0400
Date: Tue, 24 Aug 2010 12:36:35 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 10/12] Handle async PF in non preemptable context
Message-ID: <20100824093635.GZ10499@redhat.com>
References: <1279553462-7036-1-git-send-email-gleb@redhat.com>
 <1279553462-7036-11-git-send-email-gleb@redhat.com>
 <4C739131.1050203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C739131.1050203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 12:30:25PM +0300, Avi Kivity wrote:
>  On 07/19/2010 06:31 PM, Gleb Natapov wrote:
> >If async page fault is received by idle task or when preemp_count is
> >not zero guest cannot reschedule, so do sti; hlt and wait for page to be
> >ready. vcpu can still process interrupts while it waits for the page to
> >be ready.
> >
> >Acked-by: Rik van Riel<riel@redhat.com>
> >Signed-off-by: Gleb Natapov<gleb@redhat.com>
> >---
> >  arch/x86/kernel/kvm.c |   36 ++++++++++++++++++++++++++++++++----
> >  1 files changed, 32 insertions(+), 4 deletions(-)
> >
> >diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> >index a6db92e..914b0fc 100644
> >--- a/arch/x86/kernel/kvm.c
> >+++ b/arch/x86/kernel/kvm.c
> >@@ -37,6 +37,7 @@
> >  #include<asm/cpu.h>
> >  #include<asm/traps.h>
> >  #include<asm/desc.h>
> >+#include<asm/tlbflush.h>
> >
> >  #define MMU_QUEUE_SIZE 1024
> >
> >@@ -68,6 +69,8 @@ struct kvm_task_sleep_node {
> >  	wait_queue_head_t wq;
> >  	u32 token;
> >  	int cpu;
> >+	bool halted;
> >+	struct mm_struct *mm;
> >  };
> >
> >  static struct kvm_task_sleep_head {
> >@@ -96,6 +99,11 @@ static void apf_task_wait(struct task_struct *tsk, u32 token)
> >  	struct kvm_task_sleep_head *b =&async_pf_sleepers[key];
> >  	struct kvm_task_sleep_node n, *e;
> >  	DEFINE_WAIT(wait);
> >+	int cpu, idle;
> >+
> >+	cpu = get_cpu();
> >+	idle = idle_cpu(cpu);
> >+	put_cpu();
> >
> >  	spin_lock(&b->lock);
> >  	e = _find_apf_task(b, token);
> >@@ -109,17 +117,31 @@ static void apf_task_wait(struct task_struct *tsk, u32 token)
> >
> >  	n.token = token;
> >  	n.cpu = smp_processor_id();
> >+	n.mm = current->active_mm;
> >+	n.halted = idle || preempt_count()>  1;
> >+	atomic_inc(&n.mm->mm_count);
> >  	init_waitqueue_head(&n.wq);
> >  	hlist_add_head(&n.link,&b->list);
> >  	spin_unlock(&b->lock);
> >
> >  	for (;;) {
> >-		prepare_to_wait(&n.wq,&wait, TASK_UNINTERRUPTIBLE);
> >+		if (!n.halted)
> >+			prepare_to_wait(&n.wq,&wait, TASK_UNINTERRUPTIBLE);
> >  		if (hlist_unhashed(&n.link))
> >  			break;
> >-		schedule();
> >+
> >+		if (!n.halted) {
> >+			schedule();
> >+		} else {
> >+			/*
> >+			 * We cannot reschedule. So halt.
> >+			 */
> 
> If we get the wakeup here, we'll halt and never wake up again.
> 
We will not. IRQs are disabled here. native_safe_halt() enables them.

> >+			native_safe_halt();
> >+			local_irq_disable();
> 
> So we need a local_irq_disable() before the hlish_unhashed() check.
We are still in exception handler, so IRQ should be off.

> 
> >+		}
> >  	}
> >-	finish_wait(&n.wq,&wait);
> >+	if (!n.halted)
> >+		finish_wait(&n.wq,&wait);
> >
> >  	return;
> >  }
> >@@ -127,7 +149,12 @@ static void apf_task_wait(struct task_struct *tsk, u32 token)
> >  static void apf_task_wake_one(struct kvm_task_sleep_node *n)
> >  {
> >  	hlist_del_init(&n->link);
> >-	if (waitqueue_active(&n->wq))
> >+	if (!n->mm)
> >+		return;
> >+	mmdrop(n->mm);
> >+	if (n->halted)
> >+		smp_send_reschedule(n->cpu);
> >+	else if (waitqueue_active(&n->wq))
> >  		wake_up(&n->wq);
> >  }
> >
> >@@ -157,6 +184,7 @@ again:
> >  		}
> >  		n->token = token;
> >  		n->cpu = smp_processor_id();
> >+		n->mm = NULL;
> >  		init_waitqueue_head(&n->wq);
> >  		hlist_add_head(&n->link,&b->list);
> >  	} else
> 
> 
> -- 
> error compiling committee.c: too many arguments to function

--
			Gleb.
