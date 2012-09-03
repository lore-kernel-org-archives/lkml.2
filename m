Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab2ICBwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 21:52:42 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60037 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab2ICBwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 21:52:40 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-74-50440d66142d
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf bench: fix assert when NDEBUG is defined
References: <CANg8OWLL6gzUpZuq8YT2bSbT5=EVWejbpCX0TM8dt7mKXyZ9Yg@mail.gmail.com>
Date: Mon, 03 Sep 2012 10:45:03 +0900
In-Reply-To: <CANg8OWLL6gzUpZuq8YT2bSbT5=EVWejbpCX0TM8dt7mKXyZ9Yg@mail.gmail.com>
	(Irina Tirdea's message of "Mon, 3 Sep 2012 03:04:32 +0300")
Message-ID: <87txvfev6o.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Sep 2012 03:04:32 +0300, Irina Tirdea wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
>
> When NDEBUG is defined, the assert macro will be expanded to nothing.
> Some assert calls used in perf are also including some functionality
> (e.g. system calls), not only validity checks. Therefore, if NDEBUG is
> defined, these functionality will be removed along with the assert.
>
> The functionality of the program needs to be separated from the assert checks.
> In perf, BUG_ON is also defined on assert, so we need to fix these statements
> too.
>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  tools/perf/bench/mem-memcpy.c |    8 +++++---
>  tools/perf/bench/mem-memset.c |    8 +++++---
>  tools/perf/bench/sched-pipe.c |    6 ++++--
>  3 files changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
> index 02dad5d..bccb783 100644
> --- a/tools/perf/bench/mem-memcpy.c
> +++ b/tools/perf/bench/mem-memcpy.c
> @@ -144,17 +144,19 @@ static double do_memcpy_gettimeofday(memcpy_t
> fn, size_t len, bool prefault)
>  {
>  	struct timeval tv_start, tv_end, tv_diff;
>  	void *src = NULL, *dst = NULL;
> -	int i;
> +	int i, ret;
>
>  	alloc_mem(&src, &dst, len);
>
>  	if (prefault)
>  		fn(dst, src, len);
>
> -	BUG_ON(gettimeofday(&tv_start, NULL));
> +	ret = gettimeofday(&tv_start, NULL);
> +	BUG_ON(ret);

I think one of good thing of assert is that it outputs the exact failure
condition when it fails.  So with patch, it will convert

  Assertion `gettimeofday(&tv_start, NULL)' failed.

into

  Assertion `ret' failed.

which is not so informative.

So I'd rather suggest using more descriptive names like ret_gtod ?


>  	for (i = 0; i < iterations; ++i)
>  		fn(dst, src, len);
> -	BUG_ON(gettimeofday(&tv_end, NULL));
> +	ret = gettimeofday(&tv_end, NULL);
> +	BUG_ON(ret);
>
>  	timersub(&tv_end, &tv_start, &tv_diff);
>
> diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
> index 350cc95..e0702d2 100644
> --- a/tools/perf/bench/mem-memset.c
> +++ b/tools/perf/bench/mem-memset.c
> @@ -139,17 +139,19 @@ static double do_memset_gettimeofday(memset_t
> fn, size_t len, bool prefault)
>  {
>  	struct timeval tv_start, tv_end, tv_diff;
>  	void *dst = NULL;
> -	int i;
> +	int i, ret;
>
>  	alloc_mem(&dst, len);
>
>  	if (prefault)
>  		fn(dst, -1, len);
>
> -	BUG_ON(gettimeofday(&tv_start, NULL));
> +	ret = gettimeofday(&tv_start, NULL);
> +	BUG_ON(ret);
>  	for (i = 0; i < iterations; ++i)
>  		fn(dst, i, len);
> -	BUG_ON(gettimeofday(&tv_end, NULL));
> +	ret = gettimeofday(&tv_end, NULL);
> +	BUG_ON(ret);

Ditto.


>
>  	timersub(&tv_end, &tv_start, &tv_diff);
>
> diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
> index 0c7454f..b35c94b 100644
> --- a/tools/perf/bench/sched-pipe.c
> +++ b/tools/perf/bench/sched-pipe.c
> @@ -61,8 +61,10 @@ int bench_sched_pipe(int argc, const char **argv,
>  	argc = parse_options(argc, argv, options,
>  			     bench_sched_pipe_usage, 0);
>
> -	assert(!pipe(pipe_1));
> -	assert(!pipe(pipe_2));
> +	ret = pipe(pipe_1);
> +	assert(!ret);
> +	ret = !pipe(pipe_2);
> +	assert(!ret);

What about converting these raw assert's to BUG_ONs (with negating the
conditions) for consistency?

Thanks,
Namhyung


>
>  	pid = fork();
>  	assert(pid >= 0);
