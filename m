Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2JDJAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:00:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:59111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2JDJAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:00:35 -0400
Message-ID: <1349341186.4438.1.camel@twins>
Subject: Re: [PATCH RFC 1/3] sched: introduce distinct per-cpu load average
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Oct 2012 10:59:46 +0200
In-Reply-To: <1349305512-3428-2-git-send-email-andrea@betterlinux.com>
References: <1349305512-3428-1-git-send-email-andrea@betterlinux.com>
	 <1349305512-3428-2-git-send-email-andrea@betterlinux.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 01:05 +0200, Andrea Righi wrote:
> +++ b/kernel/sched/core.c
> @@ -727,15 +727,17 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
>  void activate_task(struct rq *rq, struct task_struct *p, int flags)
>  {
>         if (task_contributes_to_load(p))
> -               rq->nr_uninterruptible--;
> +               cpu_rq(p->on_cpu_uninterruptible)->nr_uninterruptible--;
>  
>         enqueue_task(rq, p, flags);
>  }

That's completely broken, you cannot do non-atomic cross-cpu
modifications like that. Also, adding an atomic op to the wakeup/sleep
paths isn't going to be popular at all.

>  void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
>  {
> -       if (task_contributes_to_load(p))
> -               rq->nr_uninterruptible++;
> +       if (task_contributes_to_load(p)) {
> +               task_rq(p)->nr_uninterruptible++;
> +               p->on_cpu_uninterruptible = task_cpu(p);
> +       }
>  
>         dequeue_task(rq, p, flags);
>  } 

This looks pointless, at deactivate time task_rq() had better be rq or
something is terribly broken.
