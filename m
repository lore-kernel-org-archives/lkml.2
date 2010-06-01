Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0FABKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 21:10:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59116 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab0FABKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 21:10:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/5] oom: select_bad_process: PF_EXITING check should take ->mm into account
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100531164354.GA9991@redhat.com>
References: <20100531183335.1846.A69D9226@jp.fujitsu.com> <20100531164354.GA9991@redhat.com>
Message-Id: <20100601093951.2430.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  1 Jun 2010 10:10:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -287,7 +287,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
> >  		 * the process of exiting and releasing its resources.
> >  		 * Otherwise we could get an easy OOM deadlock.
> >  		 */
> > -		if (p->flags & PF_EXITING) {
> > +		if ((p->flags & PF_EXITING) && p->mm) {
> 
> (strictly speaking, this change is needed after 3/5 which removes the
>  top-level "if (!p->mm)" check in select_bad_process).
> 
> 
> I'd like to add a note... with or without this, we have problems
> with the coredump. A thread participating in the coredumping
> (group-leader in this case) can have PF_EXITING && mm, but this doesn't
> mean it is going to exit soon, and the dumper can use a lot more memory.

Sure. I think coredump sould do nothing if oom occur.
So, merely making PF_COREDUMP is bad idea? I mean


task-flags		allocator
------------------------------------------------
none			N/A
TIF_MEMDIE		allow to use emergency memory.
			don't call page reclaim.
PF_COREDUMP		N/A
TIF_MEMDIE+PF_COREDUMP	disallow to use emergency memory.
			don't call page reclaim.

In other word, coredump path makes allocation failure if the task
marked as TIF_MEMDIE.
And, userland oom helper should be marked PF_OOM_ORIGIN perhaps.


> Otoh, if select_bad_process() chooses the thread which dumps the core,
> SIGKILL can't stop it. This should be fixed in do_coredump() paths, this
> is the long-standing problem.
> 
> And, as it was already discussed, we only check the group-leader here.
> But I can't suggest something better.

I guess signal_group_exit() is enough in practical case. I mean
exit(2) is only used by pthread_exit(3), so practically the last thread
in the process don't die by using exit(2).

I don't say signal_group_exit() is no side-effect. but I guess originally
intention was testing during _process_ exiting. 

Am I missing something?



