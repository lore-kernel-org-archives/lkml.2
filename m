Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab0L2OUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:20:32 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57505 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0L2OUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:20:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lxoTrpTOAyyVlvpuKbgIbLJye1mgYXwT116/MvCXZ5g3LkPNSa8a6Cx1n9nEZ3Pqm/
         DA2h9GeXkiYHBv0w3UgX4N5G4ErEe+2tRp3Y3uyquvblngVv3AU6HBuhQuKi+Jq60lyw
         eonlsErIP1wougV6KgEe7vfRjrvDuuGBYNq6g=
Date: Wed, 29 Dec 2010 22:20:19 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 07/17] sched: Serialize p->cpus_allowed and ttwu()
 using p->pi_lock
Message-ID: <20101229142019.GB2728@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20101224122338.172750730@chello.nl>
 <20101224123742.833040935@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101224123742.833040935@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 01:23:45PM +0100, Peter Zijlstra wrote:
> Currently p->pi_lock already serializes p->sched_class, also put
> p->cpus_allowed and try_to_wake_up() under it, this prepares the way
> to do the first part of ttwu() without holding rq->lock.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2301,7 +2301,7 @@ void task_oncpu_function_call(struct tas
>  
>  #ifdef CONFIG_SMP
>  /*
> - * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
> + * ->cpus_allowed is protected by both rq->lock and p->pi_lock
>   */
>  static int select_fallback_rq(int cpu, struct task_struct *p)
>  {
> @@ -2334,7 +2334,7 @@ static int select_fallback_rq(int cpu, s
>  }
>  
>  /*
> - * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
> + * The caller (fork, wakeup) owns p->pi_lock, ->cpus_allowed is stable.

Yes for wakeup, but not true for fork.
I don't see protection in wake_up_new_task().
Or am I missing something?

Thanks,
Yong
