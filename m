Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0FNX7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:59:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856Ab0FNX7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:59:52 -0400
Date: Mon, 14 Jun 2010 16:58:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salman <sqazi@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
       tytso@google.com, torvalds@linux-foundation.org, walken@google.com,
       Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-Id: <20100614165851.6bdfe485.akpm@linux-foundation.org>
In-Reply-To: <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
	<20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 15:49:54 -0700
Salman <sqazi@google.com> wrote:

> A program that repeatedly forks and waits is susceptible to having the
> same pid repeated, especially when it competes with another instance of the
> same program.  This is really bad for bash implementation.  Furthermore,
> many shell scripts assume that pid numbers will not be used for some length
> of time.
> 
> Race Description:
>
> ...
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index e9fd8c1..fbbd5f6 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -122,6 +122,43 @@ static void free_pidmap(struct upid *upid)
>  	atomic_inc(&map->nr_free);
>  }
>  
> +/*
> + * If we started walking pids at 'base', is 'a' seen before 'b'?
> + */
> +static int pid_before(int base, int a, int b)
> +{
> +	/*
> +	 * This is the same as saying
> +	 *
> +	 * (a - base + MAXUINT) % MAXUINT < (b - base + MAXUINT) % MAXUINT
> +	 * and that mapping orders 'a' and 'b' with respect to 'base'.
> +	 */
> +	return (unsigned)(a - base) < (unsigned)(b - base);
> +}

pid.c uses an exotic mix of `int' and `pid_t' to represent pids.  `int'
seems to preponderate.

> +/*
> + * We might be racing with someone else trying to set pid_ns->last_pid.
> + * We want the winner to have the "later" value, because if the
> + * "earlier" value prevails, then a pid may get reused immediately.
> + *
> + * Since pids rollover, it is not sufficient to just pick the bigger
> + * value.  We have to consider where we started counting from.
> + *
> + * 'base' is the value of pid_ns->last_pid that we observed when
> + * we started looking for a pid.
> + *
> + * 'pid' is the pid that we eventually found.
> + */
> +static void set_last_pid(struct pid_namespace *pid_ns, int base, int pid)
> +{
> +	int prev;
> +	int last_write = base;
> +	do {
> +		prev = last_write;
> +		last_write = cmpxchg(&pid_ns->last_pid, prev, pid);
> +	} while ((prev != last_write) && (pid_before(base, last_write, pid)));
> +}

<gets distracted>

hm.  For a long time cmpxchg() wasn't available on all architectures. 
That _seems_ to have been fixed.

arch/score assumes that cmpxchg() operates on unsigned longs.

arch/powerpc plays the necessary games to make 4- and 8-byte scalars work.

ia64 handles 1, 2, 4 and 8-byte quantities.

arm handles 1, 2 and 4-byte scalars.

as does blackfin.

So from the few architectures I looked at, it seems that we do indeed
handle cmpxchg() on all architectures although not very consistently. 
arch/score will blow up if someone tries to use cmpxchg() on 1- or
2-byte scalars.

<looks at the consumers>

infiniband deos cmpxchg() on u64*'s, which will blow up on many
architectures.

Using

	grep -r '[ 	]cmpxchg[^_]' . | grep -v /arch/

I can't see any cmpxchg() callers in truly generic code.  lockdep and
kernel/trace/ring_buffer.c aren't used on the more remote
architectures, I think.

Traditionally, atomic_cmpxchg() was the safe and portable one to use.


