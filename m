Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0FIJtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:49:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53641 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab0FIJtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:49:15 -0400
Date: Wed, 9 Jun 2010 11:48:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Salman <sqazi@google.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: peterz@infradead.org, akpm@inux-foundation.org,
       linux-kernel@vger.kernel.org, tytso@google.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100609094850.GA23292@elte.hu>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2631]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Salman <sqazi@google.com> wrote:

> A program that repeatedly forks and waits is susceptible to having the
> same pid repeated, especially when it competes with another instance of the
> same program.  This is really bad for bash implementation.  Furthermore, many shell
> scripts assume that pid numbers will not be used for some length of time.
> 
> Thanks to Ted Tso for the key ideas of this implementation.
> 
> Signed-off-by: Salman Qazi <sqazi@google.com>
> ---
>  kernel/pid.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index e9fd8c1..8cedeab 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -153,8 +153,17 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>  		if (likely(atomic_read(&map->nr_free))) {
>  			do {
>  				if (!test_and_set_bit(offset, map->page)) {
> +					int prev;
>  					atomic_dec(&map->nr_free);
> -					pid_ns->last_pid = pid;
> +
> +					do {
> +						prev = last;
> +						last = cmpxchg(&pid_ns->last_pid,
> +							       prev, pid);
> +						if (last >= pid)
> +							break;
> +					} while (prev != last);
> +
>  					return pid;
>  				}
>  				offset = find_next_offset(map, offset);

Looks rather interesting. (Cleanliness-wise i'd suggest to split out the while 
loop into a helper function.)

	Ingo
