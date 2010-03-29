Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0C2JLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:11:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:49162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab0C2JLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:11:36 -0400
Subject: Re: [PATCH 1/2] perf: Correctly align perf event tracing buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1269753066-17246-2-git-send-regression-fweisbec@gmail.com>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
	 <1269753066-17246-2-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 10:51:31 +0200
Message-ID: <1269852691.12097.162.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-28 at 07:11 +0200, Frederic Weisbecker wrote:
> The trace event buffer used by perf to record raw sample events
> is typed as an array of char and may then not be aligned to 8
> by alloc_percpu().
> 
> But we need it to be aligned to 8 in sparc64 because we cast
> this buffer into a random structure type built by the TRACE_EVENT()
> macro to store the traces. So if a random 64 bits field is accessed
> inside, it may be not under an expected good alignment.
> 
> Use an array of long instead to force the appropriate alignment, and
> perform a compile time check to ensure the size in byte of the buffer
> is a multiple of sizeof(long) so that its actual size doesn't get
> shrinked under us.
> 
> This fixes unaligned accesses reported while using perf lock
> in sparc 64.
> 
> Suggested-by: David Miller <davem@davemloft.net>
> Suggested-by: Tejun Heo <htejun@gmail.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: David Miller <davem@davemloft.net>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_event_perf.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index 0709e4f..69941f3 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -15,7 +15,12 @@ EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs);
>  static char *perf_trace_buf;
>  static char *perf_trace_buf_nmi;
>  
> -typedef typeof(char [PERF_MAX_TRACE_SIZE]) perf_trace_t ;
> +/*
> + * Force it to be aligned to unsigned long to avoid misaligned accesses
> + * suprises
> + */
> +typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
> +	perf_trace_t;
>  

wouldn't __aligned(8) be simpler?

