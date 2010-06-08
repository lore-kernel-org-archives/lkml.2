Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0FHTKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:10:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab0FHTKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:10:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=sWxFw8Vx798vGkPXPCwL6syIrZMRk53sdzAshTizmGqQtcOHrHmqc6NUUeTiJ2LIy
	w0Lh/LyFnycJCvTtpfpoA==
Date: Tue, 8 Jun 2010 12:10:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 01/10] oom: don't try to kill oom_unkillable child
In-Reply-To: <20100608205343.767D.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006081210180.23776@chino.kir.corp.google.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com> <20100608205343.767D.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, KOSAKI Motohiro wrote:

> Now, badness() doesn't care neigher CPUSET nor mempolicy. Then
> if the victim child process is oom_unkillable()==1, __out_of_memory()
> can makes kernel hang eventually.
> 
> This patch fixes it.
> 
> 
> [remark: this is needed to fold "oom: sacrifice child with highest
> badness score for parent"]
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/oom_kill.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index d49d542..0d7397b 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -387,9 +387,6 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
>  static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem,
>  			      int verbose)
>  {
> -	if (oom_unkillable(p, mem))
> -		return 1;
> -
>  	p = find_lock_task_mm(p);
>  	if (!p)
>  		return 1;
> @@ -440,6 +437,8 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  
>  			if (c->mm == p->mm)
>  				continue;
> +			if (oom_unkillable(c, mem, nodemask))
> +				continue;
>  
>  			/* badness() returns 0 if the thread is unkillable */
>  			cpoints = badness(c, uptime.tv_sec);

This doesn't apply to anything.
