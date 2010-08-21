Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab0HUC3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 22:29:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59361 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0HUC3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 22:29:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=GgCXnN7f4oOxGPM8wFhSbvZE6zwmjOchWXNNyaH5xxngvzdYfvjIuSQe3wwn/TtS9W
         2SWpAHM1Fu8aE/grc3dNZtjrmktMotYe2EBxTQytkiItSxx7Gkdi4y8oWbJdEOUaHKJf
         6L4o8tGEShaOkX3ZiWhp3jSQSYax1K1F75mOk=
Date: Sat, 21 Aug 2010 04:29:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100821022944.GC7959@nowhere>
References: <20100815225359.GA32152@infradead.org> <20100819005720.GB5324@nowhere> <20100819085700.GB8782@infradead.org> <20100819150422.GA325@ghostprotocols.net> <20100820091645.GA20138@infradead.org> <20100820191230.GD14788@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100820191230.GD14788@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 04:12:30PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Aug 20, 2010 at 05:16:45AM -0400, Christoph Hellwig escreveu:
> > On Thu, Aug 19, 2010 at 12:04:22PM -0300, Arnaldo Carvalho de Melo wrote:
> > > 
> > > [acme@doppio tmp]$ perf report
> > > 
> > > http://vger.kernel.org/~acme/perf/perf-report-tui-callchain-xlog_sync.png
> > > 
> > > So it seems to work (you tell me if the callchains make sense), and the problem
> > 
> > I've rebuilt perf with libnewt to reproduce it, but to get any of the
> > callchain data I need to call perf report with a -g argument (which is
> > rather expected from the documentation anyway)
> 
> In fact I never run 'perf report' specifying '-g', have you tried it
> that way?
>  
> > I still see the same problems as with the TUI perf report with that.
> > With the -g {mode},0.0 there is nothing to expand inside the GUI for
> > e.g. the pythong process, and with the 0.0 threshold I can only expand
> > a few 0.<something> callchains, but I never see the 80% your screenshot
> > shows.  What perf version are you running?
> 
> IIRC I tried this on perf/urgent and on perf/core, the former should be what
> is Linus tree.
> 
> Lemme try again, right, just checked out from torvalds/master and running it
> as:
> 
> $ perf report
> 
> that screenshot is reproduced.
> 
> > Also the flat mode is rendered incorrectly, it just adds different call
> > graphs inside a single process directly after each other instead of
> > separating them in the rendering.
> 
> Probably because of what I said above, i.e. I still have to try 'perf
> record -g flat' on the TUI, lets see...
> 
> Running it as:
> 
> $ perf report -g flat,0,0
> 
> This is produced:
> 
> http://vger.kernel.org/~acme/perf/perf-report-tui-g-flat.png
> 
> which has the flat percentages missing, have to fix that but hey, at least I
> finally tried it! 8-)
> 
> The TUI code started with the default:
> 
> [acme@doppio linux-2.6-tip]$ perf report --help
> <SNIP>
>        -g [type,min], --call-graph
>            Display callchains using type and min percent threshold. type can
>            be either:
> 
>            ·   flat: single column, linear exposure of callchains.
> 
>            ·   graph: use a graph tree, displaying absolute overhead rates.
> 
>            ·   fractal: like graph, but displays relative rates. Each branch
>                of the tree is considered as a new profiled object. Default:
>                                                                    ^^^^^^^^
>                fractal,0.5.
>                ^^^^^^^^^^^
> <SNIP>
> 
> The TUI took longer than I antecipated to get right, requiring writing a
> generic tree widget from scratch, not using any libnewt code, as the one newt
> has is too cumbersome and inflexible to use :-\
> 
> I will work to have the "flat" and "graph" modes working properly in the coming
> weeks.



I think graph mode is nice to have in the TUI.
Actually this should be called "absolute fractal", as opposite to default
mode that "relative fractal".

In "graph" mode we show the overhead percentage against the total overhead, while
in default mode "fractal" we show overhead against the parent branch.

But the flat mode is just a dumb dump of every callchain records. It's mostly
useful for callchain debugging I think. May be it's not worth adapting the TUI
for that mode. As you want.

One day I really need to fill the perf wiki about callchains.



> It should work on the stdio mode, IIRC Frédéric told me he found and fixed the
> problem there, right?



Part of it. I've a fix for the "nothing displayed unless 0 min percentage" case.
Now I need to investigate on why callchains percentages sometimes don't add up correctly.

Those are eventually two different problems (more details in my next reply to Christoph).

Thanks.

