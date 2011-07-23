Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1GWW4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 18:56:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45188 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab1GWW4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 18:56:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCH] PM: runtime: add might_sleep to PM runtime functions
Date: Sun, 24 Jul 2011 00:57:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Nishanth Menon <nm@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1311396967-16721-1-git-send-email-ccross@android.com>
In-Reply-To: <1311396967-16721-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201107240057.00197.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 23, 2011, Colin Cross wrote:
> The list of functions that can be called in atomic context is
> non-intuitive (pm_runtime_put_sync can not, but
> pm_runtime_put_sync_suspend can, if pm_runtime_irq_safe has
> been called?).

However, this behavior is documented.

Also, if you have a clean use case for calling rpm_idle() with interrupts
off, it can be modified to work in analogy with rpm_suspend() in that respect.

> The code is actively misleading - the entry
> points all start with spin_lock_irqsave, suggesting they
> are safe to call in atomic context, but may later
> enable interrupts.

May I say it is this way for a reason?

> Add might_sleep_if to all the __pm_runtime_* entry points
> to enforce correct usage.

I'm not sure how this makes things better.

> Also add pm_runtime_put_sync_autosuspend to the list of
> functions that can be called in atomic context.

OK

In addition to that rpm_idle() is missing the __releases __acquires
annotations.

> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  Documentation/power/runtime_pm.txt |    1 +
>  drivers/base/power/runtime.c       |   16 ++++++++++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
> index b24875b..22852b3 100644
> --- a/Documentation/power/runtime_pm.txt
> +++ b/Documentation/power/runtime_pm.txt
> @@ -469,6 +469,7 @@ pm_runtime_autosuspend()
>  pm_runtime_resume()
>  pm_runtime_get_sync()
>  pm_runtime_put_sync_suspend()
> +pm_runtime_put_sync_autosuspend()
>  
>  5. Run-time PM Initialization, Device Probing and Removal
>  
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 0d4587b..fdc4567 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -732,6 +732,8 @@ int __pm_runtime_idle(struct device *dev, int rpmflags)
>  	unsigned long flags;
>  	int retval;
>  
> +	might_sleep_if(!(rpmflags & RPM_ASYNC));
> +
>  	if (rpmflags & RPM_GET_PUT) {
>  		if (!atomic_dec_and_test(&dev->power.usage_count))
>  			return 0;
> @@ -754,13 +756,16 @@ EXPORT_SYMBOL_GPL(__pm_runtime_idle);
>   * return immediately if it is larger than zero.  Then carry out a suspend,
>   * either synchronous or asynchronous.
>   *
> - * This routine may be called in atomic context if the RPM_ASYNC flag is set.
> + * This routine may be called in atomic context if the RPM_ASYNC flag is set,
> + * or if pm_runtime_irq_safe() has been called.
>   */
>  int __pm_runtime_suspend(struct device *dev, int rpmflags)
>  {
>  	unsigned long flags;
>  	int retval;
>  
> +	might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);
> +
>  	if (rpmflags & RPM_GET_PUT) {
>  		if (!atomic_dec_and_test(&dev->power.usage_count))
>  			return 0;
> @@ -782,13 +787,16 @@ EXPORT_SYMBOL_GPL(__pm_runtime_suspend);
>   * If the RPM_GET_PUT flag is set, increment the device's usage count.  Then
>   * carry out a resume, either synchronous or asynchronous.
>   *
> - * This routine may be called in atomic context if the RPM_ASYNC flag is set.
> + * This routine may be called in atomic context if the RPM_ASYNC flag is set,
> + * or if pm_runtime_irq_safe() has been called.
>   */
>  int __pm_runtime_resume(struct device *dev, int rpmflags)
>  {
>  	unsigned long flags;
>  	int retval;
>  
> +	might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);
> +
>  	if (rpmflags & RPM_GET_PUT)
>  		atomic_inc(&dev->power.usage_count);
>  
> @@ -978,6 +986,8 @@ EXPORT_SYMBOL_GPL(pm_runtime_barrier);
>   */
>  void __pm_runtime_disable(struct device *dev, bool check_resume)
>  {
> +	might_sleep();
> +

Well, it's not correct to call spin_lock_irq() from interrupt context anyway.

>  	spin_lock_irq(&dev->power.lock);
>  
>  	if (dev->power.disable_depth > 0) {
> @@ -1184,6 +1194,8 @@ void __pm_runtime_use_autosuspend(struct device *dev, bool use)
>  {
>  	int old_delay, old_use;
>  
> +	might_sleep();
> +
>  	spin_lock_irq(&dev->power.lock);
>  	old_delay = dev->power.autosuspend_delay;
>  	old_use = dev->power.use_autosuspend;
> 

Thanks,
Rafael
