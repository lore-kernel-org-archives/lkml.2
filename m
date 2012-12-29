Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2L2JRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 04:17:30 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:59388 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2L2JR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 04:17:28 -0500
MIME-Version: 1.0
Date: Sat, 29 Dec 2012 17:17:27 +0800
Message-ID: <CAKvkGKd_VJUYHxtE18mDHkkGBOiHtxOR9uKJEf2d8CofuNeVHw@mail.gmail.com>
Subject: 
From: "steve.zhan" <zhanzhenbo@gmail.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    It is good idea add this feature.

1: Can we let the "ret = hwspin_lock_tests(ops, hwlock);" add after
hwspin_lock_register_single have return
succeed, that can avoid test duplicated Or error lockid. Of course, If
this interface is intend to test soc hardware capability only, we can
put it in the arch module not this core framework. For driver hardware
sanity check, i would add it after software have register it.


2:Is it possible that interface add configs that choose which locks
will be test? Because the hwspinlock module is init late in
postcore_initcall phase, Maybe MACH/ARCH code(for example: code in
early_initcall) need use private other interfaces to lock some
hwspinlocks and then register hw locks to hwspinlock framework, Maybe
some hw locks is in lock status but which test failed.




-- 
Steve Zhan


> From: Ido Yariv <ido@wizery.com>
> To: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
> 	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
> Cc: Ido Yariv <ido@wizery.com>
> Subject: [PATCH] hwspinlock/core: Add testing capabilities
> Message-ID: <1355344026-17222-1-git-send-email-ido@wizery.com>
>
> Add testing capabilities for verifying correctness of the underlying
> hwspinlock layers. This can be handy especially during development.
> These tests are performed only once as part of the hwspinlock
> registration.
>
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
>  drivers/hwspinlock/Kconfig           |    9 +++++
>  drivers/hwspinlock/hwspinlock_core.c |   54
> ++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
> index c7c3128..ad632cd 100644
> --- a/drivers/hwspinlock/Kconfig
> +++ b/drivers/hwspinlock/Kconfig
> @@ -8,6 +8,15 @@ config HWSPINLOCK
>
>  menu "Hardware Spinlock drivers"
>
> +config HWSPINLOCK_TEST
> +	bool "Verify underlying hwspinlock implementation"
> +	depends on HWSPINLOCK
> +	help
> +	  Say Y here to perform tests on the underlying hwspinlock
> +	  implementation. The tests are only performed once per implementation.
> +
> +	  Say N, unless you absolutely know what you are doing.
> +
>  config HWSPINLOCK_OMAP
>  	tristate "OMAP Hardware Spinlock device"
>  	depends on ARCH_OMAP4
> diff --git a/drivers/hwspinlock/hwspinlock_core.c
> b/drivers/hwspinlock/hwspinlock_core.c
> index 085e28e..1874e85 100644
> --- a/drivers/hwspinlock/hwspinlock_core.c
> +++ b/drivers/hwspinlock/hwspinlock_core.c
> @@ -307,6 +307,53 @@ out:
>  	return hwlock;
>  }
>
> +#ifdef CONFIG_HWSPINLOCK_TEST
> +#define NUM_OF_TEST_ITERATIONS 100
> +static int hwspin_lock_tests(const struct hwspinlock_ops *ops,
> +			     struct hwspinlock *hwlock)
> +{
> +	int i;
> +	int ret;
> +
> +	for (i = 0; i < NUM_OF_TEST_ITERATIONS; i++) {
> +		ret = ops->trylock(hwlock);
> +		if (!ret) {
> +			pr_err("%s: Initial lock failed\n", __func__);
> +			return -EFAULT;
> +		}
> +
> +		/* Verify lock actually works - re-acquiring it should fail */
> +		ret = ops->trylock(hwlock);
> +		if (ret) {
> +			/* Keep locks balanced even in failure cases */
> +			ops->unlock(hwlock);
> +			ops->unlock(hwlock);
> +			pr_err("%s: Recursive lock succeeded unexpectedly\n",
> +			       __func__);
> +			return -EFAULT;
> +		}
> +
> +		/* Verify unlock by re-acquiring the lock after releasing it */
> +		ops->unlock(hwlock);
> +		ret = ops->trylock(hwlock);
> +		if (!ret) {
> +			pr_err("%s: Unlock failed\n", __func__);
> +			return -EINVAL;
> +		}
> +
> +		ops->unlock(hwlock);
> +	}
> +
> +	return 0;
> +}
> +#else /* CONFIG_HWSPINLOCK_TEST*/
> +static int hwspin_lock_tests(const struct hwspinlock_ops *ops,
> +			     struct hwspinlock *hwlock)
> +{
> +	return 0;
> +}
> +#endif
> +
>  /**
>   * hwspin_lock_register() - register a new hw spinlock device
>   * @bank: the hwspinlock device, which usually provides numerous hw locks
> @@ -345,6 +392,13 @@ int hwspin_lock_register(struct hwspinlock_device
> *bank, struct device *dev,
>  		spin_lock_init(&hwlock->lock);
>  		hwlock->bank = bank;
>
> +		ret = hwspin_lock_tests(ops, hwlock);
> +		if (ret) {
> +			pr_err("hwspinlock tests failed on lock %d\n",
> +			       base_id + i);
> +			goto reg_failed;
> +		}
> +
>  		ret = hwspin_lock_register_single(hwlock, base_id + i);
>  		if (ret)
>  			goto reg_failed;
> --
> 1.7.7.6
