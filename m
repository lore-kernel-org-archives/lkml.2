Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab1CNUlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:41:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:59052 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1CNUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:41:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=T95gIaaEnfARS3mKPG9yy9/doIx+Gv15J7RTSqTVzD3Ec/yYOnJegcLuugmtArXmW+
         gEYFjfBG0rmYKl1p48sQ==
Date: Mon, 14 Mar 2011 13:41:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>,
        Frantisek Hrbata <fhrbata@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 for 2.6.38] oom: oom_kill_process: fix the child_points
 logic
In-Reply-To: <20110314190530.GD21845@redhat.com>
Message-ID: <alpine.DEB.2.00.1103141334470.31514@chino.kir.corp.google.com>
References: <20110303100030.B936.A69D9226@jp.fujitsu.com> <20110308134233.GA26884@redhat.com> <alpine.DEB.2.00.1103081549530.27910@chino.kir.corp.google.com> <20110309151946.dea51cde.akpm@linux-foundation.org> <alpine.DEB.2.00.1103111142260.30699@chino.kir.corp.google.com>
 <20110312123413.GA18351@redhat.com> <20110312134341.GA27275@redhat.com> <AANLkTinHGSb2_jfkwx=Wjv96phzPCjBROfCTFCKi4Wey@mail.gmail.com> <20110313212726.GA24530@redhat.com> <20110314190419.GA21845@redhat.com> <20110314190530.GD21845@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Oleg Nesterov wrote:

> oom_kill_process() starts with victim_points == 0. This means that
> (most likely) any child has more points and can be killed erroneously.
> 
> Also, "children has a different mm" doesn't match the reality, we
> should check child->mm != t->mm. This check is not exactly correct
> if t->mm == NULL but this doesn't really matter, oom_kill_task()
> will kill them anyway.
> 
> Note: "Kill all processes sharing p->mm" in oom_kill_task() is wrong
> too.
> 

There're two issues you're addressing in this patch.  It only kills a 
child in place of its selected parent when:

 - the child has a higher badness score, and

 - it has a different ->mm.

In the former case, NACK, we always want to sacrifice children regardless 
of their badness score (as long as it is non-zero) if it has a separate 
->mm in place of its parent, otherwise webservers will be killed instead 
of one of their children serving a client, sshd could be killed instead of 
bash, etc.  The behavior of the oom killer has always been to try to kill 
a child with its own ->mm first to avoid losing a large amount of work 
being done or unnecessarily killing a job scheduler, for example, when 
sacrificing a child would be satisfactory.  It'll kill additional tasks, 
and perhaps even the parent later if it has no more children, if the oom 
condition persists.

In the latter case, I agree, we should be testing if the child has a 
different ->mm before sacrificing it for its parent as the comment 
indicates it will.  I proposed that exact change in "oom: avoid deferring 
oom killer if exiting task is being traced" posted to -mm a couple days 
ago.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  mm/oom_kill.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- 38/mm/oom_kill.c~3_fix_kill_chld	2011-03-14 18:52:39.000000000 +0100
> +++ 38/mm/oom_kill.c	2011-03-14 19:36:01.000000000 +0100
> @@ -459,10 +459,10 @@ static int oom_kill_process(struct task_
>  			    struct mem_cgroup *mem, nodemask_t *nodemask,
>  			    const char *message)
>  {
> -	struct task_struct *victim = p;
> +	struct task_struct *victim;
>  	struct task_struct *child;
> -	struct task_struct *t = p;
> -	unsigned int victim_points = 0;
> +	struct task_struct *t;
> +	unsigned int victim_points;
>  
>  	if (printk_ratelimit())
>  		dump_header(p, gfp_mask, order, mem, nodemask);
> @@ -488,10 +488,15 @@ static int oom_kill_process(struct task_
>  	 * parent.  This attempts to lose the minimal amount of work done while
>  	 * still freeing memory.
>  	 */
> +	victim_points = oom_badness(p, mem, nodemask, totalpages);
> +	victim = p;
> +	t = p;
>  	do {
>  		list_for_each_entry(child, &t->children, sibling) {
>  			unsigned int child_points;
>  
> +			if (child->mm == t->mm)
> +				continue;
>  			/*
>  			 * oom_badness() returns 0 if the thread is unkillable
>  			 */
> 
> 
