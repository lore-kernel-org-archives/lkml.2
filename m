Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1EWHn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:43:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38610 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751485Ab1EWHnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:43:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19y+a0hd79ywUJsY+5Dl/MChgLgO38SUPtXTNXHFM
	uTwoS6qyg1vQuh
Subject: Re: question about blk_schedule_flush_plug
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, mingo@elte.hu,
        peterz@infradead.org
In-Reply-To: <201105231705.20168.kernel@kolivas.org>
References: <201105231705.20168.kernel@kolivas.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 09:43:49 +0200
Message-ID: <1306136629.4876.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 17:05 +1000, Con Kolivas wrote:
> I was looking at the scheduler changes going into 2.6.39 again and wondered 
> about the use of blk_schedule_flush_plug smack in the middle of schedule()
> 
> It looks like this:
> 			if (blk_needs_flush_plug(prev)) {
> 				raw_spin_unlock(&rq->lock);
> 				blk_schedule_flush_plug(prev);
> 				raw_spin_lock(&rq->lock);
> 			}
> 
> Now call me suspicious but to my eyes it looks really dubious unlocking the 
> runqueue like that right in the heart of schedule().
> 
> Comments?

Releasing/retaking rq->lock is nothing new:

static void idle_balance(int this_cpu, struct rq *this_rq)
{
...
        /*
         * Drop the rq->lock, but keep IRQ/preempt disabled.
         */
        raw_spin_unlock(&this_rq->lock);

See also need_resched, and double_lock_balance() instances.

	-Mike

