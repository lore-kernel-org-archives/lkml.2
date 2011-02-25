Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1BYCkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:40:22 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35168 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab1BYCkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:40:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=M03A/L22/Jinf/l49ISybB0q2Q/bZvZmlh0PYpmIlwlR/vUUt64Av0YRdj9aw8qa3n
         cB667r9aJdfEErRH7LDcZAITJduwZibaCCuWZNdAiX5UcqqvIt/B82d8syoaYllvlZPY
         +b0WZ8DkS3OutCgJAFE56i3A2IBc8GjtGll90=
Date: Thu, 24 Feb 2011 23:40:14 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu
Subject: Re: [RFC] Performance Events 'Samples' report
Message-ID: <20110225024014.GA16138@ghostprotocols.net>
References: <E1PslLC-0000rj-EF@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PslLC-0000rj-EF@eag09.americas.sgi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 24, 2011 at 06:15:26PM -0600, Cliff Wickman escreveu:
> From: Cliff Wickman <cpw@sgi.com>
> 
> The perf command's report prints clock periods under the heading of 'Samples'.
> Our applications people have been confused by this "Samples" heading.
> 
> perf report -n
> 
> # Overhead  Samples            Command         Shared Object                            Symbol
> # ........ ..........  ...............  ....................  ................................
> #
>     99.41%1522136216246         pthreads  pthreads              [.] work_function
>      0.33% 4980298302             perf  [kernel.kallsyms]     [k] clear_page_c
>      ....
> 
> It would be more compact to print the number of samples.  And that would
> be consistent with the heading.
> 
> Below is the code that displays the periods.  I don't see that the number
> of samples is available here, but probably easily could be.
> I presume that clock periods are derived from #samples * sample period.
> 
> perf/util/hist.c
> 
>  640 
>  641         if (symbol_conf.show_nr_samples) {
>  642                 if (sep)
>  643                         ret += snprintf(s + ret, size - ret, "%c%" PRIu64,      *sep, period);
>  644                 else
>  645                         ret += snprintf(s + ret, size - ret, "%11" PRIu64,      period);
>  646         }
>  647 

Wasn't this fixed by:

commit fec9cbd15b9e99bab9bc50f1ed7e20a1087d7c6d
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Thu Feb 17 10:37:23 2011 -0200

    perf hists: Print number of samples, not the period sum
    
    So that we match the header where we state the number of events with the
    "Samples" column when using 'perf report -n/--show-nr-samples':
    
     [root@emilia ~]# perf record -a sleep 1
     [ perf record: Woken up 1 times to write data ]
     [ perf record: Captured and wrote 0.111 MB perf.data (~4860 samples) ]
     [root@emilia ~]# perf report --stdio --show-nr-samples
     # Events: 11  cycles
     #
     # Overhead  Samples        Command       Shared Object                        Symbol
     # ........ ..........  ...........  ..................  ............................
     #
         16.65%          1        sleep  [kernel.kallsyms]   [k] unmap_vmas
         16.10%          1         perf  libpthread-2.12.so  [.] __pthread_cleanup_push_defer
         15.79%          2         perf  [kernel.kallsyms]   [k] format_decode
         12.88%          1  kworker/1:2  [kernel.kallsyms]   [k] cache_reap
         10.69%          1      swapper  [kernel.kallsyms]   [k] _raw_spin_lock
          7.55%          1        sleep  [kernel.kallsyms]   [k] prepare_exec_creds
          6.00%          1         perf  [jbd2]              [k] start_this_handle
          5.29%          1         perf  [kernel.kallsyms]   [k] seq_read
          4.75%          1         perf  [kernel.kallsyms]   [k] get_pid_task
          4.30%          1         perf  [kernel.kallsyms]   [k] _raw_spin_unlock_irqrestore
    
     #
     # (For a higher level overview, try: perf report --sort comm,dso)
     #
     [root@emilia ~]#
    
    Reported-by: Stephane Eranian <eranian@google.com>
    Acked-by: Stephane Eranian <eranian@google.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Stephane Eranian <eranian@google.com>
    Cc: Tom Zanussi <tzanussi@gmail.com>
    LKML-Reference: <new-submission>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

?

Please try using tip/perf/core.

- Arnaldo

