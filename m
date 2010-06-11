Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab0FKINX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 04:13:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43206 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab0FKINU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 04:13:20 -0400
Date: Fri, 11 Jun 2010 10:12:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 03/13] jump label v9: x86 support
Message-ID: <20100611081256.GA20217@elte.hu>
References: <cover.1276116186.git.jbaron@redhat.com>
 <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com>
 <1276171930.2077.200.camel@twins>
 <20100610121440.GA20130@elte.hu>
 <20100610132616.GA19561@basil.fritz.box>
 <20100610153742.GA9118@elte.hu>
 <20100610162453.GF19561@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610162453.GF19561@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > > A much better to get smaller kernel images is to do more __cold 
> > > annotations for slow paths. Newer gcc will then simply only do -Os for 
> > > these functions.
> > 
> > That's an opt-in method and we cannot reach the kinds of 30% code size 
> > reductions that -Os can achieve. Most code in the kernel is not cache-hot, 
> > even on microbenchmarks.
> 
> Maybe, maybe not. But yes it can be approached from both ways.

You dont seem to have understood my point: there's a big difference between an 
opt-in and an opt-out model.

What you are arguing for is a 'bloaty code generator by default' model and 
that model sucks.

Trying to achieve reductions by opt-in marking functions as a 'please reduce 
it' __cold marker is a losing battle: most new kernel code is 'cold' and 
should be reduced, yet most new code does not (and will not) come with __cold 
markers.

The proper model is to assume that everything should be conservatively 
size-reduced (because, almost by definition, 90% of new kernel code should 
stay small and should stay out of the way), and where benchmarks+importance 
proves it we can allow bloatier code generator via __hot.

Important codepaths can get __hot annotations just as much as they are 
receiving 'inline' optimizations and other kinds of hand-tuning attention.

> Personally I would prefer to simply write less bloated code to get code 
> reductions. Simpler code is often faster too.

You are posing this as an if-else choice, while in reality both should be 
done: the best result is to write simpler/faster code _and_ to have a 
compact-by-default code generator too ...

> > A much better model would be to actively mark hot codepaths with a __hot 
> > attribute instead. Then the code size difference can be considered on a 
> > case by case basis.
> 
> Yes that works too for those who still use -Os.
> 
> e.g. marking the scheduler and a few mm hot paths this way would certain 
> make sense.

Possibly, but not without substantiating the rather vague statements you have 
made so far.

If you are sending such per function annotation patches then you need to come 
up with actual hard numbers as well. One convenient way to measure such things 
is a before/after "perf stat --repeat" run - as the noise estimations can be 
compared and we can see whether there's a provable effect. (And, of course, 
disassembly of GCC suckage is helpful as well.)

Thanks,

	Ingo
