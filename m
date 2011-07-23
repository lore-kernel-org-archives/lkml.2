Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1GWTmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 15:42:21 -0400
Received: from mx4.gwdg.de ([134.76.10.17]:28299 "EHLO mx4.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab1GWTmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 15:42:17 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jul 2011 15:42:16 EDT
X-IronPort-Reputation-Score: None
X-IronPort-AV: E=McAfee;i="5400,1158,6416"; a="30663601"
X-IronPort-AV: E=Sophos;i="4.67,253,1309730400"; 
   d="scan'208";a="30663601"
In-Reply-To: <alpine.LFD.2.02.1107231242170.2702@ionos>
References: <alpine.LFD.2.02.1107231242170.2702@ionos>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0A6D8E36-D8ED-46C4-9987-63CFEB3AF479@tuebingen.mpg.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Content-Transfer-Encoding: 7bit
From: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Subject: Re: drm: Remove utterly bogus preempt_disable() sections
Date: Sat, 23 Jul 2011 21:32:46 +0200
To: Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 23, 2011, at 12:45 PM, Thomas Gleixner wrote:

> commit 27641c3f (drm/vblank: Add support for precise vblank
> timestamping) adds preempt_disable()/enable() around a spin locked
> section with the comments:
>
>  * Disable preemption, so vblank_time_lock is held as short as
>  * possible, even under a kernel with PREEMPT_RT patches.
>
> /* Disable preemption while holding vblank_time_lock. Do
>  * it explicitely to guard against PREEMPT_RT kernel.
>
> Just that this has never been tested on a RT kernel which would have
> granted that nonsense with a might_sleep() warning because
> dev->vblank_time_lock is converted to a "sleeping" spinlock on RT.
>
> So this is activly wrong on RT and superflous on mainline. Remove it.
>

Ouch! Sorry for that.

The idea was to make sure that those functions hold the  
vblank_time_lock as short as possible, as that lock can block the  
vblank irq handler (drm_handle_vblank) from progressing.

But maybe it's not needed under preempt_rt either. Do i understand  
correctly that spinlocks have priority inheritance under preempt_rt?  
In that case we should be fine without the preempt_disable(). The  
drm_handle_vblank() function as part of the vblank irq kernel thread  
would donate its high rt priority to the possibly preempted functions  
as long as they hold the spinlock and thereby make sure they don't  
get stuck for long -> Problem solved.

Other than that, would defining vblank_time_lock as a raw_spinlock_t  
have fixed it? Or would that be just as bad?

thanks,
-mario

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/gpu/drm/drm_irq.c |    9 ---------
>  1 file changed, 9 deletions(-)
>
> Index: linux-2.6/drivers/gpu/drm/drm_irq.c
> ===================================================================
> --- linux-2.6.orig/drivers/gpu/drm/drm_irq.c
> +++ linux-2.6/drivers/gpu/drm/drm_irq.c
> @@ -109,10 +109,7 @@ static void vblank_disable_and_save(stru
>  	/* Prevent vblank irq processing while disabling vblank irqs,
>  	 * so no updates of timestamps or count can happen after we've
>  	 * disabled. Needed to prevent races in case of delayed irq's.
> -	 * Disable preemption, so vblank_time_lock is held as short as
> -	 * possible, even under a kernel with PREEMPT_RT patches.
>  	 */
> -	preempt_disable();
>  	spin_lock_irqsave(&dev->vblank_time_lock, irqflags);
>
>  	dev->driver->disable_vblank(dev, crtc);
> @@ -163,7 +160,6 @@ static void vblank_disable_and_save(stru
>  	clear_vblank_timestamps(dev, crtc);
>
>  	spin_unlock_irqrestore(&dev->vblank_time_lock, irqflags);
> -	preempt_enable();
>  }
>
>  static void vblank_disable_fn(unsigned long arg)
> @@ -875,10 +871,6 @@ int drm_vblank_get(struct drm_device *de
>  	spin_lock_irqsave(&dev->vbl_lock, irqflags);
>  	/* Going from 0->1 means we have to enable interrupts again */
>  	if (atomic_add_return(1, &dev->vblank_refcount[crtc]) == 1) {
> -		/* Disable preemption while holding vblank_time_lock. Do
> -		 * it explicitely to guard against PREEMPT_RT kernel.
> -		 */
> -		preempt_disable();
>  		spin_lock_irqsave(&dev->vblank_time_lock, irqflags2);
>  		if (!dev->vblank_enabled[crtc]) {
>  			/* Enable vblank irqs under vblank_time_lock protection.
> @@ -898,7 +890,6 @@ int drm_vblank_get(struct drm_device *de
>  			}
>  		}
>  		spin_unlock_irqrestore(&dev->vblank_time_lock, irqflags2);
> -		preempt_enable();
>  	} else {
>  		if (!dev->vblank_enabled[crtc]) {
>  			atomic_dec(&dev->vblank_refcount[crtc]);

*********************************************************************
Mario Kleiner
Max Planck Institute for Biological Cybernetics
Spemannstr. 38
72076 Tuebingen
Germany

e-mail: mario.kleiner@tuebingen.mpg.de
office: +49 (0)7071/601-1623
fax:    +49 (0)7071/601-616
www:    http://www.kyb.tuebingen.mpg.de/~kleinerm
*********************************************************************
"For a successful technology, reality must take precedence
over public relations, for Nature cannot be fooled."
(Richard Feynman)

