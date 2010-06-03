Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab0FCAct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:32:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38739 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344Ab0FCAcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f958O1HpQ5CfFu8uknlbBtuVqJlzxes2vjbbXYsTPCgR7hjIBmTWjrs1lZjHOrJ8Ln
         ZIirmdNNArercxD8OYZ1DbGT4OsglS0sn/BbwtnxsOkUDuU3pG+AbaLorKE5r7LQnLhZ
         mDjJ0Jp5NPGVGOzqwT2M11DFZKsUJSB6SdDIE=
MIME-Version: 1.0
In-Reply-To: <20100603084829.7234.A69D9226@jp.fujitsu.com>
References: <20100601145033.2446.A69D9226@jp.fujitsu.com>
	<20100602150304.GA5326@barrios-desktop>
	<20100603084829.7234.A69D9226@jp.fujitsu.com>
Date: Thu, 3 Jun 2010 09:32:47 +0900
Message-ID: <AANLkTilBq_dRXW1u56gbqc3Z5fU1I66UiFiQbbRU_2Ur@mail.gmail.com>
Subject: Re: [PATCH 5/5] oom: dump_tasks() use find_lock_task_mm() too
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 9:06 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>> > @@ -344,35 +344,30 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
>> >   */
>> >  static void dump_tasks(const struct mem_cgroup *mem)
>> >  {
>> > -   struct task_struct *g, *p;
>> > +   struct task_struct *p;
>> > +   struct task_struct *task;
>> >
>> >     printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
>> >            "name\n");
>> > -   do_each_thread(g, p) {
>> > +
>> > +   for_each_process(p) {
>> >             struct mm_struct *mm;
>> >
>> > -           if (mem && !task_in_mem_cgroup(p, mem))
>> > +           if (is_global_init(p) || (p->flags & PF_KTHREAD))
>>
>> select_bad_process needs is_global_init check to not select init as victim.
>> But in this case, it is just for dumping information of tasks.
>
> But dumping oom unrelated process is useless and making confusion.
> Do you have any suggestion? Instead, adding unkillable field?

I think it's not unrelated. Of course, init process doesn't consume
lots of memory but might consume more memory than old as time goes by
or some BUG although it is unlikely.

I think whether we print information of init or not isn't a big deal.
But we have been done it until now and you are trying to change it.
At least, we need some description why you want to remove it.
Making confusion? Hmm.. I don't think it make many people confusion.

>
>
>>
>> >                     continue;
>> > -           if (!thread_group_leader(p))
>> > +           if (mem && !task_in_mem_cgroup(p, mem))
>> >                     continue;
>> >
>> > -           task_lock(p);
>> > -           mm = p->mm;
>> > -           if (!mm) {
>> > -                   /*
>> > -                    * total_vm and rss sizes do not exist for tasks with no
>> > -                    * mm so there's no need to report them; they can't be
>> > -                    * oom killed anyway.
>> > -                    */
>>
>> Please, do not remove the comment for mm newbies unless you think it's useless.
>
> How is this?
>
>               task = find_lock_task_mm(p);
>               if (!task)
>                        /*
>                         * Probably oom vs task-exiting race was happen and ->mm
>                         * have been detached. thus there's no need to report them;
>                         * they can't be oom killed anyway.
>                         */
>                        continue;
>

Looks good to adding story about racing. but my point was "total_vm
and rss sizes do not exist for tasks with no mm". But I don't want to
bother you due to trivial.
It depends on you. :)

Thanks, Kosaki.


-- 
Kind regards,
Minchan Kim
