Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1LTKZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:25:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37675 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1LTKZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:25:46 -0500
Date: Tue, 20 Dec 2011 11:23:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [GIT PULL v2] x86: Workaround for NMI iret woes
Message-ID: <20111220102352.GD20788@elte.hu>
References: <1324095039.23971.145.camel@gandalf.stny.rr.com>
 <20111218092405.GI4144@elte.hu>
 <1324314151.5916.15.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324314151.5916.15.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > > +	pushq_cfi $repeat_nmi
> > > +
> > > +	/* Put stack back */
> > > +	addq $(11*8), %rsp
> 
> This is where we put the stack back to the original position. 
> Is CFI notation really necessary here?

i'd add it if it's not hard or ugly - in theory we could get a
#MC exception in that window.

> > Note that the IRQ return checks are needed because NMI path 
> > can set the irq-work TIF. Might be worth putting into the 
> > comment - NMIs are not *entirely* passive entities.
> 
> The NMI path can set the TIF flags? Then where should they be 
> processed. There was an assumption that NMIs shouldn't do 
> that. I could have been wrong with that. What work needs to be 
> done and when? This is the change that Linus made. If that's 
> the case, we need to work something else out.

Hm, you are right, we at most access them (for 32-bit compat 
checks for example) but don't modify them - we have switched to 
using the special irq work self-IPI.

So the change is fine.

> > Something like nmi_postprocess_retry_preprocess()?
> 
> Not sure what would be good, as i386 does the retry, x86_64 
> just switches the idt. The two archs do two different things. 
> The above name would be confusing as it doesn't match what 
> x86_64 does.

Yeah, that assymetry is bothering me too. I guess we can keep it 
as-is, no strong feelings. The whole thing *feels* fragile.

Thanks,

	Ingo
