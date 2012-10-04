Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2JDJn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:43:57 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:51932 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2JDJn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:43:56 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com AEBD28217D
Date: Thu, 4 Oct 2012 11:43:49 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/3] sched: introduce distinct per-cpu load average
Message-ID: <20121004094349.GA2163@thinkpad>
References: <1349305512-3428-1-git-send-email-andrea@betterlinux.com>
 <1349305512-3428-2-git-send-email-andrea@betterlinux.com>
 <1349341186.4438.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349341186.4438.1.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 10:59:46AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-10-04 at 01:05 +0200, Andrea Righi wrote:
> > +++ b/kernel/sched/core.c
> > @@ -727,15 +727,17 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
> >  void activate_task(struct rq *rq, struct task_struct *p, int flags)
> >  {
> >         if (task_contributes_to_load(p))
> > -               rq->nr_uninterruptible--;
> > +               cpu_rq(p->on_cpu_uninterruptible)->nr_uninterruptible--;
> >  
> >         enqueue_task(rq, p, flags);
> >  }
> 
> That's completely broken, you cannot do non-atomic cross-cpu
> modifications like that. Also, adding an atomic op to the wakeup/sleep
> paths isn't going to be popular at all.

Right, the update must be atomic to have a coherent nr_uninterruptible
value. And AFAICS the only way to account a coherent nr_uninterruptible
value per-cpu is to go with atomic ops... mmh... I'll think more on
this.

> 
> >  void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
> >  {
> > -       if (task_contributes_to_load(p))
> > -               rq->nr_uninterruptible++;
> > +       if (task_contributes_to_load(p)) {
> > +               task_rq(p)->nr_uninterruptible++;
> > +               p->on_cpu_uninterruptible = task_cpu(p);
> > +       }
> >  
> >         dequeue_task(rq, p, flags);
> >  } 
> 
> This looks pointless, at deactivate time task_rq() had better be rq or
> something is terribly broken.

Correct, I didn't realize that, sorry.

Many thanks for your review, Peter.

-Andrea
