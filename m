Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab2BXTRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:17:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:35582 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab2BXTRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:17:00 -0500
Date: Fri, 24 Feb 2012 17:16:41 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jbaron@redhat.com, rostedt@goodmis.org, srikar@linux.vnet.ibm.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] perf - ensure offset provided during probe addition is
 not greater than function length
Message-ID: <20120224191641.GD27882@infradead.org>
References: <4F45FABE.90104@linux.vnet.ibm.com>
 <4F473F33.4060409@linux.vnet.ibm.com>
 <4F47673B.6000103@hitachi.com>
 <4F47756F.1020602@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F47756F.1020602@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 24, 2012 at 05:03:03PM +0530, Prashanth Nageshappa escreveu:
> Can you please pick up this patch?

I'll do it, thanks,

- Arnaldo
 
> On 02/24/2012 04:02 PM, Masami Hiramatsu wrote:
> 
> > (2012/02/24 16:41), Prashanth Nageshappa wrote:
> >> perf probe allows kprobe to be inserted at any offset from a function
> >> start, which results in adding kprobes to unintended location.
> >> (example: perf probe do_fork+10000 is allowed even though size of
> >> do_fork is ~904)
> >>
> >> This patch will ensure probe addition fails when the offset specified
> >> is greater than size of the function.
> >>
> >>
> >> Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
> > 
> > This seems good to me.
> > 
> > Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > 
> > Thank you,
> > 
> >> ---
> >>
> >>  tools/perf/util/probe-finder.c |   12 +++++++++++-
> >>  1 files changed, 11 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> >> index 5d73262..d298f94 100644
> >> --- a/tools/perf/util/probe-finder.c
> >> +++ b/tools/perf/util/probe-finder.c
> >> @@ -672,7 +672,7 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
> >>  static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
> >>  				  bool retprobe, struct probe_trace_point *tp)
> >>  {
> >> -	Dwarf_Addr eaddr;
> >> +	Dwarf_Addr eaddr, highaddr;
> >>  	const char *name;
> >>
> >>  	/* Copy the name of probe point */
> >> @@ -683,6 +683,16 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
> >>  				   dwarf_diename(sp_die));
> >>  			return -ENOENT;
> >>  		}
> >> +		if (dwarf_highpc(sp_die, &highaddr) != 0) {
> >> +			pr_warning("Failed to get end address of %s\n",
> >> +				   dwarf_diename(sp_die));
> >> +			return -ENOENT;
> >> +		}
> >> +		if (paddr > highaddr) {
> >> +			pr_warning("Offset specified is greater than size of %s\n",
> >> +				   dwarf_diename(sp_die));
> >> +			return -EINVAL;
> >> +		}
> >>  		tp->symbol = strdup(name);
> >>  		if (tp->symbol == NULL)
> >>  			return -ENOMEM;
> >>
> > 
> > 
> 
