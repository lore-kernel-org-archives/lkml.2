Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3AGWZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:25:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60981 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab3AGWZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:25:48 -0500
Message-ID: <50EB4B3B.3070900@ti.com>
Date: Mon, 7 Jan 2013 16:24:59 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Erickson <marathon96@gmail.com>, <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
References: <20121212192430.50cea126@notabene.brown> <50C8ABFC.3080309@ti.com> <20121213140635.4eda5858@notabene.brown> <50CA0B4D.2000302@ti.com> <20130107081220.3c39617b@notabene.brown>
In-Reply-To: <20130107081220.3c39617b@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.56.52]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/06/2013 03:12 PM, NeilBrown wrote:

[snip]

> I've been playing with off-mode and discovered that the first attempt to set
> the PWM after resume didn't work, but subsequent ones did.
> I did some digging and came up with the following patch.  
> With this in place, the omap_pwm_suspend() above is definitely pointless (was
> wasn't really useful even without it).

Thanks for sending. I have given this patch a try on omap3 and I am still
some some failures with my timer read test. I need to dig into that further,
but I am guessing not related to your patch as there were problems there
before :-(

Some minor comments below ...
 
> NeilBrown
> 
> 
> From: NeilBrown <neilb@suse.de>
> Date: Mon, 7 Jan 2013 07:53:03 +1100
> Subject: [PATCH] OMAP dmtimer - simplify context-loss handling.

Nit, subject should formatted "ARM: OMAP: blah blah blah"

Also, may be worth calling this "fix context-loss" as this is really
fixing something that is broken.
 
> The context loss handling in dmtimer appears to assume that
>    omap_dm_timer_set_load_start() or omap_dm_timer_start()
> and
>    omap_dm_timer_stop()
> 
> bracket all interactions.  Only the first two restore the context and
> the last updates the context loss counter.
> However omap_dm_timer_set_load() or omap_dm_timer_set_match() can
> reasonably be called outside this bracketing, and the fact that they
> call omap_dm_timer_enable() / omap_dm_timer_disable() suggest that
> is expected.
> 
> So if, after a transition into and out of off-mode which would cause
> the dm timer to loose all state, omap_dm_timer_set_match() is called
> before omap_dm_timer_start(), the value read from OMAP_TIMER_CTRL_REG
> will be 'wrong' and this wrong value will be stored context.tclr so
> a subsequent omap_dm_timer_start() can fail (As the control register
> is wrong).
> 
> Simplify this be doing the restore-from-context in
> omap_dm_timer_enable() so that whenever the timer is enabled, the
> context is correct.
> Also update the ctx_loss_count at the same time as we notice it is
> wrong - these is no value in delaying this until the
> omap_dm_timer_disable() as it cannot change while the timer is
> enabled.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
> index 938b50a..c216696 100644
> --- a/arch/arm/plat-omap/dmtimer.c
> +++ b/arch/arm/plat-omap/dmtimer.c
> @@ -253,6 +253,15 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_free);
>  void omap_dm_timer_enable(struct omap_dm_timer *timer)
>  {
>  	pm_runtime_get_sync(&timer->pdev->dev);
> +
> +	if (!(timer->capability & OMAP_TIMER_ALWON)) {
> +		int loss_count =
> +			omap_pm_get_dev_context_loss_count(&timer->pdev->dev);
> +		if (loss_count != timer->ctx_loss_count) {
> +			omap_timer_restore_context(timer);
> +			timer->ctx_loss_count = loss_count;
> +		}
> +	}
>  }

Can you rebase on v3.8-rc2? We no longer call 
omap_pm_get_dev_context_loss_count() directly and so this
does not apply. Should be something like ...

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index d51b75b..2c48182 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -315,7 +315,19 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_free);
 
 void omap_dm_timer_enable(struct omap_dm_timer *timer)
 {
+       int c;
+
        pm_runtime_get_sync(&timer->pdev->dev);
+
+       if (!(timer->capability & OMAP_TIMER_ALWON)) {
+               if (timer->get_context_loss_count) {
+                       c = timer->get_context_loss_count(&timer->pdev->dev);
+                       if (c != timer->ctx_loss_count) {
+                               omap_timer_restore_context(timer);
+                               timer->ctx_loss_count = c;
+                       }
+               }
+       }

Cheers
Jon
