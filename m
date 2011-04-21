Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab1DUNfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:35:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47251 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1DUNfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FOIXK+Xoa4DJoSLVetZDs1lqgNFWVlaMzt8MzuLSVBKXypJD/r754HZCtOH4UOsFmP
         iZG8Za7FZMPoydhpQFBFzjLColXSS+5tWw4wqYZETwBH9sz0K5AWe6a3+ksGuLRAZ4yA
         QNl8VW6nkGaI+CFbVP6rV6fOhbEWO7v4642Ns=
Date: Thu, 21 Apr 2011 21:35:41 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/7] lockdep: Print a nice description of an irq
 locking issue
Message-ID: <20110421133541.GB2702@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110421014153.126662477@goodmis.org>
 <20110421014259.132728798@goodmis.org>
 <BANLkTimzhTqOXZ6BFGP68EB4Wqrx9OAH7Q@mail.gmail.com>
 <1303386029.7181.118.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1303386029.7181.118.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 07:40:29AM -0400, Steven Rostedt wrote:
> On Thu, 2011-04-21 at 15:02 +0800, Yong Zhang wrote:
> > On Thu, Apr 21, 2011 at 9:41 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >  ---
> > >
> > > The above is the case when the unsafe lock is taken while holding
> > > a lock taken in irq context. But when a lock is taken that also
> > > grabs a unsafe lock, the call chain is shown:
> > >
> > >  ---
> > > other info that might help us debug this:
> > >
> > > Chain exists of:
> > >  &rq->lock --> lockA --> lockC
> > >
> > >  Possible interrupt unsafe locking scenario:
> > >
> > >       CPU0                    CPU1
> > >       ----                    ----
> > >  lock(lockC);
> > >                               local_irq_disable();
> > >                               lock(&rq->lock);
> > >                               lock(lockA);
> > >  <Interrupt>
> > >    lock(&rq->lock);
> > >
> > >  *** DEADLOCK ***
> > 
> > Or we could show this:
> > Chain exists of:
> > &rq->lock --> lockA --> lockC
> > 
> >  Possible interrupt unsafe locking scenario:
> > 
> >       CPU0                    CPU1                           CPU2
> >       ----                    ----                                     ----
> >  lock(lockC);
> >                               local_irq_disable();
> >                               lock(&rq->lock);            lock(lockA);
> >                               lock(lockA);                   lock(lockC);
> >  <Interrupt>
> >    lock(&rq->lock);
> > 
> >  *** DEADLOCK ***
> 
> 
> We could but I prefer not to ;) We have some chains that are 8 locks
> deep. I really don't want to scatter that entirely across the screen.
> Hence my "Chain exists.." statement, following an example that any
> kernel developer can (with a little thinking) see is a possible
> deadlock.

Yup :)

> 
> In fact, this code doesn't even look at the full chain, it only examines
> 3 locks in the chain, and lets the developer figure out the rest.

OK, fair enough.

> I
> could show the entire chain too.

Sure :)

Thanks,
Yong
