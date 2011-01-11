Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab1AKSXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:23:10 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:51586 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab1AKSXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:23:09 -0500
Date: Tue, 11 Jan 2011 21:24:18 +0300
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf top -> annotate broken; bisected to 69aad6f1
Message-ID: <20110111182418.GA3133@tugrik.mns.mnsspb.ru>
References: <20110111163520.GA4554@tugrik.mns.mnsspb.ru> <20110111171124.GB11968@ghostprotocols.net> <20110111172309.GC11968@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111172309.GC11968@ghostprotocols.net>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 03:23:10PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 11, 2011 at 03:11:24PM -0200, Arnaldo Carvalho de Melo escreveu:
> > Em Tue, Jan 11, 2011 at 07:35:20PM +0300, Kirill Smelkov escreveu:
> > > Hello up there,
> > > 
> > > Since 69aad6f1ee69546dea8535ab8f3da9f445d57328 (perf tools: Introduce
> > > event selectors; Jan 3 2011) annotating a symbol in perf top segfaults:
> > > 
> > >     Program received signal SIGSEGV, Segmentation fault.
> > >     [Switching to Thread 0xb714cb90 (LWP 4662)]
> > >     event_name (evsel=0x0) at util/parse-events.c:274
> > >     274             return __event_name(type, config);
> > >     (gdb) bt
> > >     #0  event_name (evsel=0x0) at util/parse-events.c:274
> > >     #1  0x0805f892 in display_thread (arg=0x9422448) at builtin-top.c:359
> > >     #2  0xb77234c0 in start_thread () from /lib/i686/cmov/libpthread.so.0
> > >     #3  0xb732b84e in clone () from /lib/i686/cmov/libc.so.6
> > > 
> > > 
> > > It used to work...
> > 
> > Thanks for the report, working on a fix.
> 
> Done, please test it and I'll add a Tested-by: you tag.
> 
> Thanks,
> 
> - Arnaldo
> 
> commit 347ad46af282994524510d62a4c70455929b6a9d
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Tue Jan 11 15:16:52 2011 -0200
> 
>     perf top: Fix annotate segv
>     
>     Before we had sym_counter, it was initialized to zero and we used that
>     as an index in the global attrs variable, now we have a list of evsel
>     entries, and sym_counter became sym_evsel, that remained initialized to
>     zero (NULL): b00m.
>     
>     Fix it by initializing it to the first entry in the evsel list.
>     
>     Bug-introduced: 69aad6f
>     Reported-by: Kirill Smelkov <kirr@mns.spb.ru>
>     Cc: Frederic Weisbecker <fweisbec@gmail.com>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Cc: Kirill Smelkov <kirr@mns.spb.ru>
>     Cc: Mike Galbraith <efault@gmx.de>
>     Cc: Paul Mackerras <paulus@samba.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Stephane Eranian <eranian@google.com>
>     Cc: Tom Zanussi <tzanussi@gmail.com>
>     LKML-Reference: <new-submission>
>     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 4b995ee..568b195 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1473,6 +1473,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>  		pos->attr.sample_period = default_interval;
>  	}
>  
> +	sym_evsel = list_entry(evsel_list.next, struct perf_evsel, node);
> +
>  	symbol_conf.priv_size = (sizeof(struct sym_entry) +
>  				 (nr_counters + 1) * sizeof(unsigned long));

Now it works again, thanks!

Tested-by: Kirill Smelkov <kirr@mns.spb.ru>
