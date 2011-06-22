Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab1FVSwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:52:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:43879 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab1FVSwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:52:50 -0400
Date: Wed, 22 Jun 2011 20:52:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] sched: Separate the scheduler entry for preemption
In-Reply-To: <20110622184328.GA6475@infradead.org>
Message-ID: <alpine.LFD.2.02.1106222047400.11814@ionos>
References: <20110622174659.496793734@linutronix.de> <20110622174918.813258321@linutronix.de> <20110622184328.GA6475@infradead.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Christoph Hellwig wrote:

> On Wed, Jun 22, 2011 at 05:52:13PM -0000, Thomas Gleixner wrote:
> > Block-IO and workqueues call into notifier functions from the
> > scheduler core code with interrupts and preemption disabled. These
> > calls should be made before entering the scheduler core.
> > 
> > To simplify this, separate the scheduler core code into
> > __schedule(). __schedule() is directly called from the places which
> > set PREEMPT_ACTIVE and from schedule(). This allows us to add the work
> > checks into schedule(), so they are only called when a task voluntary
> > goes to sleep.
> 
> I don't think that works.  We'll need to flush the block requests even
> for an involuntary schedule.

We don't do that right now as that code conditional on:

    if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {

Also blk_flush_plug_list() when called from io_schedule() is
preemptible, so you might be preempted in the middle of the list
operations, so calling into it when preempted would result in an utter
disaster.

Thanks,

	tglx

