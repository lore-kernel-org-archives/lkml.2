Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab1GQQXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 12:23:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55092 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab1GQQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 12:23:04 -0400
Message-ID: <4E230C63.50601@gmail.com>
Date: Sun, 17 Jul 2011 10:22:59 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 4/6] perf script: print DSOs and symbols for BTS
 branch_from addr
References: <20110717093031.3447.52715.stgit@linux3> <20110717093103.3447.98227.stgit@linux3>
In-Reply-To: <20110717093103.3447.98227.stgit@linux3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/17/2011 03:31 AM, Akihiro Nagai wrote:
> Print DSOs and symbols for branch_from address of BTS.
> BTS records branch_from address in 'addr' fields,
> and branch_to address in 'ip' field. Latest perf-script
> resolves DSOs and symbols only for 'ip' field.
> This patch resolves them for 'addr' field too.

Description does not match code change. What you are doing is enhancing
the detection of when a sample address should correlate to a symbol. In
this case you are adding HW_BRANCH_INSTRUCTIONS event.

David


> 
> # perf script -f ip,addr,dso,sym
> 3f03e016b0 (unknown) ([kernel.kallsyms]) ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e016b0    _start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04b80 _dl_start (/lib64/ld-2.14.so)       3f03e016b3 _start (/lib64/ld-2.14.so)
> 3f03e04b80 _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04ba6 _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04bad _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04c1d _dl_start (/lib64/ld-2.14.so)       3f03e04bfb _dl_start (/lib64/ld-2.14.so)
> [snip]
> 
> Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
> 
>  tools/perf/builtin-script.c |    8 +++++++-
>  tools/perf/util/event.c     |    2 +-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 2356198..7708d89 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -309,6 +309,12 @@ static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
>  	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)))
>  		return true;
>  
> +	/* BTS Events */
> +	if ((attr->type == PERF_TYPE_HARDWARE) &&
> +	    (attr->config & PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
> +	    (attr->sample_period == 1))
> +		return true;
> +
>  	return false;
>  }
>  
> @@ -328,7 +334,7 @@ static void print_sample_addr(union perf_event *event,
>  
>  	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
>  			      event->ip.pid, sample->addr, &al);
> -	/* try to resolve for user space */
> +	/* try to resolve addr_location for user space */
>  	if (!al.map)
>  		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
>  			MAP__FUNCTION, event->ip.pid, sample->addr, &al);
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 49a9315..c541d02 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -771,7 +771,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
>  
>  	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
>  			      event->ip.pid, event->ip.ip, al);
> -	/* try to resolve for user space */
> +	/* try to resolve addr_location for user space */
>  	if (!al->map)
>  		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
>  				MAP__FUNCTION, event->ip.pid, event->ip.ip, al);
> 
