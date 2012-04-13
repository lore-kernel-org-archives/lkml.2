Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635Ab2DMJl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:41:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:40817 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934017Ab2DMJl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:41:57 -0400
Date: Fri, 13 Apr 2012 11:41:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] genirq: reimplement exit_irq_thread() hook via
 task_work_queue()
In-Reply-To: <20120412211248.GC30456@redhat.com>
Message-ID: <alpine.LFD.2.02.1204131139450.2542@ionos>
References: <20120412211146.GA30448@redhat.com> <20120412211248.GC30456@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, Oleg Nesterov wrote:

> exit_irq_thread() and task->irq_thread are needed to handle
> the unexpected (and unlikely) exit of irq-thread.
> 
> We can use task_work instead and make this all private to
> kernel/irq/manage.c, simplification plus micro-optimization.
> 
> 1. rename exit_irq_thread() to irq_thread_dtor(), make it
>    static, and move it up before irq_thread().
> 
> 2. change irq_thread() to do task_queue_work(irq_thread_dtor)
>    at the start and task_work_cancel() before return.
> 
>    tracehook_notify_resume() can never play with kthreads,
>    only do_exit()->exit_task_work() can call the callback
>    and this is what we want.
> 
> 3. remove task_struct->irq_thread and the special hook
>    in do_exit().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/linux/interrupt.h |    4 --
>  include/linux/sched.h     |   10 +-----
>  kernel/exit.c             |    2 -
>  kernel/irq/manage.c       |   69 +++++++++++++++++++++-----------------------
>  4 files changed, 35 insertions(+), 50 deletions(-)

Nice cleanup.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
