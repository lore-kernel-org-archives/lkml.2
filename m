Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2K0RBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:01:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab2K0RBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:01:01 -0500
Date: Tue, 27 Nov 2012 19:00:26 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
Message-ID: <20121127170026.GM12969@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
 <CAFTL4hzzumANj7hF5hJPZ5pKPhz4YWC-Ukb3yUKdy_DO+vb3wg@mail.gmail.com>
 <20121127154455.GK12969@redhat.com>
 <CAFTL4hyfCt2imzBYW+Sn5QUAwham=ZQ2nNER5Np7Hq4yg1LzxA@mail.gmail.com>
 <20121127163910.GL12969@redhat.com>
 <CAFTL4hyzVLismy0ckx0Tu47EAgNn9WjAFEx=ptF5587-zp65hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hyzVLismy0ckx0Tu47EAgNn9WjAFEx=ptF5587-zp65hQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 05:51:12PM +0100, Frederic Weisbecker wrote:
> 2012/11/27 Gleb Natapov <gleb@redhat.com>:
> > On Tue, Nov 27, 2012 at 04:56:30PM +0100, Frederic Weisbecker wrote:
> >> 2012/11/27 Gleb Natapov <gleb@redhat.com>:
> >> > For KVM_PV_REASON_PAGE_NOT_PRESENT it behaves like an exception.
> >>
> >> Ok.
> >> There seem to be a bug in kvm_async_pf_task_wait(). Using
> >> idle_cpu(cpu) to find out if the current task is the idle task may not
> >> work if there is pending wake up. Me may schedule another task but
> >> when that other task sleeps later we can't schedule back to idle until
> >> the fault is completed.
> >>
> >> The right way is to use is_idle_task(current)
> > But if there is pending wake up then scheduling to the waked up task is
> > exactly what we want.
> 
> Ok, but what if that task goes to sleep soon after beeing scheduled
> and there is no other task on the runqueue and the page fault has not
> been handled yet? The only thing you can do is to schedule the idle
> task. But the idle task is waiting for the fault completion so you
> can't do that.
Yes, I see now. So even though we have runnable task we can't schedule
away from idle task. Wouldn't the patch below solve Sasha's and Li's
RCU problems then (not even compiled):


diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 4180a87..636800d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -113,7 +113,7 @@ void kvm_async_pf_task_wait(u32 token)
 	int cpu, idle;
 
 	cpu = get_cpu();
-	idle = idle_cpu(cpu);
+	idle = is_idle_task(current);
 	put_cpu();
 
 	spin_lock(&b->lock);
@@ -247,10 +247,7 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
-		rcu_irq_enter();
-		exit_idle();
 		kvm_async_pf_task_wait((u32)read_cr2());
-		rcu_irq_exit();
 		break;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();

--
			Gleb.
