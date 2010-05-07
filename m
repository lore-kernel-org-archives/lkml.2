Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0EGGQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:16:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:32856 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751124Ab0EGGQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:16:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18DXdstjsYDHSD67W+rOSQpqyFxw4ri1rUHAWthbD
	7hEQW27DIr6ZcV
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
From: Mike Galbraith <efault@gmx.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100507053023.GF8069@nowhere>
References: <1272429513.24542.83.camel@pasglop>
	 <201004281406.04080.arnd@arndb.de> <1272494121.24542.113.camel@pasglop>
	 <20100507042010.GR12389@ozlabs.org>  <20100507053023.GF8069@nowhere>
Content-Type: text/plain
Date: Fri, 07 May 2010 08:16:48 +0200
Message-Id: <1273213008.9286.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 07:30 +0200, Frederic Weisbecker wrote:

> I like the safeguard against the bkl, it looks indeed like something
> we should have in .34
> 
> But I really don't like the timeout.
> 
> This is going to make the things even worse if we have another cause of
> deadlock by hiding the worst part of the consequences without actually
> solving the problem.
> And since the induced latency or deadlock won't be easily visible anymore,
> we'll miss there is a problem. So we are going to spin for two jiffies
> and only someone doing specific latency measurements will notice, if he's
> lucky enough to meet the bug.
> 
> Moreover that adds some unnessary (small) overhead in this path.
> 
> May be can we have it as a debugging option, something that would
> be part of lockdep, which would require CONFIG_DEBUG_MUTEX to
> support mutex adaptive spinning.
> 
> A debugging option that could just dump the held locks and the
> current one if we spin for an excessive timeslice.

FYI, there's a case where OWNER_SPIN eats astounding amounts of CPU.

Run virgin AIM7 V1.1 with many many tasks and a nil workfile.  When the
thing kicks off preparing for test, it forks of these many tasks, who
then all try to phone home via pipe.  The result it horrible to behold.

There's a fix for AIM7's scalability problem, but the virgin code looks
like a decent OWNER_SPIN corner case test.  It turns a 32 core smt box
into an expensive space heater at sufficiently high task count:)

	-Mike

