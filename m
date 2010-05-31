Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab0EaKde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:33:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46968 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0EaKdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IOJhael0uHbHa91gWNqssZdfuS+uZCI2HftqwPnOldb99LgNGc9GPP9M1bi5LakZ51
         dMVjkInAvNz7wFZNkwgnJxW2P9cOJft8R6YNevFii/Ur1YVQzSek8laJf4JNxQ522u1x
         mDbbKZwd03ji9PIl4h7z5tf4OgS5X14P3T8LA=
MIME-Version: 1.0
In-Reply-To: <20100531155102.9a122772.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100528143605.7E2A.A69D9226@jp.fujitsu.com>
	<AANLkTikB-8Qu03VrA5Z0LMXM_alSV7SLqzl-MmiLmFGv@mail.gmail.com>
	<20100528145329.7E2D.A69D9226@jp.fujitsu.com>
	<20100528125305.GE11364@uudg.org>
	<20100528140623.GA11041@barrios-desktop>
	<20100528143617.GF11364@uudg.org>
	<20100528151249.GB12035@barrios-desktop>
	<20100528152842.GH11364@uudg.org>
	<20100528154549.GC12035@barrios-desktop>
	<20100528164826.GJ11364@uudg.org>
	<20100531092133.73705339.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikFk_HnZWPG0s_VrRkro2rruEc8OBX5KfKp_QdX@mail.gmail.com>
	<20100531140443.b36a4f02.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTil75ziCd6bivhpmwojvhaJ2LVxwEaEaBEmZf2yN@mail.gmail.com>
	<20100531145415.5e53f837.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTilcuY5e1DNmLhUWfXtiQgPUafz2zRTUuTVl-88l@mail.gmail.com>
	<20100531155102.9a122772.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 31 May 2010 19:33:32 +0900
Message-ID: <AANLkTinDG06VXxI-GKtvPWhfm5Qkm26IbRPMAymCHqaX@mail.gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 3:51 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 31 May 2010 15:09:41 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Mon, May 31, 2010 at 2:54 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Mon, 31 May 2010 14:46:05 +0900
>> > Minchan Kim <minchan.kim@gmail.com> wrote:
>> >
>> >> On Mon, May 31, 2010 at 2:04 PM, KAMEZAWA Hiroyuki
>> >> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> >> > On Mon, 31 May 2010 14:01:03 +0900
>> >> > Minchan Kim <minchan.kim@gmail.com> wrote:
>> >> >
>> >> >> Hi, Kame.
>> >> >>
>> >> >> On Mon, May 31, 2010 at 9:21 AM, KAMEZAWA Hiroyuki
>> >> >> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> >> >> > On Fri, 28 May 2010 13:48:26 -0300
>> >> >> > "Luis Claudio R. Goncalves" <lclaudio@uudg.org> wrote:
>> >> >> >>
>> >> >> >> oom-killer: give the dying task rt priority (v3)
>> >> >> >>
>> >> >> >> Give the dying task RT priority so that it can be scheduled quickly and die,
>> >> >> >> freeing needed memory.
>> >> >> >>
>> >> >> >> Signed-off-by: Luis Claudio R. Gonçalves <lgoncalv@redhat.com>
>> >> >> >>
>> >> >> >> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> >> >> >> index 84bbba2..2b0204f 100644
>> >> >> >> --- a/mm/oom_kill.c
>> >> >> >> +++ b/mm/oom_kill.c
>> >> >> >> @@ -266,6 +266,8 @@ static struct task_struct *select_bad_process(unsigned long *ppoints)
>> >> >> >>   */
>> >> >> >>  static void __oom_kill_task(struct task_struct *p, int verbose)
>> >> >> >>  {
>> >> >> >> +     struct sched_param param;
>> >> >> >> +
>> >> >> >>       if (is_global_init(p)) {
>> >> >> >>               WARN_ON(1);
>> >> >> >>               printk(KERN_WARNING "tried to kill init!\n");
>> >> >> >> @@ -288,6 +290,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
>> >> >> >>        * exit() and clear out its resources quickly...
>> >> >> >>        */
>> >> >> >>       p->time_slice = HZ;
>> >> >> >> +     param.sched_priority = MAX_RT_PRIO-10;
>> >> >> >> +     sched_setscheduler(p, SCHED_FIFO, &param);
>> >> >> >>       set_tsk_thread_flag(p, TIF_MEMDIE);
>> >> >> >>
>> >> >> >
>> >> >> > BTW, how about the other threads which share mm_struct ?
>> >> >>
>> >> >> Could you elaborate your intention? :)
>> >> >>
>> >> >
>> >> > IIUC, the purpose of rising priority is to accerate dying thread to exit()
>> >> > for freeing memory AFAP. But to free memory, exit, all threads which share
>> >> > mm_struct should exit, too. I'm sorry if I miss something.
>> >>
>> >> How do we kill only some thread and what's the benefit of it?
>> >> I think when if some thread receives  KILL signal, the process include
>> >> the thread will be killed.
>> >>
>> > yes, so, if you want a _process_ die quickly, you have to acceralte the whole
>> > threads on a process. Acceralating a thread in a process is not big help.
>>
>> Yes.
>>
>> I see the code.
>> oom_kill_process is called by
>>
>> 1. mem_cgroup_out_of_memory
>> 2. __out_of_memory
>> 3. out_of_memory
>>
>>
>> (1,2) calls select_bad_process which select victim task in processes
>> by do_each_process.
>> But 3 isn't In case of  CONSTRAINT_MEMORY_POLICY, it kills current.
>> In only the case, couldn't we pass task of process, not one of thread?
>>
>
> Hmm, my point is that priority-acceralation is against a thread, not against a process.
> So, most of threads in memory-eater will not gain high priority even with this patch
> and works slowly.
> I have no objections to this patch. I just want to confirm the purpose. If this patch
> is for accelating exiting process by SIGKILL, it seems not enough.
> If an explanation as "acceralating all thread's priority in a process seems overkill"
> is given in changelog or comment, it's ok to me.

Okay. I got your point.
Kame's concern is proper.

Couldn't we raise priorities of whole threads of the task killed?

>
> Thanks,
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
