Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab1FQJou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:44:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab1FQJoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:44:46 -0400
Date: Fri, 17 Jun 2011 11:43:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, shaohua.li@intel.com,
        alex.shi@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PULL] Re: REGRESSION: Performance regressions from
 switching anon_vma->lock to mutex
Message-ID: <20110617094333.GB19235@elte.hu>
References: <20110615201216.GA4762@elte.hu>
 <35c0ff16-bd58-4b9c-9d9f-d1a4df2ae7b9@email.android.com>
 <20110616070335.GA7661@elte.hu>
 <20110616171644.GK2582@linux.vnet.ibm.com>
 <20110616202550.GA16214@elte.hu>
 <1308262883.2516.71.camel@pasglop>
 <20110616223837.GA18431@elte.hu>
 <4DFA8802.6010300@linux.intel.com>
 <20110616225803.GA28557@elte.hu>
 <20110617004536.GP2582@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617004536.GP2582@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Fri, Jun 17, 2011 at 12:58:03AM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <ak@linux.intel.com> wrote:
> > 
> > > > There's a crazy solution for that: the idle thread could process 
> > > > RCU callbacks carefully, as if it was running user-space code.
> > > 
> > > In Ben's kernel NFS server case the system may not be idle.
> > 
> > An always-100%-busy NFS server is very unlikely, but even in the 
> > hypothetical case a kernel NFS server is really performing system 
> > calls from a kernel thread in essence. If it doesn't do it explicitly 
> > then its main loop can easily include a "check RCU callbacks" call.
> 
> As long as they make sure to call it in a clean environment: no 
> locks held and so on.  But I am a bit worried about the possibility 
> of someone forgetting to put one of these where it is needed -- it 
> would work just fine for most workloads, but could fail only for 
> rare workloads.

Yeah, some sort of worst-case-tick mechanism would guarantee that we 
wont remain without RCU GC.

> That said, invoking RCU core/callback processing from the scheduler 
> context certainly sounds like an interesting way to speed up grace 
> periods.

It also moves whatever priority logic is needed closer to the 
scheduler that has to touch those data structures anyway.

RCU, at least partially, is a scheduler driven garbage collector even 
today: beyond context switch quiescent states the main practical role 
of the per CPU timer tick itself is scheduling. So having it close to 
when we do context-switches anyway looks pretty natural - worth 
trying.

It might not work out in practice, but at first sight it would 
simplify a few things i think.

Thanks,

	Ingo
