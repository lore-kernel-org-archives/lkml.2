Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2C0Tii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:38:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60799 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab2C0Tif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:38:35 -0400
Message-ID: <1332877098.16159.260.camel@twins>
Subject: Re: [PATCH] perf: Add a new sort order: SORT_INCLUSIVE (v4)
From: Peter Zijlstra <peterz@infradead.org>
To: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Date: Tue, 27 Mar 2012 21:38:18 +0200
In-Reply-To: <4F72026C.3050604@fb.com>
References: <1331746607-6706-1-git-send-email-asharma@fb.com>
	 <20120315141402.GA550@somewhere.redhat.com> <4F622DCE.4090608@fb.com>
	 <20120319155742.GF2660@somewhere> <4F691289.7080505@fb.com>
	 <20120325021451.GA14971@somewhere.redhat.com> <4F72026C.3050604@fb.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 11:09 -0700, Arun Sharma wrote:
> On 3/24/12 7:14 PM, Frederic Weisbecker wrote:
> 
> >> The other problem in branch stacks/LBR is that they're
> >> sampled branches. Just because I got a sample with:
> >>
> >> a ->  b
> >> b ->  c
> >>
> >> doesn't necessarily mean that the callchain was a ->  b ->  c.
> >
> > Not sure what you mean. If you have a ->  b, b ->  c in single
> > LBR sample it means you got a ->  b ->  c.
> >
> 
> I was going by Stephane's commit message here:
> 
> http://article.gmane.org/gmane.linux.kernel/1236999
> 
>  > Statistical sampling of taken branch should not be confused
>  > for branch tracing. Not all branches are necessarily captured
> 
> Stephane, could you please explain if the 16 filtered branches in LBR 
> are guaranteed to be from a given callchain to the leaf function? My 
> understanding is that it's not.
> 
> callchain1: a -> b -> d -> e (sample a->b)
> callchain2: a -> c -> b -> f (sample b->f)
> 
> on PMU interrupt can we end up with:
> 
> b -> f <- top of stack
> a -> b
> ...
> 
> even though a -> b -> f can never happen in the actual program flow?

Right, so the LBR is a queue not a stack. A program like:

foo() {
	bar1();
	bar2();
}

will, using the lbr, look like: foo->bar1->bar2 (if you filter returns),
or foo->bar1->foo+x->bar2 if you include returns.

A callchain is a pure stack, a return pops the top most entry, the above
program can only give 3 possible callchains:

a) foo
b) foo, bar1
c) foo, bar2

Furthermore, the LBR is about any branch, callchains are about function
calls.
