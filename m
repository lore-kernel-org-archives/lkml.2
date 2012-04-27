Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318Ab2D0PQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:16:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51878 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256Ab2D0PQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:16:51 -0400
Date: Fri, 27 Apr 2012 12:16:42 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL 0/4] perf/annotate loop detection V2, fixes
Message-ID: <20120427151642.GB27997@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
 <20120427072153.GB4766@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120427072153.GB4766@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 27, 2012 at 09:21:53AM +0200, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > Arnaldo Carvalho de Melo (4):
> >       perf annotate browser: Handle NULL jump targets
> >       perf annotate: Disambiguage offsets and addresses in operands
> >       perf annotate: Mark jump instructions with no offset
> >       perf annotate browser: Don't draw jump connectors for out of function jumps

> Pulled, thanks a lot Arnaldo!

> Works pretty well here, the segfaults are gone. I think we can 
> use it as a starting point so I've pulled it into perf/core.

> One thing that we need to fix with this new scheme is the visual 
> dynamism/unpredictability of the loop drawing:

Yeah, something to experiment, when Linus suggested it he was afraid
that we would get way too many lines, but Arjan has since requested that
we have a key to toggle showing all jumps at the same time, so that is
what I'm going to do.

Then we can check how that goes.
 
> As I move the cursor line up and down the current loop is shown 
> and it flips in and out of view depending on where I am. In one 
> way it's a feature (it shows the currently interesting loop) - 

That is why probably we want to get a
show-me-just-the-current-loop/show-me-all-loops toggle key.

> but in another way that kind of 'active' UI element draws my eye 
> all the time and it gets tiring and hard to ignore when I'm not 
> interested in the current loop but look at other elements of the 
> UI output.
> 
> It would be better to have a stable image of loops that is 
> static and scrolls up and down with the rest of the image. When 
> I press 'o' to see the raw disassembly it should probably 
> disappear completely.

Right, that can be done as well, but perhaps its better to have a 'j'
key that cycles thru:

. Show me just the current loop
. Show me all loops
. No loops please

That can be used in both raw and augmented mode.
 
> This would require for us to draw all loops that are 
> interesting: probably all backwards jumping ones, with some 
> nesting limit of 5 or so. I think we really need this loop graph 
> for this UI to have low visual overhead :-/

Well, when first marking the jump targets we'll notice how many loops
there are, reserve N columns for them, then just have a loop where right
now we have the current loop arrow drawing code.
 
> Beyond improving visual stability of the output, this would also 
> obviously be (much) more informative as for reasonably sized 
> functions it would show all the current loop contexts - which is 
> very useful when one tries to make sense of a function in 
> assembly.
> 
> Doing that will take up some screen real estate on the left, 
> because with increasing nesting levels there will be parallel 
> lines and crossing lines - I did a quick ASCII mockup and I 
> think it will be fine, as long as we have a hotkey that makes it 
> easy to show/hide the loop graph.

'j' or 'l', I'll check which one is available
 
> If it's all concentrated within a narrow vertical column it also 
> does not clutter the output and is easy to ignore when it's not 
> needed.
> 
> How and whether labels should be mixed with this graph output 
> remains to be seen - my intuition is that the two should be 
> integrated, like the current code does it.
> 
> ( Once we have that done and gather some experience with it can 
>   we decide whether to show it by default. )

Right, hence all the toggle keys, to experiment with combinations of
output formats.

> We can also save some screen real estate on the left side of the 
> screen, the instruction overhead percentage column. Right now 
> the largest entry possible is:
> 
>   100.00 ││        lea    (%rbx,%r12,1),%r14
> 
> This could be trimmed by two characters to:
> 
>  100.0 ││        lea    (%rbx,%r12,1),%r14
> 
> This saves a space before the percent value and reduces the 
> width of the output - I think 0.1% granularity ought to be 
> enough in practice. We should also probably hide entries below 
> 0.1% overhead as if they got no hits at all.

Right, that will be used as well when I implement a suggestin Stephane
made while in San Francisco: To show multiple overhead columns for
sessions with multiple events, helping to correlate them.

- Arnaldo
