Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2EREcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:32:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64417 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2EREcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:32:21 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpiolib: Defer failed gpio requests by default
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1335959380-8209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1335959380-8209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Thu, 17 May 2012 22:32:19 -0600
Message-Id: <20120518043219.740113E062C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 May 2012 12:49:40 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> Since users must be explicitly provided with a GPIO number in order to
> request one the overwhelmingly common case for failing to request will
> be that the required GPIO driver has not yet registered and we should
> therefore defer until it has registered.
> 
> In order to avoid having to code this logic in individual drivers have
> gpio_request() return -EPROBE_DEFER when failing to look up the GPIO.
> Drivers which don't want this behaviour can override it if they desire.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

[cc'ing a bunch of people who I think have some knowledge about the PM
issues... I know this is a long email, but I think this problem needs
to be looked at by folks more familiar with suspend/resume than I]

This one is problematic.... well, not the patch itself but the way the
larger driver mode works with suspend/resume looks really wrong to me.
dpm_list keeps track of all the 'active' driver that need to be
suspended.  However, it assumes that the list are in the order that
they were probed and therefore it can can walk the list backwards when
suspending.

The assumption is already kind of bogus because the list is in the
order that devices are added, not in the order that they are probed.
Probe order has pretty much no relationship with registration order.
Probe order effectively is based on driver initialization order and
module load order.  So the ordering when suspending may be completely
different from the order devices were initialized.  I think there are
probably all kinds of implicit dependency bugs hiding in that whole
scheme.

There are the device_pm_move_* functions for manipulating the
dpm_list and trying to 'fix' the ordering, but I'm not confident that
they are effective in the way they are used.  Mostly it seems to be
used in the path of removing a device.

/anyway/ the reason I'm saying this is that devices are *supposed* to
be in the correct order for suspend/resume.  With the implicit
dependencies expected by deferred probe, it becomes really important
that devices are correctly ordered in the list.  The only way this can
be done is to move the device to the end of the list.  The agreement
when this was last discussed on the ML was to make the drivers do an
explicit move immediately after it has validated all its dependencies.
That is why it doesn't work to return -EPROBE_DEFER by default from
helpers; because it becomes really hard to audit if the drivers are
doing the right thing.

I see two solutions to this though;
1) add a new .preprobe hook to device drivers that will respect
   -EPROBE_DEFER and ignore -EPROBE_DEFER on the regular .probe.
   Probing a driver will call both, but if the .preprobe hook is
   populated, then it will also reorder dpm_list between the two
   calls.
   - This still requires modifying drivers, but at least it is
     auditable by mere-mortal reviewers.
   - It also means all bus_type code has to add a new hook.  Blech.
2) simply force devices to the end of dpm_list before each probe
   attempt (provided that it doesn't have any children).
   - I've avoided this because it adds a claim of the dpm_list_mtx
     mutex on every single probe call and adds a lot more manipulation
     of the list....
   - However, it should make your patch here actually safe.  If a
     device gets deferred, it will be guaranteed to be at the end of
     the list because it gets moved there on every probe attempt.
   - also after reading through the code (see my notes below; I'm a
     bit frustrated with the whole thing) I think it is probably the
     right thing to do.

Will you be at Connect?  I could use some time sitting in a room with
smart people to dig through this code and talk out what it should be
doing.

Grumpily yours,
g.


My notes on the issue:
device_pm_add()
 - is only called by device_add()
 - so that is easy to audit
device_pm_remove()
 - similarly is only called by device_remove()
device_pm_move_{before,after,last}()
 - Only called by device_move()
device_move()
 - Used to reparent a device
 - only 4 in-tree users:
   - drivers/media/video/pvrusb2
     - uses it to *remove* any parents to a device
     - this is a weird driver; I don't know why it is unparenting it's
       devices
   - drivers/s390/cio/device.c
     - Used to change subchannel of a device.
   - net/bluetooth/hci_sysfs.c & net/bluetooth/rfcomm/tty.c
     - 2 callsites used to unparent a device before removing the
       parent.  This actually looks rather wrong to me; but I might be
       missing something.
     - 1 call site is used to set a new parent for the rfcomm device
       after opening the tty.

As for /using/ dpm_list, I see 2 locations:
dpm_complete()
 - entries in dpm_prepared_list are spliced into dpm_list.
dpm_prepare()
 - moves entries into dpm_prepared_list
   - Hmmm... So what happens when a device is moved but it is already
     in dpm_prepared_list?  Will it accidentally put /back/ onto the
     dpm_list when it shouldn't be?  I don't see any protections
     against this.
     - It *looks* like dev->power.is_{prepared,suspended} is intended
       to protect that list, but I don't see it being used by the
       core.

There are other lists too that devices can be on instead of dpm_list:
 - dpm_suspended_list
 - dpm_late_early_list
 - dpm_noirq_list

Blech!  None of this is ******* documented.  How is this all supposed to
work and stay consistent?!?

Misc:
 - to_device is the magic macro that goes from the device->power.entry
   list item.
 - searching for power.entry also finds the relevant modifications.



> ---
>  drivers/gpio/gpiolib.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 566d012..b244b0c 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1186,7 +1186,7 @@ int gpio_request(unsigned gpio, const char *label)
>  {
>  	struct gpio_desc	*desc;
>  	struct gpio_chip	*chip;
> -	int			status = -EINVAL;
> +	int			status = -EPROBE_DEFER;
>  	unsigned long		flags;
>  
>  	spin_lock_irqsave(&gpio_lock, flags);
> -- 
> 1.7.10
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
