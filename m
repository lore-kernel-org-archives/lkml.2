Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab1BRTCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:02:45 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49953 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab1BRTCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:02:43 -0500
Date: Fri, 18 Feb 2011 22:33:46 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        suzuki@in.ibm.com, vsrivatsa@gmail.com
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
Message-ID: <20110218170346.GA30264@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <20110117152222.GA19233@linux.vnet.ibm.com>
 <20110119162348.GA29900@linux.vnet.ibm.com>
 <4D3DF5A5.7070301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3DF5A5.7070301@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jan 24, 2011 at 01:56:53PM -0800, Jeremy Fitzhardinge wrote:

For some reason, I seem to be missing emails from your id/domain and hence had
missed this completely!

> >   * bits.  However, we need to be careful about this because someone
> >   * may just be entering as we leave, and enter the slowpath.
> >   */
> > -void __ticket_unlock_release_slowpath(struct arch_spinlock *lock)
> > +void __ticket_unlock_slowpath(struct arch_spinlock *lock)
> >  {
> >  	struct arch_spinlock old, new;
> >  
> >  	BUILD_BUG_ON(((__ticket_t)NR_CPUS) != NR_CPUS);
> >  
> >  	old = ACCESS_ONCE(*lock);
> > -
> >  	new = old;
> > -	new.tickets.head += TICKET_LOCK_INC;
> >  
> >  	/* Clear the slowpath flag */
> >  	new.tickets.tail &= ~TICKET_SLOWPATH_FLAG;
> > +	if (new.tickets.head == new.tickets.tail)
> > +		cmpxchg(&lock->head_tail, old.head_tail, new.head_tail);
> >  
> > -	/*
> > -	 * If there's currently people waiting or someone snuck in
> > -	 * since we read the lock above, then do a normal unlock and
> > -	 * kick.  If we managed to unlock with no queued waiters, then
> > -	 * we can clear the slowpath flag.
> > -	 */
> > -	if (new.tickets.head != new.tickets.tail ||
> > -	    cmpxchg(&lock->head_tail,
> > -		    old.head_tail, new.head_tail) != old.head_tail) {
> > -		/* still people waiting */
> > -		__ticket_unlock_release(lock);
> > -	}
> > -
> > +	/* Wake up an appropriate waiter */
> >  	__ticket_unlock_kick(lock, new.tickets.head);
> 
> Does the __ticket_unlock_kick need to be unconditional?

I recall having tried optimizing it to be conditional, something along these
lines:

	if (new.ticket.head == new.tickets.tail) {
		cmpxchg();	
	} else {
		__ticket_unlock_kick(lock, new.tickets.head);
	}

but it didn't work for some reason. I left the call unconditional as was the
case previously based on that experiment.

- vatsa
