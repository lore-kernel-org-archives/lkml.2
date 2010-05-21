Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0EUKiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:38:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52960 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0EUKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F5pb7OfHc/uWBzW5A1Z3QgXLNvR2BvpSTyW1eMcNayV7MJQM9isHWQ+2gHrrHNKG4n
         3+mtL1fPFfZUkO7CiTwJIj8WCUaWlh7OgCBdC/wsnc0s84cIDhOl4Tji+82UTIJXZtCD
         mTCRkxUbY59t8e9iOPQdSyZO0TV1ng07QOs4w=
Date: Fri, 21 May 2010 12:38:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
	track events
Message-ID: <20100521103816.GG30108@nowhere>
References: <20100521090201.326791353@chello.nl> <20100521090710.473188012@chello.nl> <20100521094014.GA30108@nowhere> <1274436125.1674.1690.camel@laptop> <20100521101347.GC30108@nowhere> <1274437149.1674.1697.camel@laptop> <20100521102131.GE30108@nowhere> <1274438043.1674.1699.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274438043.1674.1699.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 12:34:03PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-05-21 at 12:21 +0200, Frederic Weisbecker wrote:
> > On Fri, May 21, 2010 at 12:19:09PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2010-05-21 at 12:13 +0200, Frederic Weisbecker wrote:
> > > > > I assumed that after probe unregister a tracepoint callback doesn't
> > > > > happen, which then guarantees we should never get !head.
> > > 
> > > > I'm not sure about this. The tracepoints are called under rcu_read_lock(),
> > > > but there is not synchronize_rcu() after we unregister a tracepoint, which
> > > > means you can have a pending preempted one somewhere.
> > > > 
> > > > There is a call_rcu that removes the callbacks, but that only protect
> > > > the callback themselves. 
> > > 
> > > Ah, ok, so we should do probe_unregister + synchronize_sched().
> > > That should ensure __DO_TRACE() doesn't call into it anymore.
> > > 
> > > /me goes make a patch
> > > 
> > 
> > 
> > Yep. But that also means we need to rcu_dereference_sched() to access
> > the per cpu list of events.
> 
> Why?
> 
> The per-cpu vars are allocated and freed in a fully serialized manner,
> there should be no races what so ever.


Ah right, I was confused.

