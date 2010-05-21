Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301Ab0EUShK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:37:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48616 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934101Ab0EUShI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:37:08 -0400
Date: Fri, 21 May 2010 20:36:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/4] perf: Precise task / softirq / hardirq filtered
 stats/profiles
Message-ID: <20100521183649.GA9685@elte.hu>
References: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
 <20100521151230.GA20941@elte.hu>
 <1274458513.1674.1714.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274458513.1674.1714.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4083]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2010-05-21 at 17:12 +0200, Ingo Molnar wrote:
> > 'exclusion' is the ABI detail. The feature your patches 
> > implement are to allow 'softirq limited' or 'task-context 
> > limited' or 'hardirq profiling' - which is way cool.
> > 
> > One thing i'd like to see in this feature is for it to 
> > work on pure event counting - i.e. 'perf stat' as well. 
> 
> Its not really exclusion, all it does is discard samples 
> when in the wrong context (which happens to work 
> reasonably well for all the swevents, except for the 
> timer ones).
> 
> If you really want to do exclusion you have to 
> disable/enable on *IRQ entry/exit, but I guess that gets 
> to be prohibitive on costs.

Yeah, i know - this is what i tried to allude to in my 
other part of my reply:

> > If we extended your feature to perf stat, we might be 
> > able to get a lot more precise measurements in terms 
> > of kernel optimizations (and kernel bloat).

Right, so there's two ways to do it, one is the 
disable/enable what you mention, the other would be to 
save the count and then read again and subtract the delta. 

( the RDPMC based delta method can be made to work for 
  sampling as well, even if the NMI hits in the middle of 
  the softirq or hardirq. )

Two reads might be cheaper than a disable+enable. 
Especially if it's done using RDPMC.

We should do it like that, not by discarding samples, and 
overhead should be OK as long as we dont do the 
disable/enable (or delta read) if the feature is off.

If a simple enable/disable or read/read costs too much 
then we need to prod hw makers about it. But it should be 
OK i think.

	Ingo
