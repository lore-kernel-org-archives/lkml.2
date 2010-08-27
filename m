Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0H0Plj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:41:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0H0Pli convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:41:38 -0400
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100827152125.GB14926@Krystal>
References: <20100826180908.648103531@efficios.com>
	 <1282849045.1975.1587.camel@laptop>
	 <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain>
	 <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain>
	 <20100826230934.GA4194@Krystal> <1282894655.1975.1650.camel@laptop>
	 <20100827152125.GB14926@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 17:41:26 +0200
Message-ID: <1282923686.1975.2780.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 11:21 -0400, Mathieu Desnoyers wrote:
>        SIGEV_THREAD
>               Upon  timer  expiration,  invoke  sigev_notify_function as if it
>               were the start function of a new thread.  (Among the implementa‐
>               tion  possibilities  here are that each timer notification could
>               result in the creation of a new thread, or that a single  thread
>               is  created  to  receive  all  notifications.)   The function is
>               invoked   with   sigev_value   as   its   sole   argument.    If
>               sigev_notify_attributes  is  not  NULL,  it  should  point  to a
>               pthread_attr_t structure that defines  attributes  for  the  new
>               thread (see pthread_attr_init(3).
> 
> So basically, it's the glibc implementation that is broken, not the standard.

The standard is broken too, what context will the new thread inherit?
The pthread_attr_t stuff tries to cover some of that, but pthread_attr_t
doesn't cover all inherited task attributes, and allows for some very
'interesting' bugs [1].

The specification also doesn't cover the case where the handler takes
more time to execute than the timer interval.

[1] - consider the case where pthread_attr_t includes the stack and we
use a spawn thread on expire policy and then run into the situation
where the handler is delayed past the next expiration.
