Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1HOOHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:07:12 -0400
Received: from orion.CARNet.hr ([161.53.160.90]:59708 "EHLO orion.carnet.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab1HOOHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:07:10 -0400
X-Greylist: delayed 2152 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Aug 2011 10:07:10 EDT
Date: Mon, 15 Aug 2011 15:31:17 +0200
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,SPARC] make sparc32 arch_write_unlock() match the
 sparc64 version
Message-ID: <20110815133116.GA20563@entuzijast.net>
References: <20040.65109.439941.444670@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20040.65109.439941.444670@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: Josip Rodin <joy@entuzijast.net>
X-SA-Exim-Connect-IP: <locally generated>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 01:09:09PM +0200, Mikael Pettersson wrote:
> The sparc32 version of arch_write_unlock() is just a plain assignment.
> Unfortunately this allows the compiler to schedule side-effects in a
> protected region to occur after the HW-level unlock, which is broken.
> E.g., the following trivial test case gets miscompiled:
> 
> 	#include <linux/spinlock.h>
> 	rwlock_t lock;
> 	int counter;
> 	void foo(void) { write_lock(&lock); ++counter; write_unlock(&lock); }
> 
> Fixed by adding a compiler memory barrier to arch_write_unlock().  The
> sparc64 version combines the barrier and assignment into a single asm(),
> so that's what I did here as well.
> 
> Compiled-tested with a sparc32 SMP kernel.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> ---
> --- linux-3.1-rc2/arch/sparc/include/asm/spinlock_32.h.~1~	2011-07-22 12:01:08.000000000 +0200
> +++ linux-3.1-rc2/arch/sparc/include/asm/spinlock_32.h	2011-08-15 11:43:49.000000000 +0200
> @@ -131,6 +131,15 @@ static inline void arch_write_lock(arch_
>  	*(volatile __u32 *)&lp->lock = ~0U;
>  }
>  
> +static void inline arch_write_unlock(arch_rwlock_t *lock)
> +{
> +	__asm__ __volatile__(
> +"	st		%%g0, [%0]"
> +	: /* no outputs */
> +	: "r" (lock)
> +	: "memory");
> +}
> +
>  static inline int arch_write_trylock(arch_rwlock_t *rw)
>  {
>  	unsigned int val;
> @@ -175,7 +184,7 @@ static inline int __arch_read_trylock(ar
>  	res; \
>  })
>  
> -#define arch_write_unlock(rw)	do { (rw)->lock = 0; } while(0)
> +#define arch_write_unlock(rw)	arch_write_unlock(rw)
>  
>  #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
>  #define arch_read_lock_flags(rw, flags)   arch_read_lock(rw)

Why keep the tautological define? Just wondering.

-- 
     2. That which causes joy or happiness.
