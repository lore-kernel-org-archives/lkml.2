Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab2IFV3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:29:08 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40616 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab2IFV3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:29:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] wakeup: Use irqsave/irqrestore for events_lock
Date: Thu, 6 Sep 2012 23:35:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
        Android Team <kernel-team@android.com>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>
References: <1346954857-52669-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1346954857-52669-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209062335.23013.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 06, 2012, John Stultz wrote:
> Jon Medhurst (Tixy) recently noticed a problem with the
> events_lock usage. One of the Android patches that uses
> wakeup_sources calls wakeup_source_add() with irqs disabled.
> However, the event_lock usage in wakeup_source_add() uses
> spin_lock_irq()/spin_unlock_irq(), which reenables interrupts.
> This results in lockdep warnings.
> 
> The fix is to use spin_lock_irqsave()/spin_lock_irqrestore()
> instead for the events_lock.
> 
> Full bug report here:
> https://bugs.launchpad.net/linaro-landing-team-arm/+bug/1037565
> 
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Android Team <kernel-team@android.com>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
> Reported-and-debugged-by: Jon Medhurst (Tixy) <tixy@linaro.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Thanks, applied to the linux-next brach of the linux-pm.git tree as v3.7
material.

Please consider CCing PM-related patches to linux-pm@vger.kernel.org in the
future, that makes it much easier for me to handle them.

Thanks,
Rafael


> ---
>  drivers/base/power/wakeup.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
> index cbb463b..0e4b093 100644
> --- a/drivers/base/power/wakeup.c
> +++ b/drivers/base/power/wakeup.c
> @@ -127,6 +127,8 @@ EXPORT_SYMBOL_GPL(wakeup_source_destroy);
>   */
>  void wakeup_source_add(struct wakeup_source *ws)
>  {
> +	unsigned long flags;
> +
>  	if (WARN_ON(!ws))
>  		return;
>  
> @@ -135,9 +137,9 @@ void wakeup_source_add(struct wakeup_source *ws)
>  	ws->active = false;
>  	ws->last_time = ktime_get();
>  
> -	spin_lock_irq(&events_lock);
> +	spin_lock_irqsave(&events_lock, flags);
>  	list_add_rcu(&ws->entry, &wakeup_sources);
> -	spin_unlock_irq(&events_lock);
> +	spin_unlock_irqrestore(&events_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(wakeup_source_add);
>  
> @@ -147,12 +149,14 @@ EXPORT_SYMBOL_GPL(wakeup_source_add);
>   */
>  void wakeup_source_remove(struct wakeup_source *ws)
>  {
> +	unsigned long flags;
> +
>  	if (WARN_ON(!ws))
>  		return;
>  
> -	spin_lock_irq(&events_lock);
> +	spin_lock_irqsave(&events_lock, flags);
>  	list_del_rcu(&ws->entry);
> -	spin_unlock_irq(&events_lock);
> +	spin_unlock_irqrestore(&events_lock, flags);
>  	synchronize_rcu();
>  }
>  EXPORT_SYMBOL_GPL(wakeup_source_remove);
> @@ -723,15 +727,16 @@ bool pm_get_wakeup_count(unsigned int *count, bool block)
>  bool pm_save_wakeup_count(unsigned int count)
>  {
>  	unsigned int cnt, inpr;
> +	unsigned long flags;
>  
>  	events_check_enabled = false;
> -	spin_lock_irq(&events_lock);
> +	spin_lock_irqsave(&events_lock, flags);
>  	split_counters(&cnt, &inpr);
>  	if (cnt == count && inpr == 0) {
>  		saved_count = count;
>  		events_check_enabled = true;
>  	}
> -	spin_unlock_irq(&events_lock);
> +	spin_unlock_irqrestore(&events_lock, flags);
>  	return events_check_enabled;
>  }
>  
> 

