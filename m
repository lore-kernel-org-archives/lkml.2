Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab0FJQY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:24:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56395 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0FJQY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:24:56 -0400
Date: Thu, 10 Jun 2010 18:24:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 03/13] jump label v9: x86 support
Message-ID: <20100610162453.GF19561@basil.fritz.box>
References: <cover.1276116186.git.jbaron@redhat.com> <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com> <1276171930.2077.200.camel@twins> <20100610121440.GA20130@elte.hu> <20100610132616.GA19561@basil.fritz.box> <20100610153742.GA9118@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610153742.GA9118@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 05:37:42PM +0200, Ingo Molnar wrote:
> 
> > [...] It costs you in some benchmarks. [...]
> 
> Microbenchmarks mostly, see below.

I didn't make these decisions, but I assume who made them had good reasons
and enough data on larger benchmarks too.

> > A much better to get smaller kernel images is to do more __cold annotations 
> > for slow paths. Newer gcc will then simply only do -Os for these functions.
> 
> That's an opt-in method and we cannot reach the kinds of 30% code size 
> reductions that -Os can achieve. Most code in the kernel is not cache-hot, 
> even on microbenchmarks.

Maybe, maybe not. But yes it can be approached from both ways.

Personally I would prefer to simply write less bloated code to get
code reductions. Simpler code is often faster too.

> 
> A much better model would be to actively mark hot codepaths with a __hot 
> attribute instead. Then the code size difference can be considered on a case 
> by case basis.

Yes that works too for those who still use -Os. 

e.g. marking the scheduler and a few mm hot paths this way would certain make sense.

> 
> And where GCC produces indefensibly crap code there GCC needs to be fixed. 
> Crap code often increases size so the fix would increase the efficiency of 
> -Os.

In some cases agreed, but common cases it's really: you asked for the smallest
you got it, even if it's slow. It's not -Odwim. 

One standard example here is a division by constant. The shortest way is 
using DIVI/IDIV if it's not 2^n and small enough, but it's really quite slow 
in hardware.  If you spend a few more bytes you can do much better for a wide 
range of constants.

Most likely we would need a new -O flag to avoid such cases. 

BTW I experimented with marking a few common cases like this (e.g. time unit 
conversion) hot, but gcc currently has trouble with __hot on inlines. So you
would always need to mark the caller.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
