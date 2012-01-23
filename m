Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2AWTxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:53:11 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:16605 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2AWTxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:53:10 -0500
Date: Mon, 23 Jan 2012 14:50:47 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: xen: size struct xen_spinlock to always fit in
 arch_spinlock_t
Message-ID: <20120123195047.GA11002@phenom.dumpdata.com>
References: <1327347145-16439-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327347145-16439-1-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F1DBAA1.00F7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 07:32:25PM +0000, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> If NR_CPUS < 256 then arch_spinlock_t is only 16 bits wide but struct
> xen_spinlock is 32 bits.  When a spin lock is contended and
> xl->spinners is modified the two bytes immediately after the spin lock
> would be corrupted.
> 
> This is a regression caused by 84eb950db13ca40a0572ce9957e14723500943d6
> (x86, ticketlock: Clean up types and accessors) which reduced the size
> of arch_spinlock_t.
> 
> Fix this by making xl->spinners a u8 if NR_CPUS < 256.  A
> BUILD_BUG_ON() is also added to check the sizes of the two structures
> are compatible.
> 
> In many cases this was not noticable as there would often be padding
> bytes after the lock (e.g., if any of CONFIG_GENERIC_LOCKBREAK,
> CONFIG_DEBUG_SPINLOCK, or CONFIG_DEBUG_LOCK_ALLOC were enabled).
> 
> The bnx2 driver is affected. In struct bnx2, phy_lock and
> indirect_lock may have no padding after them.  Contention on phy_lock
> would corrupt indirect_lock making it appear locked and the driver
> would deadlock.

Nice find. I think it also affected the ahci driver, and some of the USB
ones - at least those I saw starting to hang with:

[   79.317407] BUG: soft lockup - CPU#1 stuck for 22s! [modprobe:2244]

Do you have some of those messages by any chance?

Going to test this overnight to see if it fixes the mysterious rash of
32-bit v3.3-rc1 build dying and showing:

 [<c1308681>] ? xen_poll_irq_timeout+0x41/0x60
 [<c13086ac>] xen_poll_irq+0xc/0x10
 [<c104447a>] xen_spin_lock_slow+0xca/0x210
 [<c10447bc>] xen_spin_lock+0xec/0x100
 [<c154a561>] _raw_spin_lock+0x21/0x30

Thanks!
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>  arch/x86/xen/spinlock.c |   27 ++++++++++++++++++++++-----
>  1 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index cc9b1e1..d69cc6c 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -116,9 +116,26 @@ static inline void spin_time_accum_blocked(u64 start)
>  }
>  #endif  /* CONFIG_XEN_DEBUG_FS */
>  
> +/*
> + * Size struct xen_spinlock so it's the same as arch_spinlock_t.
> + */
> +#if NR_CPUS < 256
> +typedef u8 xen_spinners_t;
> +# define inc_spinners(xl) \
> +	asm(LOCK_PREFIX " incb %0" : "+m" ((xl)->spinners) : : "memory");
> +# define dec_spinners(xl) \
> +	asm(LOCK_PREFIX " decb %0" : "+m" ((xl)->spinners) : : "memory");
> +#else
> +typedef u16 xen_spinners_t;
> +# define inc_spinners(xl) \
> +	asm(LOCK_PREFIX " incw %0" : "+m" ((xl)->spinners) : : "memory");
> +# define dec_spinners(xl) \
> +	asm(LOCK_PREFIX " decw %0" : "+m" ((xl)->spinners) : : "memory");
> +#endif
> +
>  struct xen_spinlock {
>  	unsigned char lock;		/* 0 -> free; 1 -> locked */
> -	unsigned short spinners;	/* count of waiting cpus */
> +	xen_spinners_t spinners;	/* count of waiting cpus */
>  };
>  
>  static int xen_spin_is_locked(struct arch_spinlock *lock)
> @@ -164,8 +181,7 @@ static inline struct xen_spinlock *spinning_lock(struct xen_spinlock *xl)
>  
>  	wmb();			/* set lock of interest before count */
>  
> -	asm(LOCK_PREFIX " incw %0"
> -	    : "+m" (xl->spinners) : : "memory");
> +	inc_spinners(xl);
>  
>  	return prev;
>  }
> @@ -176,8 +192,7 @@ static inline struct xen_spinlock *spinning_lock(struct xen_spinlock *xl)
>   */
>  static inline void unspinning_lock(struct xen_spinlock *xl, struct xen_spinlock *prev)
>  {
> -	asm(LOCK_PREFIX " decw %0"
> -	    : "+m" (xl->spinners) : : "memory");
> +	dec_spinners(xl);
>  	wmb();			/* decrement count before restoring lock */
>  	__this_cpu_write(lock_spinners, prev);
>  }
> @@ -373,6 +388,8 @@ void xen_uninit_lock_cpu(int cpu)
>  
>  void __init xen_init_spinlocks(void)
>  {
> +	BUILD_BUG_ON(sizeof(struct xen_spinlock) > sizeof(arch_spinlock_t));
> +
>  	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
>  	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
>  	pv_lock_ops.spin_lock = xen_spin_lock;
> -- 
> 1.7.2.5
