Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2HMIPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 04:15:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49643 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2HMIPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 04:15:22 -0400
Message-ID: <1344845704.31459.11.camel@twins>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 13 Aug 2012 10:15:04 +0200
In-Reply-To: <alpine.LFD.2.02.1208091243080.5231@xanadu.home>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
	 <alpine.LFD.2.02.1208090029460.5231@xanadu.home>
	 <20120809144953.GC18486@mudshark.cambridge.arm.com>
	 <alpine.LFD.2.02.1208091201380.5231@xanadu.home>
	 <alpine.LFD.2.02.1208091243080.5231@xanadu.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 12:57 -0400, Nicolas Pitre wrote:
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
> -       if (unlikely(atomic_xchg(count, 0) != 1))
> -               fail_fn(count);
> +       if (unlikely(atomic_xchg(count, 0) != 1)) {
> +               /* Mark lock contention explicitly */
> +               if (likely(atomic_xchg(count, -1) != 1))
> +                       fail_fn(count);
> +       }
>  } 

OK, I like this.. Thanks guys! Will will you send a final and complete
patch?
