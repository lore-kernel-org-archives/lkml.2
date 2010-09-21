Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab0IURQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab0IURQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:16:07 -0400
Date: Tue, 21 Sep 2010 12:33:34 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 08/10] jump label v11: x86 support
Message-ID: <20100921163334.GE2873@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com> <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com> <4C981BC4.90405@zytor.com> <20100921152525.GC2873@redhat.com> <20100921152957.GA23380@elte.hu> <1285083324.23122.1955.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285083324.23122.1955.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 11:35:24AM -0400, Steven Rostedt wrote:
> On Tue, 2010-09-21 at 17:29 +0200, Ingo Molnar wrote:
> 
> > > >From the documentation patch:
> > > 
> > > " The optimization depends on !CC_OPTIMIZE_FOR_SIZE. When 
> > > CC_OPTIMIZE_FOR_SIZE is set, gcc does not always out of line the not 
> > > taken label path in the same way that the "if unlikely()" paths are 
> > > made out of line. Thus, with CC_OPTIMIZE_FOR_SIZE set, this 
> > > optimization is not always optimal. This may be solved in subsequent 
> > > gcc versions, that allow us to move labels out of line, while still 
> > > optimizing for size. "
> > 
> > OTOH making a difficult optimization (HAVE_ARCH_JUMP_LABEL) dependent on 
> > compiler flags is really asking for trouble.
> > 
> > So how about enabling it unconditionally, and just chalk up the cost 
> > under CC_OPTIMIZE_FOR_SIZE as one of the costs it already has? This also 
> > has the advantage that future compilers can improve things without 
> > having to wait for yet another kernel patch that re-enables 
> > HAVE_ARCH_JUMP_LABEL.
> 
> Agreed,
> 
> CC_OPTIMIZE_FOR_SIZE does not mean OPTIMIZE_FOR_PERFORMANCE. Although
> people have argued that with smaller size you gain better cache
> performance. I've noticed that the general case is that optimizing for
> size has decreased performance (although I have not done any official
> benchmarks, just my own personal observations).
> 
> I thought you may have had that there because OPTIMIZE_FOR_SIZE actually
> broke the code (as some gcc compilers do for function graph tracer). If
> its just a "we don't perform better with this set". Then get rid of it.
> 

No, OPTIMIZE_FOR_SIZE doesn't break anything, its just that the
'dormant' or the cold code path, isn't moved out of line.

I believe the current approach will eventually lead us to an optimal solution,
(single no-op in the fast path, with ability to jump patch to
out-of-line cold code), even if its not quite there yet under this
compiler flag. And the inclusion of this code will provide more of an
impetus for gcc to make further optimizations.

thanks,

-Jason
