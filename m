Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab1ISTOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 15:14:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41063 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1ISTOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 15:14:31 -0400
Subject: Re: [RFC][PATCH 2/3] futex: Reduce hash bucket lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Date: Mon, 19 Sep 2011 10:51:47 +0200
In-Reply-To: <1316417840.10174.46.camel@twins>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.831707072@chello.nl> <1316176490.10174.22.camel@twins>
	 <4E749937.5090803@colorfullife.com> <1316417840.10174.46.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316422307.1511.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 09:37 +0200, Peter Zijlstra wrote:
> On Sat, 2011-09-17 at 14:57 +0200, Manfred Spraul wrote:
> > How do we verify that everything is able to deal with spurious
> > wakeups?
> > 
> Well, I could go audit all 1400+ *schedule*() callsites in the kernel.
> Or we can rely on the fact that current code can already cause spurious
> wakeups due to signals.

Hrmm,. the sem code would have serialized on the IN_WAKER stuff, the
mutex code would serialize on the ->wait_lock, and the futex code would
have serialized on the hb lock.

So while it can issue multiple wakeups, those should not leak out of the
locking primitive.. crap.

Still wondering why we've got that many schedule() calls in the kernel
though, clearly we don't have enough blocking primitives or so..
