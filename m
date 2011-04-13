Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab1DMLEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 07:04:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:35842 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab1DMLEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:04:11 -0400
Subject: Re: [PATCH 04/21] sched: Change the ttwu success details
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
In-Reply-To: <1302691703.2035.10.camel@laptop>
References: <20110405152338.692966333@chello.nl>
	 <20110405152728.866866929@chello.nl>  <1302686630.2388.125.camel@twins>
	 <1302691703.2035.10.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 13:06:39 +0200
Message-ID: <1302692799.2035.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 12:48 +0200, Peter Zijlstra wrote:
> On Wed, 2011-04-13 at 11:23 +0200, Peter Zijlstra wrote:
> > and workqueue wakeups, and I doubt extra wakeups will cause lockups. 
> 
> Damn assumptions ;-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2447,7 +2447,7 @@ static inline void ttwu_post_activation(
>  	}
>  #endif
>  	/* if a worker is waking up, notify workqueue */
> -	if ((p->flags & PF_WQ_WORKER) && success)
> +	if (p->flags & PF_WQ_WORKER)
>  		wq_worker_waking_up(p, cpu_of(rq));
>  }
>  
> 
> Appears to be sufficient to cause the lockup, so somehow the whole
> workqueue stuff relies on the fact that waking a TASK_(UN)INTERRUPTIBLE
> task that hasn't been dequeued yet isn't a wakeup.
> 
> Tejun any quick clues as to why and how to cure this?
> 
> /me goes read that stuff

OK, so wq_worker_waking_up() does an atomic_inc() that wants to be
balanced against the atomic_dec() in wq_worker_sleeping(), which is only
called when we dequeue things.


