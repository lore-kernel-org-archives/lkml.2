Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0HTTMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 15:12:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:37711 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab0HTTMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 15:12:41 -0400
Date: Fri, 20 Aug 2010 16:12:30 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100820191230.GD14788@ghostprotocols.net>
References: <20100815225359.GA32152@infradead.org>
 <20100819005720.GB5324@nowhere>
 <20100819085700.GB8782@infradead.org>
 <20100819150422.GA325@ghostprotocols.net>
 <20100820091645.GA20138@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100820091645.GA20138@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 20, 2010 at 05:16:45AM -0400, Christoph Hellwig escreveu:
> On Thu, Aug 19, 2010 at 12:04:22PM -0300, Arnaldo Carvalho de Melo wrote:
> > 
> > [acme@doppio tmp]$ perf report
> > 
> > http://vger.kernel.org/~acme/perf/perf-report-tui-callchain-xlog_sync.png
> > 
> > So it seems to work (you tell me if the callchains make sense), and the problem
> 
> I've rebuilt perf with libnewt to reproduce it, but to get any of the
> callchain data I need to call perf report with a -g argument (which is
> rather expected from the documentation anyway)

In fact I never run 'perf report' specifying '-g', have you tried it
that way?
 
> I still see the same problems as with the TUI perf report with that.
> With the -g {mode},0.0 there is nothing to expand inside the GUI for
> e.g. the pythong process, and with the 0.0 threshold I can only expand
> a few 0.<something> callchains, but I never see the 80% your screenshot
> shows.  What perf version are you running?

IIRC I tried this on perf/urgent and on perf/core, the former should be what
is Linus tree.

Lemme try again, right, just checked out from torvalds/master and running it
as:

$ perf report

that screenshot is reproduced.

> Also the flat mode is rendered incorrectly, it just adds different call
> graphs inside a single process directly after each other instead of
> separating them in the rendering.

Probably because of what I said above, i.e. I still have to try 'perf
record -g flat' on the TUI, lets see...

Running it as:

$ perf report -g flat,0,0

This is produced:

http://vger.kernel.org/~acme/perf/perf-report-tui-g-flat.png

which has the flat percentages missing, have to fix that but hey, at least I
finally tried it! 8-)

The TUI code started with the default:

[acme@doppio linux-2.6-tip]$ perf report --help
<SNIP>
       -g [type,min], --call-graph
           Display callchains using type and min percent threshold. type can
           be either:

           ·   flat: single column, linear exposure of callchains.

           ·   graph: use a graph tree, displaying absolute overhead rates.

           ·   fractal: like graph, but displays relative rates. Each branch
               of the tree is considered as a new profiled object. Default:
                                                                   ^^^^^^^^
               fractal,0.5.
               ^^^^^^^^^^^
<SNIP>

The TUI took longer than I antecipated to get right, requiring writing a
generic tree widget from scratch, not using any libnewt code, as the one newt
has is too cumbersome and inflexible to use :-\

I will work to have the "flat" and "graph" modes working properly in the coming
weeks.

It should work on the stdio mode, IIRC Frédéric told me he found and fixed the
problem there, right?

- Arnaldo
