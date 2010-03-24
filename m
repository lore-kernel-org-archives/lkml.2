Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0CXF7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:59:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45513 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0CXF7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:59:46 -0400
Date: Wed, 24 Mar 2010 11:29:39 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
Message-ID: <20100324055939.GA21999@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6> <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6> <1269342115.5279.1620.camel@twins> <20100323122335.GB26762@linux.vnet.ibm.com> <1269352012.5109.22.camel@twins> <20100323150544.GA18323@in.ibm.com> <1269357354.5109.83.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269357354.5109.83.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 04:15:54PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-03-23 at 20:35 +0530, Ananth N Mavinakayanahalli wrote:
> > Now the question is, where the complexity needs to be.
> 
> Both in-tree consumers of uprobes (ftrace and perf) are capable of task
> filters.
> 
> But the thing is, dso:sym is very much not a task property, adding task
> filters afterwards sure makes sense in some cases but it should not be
> the primary mode.

Not sure if I am following you correctly...

> If people really want to optimize this we can easily add a few bits of
> task state which could tell the trap handler to not even bother looking
> up things but restart as fast as possible.

Are you suggesting we have the global tracing as default and
then have task filters. I've already alluded to this being vetoed
earlier, by people including Andrew Morton, Hugh Dickins, Arjan,
Christoph Hellwig, Nick Piggin, etc. It's a route we'd prefer not to
go down again...

Aside, what are the mechanisms to do this?

The current breakpoint insertion and removal, even for shared libraries,
is process local since the only page tables of the process being traced
is modified.

In order to have a global visibility of dso probes, one obvious method
is to put in the probes before the text hits pagecache. This approach
works for 'yet-to-start' processes that would map the dso too. This was
prototyped in the series at http://lkml.org/lkml/2006/5/9/25 did that
and was suitably junked, for very valid reasons. Even Hugh Dickins
thumbed down the pagecache approach (http://lkml.org/lkml/2006/5/9/209)

Given the current design has enough flexibility to accommodate non perf
users like gdb, a simple pid based approach for the lowest layer makes
the most sense. I'd rather prefer a higher level entity (say, perf) do
the difficult job of filtering down individual requests only for
processes of interest, then the lower layer can iteratively do the probe
insertions for all processes of interest.

I am not sure if there is a better method to do probes with 'global'
visibility. Did you have an easier approach in mind?

Ananth
