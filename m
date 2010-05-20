Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab0ETVJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:09:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:57227 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab0ETVJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:09:50 -0400
Subject: Re: [PATCH RFC] reduce runqueue lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, axboe@kernel.dk, linux-kernel@vger.kernel.org
In-Reply-To: <20100520204810.GA19188@think>
References: <20100520204810.GA19188@think>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 23:09:46 +0200
Message-ID: <1274389786.1674.1653.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 16:48 -0400, Chris Mason wrote:
> 
> This is more of a starting point than a patch, but it is something I've
> been meaning to look at for a long time.  Many different workloads end
> up hammering very hard on try_to_wake_up, to the point where the
> runqueue locks dominate CPU profiles.

Right, so one of the things that I considered was to make p->state an
atomic_t and replace the initial stage of try_to_wake_up() with
something like:

int try_to_wake_up(struct task *p, unsigned int mask, wake_flags)
{
  int state = atomic_read(&p->state);

  do {
    if (!(state & mask))
      return 0;

    state = atomic_cmpxchg(&p->state, state, TASK_WAKING);
  } while (state != TASK_WAKING);

  /* do this pending queue + ipi thing */

  return 1;
}

Also, I think we might want to put that atomic single linked list thing
into some header (using atomic_long_t or so), because I have a similar
thing living in kernel/perf_event.c, that needs to queue things from NMI
context.

The advantage of doing basically the whole enqueue on the remote cpu is
less cacheline bouncing of the runqueue structures.

