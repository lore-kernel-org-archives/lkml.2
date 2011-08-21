Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab1HUSIH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 14:08:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55608 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1HUSIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 14:08:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH 1/2] PM / Runtime: Introduce pm_runtime_irq_unsafe()
Date: Sun, 21 Aug 2011 20:09:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-sh@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1108211048060.12143-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108211048060.12143-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108212009.49550.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 21, 2011, Alan Stern wrote:
> On Sat, 20 Aug 2011, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Add a helper function allowing drivers and subsystems to clear
> > the power.irq_safe device flag.
> 
> > --- linux.orig/drivers/base/power/runtime.c
> > +++ linux/drivers/base/power/runtime.c
> > @@ -1109,22 +1109,23 @@ void pm_runtime_no_callbacks(struct devi
> >  EXPORT_SYMBOL_GPL(pm_runtime_no_callbacks);
> >  
> >  /**
> > - * pm_runtime_irq_safe - Leave interrupts disabled during callbacks.
> > + * __pm_runtime_irq_safe - Manipulate a device's power.irq_safe flag.
> >   * @dev: Device to handle
> > + * @irq_safe: Whether or not to leave interrupts disabled during callbacks.
> >   *
> > - * Set the power.irq_safe flag, which tells the PM core that the
> > + * Set or unset the power.irq_safe flag, which tells the PM core that the
> >   * ->runtime_suspend() and ->runtime_resume() callbacks for this device should
> >   * always be invoked with the spinlock held and interrupts disabled.  It also
> >   * causes the parent's usage counter to be permanently incremented, preventing
> >   * the parent from runtime suspending -- otherwise an irq-safe child might have
> >   * to wait for a non-irq-safe parent.
> >   */
> > -void pm_runtime_irq_safe(struct device *dev)
> > +void __pm_runtime_irq_safe(struct device *dev, bool irq_safe)
> >  {
> >  	if (dev->parent)
> >  		pm_runtime_get_sync(dev->parent);
> >  	spin_lock_irq(&dev->power.lock);
> > -	dev->power.irq_safe = 1;
> > +	dev->power.irq_safe = irq_safe;
> >  	spin_unlock_irq(&dev->power.lock);
> 
> It's not quite this easy.  There are two important aspects that must be
> considered.
> 
> Firstly, I originally envisioned pm_runtime_irq_safe() being called
> just once, before the device is enabled for runtime PM.  If you allow
> the flag to be turned on and off like this, you raise the possibility
> of races with runtime PM callbacks.  (That is, if a callback occurs at
> about the same time as the irq_safe flag is changed, nobody can predict
> whether the callback will be invoked with interrupts enabled.)  Maybe
> that's something the driver needs to take care of, but it should at
> least be mentioned in the documentation.

Good point.  Perhaps I should make it possible only if runtime PM is
disabled.

> Secondly, this doesn't manage the parent's usage counter correctly.

Right, I forgot about that.

> Do the pm_runtime_get_sync(dev->parent) at the beginning only when the
> irq_safe flag was off and is being turned on.  And at the end, if the
> irq_safe flag was on and is being turned off, do
> pm_runtime_put_sync(dev->parent).  See pm_runtime_remove() for why this
> matters.  (Also update the documentation; the change to the parent
> isn't necessarily permanent any more.)

I'll try to figure out an alternative approach without the $subject change
first.  If I can't, I'll revisit this idea.

Thanks,
Rafael
