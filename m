Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2HISR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:17:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43731 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504Ab2HISRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:17:25 -0400
Date: Thu, 9 Aug 2012 19:17:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
Message-ID: <20120809181705.GG18486@mudshark.cambridge.arm.com>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208090029460.5231@xanadu.home>
 <20120809144953.GC18486@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208091201380.5231@xanadu.home>
 <alpine.LFD.2.02.1208091243080.5231@xanadu.home>
 <20120809175019.GE18486@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208091405340.5231@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208091405340.5231@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 07:09:02PM +0100, Nicolas Pitre wrote:
> On Thu, 9 Aug 2012, Will Deacon wrote:
> > On Thu, Aug 09, 2012 at 05:57:33PM +0100, Nicolas Pitre wrote:
> > > On Thu, 9 Aug 2012, Nicolas Pitre wrote:
> > > diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
> > > index 580a6d35c7..44a66c99c8 100644
> > > --- a/include/asm-generic/mutex-xchg.h
> > > +++ b/include/asm-generic/mutex-xchg.h
> > > @@ -25,8 +25,11 @@
> > >  static inline void
> > >  __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
> > >  {
> > > -	if (unlikely(atomic_xchg(count, 0) != 1))
> > > -		fail_fn(count);
> > > +	if (unlikely(atomic_xchg(count, 0) != 1)) {
> > > +		/* Mark lock contention explicitly */
> > > +		if (likely(atomic_xchg(count, -1) != 1))
> > > +			fail_fn(count);
> > > +	}
> > >  }
> > >  
> > >  /**
> > 
> > Doesn't this mean that we're no longer just swapping 0 for a 0 if the lock
> > was taken, therefore needlessly sending the current owner down the slowpath
> > on unlock?
> 
> If the lock was taken, this means the count was either 0 or -1.  If it 
> was 1 then we just put a 0 there and we own it.  But if the cound was 0 
> then we should store -1 instead, which is what the inner xchg does.  If 
> the count was already -1 then we store -1 back.  That more closely mimic 
> what the atomic dec does which is what we want.

Ok, I just wasn't sure that marking the lock contended was required when it
was previously locked, given that we'll drop into spinning on the owner
anyway.

I'll add a commit message to the above and re-post if that's ok?

Will
