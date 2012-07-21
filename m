Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2GUKkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 06:40:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59232 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2GUKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 06:40:41 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/11] perf tool: give user better message if precise is not supported
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
	<1342826756-64663-11-git-send-email-dsahern@gmail.com>
Date: Sat, 21 Jul 2012 19:40:33 +0900
In-Reply-To: <1342826756-64663-11-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Fri, 20 Jul 2012 17:25:55 -0600")
Message-ID: <87y5mdqtwe.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

On Fri, 20 Jul 2012 17:25:55 -0600, David Ahern wrote:
> If the PEBS is not supported (e.g., a VM) and the precise modifier is
> set the user is given a confusing error message:
>
>   $ perf top -e cycles:p
>
>   The sys_perf_event_open() syscall returned with 95 (Operation not supported).
> /bin/dmesg may provide additional information.
>   No CONFIG_PERF_EVENTS=y kernel support configured?
>
>   $ perf record -e cycles:p -a -- sleep 1
>
>   Error: sys_perf_event_open() syscall returned with 95 (Operation not
> supported).  /bin/dmesg may provide additional information.
>
>   Fatal: No hardware sampling interrupt available. No APIC? If so then you can
> boot the kernel with the "lapic" boot parameter to force-enable it.
>
> Which in no way conveys the real error. With this patch:
>   $ perf top -e cycles:p
>   PEBS request not supported. Try removing 'p' modifier
>
>   $ perf record -e cycles:p -a -- sleep 1
>   PEBS request not supported. Try removing 'p' modifier
>

The name 'PEBS' is intel-specific, so shouldn't we try to avoid using it
directly? How about this:

    Precise event sampling is not supported. Try removing 'p' modifier

Thanks,
Namhyung


> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  tools/perf/builtin-record.c |    4 ++++
>  tools/perf/builtin-top.c    |    4 ++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index f5a6452..911e300 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -267,6 +267,10 @@ try_again:
>  				ui__error("The %s event is not supported.\n",
>  					  perf_evsel__name(pos));
>  				exit(EXIT_FAILURE);
> +			} else if ((err == ENOTSUP) && (attr->precise_ip)) {
> +				ui__error("PEBS request not supported. "
> +					  "Try removing 'p' modifier\n");
> +				exit(EXIT_FAILURE);
>  			}
>  
>  			printf("\n");
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 0ce665c..1706dc9 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -968,6 +968,10 @@ try_again:
>  				ui__error("Too many events are opened.\n"
>  					    "Try again after reducing the number of events\n");
>  				goto out_err;
> +			} else if ((err == ENOTSUP) && (attr->precise_ip)) {
> +				ui__error("PEBS request not supported. "
> +					    "Try removing 'p' modifier\n");
> +				goto out_err;
>  			}
>  
>  			ui__error("The sys_perf_event_open() syscall "
