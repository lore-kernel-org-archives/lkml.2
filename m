Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2JUQiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:38:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36471 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2JUQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:38:54 -0400
Date: Sun, 21 Oct 2012 18:38:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
Message-ID: <20121021163848.GB28726@gmail.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> hi,
> adding support to read sample values through the PERF_SAMPLE_READ
> sample type. It's now possible to specify 'S' modifier for an event
> and get its sample value by PERF_SAMPLE_READ.
> 
> For group the 'S' modifier will enable sampling only for the leader
> and read all the group member by PERF_SAMPLE_READ smple type with
> PERF_FORMAT_GROUP read format.
> 
> This patchset is based on group report patches by Namhyung Kim:
> http://lwn.net/Articles/518569/
> 
> Example:
> (making sample on cycles, reading both cycles and cache-misses
>  by PERF_SAMPLE_READ/PERF_FORMAT_GROUP)
> 
>   # ./perf record -e '{cycles,cache-misses}:S' ls
>   ...
> 
>   # ./perf report --group --show-total-period --stdio
>   # ========
>   # captured on: Sat Oct 20 16:53:39 2012
>   ...
>   # group: {cycles,cache-misses}
>   # ========
>   #
>   # Samples: 86  of event 'anon group { cycles, cache-misses }'
>   # Event count (approx.): 34863674
>   #
>   #         Overhead                    Period  Command      Shared Object                            Symbol
>   # ................  ........................  .......  .................  ................................

Might make sense to consider this column enumeration:

    #
    #   cycles
    #   |       cache-misses
    #   |       |
>   #   v       v
>   #
>       16.56%  19.47%       5773450         475       ls  [kernel.kallsyms]  [k] native_sched_clock          
>       10.87%   0.74%       3789088          18       ls  [kernel.kallsyms]  [k] rtl8169_interrupt           
>        9.82%  15.86%       3423364         387       ls  [kernel.kallsyms]  [k] mark_lock                   
>        8.43%  17.75%       2938384         433       ls  ld-2.14.90.so      [.] do_lookup_x                 
>        6.79%  20.86%       2365622         509       ls  ls                 [.] calculate_columns           
>        6.36%   0.61%       2216808          15       ls  [kernel.kallsyms]  [k] lock_release                
>   ...

/me wants this feature ASAP :-)

This should probably be the out of box default for perf record 
and perf top as well - the cache miss rate is probably one of 
the least appreciated aspects of overhead analysis.

Does it have sane output if the cache-misses event is not 
supported? The cache-misses column should probably stay empty in 
that case - basically falling back to today's default output.

Thanks,

	Ingo
