Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab2HIQRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:17:33 -0400
Received: from relais.videotron.ca ([24.201.245.36]:26951 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab2HIQRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:17:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 09 Aug 2012 12:17:30 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
In-reply-to: <20120809144953.GC18486@mudshark.cambridge.arm.com>
Message-id: <alpine.LFD.2.02.1208091201380.5231@xanadu.home>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208090029460.5231@xanadu.home>
 <20120809144953.GC18486@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012, Will Deacon wrote:

> I think we could actually fix this entirely in mutex-xchg.h by doing
> something in fastpath_lock similar to what we do for trylock:
> 
> 
> diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
> index 580a6d3..c082e99 100644
> --- a/include/asm-generic/mutex-xchg.h
> +++ b/include/asm-generic/mutex-xchg.h
> @@ -25,8 +25,19 @@
>  static inline void
>  __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
>  {
> -       if (unlikely(atomic_xchg(count, 0) != 1))
> -               fail_fn(count);
> +       int prev = atomic_xchg(count, 0);
> +
> +       if (unlikely(prev != 1)) {
> +               if (prev < 0)
> +                       /*
> +                        * The lock was contended, so we need to restore
> +                        * its original state to ensure that any waiting
> +                        * tasks are woken up by the unlock slow path.
> +                        */
> +                       prev = atomic_xchg(count, prev);
> +               if (prev != 1)
> +                       fail_fn(count);
> +       }
>  }
> 
> What do you reckon?

Yes, that looks fine.  I'd remove that if (prev < 0) entirely though.  
We'll just swap a 0 for a 0 if the count wasn't < 0, or a 0 for a 1 if 
the mutex just got unlocked which is also fine.  This is especially 
beneficial when a native xchg processor instruction is used.

> > Of course that might tilt the balance towards using mutex-dec.h on ARM 
> > v6 and above instead of mutex-xchg.h.  But that is an orthogonal issue, 
> > and that doesn't remove the need for fixing the xchg based case for 
> > correctness.
> 
> I'll do some hackbench runs against mutex-dec once we've decided on the final
> xchg code. If it's faster, I'll submit a patch for ARM.

I don't think it would be faster.  It is just potentially more fair.


Nicolas
