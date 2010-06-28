Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0F1Nzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:55:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39957 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab0F1Nz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:55:29 -0400
Subject: Re: [PATCH] avoid return NULL on root rb_node in rb_next/rb_prev
 in lib/rbtree.c
From: Peter Zijlstra <peterz@infradead.org>
To: shenghui <crosslonelyover@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, linux-mm@kvack.org, mingo@elte.hu
In-Reply-To: <AANLkTilJDrpoFGyTSrKg3Hg59u9TvBLbxk4HAVKBvjxQ@mail.gmail.com>
References: <AANLkTilJDrpoFGyTSrKg3Hg59u9TvBLbxk4HAVKBvjxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Jun 2010 15:55:20 +0200
Message-ID: <1277733320.3561.50.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 21:17 +0800, shenghui wrote:
> Hi,
> 
>        I'm reading cfs code, and get the following potential bug.
> 
> In kernel/sched_fair.c, we can get the following call thread:
> 
> 1778static struct task_struct *pick_next_task_fair(struct rq *rq)
> 1779{
> ...
> 1787        do {
> 1788                se = pick_next_entity(cfs_rq);
> 1789                set_next_entity(cfs_rq, se);
> 1790                cfs_rq = group_cfs_rq(se);
> 1791        } while (cfs_rq);
> ...
> 1797}
> 
>  925static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
>  926{
>  927        struct sched_entity *se = __pick_next_entity(cfs_rq);
> ...
>  941        return se;
>  942}
> 
>  377static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
>  378{
>  379        struct rb_node *left = cfs_rq->rb_leftmost;
>  380
>  381        if (!left)
>  382                return NULL;
>  ...
>  385}
> 
> To manipulate cfs_rq->rb_leftmost, __dequeue_entity does the following:
> 
>  365static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  366{
>  367        if (cfs_rq->rb_leftmost == &se->run_node) {
>  368                struct rb_node *next_node;
>  369
>  370                next_node = rb_next(&se->run_node);
>  371                cfs_rq->rb_leftmost = next_node;
>  372        }
>  373
>  374        rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
>  375}
> 
> Here, if se->run_node is the root rb_node, next_node will be set NULL
> by rb_next.
> Then __pick_next_entity may get NULL on some call, and set_next_entity
> may deference
> NULL value.

So if ->rb_leftmost is NULL, then the if (!left) check in
__pick_next_entity() would return null.

As to the NULL deref in in pick_next_task_fair()->set_next_entity() that
should never happen because pick_next_task_fair() will bail
on !->nr_running.

Furthermore, you've failed to mention what kernel version you're looking
at.
