Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1KOGYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 01:24:49 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6650 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab1KOGYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 01:24:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 14 Nov 2011 22:24:48 -0800
Message-ID: <4EC205AC.4000202@nvidia.com>
Date: Tue, 15 Nov 2011 11:54:44 +0530
From: Varun Wadekar <vwadekar@nvidia.com>
Organization: NVIDIA Corporation
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Varun Wadekar <vwadekar@nvidia.com>
CC: "ohad@wizery.com" <ohad@wizery.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwspinlock: core: support for TEGRA hardware spinlocks
References: <1321334342-3283-1-git-send-email-vwadekar@nvidia.com>
In-Reply-To: <1321334342-3283-1-git-send-email-vwadekar@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+LKML ml

This is an idea that I wanted some review comments on (to check if I am
on the right path), before the TEGRA driver gets written.

On Tuesday 15 November 2011 10:49 AM, Varun Wadekar wrote:
> TEGRA has a hardware spinlock block which is used
> to get exclusive access to the hardware blocks either
> from the CPU or the COP. The TEGRA hardware spinlock
> block has the capability to interrupt the requester
> on success. For this the core need not disable
> preemption or interrupts before calling into the
> actual driver. Add lock_timeout to the ops structure
> to facilitate this working and to maintain backward
> compatibility.
>
> Signed-off-by: Varun Wadekar <vwadekar@nvidia.com>
> ---
>  Documentation/hwspinlock.txt             |   39 ++++++++++++++++++++++++++---
>  drivers/hwspinlock/hwspinlock_core.c     |   16 ++++++++++--
>  drivers/hwspinlock/hwspinlock_internal.h |    3 ++
>  3 files changed, 51 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.txt
> index a903ee5..35730b8 100644
> --- a/Documentation/hwspinlock.txt
> +++ b/Documentation/hwspinlock.txt
> @@ -29,6 +29,18 @@ the remote processors, and access to it is synchronized using the hwspinlock
>  module (remote processor directly places new messages in this shared data
>  structure).
>  
> +The Tegra line of processors has a CPU and a COP similar to the OMAP processors.
> +The Tegra SoC has a hardware block which arbitrates access to different hardware
> +modules on the SoC between the CPU and the COP. The hardware spinlock block
> +also has the capability to interrupt the caller when it has access to the
> +requested hardware module. To facilitate SoCs like Tegra which do a lot more
> +than just share data structures between the CPU and the COP, a new callback,
> +int (*lock_timeout)(struct hwspinlock *lock, unsigned int to), has been added
> +to struct hwspinlock_ops. The drivers which support functionality similar to
> +the Tegra SoCs, will use lock_timeout to grant access to the hardware spinlock
> +block on the SoCs. Such SoC drivers will not support all the apis exposed
> +by the hwspinlock framework. More information below.
> +
>  A common hwspinlock interface makes it possible to have generic, platform-
>  independent, drivers.
>  
> @@ -58,8 +70,11 @@ independent, drivers.
>     - lock a previously-assigned hwspinlock with a timeout limit (specified in
>       msecs). If the hwspinlock is already taken, the function will busy loop
>       waiting for it to be released, but give up when the timeout elapses.
> -     Upon a successful return from this function, preemption is disabled so
> -     the caller must not sleep, and is advised to release the hwspinlock as
> +     If the underlying hardware driver supports lock_timeout in it's ops structure
> +     then upon a successful return from this function, the caller is allowed
> +     to sleep since we do not disable premption or interrupts in this scenario.
> +     If not, upon a successful return from this function, preemption is disabled
> +     so the caller must not sleep, and is advised to release the hwspinlock as
>       soon as possible, in order to minimize remote cores polling on the
>       hardware interconnect.
>       Returns 0 when successful and an appropriate error code otherwise (most
> @@ -68,7 +83,10 @@ independent, drivers.
>  
>    int hwspin_lock_timeout_irq(struct hwspinlock *hwlock, unsigned int timeout);
>     - lock a previously-assigned hwspinlock with a timeout limit (specified in
> -     msecs). If the hwspinlock is already taken, the function will busy loop
> +     msecs).
> +     Not supported if lock_timeout is exported from the ops struct by the
> +     underlying driver.
> +     If the hwspinlock is already taken, the function will busy loop
>       waiting for it to be released, but give up when the timeout elapses.
>       Upon a successful return from this function, preemption and the local
>       interrupts are disabled, so the caller must not sleep, and is advised to
> @@ -80,7 +98,10 @@ independent, drivers.
>    int hwspin_lock_timeout_irqsave(struct hwspinlock *hwlock, unsigned int to,
>  							unsigned long *flags);
>     - lock a previously-assigned hwspinlock with a timeout limit (specified in
> -     msecs). If the hwspinlock is already taken, the function will busy loop
> +     msecs).
> +     Not supported if lock_timeout is exported from the ops struct by the
> +     underlying driver.
> +     If the hwspinlock is already taken, the function will busy loop
>       waiting for it to be released, but give up when the timeout elapses.
>       Upon a successful return from this function, preemption is disabled,
>       local interrupts are disabled and their previous state is saved at the
> @@ -93,6 +114,8 @@ independent, drivers.
>    int hwspin_trylock(struct hwspinlock *hwlock);
>     - attempt to lock a previously-assigned hwspinlock, but immediately fail if
>       it is already taken.
> +     Not supported if lock_timeout is exported from the ops struct by the
> +     underlying driver.
>       Upon a successful return from this function, preemption is disabled so
>       caller must not sleep, and is advised to release the hwspinlock as soon as
>       possible, in order to minimize remote cores polling on the hardware
> @@ -104,6 +127,8 @@ independent, drivers.
>    int hwspin_trylock_irq(struct hwspinlock *hwlock);
>     - attempt to lock a previously-assigned hwspinlock, but immediately fail if
>       it is already taken.
> +     Not supported if lock_timeout is exported from the ops struct by the
> +     underlying driver.
>       Upon a successful return from this function, preemption and the local
>       interrupts are disabled so caller must not sleep, and is advised to
>       release the hwspinlock as soon as possible.
> @@ -114,6 +139,8 @@ independent, drivers.
>    int hwspin_trylock_irqsave(struct hwspinlock *hwlock, unsigned long *flags);
>     - attempt to lock a previously-assigned hwspinlock, but immediately fail if
>       it is already taken.
> +     Not supported if lock_timeout is exported from the ops struct by the
> +     underlying driver.
>       Upon a successful return from this function, preemption is disabled,
>       the local interrupts are disabled and their previous state is saved
>       at the given flags placeholder. The caller must not sleep, and is advised
> @@ -130,6 +157,8 @@ independent, drivers.
>  
>    void hwspin_unlock_irq(struct hwspinlock *hwlock);
>     - unlock a previously-locked hwspinlock and enable local interrupts.
> +     Not supported if lock_timeout is exported from the ops struct by the
> +     underlying driver.
>       The caller should _never_ unlock an hwspinlock which is already unlocked.
>       Doing so is considered a bug (there is no protection against this).
>       Upon a successful return from this function, preemption and local
> @@ -138,6 +167,8 @@ independent, drivers.
>    void
>    hwspin_unlock_irqrestore(struct hwspinlock *hwlock, unsigned long *flags);
>     - unlock a previously-locked hwspinlock.
> +     Not supported if lock_timeout is exported from the ops struct by the
> +     underlying driver.
>       The caller should _never_ unlock an hwspinlock which is already unlocked.
>       Doing so is considered a bug (there is no protection against this).
>       Upon a successful return from this function, preemption is reenabled,
> diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
> index 61c9cf1..520c2c9 100644
> --- a/drivers/hwspinlock/hwspinlock_core.c
> +++ b/drivers/hwspinlock/hwspinlock_core.c
> @@ -91,6 +91,10 @@ int __hwspin_trylock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
>  
>  	BUG_ON(!hwlock);
>  	BUG_ON(!flags && mode == HWLOCK_IRQSTATE);
> +	BUG_ON(hwlock->bank->ops->trylock && hwlock->bank->ops->lock_timeout);
> +
> +	if (!hwlock->bank->ops->trylock)
> +		return -EINVAL;
>  
>  	/*
>  	 * This spin_lock{_irq, _irqsave} serves three purposes:
> @@ -182,6 +186,9 @@ int __hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned int to,
>  
>  	expire = msecs_to_jiffies(to) + jiffies;
>  
> +	if (hwlock->bank->ops->lock_timeout)
> +		return hwlock->bank->ops->lock_timeout(hwlock, expire);
> +
>  	for (;;) {
>  		/* Try to take the hwspinlock */
>  		ret = __hwspin_trylock(hwlock, mode, flags);
> @@ -245,7 +252,10 @@ void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
>  	 */
>  	mb();
>  
> -	hwlock->bank->ops->unlock(hwlock);
> +	if (hwlock->bank->ops->lock_timeout)
> +		return hwlock->bank->ops->unlock(hwlock);
> +	else
> +		hwlock->bank->ops->unlock(hwlock);
>  
>  	/* Undo the spin_trylock{_irq, _irqsave} called while locking */
>  	if (mode == HWLOCK_IRQSTATE)
> @@ -328,8 +338,8 @@ int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
>  	struct hwspinlock *hwlock;
>  	int ret = 0, i;
>  
> -	if (!bank || !ops || !dev || !num_locks || !ops->trylock ||
> -							!ops->unlock) {
> +	if (!bank || !ops || !dev || !num_locks ||
> +	    (!ops->trylock && !ops->lock_timeout) || !ops->unlock) {
>  		pr_err("invalid parameters\n");
>  		return -EINVAL;
>  	}
> diff --git a/drivers/hwspinlock/hwspinlock_internal.h b/drivers/hwspinlock/hwspinlock_internal.h
> index d26f78b..b0ba642 100644
> --- a/drivers/hwspinlock/hwspinlock_internal.h
> +++ b/drivers/hwspinlock/hwspinlock_internal.h
> @@ -26,6 +26,8 @@ struct hwspinlock_device;
>  /**
>   * struct hwspinlock_ops - platform-specific hwspinlock handlers
>   *
> + * @lock_timeout: attempt to take the lock and wait with a timeout.
> + * 		  returns 0 on failure and true on success. may_sleep.
>   * @trylock: make a single attempt to take the lock. returns 0 on
>   *	     failure and true on success. may _not_ sleep.
>   * @unlock:  release the lock. always succeed. may _not_ sleep.
> @@ -35,6 +37,7 @@ struct hwspinlock_device;
>   */
>  struct hwspinlock_ops {
>  	int (*trylock)(struct hwspinlock *lock);
> +	int (*lock_timeout)(struct hwspinlock *lock, unsigned int to);
>  	void (*unlock)(struct hwspinlock *lock);
>  	void (*relax)(struct hwspinlock *lock);
>  };

