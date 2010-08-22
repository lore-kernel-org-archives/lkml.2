Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0HVAte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 20:49:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59773 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0HVAtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 20:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SfaD9N/p89XoKZ9LNRkr4A9x+c/OuH7dWCpVNvi0RpAKn8FmFjEiQ+rKkkUuov8BY/
         baILFRTPE/HLkBPGeOY7UPLDG6TG05q85ZY5SslEtFBSGj+ERvRJh75etz/5fzY0arLT
         xZXR0gm1rwtHWWhm8acFO1nfsy7KnqztgL7gc=
Date: Sun, 22 Aug 2010 02:49:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100822004927.GC5258@nowhere>
References: <20100815225359.GA32152@infradead.org> <20100819005720.GB5324@nowhere> <20100819085700.GB8782@infradead.org> <20100819150422.GA325@ghostprotocols.net> <20100820091645.GA20138@infradead.org> <20100821024713.GD7959@nowhere> <20100821144239.GA31202@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821144239.GA31202@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 10:42:39AM -0400, Christoph Hellwig wrote:
> It does seem to fix the bug for some cases but not all.  Default perf
> report in TUI and the normal command line seem to get it right.  perf
> report -g flat still shows the old problem.  perf report -g flat,0.0
> shows callgraphs, but just as before they just show the 0.<n>
> percentages.



Yep. So I just found the other problem.
We collect every events and store them into per tid histograms.
But depending on the final sorting (by default we sort by comm),
we may merge (collapse) the histograms against the sorting
criteria. If this is by comm, per tid histograms will become
per comm histograms, hence threads profiles will into process
profiles. We have callbacks that handle this merge, but we
forgot to handle callchains.

So imagine we have three threads (tids: 1000, 1001, 1002) that
belong to python.

tid 1000 got 100 events
tid 1001 got 10 events
tid 1002 got 3 events


Once we merge these histograms to get a per comm result, we'll
finally get:

python got 113 events

The problem is we merge 1000 and 1001 histograms into 1002. So the end
merge result, wrt callchains, will be only 1002 callchains. Because
we haven't handled callchains in the merge. Only those from one of
the threads survived.


So, I'm going to fix that.



> Btw, even in normal perf report mode the numbers while they look correct
> confused me a bit.  The percentages before the callgraphs split are
> always relative to the node above, not absolute which is rather
> confusing.  And even despite adding -n to the perf report command line
> I only get absolute numbers for the proccesses but not the actual
> callgraphs.



That's the point of the fractal mode. It's a relative profiling against
the parent node.

But you can select the "graph" mode that does an absolute profiling (against
the total hits).


 
> > > Also the flat mode is rendered incorrectly, it just adds different call
> > > graphs inside a single process directly after each other instead of
> > > separating them in the rendering.
> > 
> > 
> > I'm not sure what you mean. The flat format is a pure dump of every callchains
> > that belong to a single process (or whatever kind of histogram source...).
> > 
> > What do you mean by separating them in the rendering?
> 
> If there are different callchains leading to the same tracepoint they
> are just appened to each other with no visual indication that they are
> separate callchains


Ah right. There is a blank line between callchains. If that's confusing I
can add a kind of "----" boundary.

Thanks.

