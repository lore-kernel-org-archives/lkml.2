Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2CMKvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:51:48 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50203 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757707Ab2CMKvq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:51:46 -0400
MIME-Version: 1.0
In-Reply-To: <1331597724-31358-8-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
	<1331597724-31358-8-git-send-email-paul.gortmaker@windriver.com>
Date: Tue, 13 Mar 2012 11:51:44 +0100
Message-ID: <CABPqkBRSYH7YiTZUug0RaQgwoCYhiMWa6=0QY7hdpjsE0h84EA@mail.gmail.com>
Subject: Re: [34-longterm 007/196] perf: Better fit max unprivileged mlock
 pages for tools needs
From: Stephane Eranian <eranian@google.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 1:12 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
>
>                   -------------------
>    This is a commit scheduled for the next v2.6.34 longterm release.
>    If you see a problem with using this for longterm, please comment.
>                   -------------------
>
> commit 880f57318450dbead6a03f9e31a1468924d6dd88 upstream.
>
> The maximum kilobytes of locked memory that an unprivileged user
> can reserve is of 512 kB = 128 pages by default, scaled to the
> number of onlined CPUs, which fits well with the tools that use
> 128 data pages by default.
>
> However tools actually use 129 pages, because they need one more
> for the user control page. Thus the default mlock threshold is
> not sufficient for the default tools needs and we always end up
> to evaluate the constant mlock rlimit policy, which doesn't have
> this scaling with the number of online CPUs.
>
> Hence, on systems that have more than 16 CPUs, we overlap the
> rlimit threshold and fail to mmap:
>
>        $ perf record ls
>        Error: failed to mmap with 1 (Operation not permitted)
>
But isn't that simply coming from the fact that perf chose to request
128 pages by default? I don't know how this size was chosen. If perf
were to allocate 127 (data) pages, you would not have that problem
with the current default limit, would you?


> Just increase the max unprivileged mlock threshold by one page
> so that it supports well perf tools even after 16 CPUs.
>
> Reported-by: Han Pingtian <phan@redhat.com>
> Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> LKML-Reference: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  kernel/perf_event.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 2357b19..b203546 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -57,7 +57,8 @@ static atomic_t nr_task_events __read_mostly;
>  */
>  int sysctl_perf_event_paranoid __read_mostly = 1;
>
> -int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
> +/* Minimum for 128 pages + 1 for the user control page */
> +int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
>
>  /*
>  * max perf event sample rate
> --
> 1.7.9.3
>
