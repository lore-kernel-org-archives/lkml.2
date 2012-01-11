Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2AKR32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:29:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:46493 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab2AKR3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:29:24 -0500
Message-ID: <1326302955.2442.174.camel@twins>
Subject: Re: [Question] sched: Should nr_uninterruptible be decremented in
 ttwu_do_activate()?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jan 2012 18:29:15 +0100
In-Reply-To: <CADZ9YHicin2YjGm_m9B0LMv3NW1Z3cb7HSCaqwycFmVfRpvpWA@mail.gmail.com>
References: <CADZ9YHicin2YjGm_m9B0LMv3NW1Z3cb7HSCaqwycFmVfRpvpWA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 23:22 +0600, Rakib Mullick wrote:
> Hello all,
> 
> In ttwu_do_activate(), we're decrementing nr_uninterruptible if
> p->sched_contributes_to_load (for SMP=y). But, we're also decrementing
> nr_uninterruptible from activate_task at the same path. Why we're
> doing it twice for a single task activation path?

activate_task() does:

 if (task_contributes_to_load(p))
   rq->nr_uninterruptible--;

Now task_contributes_to_load() reads like:

#define task_contributes_to_load(task)	\
				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
				 (task->flags & PF_FREEZING) == 0)

which will be false, since we've set TASK_WAKING.
