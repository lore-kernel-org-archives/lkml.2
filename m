Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab0FCAGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:06:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37784 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab0FCAGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:06:13 -0400
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
In-Reply-To: <20100602150304.GA5326@barrios-desktop>
References: <20100601145033.2446.A69D9226@jp.fujitsu.com> <20100602150304.GA5326@barrios-desktop>
Message-Id: <20100603084829.7234.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 09:06:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > @@ -344,35 +344,30 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
> >   */
> >  static void dump_tasks(const struct mem_cgroup *mem)
> >  {
> > -	struct task_struct *g, *p;
> > +	struct task_struct *p;
> > +	struct task_struct *task;
> >  
> >  	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
> >  	       "name\n");
> > -	do_each_thread(g, p) {
> > +
> > +	for_each_process(p) {
> >  		struct mm_struct *mm;
> >  
> > -		if (mem && !task_in_mem_cgroup(p, mem))
> > +		if (is_global_init(p) || (p->flags & PF_KTHREAD))
> 
> select_bad_process needs is_global_init check to not select init as victim.
> But in this case, it is just for dumping information of tasks. 

But dumping oom unrelated process is useless and making confusion.
Do you have any suggestion? Instead, adding unkillable field?


> 
> >  			continue;
> > -		if (!thread_group_leader(p))
> > +		if (mem && !task_in_mem_cgroup(p, mem))
> >  			continue;
> >  
> > -		task_lock(p);
> > -		mm = p->mm;
> > -		if (!mm) {
> > -			/*
> > -			 * total_vm and rss sizes do not exist for tasks with no
> > -			 * mm so there's no need to report them; they can't be
> > -			 * oom killed anyway.
> > -			 */
> 
> Please, do not remove the comment for mm newbies unless you think it's useless.

How is this?

               task = find_lock_task_mm(p);
               if (!task)
                        /*
                         * Probably oom vs task-exiting race was happen and ->mm
                         * have been detached. thus there's no need to report them;
                         * they can't be oom killed anyway.
                         */
                        continue;



