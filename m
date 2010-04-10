Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0DJB21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 21:28:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57551 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0DJB2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 21:28:25 -0400
Date: Fri, 9 Apr 2010 22:28:15 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip v2 7/8] perf probe: Remove die() from probe-finder
	code
Message-ID: <20100410012815.GC16721@ghostprotocols.net>
References: <20100406220542.13329.45837.stgit@localhost6.localdomain6> <20100406220629.13329.71869.stgit@localhost6.localdomain6> <4BBFB5CE.7070104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBFB5CE.7070104@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 09, 2010 at 07:18:38PM -0400, Masami Hiramatsu escreveu:
> Hi Arnaldo,
> 
> Has this code done what you suggested? :)
> I'd like to have your comment.

It improves the current situation, yes, but there are still cases there
where die() is called, I assume that is left for later, right?

More comments below.
 
> Thank you,
> 
> Masami Hiramatsu wrote:
> > Remove die() and DIE_IF() code from util/probe-finder.c since
> > these 'sudden death' in utility functions make reusing it from
> > other code (especially tui/gui) difficult.
> > 
> > Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> > 
> >  tools/perf/util/probe-event.c  |    4 
> >  tools/perf/util/probe-finder.c |  517 +++++++++++++++++++++++++---------------
> >  2 files changed, 322 insertions(+), 199 deletions(-)
> > 
> > diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> > index bef2805..7893b32 100644
> > --- a/tools/perf/util/probe-event.c
> > +++ b/tools/perf/util/probe-event.c
> > @@ -151,10 +151,10 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
> >  
> >  	/* Error path */
> >  	if (need_dwarf) {
> > -		if (ntevs == -ENOENT)
> > +		if (ntevs == -EBADF)
> >  			pr_warning("No dwarf info found in the vmlinux - "
> >  				"please rebuild with CONFIG_DEBUG_INFO=y.\n");
> > -		die("Could not analyze debuginfo.");
> > +		die("Failed to analyze debuginfo.");

Like here, the TUI/GUI can try to add a probe but if it fails it can
still continue providing things like a "perf top" window, analysing
perf.data files, doing 'perf diffs', etc.

> >  	}
> >  	pr_debug("An error occurred in debuginfo analysis."
> >  		 " Try to use symbols.\n");
> > diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> > index 1f45285..4a57504 100644
> > --- a/tools/perf/util/probe-finder.c
> > +++ b/tools/perf/util/probe-finder.c
> > @@ -196,19 +196,7 @@ static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
> >  {
> >  	const char *name;
> >  	name = dwarf_diename(dw_die);
> > -	DIE_IF(name == NULL);
> > -	return strcmp(tname, name);
> > -}
> > -
> > -/* Get entry pc(or low pc, 1st entry of ranges)  of the die */
> > -static Dwarf_Addr die_get_entrypc(Dwarf_Die *dw_die)
> > -{
> > -	Dwarf_Addr epc;
> > -	int ret;
> > -
> > -	ret = dwarf_entrypc(dw_die, &epc);
> > -	DIE_IF(ret == -1);
> > -	return epc;
> > +	return name ? strcmp(tname, name) : -1;

This change is correct, with the stated intent :-)

> >  }
> >  
> >  /* Get type die, but skip qualifiers and typedef */
> > @@ -390,7 +378,7 @@ static Dwarf_Die *die_find_member(Dwarf_Die *st_die, const char *name,
> >   */
> >  
> >  /* Show a location */
> > -static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
> > +static int convert_location(Dwarf_Op *op, struct probe_finder *pf)

Yeah, there are still lots of places, in other areas that don't return a
status, just printing a warning and silently failing, like in the trace
parsing routines

> >  {
> >  	unsigned int regn;
> >  	Dwarf_Word offs = 0;
> > @@ -400,8 +388,11 @@ static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
> >  
> >  	/* If this is based on frame buffer, set the offset */
> >  	if (op->atom == DW_OP_fbreg) {
> > -		if (pf->fb_ops == NULL)
> > -			die("The attribute of frame base is not supported.\n");
> > +		if (pf->fb_ops == NULL) {
> > +			pr_warning("The attribute of frame base is not "
> > +				   "supported.\n");
> > +			return -ENOTSUP;
> > +		}

Correct, if you look at tools/perf/util/debug.c, eprintf() looks if
we're in TUI mode, use_browser is true and either fprintfs(stderr) if
not or calls a routine to put it at the "status line" (bottom) in the
TUI.

Having a list with the last messages so that we can have a log window,
or keeping it in a log file that would then be browser is an enhancement
to be made.

> >  		ref = true;
> >  		offs = op->number;
> >  		op = &pf->fb_ops[0];
> > @@ -419,50 +410,63 @@ static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
> >  		ref = true;
> >  	} else if (op->atom == DW_OP_regx) {
> >  		regn = op->number;
> > -	} else
> > -		die("DW_OP %d is not supported.", op->atom);
> > +	} else {
> > +		pr_warning("DW_OP %d is not supported.\n", op->atom);
> > +		return -ENOTSUP;
> > +	}

correct

> >  	regs = get_arch_regstr(regn);
> > -	if (!regs)
> > -		die("%u exceeds max register number.", regn);
> > +	if (!regs) {
> > +		pr_warning("%u exceeds max register number.\n", regn);
> > +		return -ERANGE;
> > +	}
> >  
> >  	tvar->value = xstrdup(regs);
> >  	if (ref) {
> >  		tvar->ref = xzalloc(sizeof(struct kprobe_trace_arg_ref));

We have to kill those xzcalloc, etc, too they are die() in disguise :-)

- Arnaldo
