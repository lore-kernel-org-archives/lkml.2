Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab1CWSiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:38:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab1CWSiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:38:51 -0400
Date: Wed, 23 Mar 2011 15:38:12 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Han Pingtian <phan@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, Stable <stable@kernel.org>
Subject: Re: [PATCH] perf: Better fit max unprivileged mlock pages for
	tools needs
Message-ID: <20110323183812.GB30553@ghostprotocols.net>
References: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 23, 2011 at 07:29:39PM +0100, Frederic Weisbecker escreveu:
> The maximum kilobytes of locked memory that an unprivileged user can
> reserve is of 512 kB = 128 pages by default, scaled to the number of
> onlined CPUs, which fits well with the tools that use 128 data pages
> by default.
> 
> However tools actually use 129 pages, because they need one more for
> the user control page. Thus the default mlock threshold is not
> sufficient for the default tools needs and we always end up to
> evaluate the constant mlock rlimit policy, which doesn't have this
> scaling with the number of online CPUs.
> 
> Hence, on systems that have more than 16 CPUs, we overlap the rlimit
> threshold and fail to mmap:
> 
> 	$ perf record ls
> 	Error: failed to mmap with 1 (Operation not permitted)
> 
> Just increase the max unprivileged mlock threshold by one page so
> that it supports well perf tools even after 16 CPUs.

Thanks!

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
 
> Reported-by: Han Pingtian <phan@redhat.com>
> Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Stable <stable@kernel.org>
> ---
>  kernel/perf_event.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 3472bb1..d5943b0 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -145,7 +145,8 @@ static struct srcu_struct pmus_srcu;
>   */
>  int sysctl_perf_event_paranoid __read_mostly = 1;
>  
> -int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
> +/* Minimum for 128 pages + 1 for the user control page */
> +int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
>  
>  /*
>   * max perf event sample rate
> -- 
> 1.7.3.2
