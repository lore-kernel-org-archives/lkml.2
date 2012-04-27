Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab2D0HWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:22:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54264 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2D0HV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:21:59 -0400
Date: Fri, 27 Apr 2012 09:21:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL 0/4] perf/annotate loop detection V2, fixes
Message-ID: <20120427072153.GB4766@gmail.com>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1335452777-27326-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling into tip/perf/core.
> 
> 	Just flushing out the annotate queue before it gets too big.
> 
> 	I'll work on the suggestions made on G+ and on lkml.
> 
> - Arnaldo
> 
> The following changes since commit a3f895be1f1ed17f66e6e71adeef0cc7f937512c:
> 
>   perf annotate browser: Initial loop detection (2012-04-24 14:24:28 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-annotate-for-mingo
> 
> for you to fetch changes up to 38b31bd0cefbb0e69a182d9a94b09a7e648549dc:
> 
>   perf annotate browser: Don't draw jump connectors for out of function jumps (2012-04-25 14:18:42 -0300)
> 
> ----------------------------------------------------------------
> Fixes on top of the previous perf/annotate pull request
> 
> . Sometimes a jump points to an offset with no instructions, make the
>   mark jump targets function handle that, for now just ignoring such
>   jump targets, more investigation is needed to figure out how to cope
>   with that.
> 
> . Handle jump targets that are outside the function, for now just don't
>   try to draw the connector arrow, right thing seems to be to mark this
>   jump with a -> (right arrow) and handle it like a callq.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (4):
>       perf annotate browser: Handle NULL jump targets
>       perf annotate: Disambiguage offsets and addresses in operands
>       perf annotate: Mark jump instructions with no offset
>       perf annotate browser: Don't draw jump connectors for out of function jumps
> 
>  tools/perf/ui/browsers/annotate.c |   27 ++++++++++++++++++---------
>  tools/perf/util/annotate.c        |   27 +++++++++++++++------------
>  tools/perf/util/annotate.h        |   13 +++++++++++--
>  3 files changed, 44 insertions(+), 23 deletions(-)

Pulled, thanks a lot Arnaldo!

Works pretty well here, the segfaults are gone. I think we can 
use it as a starting point so I've pulled it into perf/core.

One thing that we need to fix with this new scheme is the visual 
dynamism/unpredictability of the loop drawing:

As I move the cursor line up and down the current loop is shown 
and it flips in and out of view depending on where I am. In one 
way it's a feature (it shows the currently interesting loop) - 
but in another way that kind of 'active' UI element draws my eye 
all the time and it gets tiring and hard to ignore when I'm not 
interested in the current loop but look at other elements of the 
UI output.

It would be better to have a stable image of loops that is 
static and scrolls up and down with the rest of the image. When 
I press 'o' to see the raw disassembly it should probably 
disappear completely.

This would require for us to draw all loops that are 
interesting: probably all backwards jumping ones, with some 
nesting limit of 5 or so. I think we really need this loop graph 
for this UI to have low visual overhead :-/

Beyond improving visual stability of the output, this would also 
obviously be (much) more informative as for reasonably sized 
functions it would show all the current loop contexts - which is 
very useful when one tries to make sense of a function in 
assembly.

Doing that will take up some screen real estate on the left, 
because with increasing nesting levels there will be parallel 
lines and crossing lines - I did a quick ASCII mockup and I 
think it will be fine, as long as we have a hotkey that makes it 
easy to show/hide the loop graph.

If it's all concentrated within a narrow vertical column it also 
does not clutter the output and is easy to ignore when it's not 
needed.

How and whether labels should be mixed with this graph output 
remains to be seen - my intuition is that the two should be 
integrated, like the current code does it.

( Once we have that done and gather some experience with it can 
  we decide whether to show it by default. )

We can also save some screen real estate on the left side of the 
screen, the instruction overhead percentage column. Right now 
the largest entry possible is:

  100.00 ││        lea    (%rbx,%r12,1),%r14

This could be trimmed by two characters to:

 100.0 ││        lea    (%rbx,%r12,1),%r14

This saves a space before the percent value and reduces the 
width of the output - I think 0.1% granularity ought to be 
enough in practice. We should also probably hide entries below 
0.1% overhead as if they got no hits at all.

Thanks,

	Ingo
