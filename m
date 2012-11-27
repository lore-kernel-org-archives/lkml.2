Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2K0T2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:28:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab2K0T15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:27:57 -0500
Date: Tue, 27 Nov 2012 21:27:48 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
Message-ID: <20121127192748.GB7695@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
 <CAFTL4hzzumANj7hF5hJPZ5pKPhz4YWC-Ukb3yUKdy_DO+vb3wg@mail.gmail.com>
 <20121127154455.GK12969@redhat.com>
 <CAFTL4hyfCt2imzBYW+Sn5QUAwham=ZQ2nNER5Np7Hq4yg1LzxA@mail.gmail.com>
 <20121127163910.GL12969@redhat.com>
 <CAFTL4hyzVLismy0ckx0Tu47EAgNn9WjAFEx=ptF5587-zp65hQ@mail.gmail.com>
 <20121127170026.GM12969@redhat.com>
 <CAFTL4hyb0qYYhy1OE9HDHymFkmHDb5jNyuLNSR2aQ3dKPpuZkw@mail.gmail.com>
 <20121127174737.GN12969@redhat.com>
 <CAFTL4hxh96wDMpBEid0EN8ir-9C=Z+pdy6viVVK5fyKkRbUOOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxh96wDMpBEid0EN8ir-9C=Z+pdy6viVVK5fyKkRbUOOw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 07:12:40PM +0100, Frederic Weisbecker wrote:
> 2012/11/27 Gleb Natapov <gleb@redhat.com>:
> > On Tue, Nov 27, 2012 at 06:30:32PM +0100, Frederic Weisbecker wrote:
> >> 2012/11/27 Gleb Natapov <gleb@redhat.com>:
> >> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> >> > index 4180a87..636800d 100644
> >> > --- a/arch/x86/kernel/kvm.c
> >> > +++ b/arch/x86/kernel/kvm.c
> >> > @@ -113,7 +113,7 @@ void kvm_async_pf_task_wait(u32 token)
> >> >         int cpu, idle;
> >> >
> >> >         cpu = get_cpu();
> >> > -       idle = idle_cpu(cpu);
> >> > +       idle = is_idle_task(current);
> >>
> >> I suggest this part goes to a standalone patch.
> >>
> >> >         put_cpu();
> >> >
> >> >         spin_lock(&b->lock);
> >> > @@ -247,10 +247,7 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
> >> >                 break;
> >> >         case KVM_PV_REASON_PAGE_NOT_PRESENT:
> >> >                 /* page is swapped out by the host. */
> >> > -               rcu_irq_enter();
> >> > -               exit_idle();
> >> >                 kvm_async_pf_task_wait((u32)read_cr2());
> >> > -               rcu_irq_exit();
> >>
> >> Hmm, we still need those above around. I believe we just need to add
> >> rcu_user_exit() in the beginning of that case.
> > The exception may happen in kernel space too. Is calling rcu_user_exit()
> > still OK? Also why calling exit_idle() if we are not exiting idle?
> 
> Yeah, rcu_user_exit() takes care of that. And exit_idle() also checks
> we are really idle before firing the notifier.
> 
> Now we should probably call back enter_idle() before resuming idle if
> needed. We disable irqs before calling enter_idle(). And exit_idle()
> is called from irqs. This way we ensure it's either called before we
> called local_irq_disable() or while the CPU is halt(). This provides
> the guarantee that enter_idle() is always called before the CPU goes
> to sleep. The fact we call exit_idle()  from an exception in idle
> breaks this guarantee. But that's another issue.

What is the semantics of enter_idle()/exit_idle(), what are they used for?
Not present fault happening in idle task does not mean we exit idle
task. If this happens exception handler will execute sti; hlt waiting
for missing page to be ready. Any interrupt happening during this hlt
will do exit_idle() by itself.

--
			Gleb.
