Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1HYRBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:01:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60475 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1HYRBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:01:21 -0400
Date: Thu, 25 Aug 2011 10:01:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dudley Du <dudl@cypress.com>,
        "rubini@ipvvis.unipv.it" <rubini@cvml.unipv.it>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] input:cyapa: Add new I2C-based input touchpad driver for
 Cypress I2C touchpad devices
Message-ID: <20110825170112.GA27146@core.coreip.homeip.net>
References: <B27AC323FA92C946BA36D2913DDC8E370226D9457E6B@VMBX126.ihostexchange.net>
 <B27AC323FA92C946BA36D2913DDC8E370226D9457E7B@VMBX126.ihostexchange.net>
 <20110825150146.2e876af8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825150146.2e876af8@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 03:01:46PM +0100, Alan Cox wrote:
> > +
> > +static void cyapa_disable_irq(struct cyapa_i2c *touch)
> > +{
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&touch->miscdev_spinlock, flags);
> > +       if (!touch->polling_mode_enabled &&
> > +               touch->bl_irq_enable &&
> > +               touch->irq_enabled) {
> > +               touch->irq_enabled = false;
> > +               disable_irq(touch->irq);
> > +       }
> > +       spin_unlock_irqrestore(&touch->miscdev_spinlock, flags);
> 
> This doesn't do what you think. disable_irq does not guarantee that the
> IRQ is not executing on another CPU core. disable_irq_sync does but then
> you will deadlock.

Actually disable_irq() does guarantee that IRQ is not executing once the
call completes. We have disable_irq_nosync() that does not wait.

> +
> > +static int cyapa_i2c_open(struct input_dev *input)
> > +{
> > +       struct cyapa_i2c *touch = input_get_drvdata(input);
> > +       int ret;
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&touch->lock, flags);
> > +       if (touch->open_count == 0) {
> > +               ret = cyapa_i2c_reset_config(touch);
> > +               if (ret < 0) {
> > +                       pr_err("reset i2c trackpad error code, %d.\n", ret);
> > +                       return ret;
> > +               }
> > +       }
> > +       spin_unlock_irqrestore(&touch->lock, flags);
> > +
> > +       spin_lock_irqsave(&touch->lock, flags);
> > +       touch->open_count++;
> > +       spin_unlock_irqrestore(&touch->lock, flags);
> 
> You've dropped the lock and taken it and dropped it again in sequential
> lines. That's nonsensical and also means you've added a race !
> 

Also please note that input core ensures that open() and close() methods
are called only when needed (first user opens the device or last user
closes it), you do not need to count yourself.

> 
> > +static void cyapa_i2c_close(struct input_dev *input)
> > +{
> > +       unsigned long flags;
> > +       struct cyapa_i2c *touch = input_get_drvdata(input);
> > +
> > +       spin_lock_irqsave(&touch->lock, flags);
> > +
> > +       if (touch->open_count == 0) {
> 
> Wouldn't this be an error ?
> 
> 
> > +       ret = request_irq(touch->irq,
> > +                       cyapa_i2c_irq,
> > +                       IRQF_TRIGGER_FALLING,
> > +                       CYAPA_I2C_NAME,
> > +                       touch);
> 
> This IRQ can happen from the moment it is registered which means it can
> occur before the variables you set up further down...
> 
> > +       if (ret) {
> > +               pr_warning("IRQ request failed: %d, "
> > +                       "falling back to polling mode.\n", ret);
> > +
> > +               spin_lock_irqsave(&touch->miscdev_spinlock, flags);
> > +               touch->polling_mode_enabled = true;
> > +               touch->bl_irq_enable = false;
> > +               touch->irq_enabled = false;
> > +               spin_unlock_irqrestore(&touch->miscdev_spinlock, flags);
> > +       } else {
> > +               spin_lock_irqsave(&touch->miscdev_spinlock, flags);
> > +               touch->polling_mode_enabled = false;
> > +               touch->bl_irq_enable = false;
> > +               touch->irq_enabled = true;
> > +               enable_irq_wake(touch->irq);
> > +               spin_unlock_irqrestore(&touch->miscdev_spinlock, flags);
> > +       }
> > +
> > +       /* create an input_dev instance for trackpad device. */
> > +       ret = cyapa_create_input_dev(touch);
> > +       if (ret) {
> > +               free_irq(touch->irq, touch);
> 
> But what if it was polling ?
> 
> 
> In general I think
> 
> - use the threaded_irq interfaces for your IRQ paths (if you look at the
>   current kernel you'll see a lot of drivers do this)
> - use the polled input device interface for the no IRQ case, so it does
>   all the polling work for you

Polling mode for a touchscreen is unusable in real product (unlike
accelerometers/magnetometers/etc touchscreens need constant polling with
relatively high rate) so I'd rather not have it at all.

> - tidy up the locking (and the fact you've got locking in there is a lot
>   better than many first submissions we see)
> 
> I would think about how the various states and handlers work. Right now
> the code is quite convoluted, and maybe a state machine of some kind would
> clean it up ?
> 

Also the miscdevice inteface should go away and be replaced with
sysfs/debugfs solution. For firmware update request_firmware() interface
can be used (see atmel_mxt_ts driver).

Thanks.

-- 
Dmitry
