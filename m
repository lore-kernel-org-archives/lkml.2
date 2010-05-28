Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0E1FvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:51:03 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65398 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab0E1Fu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:50:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=skFub5zibItuRmnzOgapY5pfY00FjO5R2Yo2+flxHR37lb9R49Rwbrwl3e5JYtQ0D3
         PTeA8Nn3cx/NH4dEZTIWRlpYhP05jci8ERP7DLwXZcfds7WR3w5IEwSsQToogP77WGz1
         YqOFs8xyV+I6pAsi4KQSSOOi11k7VtumRZ//0=
MIME-Version: 1.0
In-Reply-To: <20100528143605.7E2A.A69D9226@jp.fujitsu.com>
References: <20100528134133.7E24.A69D9226@jp.fujitsu.com>
	<AANLkTilimqXmhOSEvL7DKW9rmsczkv-u2p4vwAX3aPdd@mail.gmail.com>
	<20100528143605.7E2A.A69D9226@jp.fujitsu.com>
Date: Fri, 28 May 2010 14:50:55 +0900
Message-ID: <AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 2:39 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>> Hi, Kosaki.
>>
>> On Fri, May 28, 2010 at 1:46 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> * Luis Claudio R. Goncalves <lclaudio@uudg.org> [2010-05-28 00:51:47]:
>> >>
>> >> > @@ -382,6 +382,8 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
>> >> >   */
>> >> >  static void __oom_kill_task(struct task_struct *p, int verbose)
>> >> >  {
>> >> > +   struct sched_param param;
>> >> > +
>> >> >     if (is_global_init(p)) {
>> >> >             WARN_ON(1);
>> >> >             printk(KERN_WARNING "tried to kill init!\n");
>> >> > @@ -413,8 +415,9 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
>> >> >      */
>> >> >     p->rt.time_slice = HZ;
>> >> >     set_tsk_thread_flag(p, TIF_MEMDIE);
>> >> > -
>> >> >     force_sig(SIGKILL, p);
>> >> > +   param.sched_priority = MAX_RT_PRIO-1;
>> >> > +   sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
>> >> >  }
>> >> >
>> >>
>> >> I would like to understand the visible benefits of this patch. Have
>> >> you seen an OOM kill tasked really get bogged down. Should this task
>> >> really be competing with other important tasks for run time?
>> >
>> > What you mean important? Until OOM victim task exit completely, the system have no memory.
>> > all of important task can't do anything.
>> >
>> > In almost kernel subsystems, automatically priority boost is really bad idea because
>> > it may break RT task's deterministic behavior. but OOM is one of exception. The deterministic
>> > was alread broken by memory starvation.
>>
>> Yes or No.
>>
>> IMHO, normally RT tasks shouldn't use dynamic allocation(ie,
>> non-deterministic functions or system calls) in place which is needed
>> deterministic. So memory starvation might not break real-time
>> deterministic.
>
> I think It's impossible. Normally RT task use mlock and it prevent almost page
> allocation. but every syscall internally call kmalloc(). They can't avoid
> it practically.
>
> How do you perfectly avoid dynamic allocation?

RT Task

void non-RT-function()
{
   system call();
   buffer = malloc();
   memset(buffer);
}
/*
 * We make sure this function must be executed in some millisecond
 */
void RT-function()
{
   some calculation(); <- This doesn't have no dynamic characteristic
}
int main()
{
   non-RT-function();
   /* This function make sure RT-function cannot preempt by others */
   set_RT_max_high_priority();
   RT-function A();
   set_normal_priority();
   non-RT-function();
}

We don't want realtime in whole function of the task. What we want is
just RT-function A.
Of course, current Linux cannot make perfectly sure RT-functionA can
not preempt by others.
That's because some interrupt or exception happen. But RT-function A
doesn't related to any dynamic characteristic. What can justify to
preempt RT-function A by other processes?


-- 
Kind regards,
Minchan Kim
