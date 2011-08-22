Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1HVNAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:00:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53368 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1HVNAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:00:14 -0400
Message-ID: <4E5252DA.3050307@gmail.com>
Date: Mon, 22 Aug 2011 07:00:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v3 3/5] perf script: enhance IP and ADDR correlate
 detection for BTS
References: <20110811120555.5900.23642.stgit@linux3> <20110811120626.5900.88562.stgit@linux3>
In-Reply-To: <20110811120626.5900.88562.stgit@linux3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/11/2011 06:06 AM, Akihiro Nagai wrote:
> BTS records branch_from_addr and branch_to_addr in IP and ADDR field in perf_sample.
> This patch detects this correlation in perf-script.
> 
> # perf script -f ip,addr,dso,sym
> 3f03e016b0    _start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e016b0    _start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04b80 _dl_start (/lib64/ld-2.14.so)       3f03e016b3     _start (/lib64/ld-2.14.so)
> 3f03e04b80 _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04ba6 _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04bad _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
> 3f03e04c1d _dl_start (/lib64/ld-2.14.so)       3f03e04bfb  _dl_start (/lib64/ld-2.14.so)
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
>  tools/perf/builtin-script.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index b3312ff..aeec5bc 100644
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
> 

Acked-By: David Ahern <dsahern@gmail.com>
