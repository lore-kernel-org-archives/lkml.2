Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1EQUkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:40:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33143 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab1EQUkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:40:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v4 1/2] PM / Core: suspend_again callback for suspend_ops.
Date: Tue, 17 May 2011 22:40:46 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
References: <20110512061928.GB2460@localhost.ucw.cz> <1305608346-23800-1-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1305608346-23800-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105172240.46970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 17, 2011, MyungJoo Ham wrote:
> A system or a device may need to control suspend/wakeup events. It may
> want to wakeup the system after a predefined amount of time or at a
> predefined event decided while entering suspend for polling or delayed
> work. Then, it may want to enter suspend again if its predefined wakeup
> condition is the only wakeup reason and there is no outstanding events;
> thus, it does not wakeup the userspace unnecessary or unnecessary
> devices and keeps suspended as long as possible (saving the power).
> 
> Enabling a system to wakeup after a specified time can be easily
> achieved by using RTC. However, to enter suspend again immediately
> without invoking userland and unrelated devices, we need additional
> features in the suspend framework.
> 
> Such need comes from:
> 
> 1. Monitoring a critical device status without interrupts that can
> wakeup the system. (in-suspend polling)
>  An example is ambient temperature monitoring that needs to shut down
> the system or a specific device function if it is too hot or cold. The
> temperature of a specific device may be needed to be monitored as well;
> e.g., a charger monitors battery temperature in order to stop charging
> if overheated.
> 
> 2. Execute critical "delayed work" at suspend.
>  A driver or a system/board may have a delayed work (or any similar
> things) that it wants to execute at the requested time.
>  For example, some chargers want to check the battery voltage some
> time (e.g., 30 seconds) after the battery is fully charged and the
> charger has stopped. Then, the charger restarts charging if the voltage
> has dropped more than a threshold, which is smaller than "restart-charger"
> voltage, which is a threshold to restart charging regardless of the
> time passed.
> 
> This patch allows to add "suspend_again" callback at struct
> platform_suspend_ops and let the "suspend_again" callback return true if
> the system is required to enter suspend again after the current instance
> of wakeup. Device-wise suspend_again implemented at dev_pm_ops or
> syscore is not done because: a) suspend_again feature is usually under
> platform-wise decision and controls the behavior of the whole platform
> and b) There are very limited devices related to the usage cases of
> suspend_again; chargers and temperature sensors are mentioned so far.
> 
> With suspend_again callback registered at struct platform_suspend_ops
> suspend_ops in kernel/power/suspend.c with suspend_set_ops by the
> platform, the suspend framework tries to enter suspend again by
> looping suspend_enter() if suspend_again has returned true and there has
> been no errors in the suspending sequence or pending wakeups (by
> pm_wakeup_pending).
> 
> Tested at Exynos4-NURI.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> --
> Thank you for your valuable comments, Pavel, Rafael, Greg, and others.
> 
> Changed from v3:
> 	- renamed local variable "pm_wkup_pending" to "wakeup_pending".
> 	pm_wakeup_pending is not used because there is a function with the
> 	same name.
> Changed from v2:
> 	- moved (again) from dev_pm_ops to suspend_ops
> 	- settled suspend_again point at around suspend_enter().
> Changes from v1:
> 	- moved from syscore to dev_pm_ops
> 	- added generic ops for subsystems.
> 	- cleaned up suspend_again code at kernel/power/suspend.
> ---
>  include/linux/suspend.h |    8 ++++++++
>  kernel/power/suspend.c  |   13 ++++++++++---
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index 5a89e36..caf5e97 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -92,6 +92,13 @@ typedef int __bitwise suspend_state_t;
>   *	@enter() and @wake(), even if any of them fails.  It is executed after
>   *	a failing @prepare.
>   *
> + * @suspend_again: Returns whether the system should suspend again (true) or
> + *	not (false). If the platform wants to poll sensors or execute some
> + *	code during suspended without invoking userspace and most of devices,
> + *	suspend_again callback is the place assuming that periodic-wakeup or
> + *	alarm-wakeup is already setup. This allows to execute some codes while
> + *	being kept suspended in the view of userland and devices.
> + *
>   * @end: Called by the PM core right after resuming devices, to indicate to
>   *	the platform that the system has returned to the working state or
>   *	the transition to the sleep state has been aborted.
> @@ -113,6 +120,7 @@ struct platform_suspend_ops {
>  	int (*enter)(suspend_state_t state);
>  	void (*wake)(void);
>  	void (*finish)(void);
> +	bool (*suspend_again)(void);
>  	void (*end)(void);
>  	void (*recover)(void);
>  };
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 08515b4..63a6b0b 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -128,10 +128,12 @@ void __attribute__ ((weak)) arch_suspend_enable_irqs(void)
>  /**
>   *	suspend_enter - enter the desired system sleep state.
>   *	@state:		state to enter
> + *	@wakeup_pending:	indicates that the power transition in progress
> + *				should be aborted.
>   *
>   *	This function should be called after devices have been suspended.
>   */
> -static int suspend_enter(suspend_state_t state)
> +static int suspend_enter(suspend_state_t state, bool *wakeup_pending)

You don't need to use the wakeup_pending argument at all.  I think you
shouldn't use it even, because in theory there may be a wakeup event after
you've called pm_wakeup_pending() in suspend_enter() and in that case
you should break the loop too.

>  {
>  	int error;
>  
> @@ -167,7 +169,8 @@ static int suspend_enter(suspend_state_t state)
>  	if (!error)
>  		error = syscore_suspend();
>  	if (!error) {
> -		if (!(suspend_test(TEST_CORE) || pm_wakeup_pending())) {
> +		*wakeup_pending = pm_wakeup_pending();
> +		if (!(suspend_test(TEST_CORE) || *wakeup_pending)) {
>  			error = suspend_ops->enter(state);
>  			events_check_enabled = false;
>  		}
> @@ -202,6 +205,7 @@ static int suspend_enter(suspend_state_t state)
>  int suspend_devices_and_enter(suspend_state_t state)
>  {
>  	int error;
> +	bool wakeup_pending = false;
>  
>  	if (!suspend_ops)
>  		return -ENOSYS;
> @@ -224,7 +228,10 @@ int suspend_devices_and_enter(suspend_state_t state)
>  	if (suspend_test(TEST_DEVICES))
>  		goto Recover_platform;
>  
> -	error = suspend_enter(state);
> +	do {
> +		error = suspend_enter(state, &wakeup_pending);
> +	} while (suspend_ops->suspend_again && suspend_ops->suspend_again() &&
> +		 !error && !wakeup_pending);

So I would simply call pm_wakeup_pending() here again.

>  
>   Resume_devices:
>  	suspend_test_start();
> 

Thanks,
Rafael
