Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab0FCAl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:41:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58804 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab0FCAlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:41:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 5/5] oom: dump_tasks() use find_lock_task_mm() too
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <AANLkTilBq_dRXW1u56gbqc3Z5fU1I66UiFiQbbRU_2Ur@mail.gmail.com>
References: <20100603084829.7234.A69D9226@jp.fujitsu.com> <AANLkTilBq_dRXW1u56gbqc3Z5fU1I66UiFiQbbRU_2Ur@mail.gmail.com>
Message-Id: <20100603093548.7237.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 09:41:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jun 3, 2010 at 9:06 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Hi
> >
> >> > @@ -344,35 +344,30 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
> >> >   */
> >> >  static void dump_tasks(const struct mem_cgroup *mem)
> >> >  {
> >> > -   struct task_struct *g, *p;
> >> > +   struct task_struct *p;
> >> > +   struct task_struct *task;
> >> >
> >> >     printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
> >> >            "name\n");
> >> > -   do_each_thread(g, p) {
> >> > +
> >> > +   for_each_process(p) {
> >> >             struct mm_struct *mm;
> >> >
> >> > -           if (mem && !task_in_mem_cgroup(p, mem))
> >> > +           if (is_global_init(p) || (p->flags & PF_KTHREAD))
> >>
> >> select_bad_process needs is_global_init check to not select init as victim.
> >> But in this case, it is just for dumping information of tasks.
> >
> > But dumping oom unrelated process is useless and making confusion.
> > Do you have any suggestion? Instead, adding unkillable field?
> 
> I think it's not unrelated. Of course, init process doesn't consume
> lots of memory but might consume more memory than old as time goes by
> or some BUG although it is unlikely.
> 
> I think whether we print information of init or not isn't a big deal.
> But we have been done it until now and you are trying to change it.
> At least, we need some description why you want to remove it.
> Making confusion? Hmm.. I don't think it make many people confusion.

Hm. ok, I'll change logic as you said.



> >> > -           mm = p->mm;
> >> > -           if (!mm) {
> >> > -                   /*
> >> > -                    * total_vm and rss sizes do not exist for tasks with no
> >> > -                    * mm so there's no need to report them; they can't be
> >> > -                    * oom killed anyway.
> >> > -                    */
> >>
> >> Please, do not remove the comment for mm newbies unless you think it's useless.
> >
> > How is this?
> >
> >               task = find_lock_task_mm(p);
> >               if (!task)
> >                        /*
> >                         * Probably oom vs task-exiting race was happen and ->mm
> >                         * have been detached. thus there's no need to report them;
> >                         * they can't be oom killed anyway.
> >                         */
> >                        continue;
> >
> 
> Looks good to adding story about racing. but my point was "total_vm
> and rss sizes do not exist for tasks with no mm". But I don't want to
> bother you due to trivial.
> It depends on you. :)


old ->mm check have two intention.

   a) the task is kernel thread?
   b) the task have alredy detached ->mm

but a) is not strictly correct check because we should think use_mm(). 
therefore we appended PF_KTHREAD check. then, here find_lock_task_mm()
focus exiting race, I think.




