Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1BVMLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:11:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab1BVMLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:11:04 -0500
Date: Tue, 22 Feb 2011 09:10:46 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [PATCH 1/2] perf probe: Fix error propagation leading to
	segfault
Message-ID: <20110222121045.GA27070@ghostprotocols.net>
References: <1298338262-26258-1-git-send-email-acme@infradead.org> <1298338262-26258-2-git-send-email-acme@infradead.org> <4D632B76.2080801@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D632B76.2080801@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 22, 2011 at 12:20:22PM +0900, Masami Hiramatsu escreveu:
> (2011/02/22 10:31), Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > There are two hunks in this patch that stops probe processing as soon as one
> > error is found, breaking out of loops, the other fix an error propagation that
> > should return a negative error number but instead was returning the result of
> > "ret < 0", which is 1 and thus made several error checks fail because they test
> > agains < 0.
> > 
> > The problem could be triggered by asking for a variable that was optimized out,
> > fact that should stop the whole probe processing but instead was segfaulting
> > while installing broken probes:
> > 
> > [root@emilia ~]# probe perf_mmap:55 user_lock_limit
> > Failed to find the location of user_lock_limit at this address.
> >  Perhaps, it has been optimized out.
> > Failed to find 'user_lock_limit' in this function.
> > Add new events:
> >   probe:perf_mmap      (on perf_mmap:55 with user_lock_limit)
> >   probe:perf_mmap_1    (on perf_mmap:55 with user_lock_limit)
> > Segmentation fault (core dumped)
> > [root@emilia ~]# perf probe -l
> >   probe:perf_mmap      (on perf_mmap:55@git/linux/kernel/perf_event.c with user_lock_limit)
> >   probe:perf_mmap_1    (on perf_mmap:55@git/linux/kernel/perf_event.c with user_lock_limit)
> > [root@emilia ~]#
> > 
> > After the fix:
> > 
> > [root@emilia ~]# probe perf_mmap:55 user_lock_limit
> > Failed to find the location of user_lock_limit at this address.
> >  Perhaps, it has been optimized out.
> > Failed to find 'user_lock_limit' in this function.
> >   Error: Failed to add events. (-2)
> > [root@emilia ~]#
> 
> Oops, thanks! But I've also found this fix including some
> redundant checks.

I'll remove the redundancies as I describe later on this message.

> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Stephane Eranian <eranian@google.com>
> > Cc: Tom Zanussi <tzanussi@gmail.com>
> > LKML-Reference: <new-submission>
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  tools/perf/util/probe-event.c  |    5 ++++-
> >  tools/perf/util/probe-finder.c |    4 +++-
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> > index 0e3ea13..369ddc6 100644
> > --- a/tools/perf/util/probe-event.c
> > +++ b/tools/perf/util/probe-event.c
> > @@ -1832,9 +1832,12 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
> >  	}
> >  
> >  	/* Loop 2: add all events */
> > -	for (i = 0; i < npevs && ret >= 0; i++)
> > +	for (i = 0; i < npevs && ret >= 0; i++) {
> >  		ret = __add_probe_trace_events(pkgs[i].pev, pkgs[i].tevs,
> >  						pkgs[i].ntevs, force_add);
> > +		if (ret < 0)
> > +			break;
> > +	}
> 
> Hmm, we've already checked ret >= 0 in for().

You see? There is value in sticking to common practices, even being one
line above I automatically looked after the assignment, not before. :-\

For that to work one needs to make sure to have ret initialized to zero
before the loop and do an unneeded test before we start the
__add_probe_trace_events calls.
 
> >  end:
> >  	/* Loop 3: cleanup and free trace events  */
> >  	for (i = 0; i < npevs; i++) {
> > diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> > index fe461f6..eecbdca 100644
> > --- a/tools/perf/util/probe-finder.c
> > +++ b/tools/perf/util/probe-finder.c
> > @@ -1262,7 +1262,7 @@ static int probe_point_line_walker(const char *fname, int lineno,
> >  	ret = call_probe_finder(NULL, pf);
> >  
> >  	/* Continue if no error, because the line will be in inline function */
> > -	return ret < 0 ?: 0;
> > +	return ret < 0 ? ret : 0;
> 
> I think the problem is only here.
> 
> >  }
> >  
> >  /* Find probe point from its line number */
> > @@ -1484,6 +1484,8 @@ static int find_probes(int fd, struct probe_finder *pf)
> >  				pf->lno = pp->line;
> >  				ret = find_probe_point_by_line(pf);
> >  			}
> > +			if (ret != DWARF_CB_OK)
> > +				break;
> 
> Actually, we must check that ret < 0 here, and that has been checked
> in while().

Ok, another instance of the above pet peeve of mine :-)

> >  		}
> >  		off = noff;
> >  	}
> 
> Only with the second hunk of the patch, I've checked that is enough to fix
> the problem.
> 
> $ ./perf probe -vv perf_mmap:55 user_lock_limit
> probe-definition(0): perf_mmap:55 user_lock_limit
> symbol:perf_mmap file:(null) line:55 offset:0 return:0 lazy:(null)
> parsing arg: user_lock_limit into user_lock_limit
> 1 arguments
> Looking at the vmlinux_path (6 entries long)
> Using //lib/modules/2.6.38-rc5-tip+/build/vmlinux for symbols
> Try to open /lib/modules/2.6.38-rc5-tip+/build/vmlinux
> Get 4514 lines from this CU
> Probe point found: perf_mmap+352
> Searching 'user_lock_limit' variable in context.
> Converting variable user_lock_limit into trace event.
> user_lock_limit type is long unsigned int.
> Probe point found: perf_mmap+359
> Searching 'user_lock_limit' variable in context.
> Converting variable user_lock_limit into trace event.
> user_lock_limit type is long unsigned int.
> Probe point found: perf_mmap+322
> Searching 'user_lock_limit' variable in context.
> Converting variable user_lock_limit into trace event.
> Failed to find the location of user_lock_limit at this address.
>  Perhaps, it has been optimized out.
> Failed to find 'user_lock_limit' in this function.
> An error occurred in debuginfo analysis (-2).
>   Error: Failed to add events. (-2)

Thanks for checking,

- Arnaldo
