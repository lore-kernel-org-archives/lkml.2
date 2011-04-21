Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1DULkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:40:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52679 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1DULkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:40:31 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=R6sLeq5vHiIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=zGKtL67101eEpoBJi5MA:9 a=37H__hBZQYICicOkydAA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/7] lockdep: Print a nice description of an irq
 locking issue
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <BANLkTimzhTqOXZ6BFGP68EB4Wqrx9OAH7Q@mail.gmail.com>
References: <20110421014153.126662477@goodmis.org>
	 <20110421014259.132728798@goodmis.org>
	 <BANLkTimzhTqOXZ6BFGP68EB4Wqrx9OAH7Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Apr 2011 07:40:29 -0400
Message-ID: <1303386029.7181.118.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 15:02 +0800, Yong Zhang wrote:
> On Thu, Apr 21, 2011 at 9:41 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >  ---
> >
> > The above is the case when the unsafe lock is taken while holding
> > a lock taken in irq context. But when a lock is taken that also
> > grabs a unsafe lock, the call chain is shown:
> >
> >  ---
> > other info that might help us debug this:
> >
> > Chain exists of:
> >  &rq->lock --> lockA --> lockC
> >
> >  Possible interrupt unsafe locking scenario:
> >
> >       CPU0                    CPU1
> >       ----                    ----
> >  lock(lockC);
> >                               local_irq_disable();
> >                               lock(&rq->lock);
> >                               lock(lockA);
> >  <Interrupt>
> >    lock(&rq->lock);
> >
> >  *** DEADLOCK ***
> 
> Or we could show this:
> Chain exists of:
> &rq->lock --> lockA --> lockC
> 
>  Possible interrupt unsafe locking scenario:
> 
>       CPU0                    CPU1                           CPU2
>       ----                    ----                                     ----
>  lock(lockC);
>                               local_irq_disable();
>                               lock(&rq->lock);            lock(lockA);
>                               lock(lockA);                   lock(lockC);
>  <Interrupt>
>    lock(&rq->lock);
> 
>  *** DEADLOCK ***


We could but I prefer not to ;) We have some chains that are 8 locks
deep. I really don't want to scatter that entirely across the screen.
Hence my "Chain exists.." statement, following an example that any
kernel developer can (with a little thinking) see is a possible
deadlock.

In fact, this code doesn't even look at the full chain, it only examines
3 locks in the chain, and lets the developer figure out the rest. I
could show the entire chain too.

Thanks,

-- Steve


