Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab1E3RUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:20:20 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:57501 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1E3RUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:20:19 -0400
X-Greylist: delayed 1985 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 May 2011 13:20:18 EDT
Date: Mon, 30 May 2011 12:46:53 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@gmail.com>,
        Ben Blum <bblum@andrew.cmu.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, cgroup: Fix up for new API
Message-ID: <20110530164653.GA1315@ghc17.ghc.andrew.cmu.edu>
References: <1306767651.1200.2990.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306767651.1200.2990.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 HTML_NO_HTTP 0.1, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_HTML 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 05:00:51PM +0200, Peter Zijlstra wrote:
> Subject: perf, cgroup: Fix up for new API
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon May 30 16:48:06 CEST 2011
> 
> Ben changed the API but forgot to convert everybody...
> 
> Cc: Ben Blum <bblum@andrew.cmu.edu>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Oops - I guess I missed the new subsystem when I refreshed against
2.6.39. This looks good to me.

Acked-by: Ben Blum <bblum@andrew.cmu.edu>

> ---
>  kernel/events/core.c |   22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 
> Index: linux-2.6/kernel/events/core.c
> ===================================================================
> --- linux-2.6.orig/kernel/events/core.c
> +++ linux-2.6/kernel/events/core.c
> @@ -7394,26 +7394,12 @@ static int __perf_cgroup_move(void *info
>  	return 0;
>  }
>  
> -static void perf_cgroup_move(struct task_struct *task)
> +static void
> +perf_cgroup_attach_task(struct cgroup *cgrp, struct task_struct *task)
>  {
>  	task_function_call(task, __perf_cgroup_move, task);
>  }
>  
> -static void perf_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
> -		struct cgroup *old_cgrp, struct task_struct *task,
> -		bool threadgroup)
> -{
> -	perf_cgroup_move(task);
> -	if (threadgroup) {
> -		struct task_struct *c;
> -		rcu_read_lock();
> -		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
> -			perf_cgroup_move(c);
> -		}
> -		rcu_read_unlock();
> -	}
> -}
> -
>  static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
>  		struct cgroup *old_cgrp, struct task_struct *task)
>  {
> @@ -7425,7 +7411,7 @@ static void perf_cgroup_exit(struct cgro
>  	if (!(task->flags & PF_EXITING))
>  		return;
>  
> -	perf_cgroup_move(task);
> +	perf_cgroup_attach_task(cgrp, task);
>  }
>  
>  struct cgroup_subsys perf_subsys = {
> @@ -7434,6 +7420,6 @@ struct cgroup_subsys perf_subsys = {
>  	.create		= perf_cgroup_create,
>  	.destroy	= perf_cgroup_destroy,
>  	.exit		= perf_cgroup_exit,
> -	.attach		= perf_cgroup_attach,
> +	.attach_task	= perf_cgroup_attach_task,
>  };
>  #endif /* CONFIG_CGROUP_PERF */
> 
> 
