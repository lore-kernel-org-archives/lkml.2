Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab0L2OPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:15:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43484 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab0L2OO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dnZhuXX3/TCjrrHB8SQ4ZyQLuGEKfm+OMyzKQlhdLHWP5XpIXHXifdkMA/rbXPUj+8
         ZBgwioTQ49jUOsjP5BIOF7xqIOQH8+Tsn5VGAtFahywasl165F5n6idvDOqwQTDoX7fy
         4EE5F5bZQdNgQC1Fn/1Zj5Ubn14xaCVD1WMAY=
Date: Wed, 29 Dec 2010 22:14:46 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 06/17] sched: Provide p->on_rq
Message-ID: <20101229141445.GA2728@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20101224122338.172750730@chello.nl>
 <20101224123742.782732530@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101224123742.782732530@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 01:23:44PM +0100, Peter Zijlstra wrote:
> Provide a generic p->on_rq because the p->se.on_rq semantics are
> unfavourable for lockless wakeups but needed for sched_fair.
> 
> In particular, p->on_rq is only cleared when we actually dequeue the
> task in schedule() and not on any random dequeue as done by things
> like __migrate_task() and __sched_setscheduler().
> 
> This also allows us to remove p->se usage from !sched_fair code.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/sched.h   |    1 +
>  kernel/sched.c          |   36 ++++++++++++++++++------------------
>  kernel/sched_debug.c    |    2 +-
>  kernel/sched_rt.c       |   10 +++++-----
> Index: linux-2.6/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -1132,7 +1132,7 @@ static void put_prev_task_rt(struct rq *
>  	 * The previous task needs to be made eligible for pushing
>  	 * if it is still active
>  	 */
> -	if (p->se.on_rq && p->rt.nr_cpus_allowed > 1)
> +	if (p->on_rq && p->rt.nr_cpus_allowed > 1)
>  		enqueue_pushable_task(rq, p);

Seems we need on_rt_rq(&p->rt) here, otherwise we enqueue the
task to pushable list when called from rt_mutex_setprio()/
__sched_setscheduler() etc. Thus add a little overhead.
Though we call dequeue_pushable_task() in set_curr_task_rt()
unconditionally.

Thanks,
Yong
