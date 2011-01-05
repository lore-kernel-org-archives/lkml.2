Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1AESyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 13:54:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1AESyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 13:54:31 -0500
Date: Wed, 5 Jan 2011 19:46:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/18] sched: Add p->pi_lock to task_rq_lock()
Message-ID: <20110105184644.GA28306@redhat.com>
References: <20110104145929.772813816@chello.nl> <20110104150102.862431889@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104150102.862431889@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04, Peter Zijlstra wrote:
>
> This makes task_rq_lock() acquire both locks, and have
> __task_rq_lock() validate that p->pi_lock is held.

... and kills task_is_waking(), good ;)

So TASK_WAKING is only means "do not try to wakeup", this greatly
simplifies things.

One purely cosmetic nit,

> @@ -4902,8 +4898,7 @@ static int __sched_setscheduler(struct t
>
>  		check_class_changed(rq, p, prev_class, oldprio, running);
>  	}
> -	__task_rq_unlock(rq);
> -	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> +	task_rq_unlock(rq, p, &flags);

__sched_setscheduler() has a couple more instances of

	__task_rq_unlock(rq);
	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
	return EXXX;

above.

> @@ -5691,8 +5685,7 @@ int set_cpus_allowed_ptr(struct task_str
>  		return 0;
>  	}
>  out:
> -	__task_rq_unlock(rq);
> -	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> +	task_rq_unlock(rq, p, &flags);

the same.


Hmm, and normalize_rt_tasks(), it could just do task_rq_lock/task_rq_unlock.
And why it does read_lock_irqsave(tasklist), btw? _irqsave looks unneeded.

Oleg.

