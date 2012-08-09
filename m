Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab2HIRuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:50:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42781 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757744Ab2HIRuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:50:39 -0400
Date: Thu, 9 Aug 2012 18:50:20 +0100
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
Message-ID: <20120809175019.GE18486@mudshark.cambridge.arm.com>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208090029460.5231@xanadu.home>
 <20120809144953.GC18486@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208091201380.5231@xanadu.home>
 <alpine.LFD.2.02.1208091243080.5231@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208091243080.5231@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 05:57:33PM +0100, Nicolas Pitre wrote:
> On Thu, 9 Aug 2012, Nicolas Pitre wrote:
> > Yes, that looks fine.  I'd remove that if (prev < 0) entirely though.  
> > We'll just swap a 0 for a 0 if the count wasn't < 0, or a 0 for a 1 if 
> > the mutex just got unlocked which is also fine.  This is especially 
> > beneficial when a native xchg processor instruction is used.
> 
> In fact, this suggestion isn't entirely correct either. The inner xchg 
> in this case should be -1 and not 'count'.  If 'count' is 0 and the 
> mutex becomes contended in the small window between the two xchg's then 
> the contention mark would be lost again.
> 
> In other words, I think this should look like this:
> 
> diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
> index 580a6d35c7..44a66c99c8 100644
> --- a/include/asm-generic/mutex-xchg.h
> +++ b/include/asm-generic/mutex-xchg.h
> @@ -25,8 +25,11 @@
>  static inline void
>  __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
>  {
> -	if (unlikely(atomic_xchg(count, 0) != 1))
> -		fail_fn(count);
> +	if (unlikely(atomic_xchg(count, 0) != 1)) {
> +		/* Mark lock contention explicitly */
> +		if (likely(atomic_xchg(count, -1) != 1))
> +			fail_fn(count);
> +	}
>  }
>  
>  /**

Doesn't this mean that we're no longer just swapping 0 for a 0 if the lock
was taken, therefore needlessly sending the current owner down the slowpath
on unlock? If we have the explicit test, that doesn't happen and the
disassembly isn't much different (an additional cmp/conditional branch).

Will
