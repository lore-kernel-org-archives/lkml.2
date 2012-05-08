Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2EHNMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:12:13 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52019 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2EHNML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:12:11 -0400
Date: Tue, 8 May 2012 10:12:07 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] perf record: fix fallback to cpu-clock on ppc
Message-ID: <20120508131207.GG2485@infradead.org>
References: <1336452004-55724-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336452004-55724-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 07, 2012 at 10:40:04PM -0600, David Ahern escreveu:
> perf-record on PPC is not falling back to cpu-clock:
> 
> Old kernel, cannot exclude guest or host samples.
> 
>   Error: sys_perf_event_open() syscall returned with 6 (No such device or address).  /bin/dmesg may provide additional information.
> 
>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> The problem is that until 2.6.37 (behavior changed with commit b0a873e)
> perf on PPC returns ENXIO when hw_perf_event_init() fails. With this
> patch we get the expected behavior:
> 
> Old kernel, cannot exclude guest or host samples.
> The cycles event is not supported, trying to fall back to cpu-clock-ticks
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.150 MB /tmp/perf.data (~6569 samples) ]

Would be good to have this documented on the spot, i.e. just before that
if.

Also, have you checked that 'perf stat' and 'perf top' works as well? We
really need to move all this logic to a central place, namely
perf_evlist__open().

For now checking if stat and top ara ok should be enough.

- Arnaldo
 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/builtin-record.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 42e2414..080c708 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -244,7 +244,8 @@ try_again:
>  			 * based cpu-clock-tick sw counter, which
>  			 * is always available even if no PMU support:
>  			 */
> -			if (err == ENOENT && attr->type == PERF_TYPE_HARDWARE
> +			if ((err == ENOENT || err == ENXIO)
> +					&& attr->type == PERF_TYPE_HARDWARE
>  					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
>  
>  				if (verbose)
> -- 
> 1.7.5.4
