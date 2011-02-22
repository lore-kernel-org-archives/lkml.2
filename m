Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1BVDUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:20:30 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39277 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1BVDU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:20:27 -0500
X-AuditID: b753bd60-a314bba0000001d0-67-4d632b7936f8
X-AuditID: b753bd60-a314bba0000001d0-67-4d632b7936f8
Message-ID: <4D632B76.2080801@hitachi.com>
Date: Tue, 22 Feb 2011 12:20:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [PATCH 1/2] perf probe: Fix error propagation leading to segfault
References: <1298338262-26258-1-git-send-email-acme@infradead.org> <1298338262-26258-2-git-send-email-acme@infradead.org>
In-Reply-To: <1298338262-26258-2-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/22 10:31), Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> There are two hunks in this patch that stops probe processing as soon as one
> error is found, breaking out of loops, the other fix an error propagation that
> should return a negative error number but instead was returning the result of
> "ret < 0", which is 1 and thus made several error checks fail because they test
> agains < 0.
> 
> The problem could be triggered by asking for a variable that was optimized out,
> fact that should stop the whole probe processing but instead was segfaulting
> while installing broken probes:
> 
> [root@emilia ~]# probe perf_mmap:55 user_lock_limit
> Failed to find the location of user_lock_limit at this address.
>  Perhaps, it has been optimized out.
> Failed to find 'user_lock_limit' in this function.
> Add new events:
>   probe:perf_mmap      (on perf_mmap:55 with user_lock_limit)
>   probe:perf_mmap_1    (on perf_mmap:55 with user_lock_limit)
> Segmentation fault (core dumped)
> [root@emilia ~]# perf probe -l
>   probe:perf_mmap      (on perf_mmap:55@git/linux/kernel/perf_event.c with user_lock_limit)
>   probe:perf_mmap_1    (on perf_mmap:55@git/linux/kernel/perf_event.c with user_lock_limit)
> [root@emilia ~]#
> 
> After the fix:
> 
> [root@emilia ~]# probe perf_mmap:55 user_lock_limit
> Failed to find the location of user_lock_limit at this address.
>  Perhaps, it has been optimized out.
> Failed to find 'user_lock_limit' in this function.
>   Error: Failed to add events. (-2)
> [root@emilia ~]#

Oops, thanks! But I've also found this fix including some
redundant checks.

> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/probe-event.c  |    5 ++++-
>  tools/perf/util/probe-finder.c |    4 +++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 0e3ea13..369ddc6 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1832,9 +1832,12 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
>  	}
>  
>  	/* Loop 2: add all events */
> -	for (i = 0; i < npevs && ret >= 0; i++)
> +	for (i = 0; i < npevs && ret >= 0; i++) {
>  		ret = __add_probe_trace_events(pkgs[i].pev, pkgs[i].tevs,
>  						pkgs[i].ntevs, force_add);
> +		if (ret < 0)
> +			break;
> +	}

Hmm, we've already checked ret >= 0 in for().

>  end:
>  	/* Loop 3: cleanup and free trace events  */
>  	for (i = 0; i < npevs; i++) {
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index fe461f6..eecbdca 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -1262,7 +1262,7 @@ static int probe_point_line_walker(const char *fname, int lineno,
>  	ret = call_probe_finder(NULL, pf);
>  
>  	/* Continue if no error, because the line will be in inline function */
> -	return ret < 0 ?: 0;
> +	return ret < 0 ? ret : 0;

I think the problem is only here.

>  }
>  
>  /* Find probe point from its line number */
> @@ -1484,6 +1484,8 @@ static int find_probes(int fd, struct probe_finder *pf)
>  				pf->lno = pp->line;
>  				ret = find_probe_point_by_line(pf);
>  			}
> +			if (ret != DWARF_CB_OK)
> +				break;

Actually, we must check that ret < 0 here, and that has been checked
in while().

>  		}
>  		off = noff;
>  	}

Only with the second hunk of the patch, I've checked that is enough to fix
the problem.

$ ./perf probe -vv perf_mmap:55 user_lock_limit
probe-definition(0): perf_mmap:55 user_lock_limit
symbol:perf_mmap file:(null) line:55 offset:0 return:0 lazy:(null)
parsing arg: user_lock_limit into user_lock_limit
1 arguments
Looking at the vmlinux_path (6 entries long)
Using //lib/modules/2.6.38-rc5-tip+/build/vmlinux for symbols
Try to open /lib/modules/2.6.38-rc5-tip+/build/vmlinux
Get 4514 lines from this CU
Probe point found: perf_mmap+352
Searching 'user_lock_limit' variable in context.
Converting variable user_lock_limit into trace event.
user_lock_limit type is long unsigned int.
Probe point found: perf_mmap+359
Searching 'user_lock_limit' variable in context.
Converting variable user_lock_limit into trace event.
user_lock_limit type is long unsigned int.
Probe point found: perf_mmap+322
Searching 'user_lock_limit' variable in context.
Converting variable user_lock_limit into trace event.
Failed to find the location of user_lock_limit at this address.
 Perhaps, it has been optimized out.
Failed to find 'user_lock_limit' in this function.
An error occurred in debuginfo analysis (-2).
  Error: Failed to add events. (-2)


Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
