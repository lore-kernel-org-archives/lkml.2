Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0C3PtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 11:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab0C3PtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:49:11 -0400
Date: Tue, 30 Mar 2010 17:46:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: give current access to memory reserves if it has
	been killed
Message-ID: <20100330154659.GA12416@redhat.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com> <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, David Rientjes wrote:
>
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -681,6 +681,16 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
>  	}
>
>  	/*
> +	 * If current has a pending SIGKILL, then automatically select it.  The
> +	 * goal is to allow it to allocate so that it may quickly exit and free
> +	 * its memory.
> +	 */
> +	if (fatal_signal_pending(current)) {
> +		__oom_kill_task(current);

I am worried...

Note that __oom_kill_task() does force_sig(SIGKILL) which assumes that
->sighand != NULL. This is not true if out_of_memory() is called after
current has already passed exit_notify().


Hmm. looking at oom_kill.c... Afaics there are more problems with mt
apllications. select_bad_process() does for_each_process() which can
only see the group leaders. This is fine, but what if ->group_leader
has already exited? In this case its ->mm == NULL, and we ignore the
whole thread group.

IOW, unless I missed something, it is very easy to hide the process
from oom-kill:

	int main()
	{
		pthread_create(memory_hog_func);
		syscall(__NR_exit);
	}



probably we need something like

	--- x/mm/oom_kill.c
	+++ x/mm/oom_kill.c
	@@ -246,21 +246,27 @@ static enum oom_constraint constrained_a
	 static struct task_struct *select_bad_process(unsigned long *ppoints,
							struct mem_cgroup *mem)
	 {
	-	struct task_struct *p;
	+	struct task_struct *g, *p;
		struct task_struct *chosen = NULL;
		struct timespec uptime;
		*ppoints = 0;
	 
		do_posix_clock_monotonic_gettime(&uptime);
	-	for_each_process(p) {
	+	for_each_process(g) {
			unsigned long points;
	 
			/*
			 * skip kernel threads and tasks which have already released
			 * their mm.
			 */
	+		p = g;
	+		do {
	+			if (p->mm)
	+				break;
	+		} while_each_thread(g, p);
			if (!p->mm)
				continue;
	+
			/* skip the init task */
			if (is_global_init(p))
				continue;

except is should be simplified and is_global_init() should check g.

No?


Oh... proc_oom_score() is racy. We can't trust ->group_leader even
under tasklist_lock. If we race with exit/exec it can point to
nowhere. I'll send the simple fix.

Oleg.

