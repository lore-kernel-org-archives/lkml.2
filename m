Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1GSVNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 17:13:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:36783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1GSVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:13:42 -0400
Subject: Re: [PATCH 2/2] sched: Fix "divide error: 0000" in
 find_busiest_group
From: Peter Zijlstra <peterz@infradead.org>
To: Terry Loftin <terry.loftin@hp.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Bob Montgomery <bob.montgomery@hp.com>
In-Reply-To: <4E25F009.1040309@hp.com>
References: <4E25F009.1040309@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 23:18:10 +0200
Message-ID: <1311110290.2617.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 14:58 -0600, Terry Loftin wrote:
> Add a check to sched_avg_update() to detect and reset age_stamp if the
> clock value has wrapped.  Because __cycles_2_ns() includes an offset
> to account for start up time, the clock may not wrap to zero, so use
> the current clock value instead.

So you're running on a platform (unspecified) where we use a raw
sched_clock() that is buggy. Again, you're fixing symptoms not causes. 

> Signed-off-by: Terry Loftin <terry.loftin@hp.com>
> Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 18d38e4..b39cae1 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1256,6 +1256,8 @@ static void sched_avg_update(struct rq *rq)
>  {
>  	s64 period = sched_avg_period();
> 
> +	if (unlikely(rq->age_stamp > rq->clock))
> +		rq->age_stamp = rq->clock;
>  	while ((s64)(rq->clock - rq->age_stamp) > period) {
>  		/*
>  		 * Inline assembly required to prevent the compiler



