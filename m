Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1FOTLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:11:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294Ab1FOTLs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:11:48 -0400
MIME-Version: 1.0
In-Reply-To: <1308135495.15315.38.camel@twins>
References: <1308097798.17300.142.camel@schen9-DESK> <1308134200.15315.32.camel@twins>
 <1308135495.15315.38.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 12:11:19 -0700
Message-ID: <BANLkTikt88KnxTy8TuGGVrBVnXvsnL7nMQ@mail.gmail.com>
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock
 to mutex
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, ak@linux.intel.com,
        shaohua.li@intel.com, alex.shi@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 3:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> The first thing that stood out when running it was:
>
> 31694 root      20   0 26660 1460 1212 S 17.5  0.0   0:01.97 exim
>    7 root      -2  19     0    0    0 S 12.7  0.0   0:06.14 rcuc0
...
>
> Which is an impressive amount of RCU usage..

Gaah. Can we just revert that crazy "use threads for RCU" thing already?

It's wrong. It's clearly expensive. It's using threads FOR NO GOOD
REASON, since the only reason for using them are config options that
nobody even uses, for chissake!

And it results in real problems. For example, if you use "perf record"
to see what the hell is up, the use of kernel threads for RCU
callbacks means that the RCU cost is never even seen. I don't know how
Tim did his profiling to figure out the costs, and I don't know how he
decided that the spinlock to semaphore conversion was the culprit, but
it is entirely possible that Tim didn't actually bisect the problem,
but instead used "perf record" on the exim task, saw that the
semaphore costs had gone up, and decided that it must be the
conversion.

And sure, maybe 50% of it was the conversion, and maybe 50% of it the
RCU changes - and "perf record" just never showed the RCU component.
We already know that it causes huge slowdowns on some other loads. We
just don't know.

So using anonymous kernel threads is actually a real downside. It
makes it much less obvious what is going on. We saw that exact same
thing with the generic worker thread conversions: things that used to
have clear performance issues ("oh, the iwl-phy0 thread is using 3% of
CPU time because it is polling for IO, and I can see that in 'top'")
turned into much-harder-to-see issues ("oh, kwork0 us using 3% CPU
time according to 'top' - I have no idea why").

Now, with RCU using softirq's, clearly the costs of RCU can sometimes
be mis-attributed because it turns out that the softirq is run from
some other thread. But statistically, if you end up having a heavy
softirq load, it _usually_ ends up being triggered in the context of
whoever causes that load. Not always, and not reliably, but I suspect
it ends up being easier to see.

And quite frankly, just look at commit a26ac2455ffc: it sure as hell
isn't making anything simpler. It adds several hundred lines of code,
and it's already been implicated in one major performance regression,
and is a possible reason for this one.

So Ingo, Paul: can we *please* just revert it, and agree that if you
want to re-instate it, the code should be

 (a) only done for the case where it matters (ie for the RCUBOOST case)

 (b) tested better for performance issues (and maybe shared with the
tinyrcu case that also uses threads?)

Please? It's more than a revert of that one commit - there's tons of
commits on top of that to actually do the boosting etc (and fixing
some of the fallout). But really, by now I'd prefer to just revert it
all, rather than see if it can be fixed up.. According to Peter,
Shaohua Li's patch that largely fixes the performance issue for the
other load (by moving *some* of the RCU stuff back to softirq context)
helps, but still leaves the rcu threads with a lot of CPU time.

Considering that most of the RCU callbacks are not very CPU intensive,
I bet that there's a *ton* of them, and that the context switch
overhead is quite noticeable. And quite frankly, even if Shaohua Li's
patch largely fixes the performance issue, it does so by making the
RCU situation EVEN MORE COMPLEX, with RCU now using *both* threads and
softirq.

That's just crazy. If you really want to do both the threads and
softirq thing for the magical RCU_BOOST case, go ahead, but please
don't do crazy things for the sane configurations.

                                Linus
