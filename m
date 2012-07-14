Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2GNEor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 00:44:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38171 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2GNEoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 00:44:44 -0400
Date: Fri, 13 Jul 2012 21:44:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joshhunt00@gmail.com, axboe@kernel.dk,
        rni@google.com, vgoyal@redhat.com, vwadekar@nvidia.com,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, swhiteho@redhat.com, bpm@sgi.com,
        elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 5/6] workqueue: introduce NR_WORKER_POOLS and
 for_each_worker_pool()
Message-ID: <20120714044438.GA7718@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
 <1341859315-17759-6-git-send-email-tj@kernel.org>
 <20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Fri, Jul 13, 2012 at 09:27:03PM -0700, Linus Torvalds wrote:
> Seeing code like this
> 
> +       return &(*nr_running)[0];
> 
> just makes me go "WTF?"

I was going WTF too.  This was the smallest fix and I wanted to make
it minimal because there's another stack of patches on top of it.
Planning to just fold nr_running into worker_pool afterwards which
will remove the whole function.

> Why are you taking the address of something you just dereferenced (the
> "& [0]" part).

nr_running is atomic_t (*nr_running)[2].  Ignoring the pointer to
array part, it's just returning the address of N'th element of the
array.  ARRAY + N == &ARRAY[N].

> And you actually do that *twice*, except the inner one is more
> complicated. When you assign nr_runing, you take the address of it, so
> the "*nr_running" is actually just the same kind of odd thing (except
> in reverse - you take dereference something you just took the
> address-of).
> 
> Seriously, this to me is a sign of *deeply* confused code. And the
> fact that your first version of that code was buggy *EXACTLY* due to
> this confusion should have made you take a step back.

Type-wise, I don't think it's confused.  Ah okay, you're looking at
the fifth patch in isolation.  Upto this point, the index is always 0.
I'm puttin it in as a placeholder for the next patch which makes use
of non-zero index.  This patch is supposed to prepare everything for
multiple pools and thus non-zero index.

> As far as I can tell, what you actually want that function to do is:
> 
>   static atomic_t *get_pool_nr_running(struct worker_pool *pool)
>   {
>     int cpu = pool->gcwq->cpu;
> 
>     if (cpu != WORK_CPU_UNBOUND)
>         return per_cpu(pool_nr_running, cpu);
> 
>     return unbound_pool_nr_running;
>   }

More like the folloiwng in the end.

static atomic_t *get_pool_nr_running(struct worker_pool *pool)
{
	int cpu = pool->gcwq->cpu;
	int is_highpri = pool_is_highpri(pool);

	if (cpu != WORK_CPU_UNBOUND)
		return &per_cpu(pool_nr_running, cpu)[is_highpri];

	return &unbound_pool_nr_running[is_highpri];
}

> I didn't test the code, btw. I just looked at the patch and went WTF.

Eh... yeah, with or without [2], this is WTF.  I'll just refresh it
with the above version.

Thanks.

-- 
tejun
