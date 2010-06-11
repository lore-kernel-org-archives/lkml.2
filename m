Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306Ab0FKOhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 10:37:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759700Ab0FKOhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 10:37:04 -0400
Date: Fri, 11 Jun 2010 16:35:26 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] thread_group_cputime: simplify, document the
	"alive" check
Message-ID: <20100611143525.GA2586@dhcp-lab-161.englab.brq.redhat.com>
References: <20100610230956.GA25921@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610230956.GA25921@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 01:09:56AM +0200, Oleg Nesterov wrote:
> thread_group_cputime() looks as if it is rcu-safe, but in fact this
> was wrong until ea6d290c which pins task->signal to task_struct.
> It checks ->sighand != NULL under rcu, but this can't help if ->signal
> can go away. Fortunately the caller either holds ->siglock, or it is
> fastpath_timer_check() which uses current and checks exit_state == 0.

Hmm, I thought we avoided calling thread_group_cputime() from
fastpatch_timer_check(), but seems it is still possible when we
call run_posix_cpu_timers() on two different cpus simultaneously ...

> - Since ea6d290c commit tsk->signal is stable, we can read it first
>   and avoid the initialization from INIT_CPUTIME.
> 
> - Even if tsk->signal is always valid, we still have to check it
>   is safe to use next_thread() under rcu_read_lock(). Currently
>   the code checks ->sighand != NULL, change it to use pid_alive()
>   which is commonly used to ensure the task wasn't unhashed before
>   we take rcu_read_lock().

I'm not sure how important are values of almost dead task, but
perhaps would be better to return times form all threads
using as base sig->curr_target in loop.

Stanislaw
