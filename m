Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab1DUGuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:50:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44473 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab1DUGuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tnp0s21PHN61o5B4Wz6NrJ6+mrLb0Jlb+ck6KiYcq6nO9wgRcFRtPVtEgcKqt3cfHv
         Q0CBp+WlrrivXVSi/6EAlZcKAFWaOpGJbWW5EqMAeSL2TnBC03KDvb25QjPD1NRtwp5a
         0DiLt/rAkyxMJMcnK/xzAMwciT2H/UcBmHme0=
MIME-Version: 1.0
In-Reply-To: <20110421014300.727863282@goodmis.org>
References: <20110421014153.126662477@goodmis.org>
	<20110421014300.727863282@goodmis.org>
Date: Thu, 21 Apr 2011 14:50:12 +0800
Message-ID: <BANLkTinrHGbGikVxLUnJohS3w8AZ-pV5Ww@mail.gmail.com>
Subject: Re: [PATCH 7/7] lockdep: Remove cmpxchg to update nr_chain_hlocks
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 9:42 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> For some reason nr_chain_hlocks is updated with cmpxchg, but this
> is performed inside of the lockdep global "grab_lock()", which also
> makes simple modification of this variable atomic.
>
> Remove the cmpxchg logic for updating nr_chain_hlocks and simplify
> the code.
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/lockdep.c |   14 ++++----------
>  1 files changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 3b1ac92..60bce52 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -1973,7 +1973,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
>        struct list_head *hash_head = chainhashentry(chain_key);
>        struct lock_chain *chain;
>        struct held_lock *hlock_curr, *hlock_next;

Maybe we can also remove hlock_next in this function for some cleanup, because
it's just an alias of hlock.

Thanks,
Yong

> -       int i, j, n, cn;
> +       int i, j;
>
>        if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
>                return 0;
> @@ -2033,15 +2033,9 @@ cache_hit:
>        }
>        i++;
>        chain->depth = curr->lockdep_depth + 1 - i;
> -       cn = nr_chain_hlocks;
> -       while (cn + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS) {
> -               n = cmpxchg(&nr_chain_hlocks, cn, cn + chain->depth);
> -               if (n == cn)
> -                       break;
> -               cn = n;
> -       }
> -       if (likely(cn + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS)) {
> -               chain->base = cn;
> +       if (likely(nr_chain_hlocks + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS)) {
> +               chain->base = nr_chain_hlocks;
> +               nr_chain_hlocks += chain->depth;
>                for (j = 0; j < chain->depth - 1; j++, i++) {
>                        int lock_id = curr->held_locks[i].class_idx - 1;
>                        chain_hlocks[chain->base + j] = lock_id;
> --
> 1.7.2.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
