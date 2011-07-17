Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab1GQQUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 12:20:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40422 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab1GQQUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 12:20:47 -0400
Message-ID: <4E230BDA.5020305@gmail.com>
Date: Sun, 17 Jul 2011 10:20:42 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 3/6] perf script: resolve DSOs and symbols for
 user-space
References: <20110717093031.3447.52715.stgit@linux3> <20110717093057.3447.31077.stgit@linux3>
In-Reply-To: <20110717093057.3447.31077.stgit@linux3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2011 03:30 AM, Akihiro Nagai wrote:
> Resolve user-space DSOs and symbols.
> Latest perf-script can resolve DSOs and symbols for only kernel
> and kernel modules. This patch resolves them for other
> executable binaries.

The description is a bit misleading. perf script does resolve symbols
for userspace. e.g., the example in the bug fix I submitted in May:
https://lkml.org/lkml/2011/5/30/223

Do you look into why the cpumode setting is not working that you have to
try specific settings?

David


> 
> # perf script -f ip,addr,sym,dso
> 3f03e016b0 ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e016b0 ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04b80       3f03e016b3 _start (/lib64/ld-2.14.so)
> 3f03e04b80 ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04ba6 ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04bad ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04c1d       3f03e04bfb _dl_start (/lib64/ld-2.14.so)
> 3f03e04c00       3f03e04c21 _dl_start (/lib64/ld-2.14.so)
> 3f03e04c00       3f03e04c21 _dl_start (/lib64/ld-2.14.so)
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
>  tools/perf/builtin-script.c |    4 ++++
>  tools/perf/util/event.c     |    5 +++++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index b3e0951..2356198 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -328,6 +328,10 @@ static void print_sample_addr(union perf_event *event,
>  
>  	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
>  			      event->ip.pid, sample->addr, &al);
> +	/* try to resolve for user space */
> +	if (!al.map)
> +		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
> +			MAP__FUNCTION, event->ip.pid, sample->addr, &al);
>  	if (!al.map)
>  		thread__find_addr_map(thread, session, cpumode, MAP__VARIABLE,
>  				      event->ip.pid, sample->addr, &al);
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 3c1b8a6..49a9315 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -771,6 +771,11 @@ int perf_event__preprocess_sample(const union perf_event *event,
>  
>  	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
>  			      event->ip.pid, event->ip.ip, al);
> +	/* try to resolve for user space */
> +	if (!al->map)
> +		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
> +				MAP__FUNCTION, event->ip.pid, event->ip.ip, al);
> +
>  	dump_printf(" ...... dso: %s\n",
>  		    al->map ? al->map->dso->long_name :
>  			al->level == 'H' ? "[hypervisor]" : "<not found>");
> 
