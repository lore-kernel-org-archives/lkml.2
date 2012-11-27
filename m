Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2K0SMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:12:42 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45404 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab2K0SMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:12:41 -0500
MIME-Version: 1.0
In-Reply-To: <20121127174737.GN12969@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	<CAFTL4hzzumANj7hF5hJPZ5pKPhz4YWC-Ukb3yUKdy_DO+vb3wg@mail.gmail.com>
	<20121127154455.GK12969@redhat.com>
	<CAFTL4hyfCt2imzBYW+Sn5QUAwham=ZQ2nNER5Np7Hq4yg1LzxA@mail.gmail.com>
	<20121127163910.GL12969@redhat.com>
	<CAFTL4hyzVLismy0ckx0Tu47EAgNn9WjAFEx=ptF5587-zp65hQ@mail.gmail.com>
	<20121127170026.GM12969@redhat.com>
	<CAFTL4hyb0qYYhy1OE9HDHymFkmHDb5jNyuLNSR2aQ3dKPpuZkw@mail.gmail.com>
	<20121127174737.GN12969@redhat.com>
Date: Tue, 27 Nov 2012 19:12:40 +0100
Message-ID: <CAFTL4hxh96wDMpBEid0EN8ir-9C=Z+pdy6viVVK5fyKkRbUOOw@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/27 Gleb Natapov <gleb@redhat.com>:
> On Tue, Nov 27, 2012 at 06:30:32PM +0100, Frederic Weisbecker wrote:
>> 2012/11/27 Gleb Natapov <gleb@redhat.com>:
>> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> > index 4180a87..636800d 100644
>> > --- a/arch/x86/kernel/kvm.c
>> > +++ b/arch/x86/kernel/kvm.c
>> > @@ -113,7 +113,7 @@ void kvm_async_pf_task_wait(u32 token)
>> >         int cpu, idle;
>> >
>> >         cpu = get_cpu();
>> > -       idle = idle_cpu(cpu);
>> > +       idle = is_idle_task(current);
>>
>> I suggest this part goes to a standalone patch.
>>
>> >         put_cpu();
>> >
>> >         spin_lock(&b->lock);
>> > @@ -247,10 +247,7 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
>> >                 break;
>> >         case KVM_PV_REASON_PAGE_NOT_PRESENT:
>> >                 /* page is swapped out by the host. */
>> > -               rcu_irq_enter();
>> > -               exit_idle();
>> >                 kvm_async_pf_task_wait((u32)read_cr2());
>> > -               rcu_irq_exit();
>>
>> Hmm, we still need those above around. I believe we just need to add
>> rcu_user_exit() in the beginning of that case.
> The exception may happen in kernel space too. Is calling rcu_user_exit()
> still OK? Also why calling exit_idle() if we are not exiting idle?

Yeah, rcu_user_exit() takes care of that. And exit_idle() also checks
we are really idle before firing the notifier.

Now we should probably call back enter_idle() before resuming idle if
needed. We disable irqs before calling enter_idle(). And exit_idle()
is called from irqs. This way we ensure it's either called before we
called local_irq_disable() or while the CPU is halt(). This provides
the guarantee that enter_idle() is always called before the CPU goes
to sleep. The fact we call exit_idle()  from an exception in idle
breaks this guarantee. But that's another issue.
