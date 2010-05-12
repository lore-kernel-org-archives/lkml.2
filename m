Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0ELTGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:06:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab0ELTGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:06:32 -0400
Date: Wed, 12 May 2010 11:55:12 -0700
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: mjg@redhat.com, mzxreary@0pointer.de, rpurdie@linux.intel.com,
       jlee@novell.com, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 4/4] msi-laptop: Add i8042 filter to sync sw state with
 BIOS when function key pressed
Message-ID: <20100512185512.GB28990@suse.de>
References: <20100512141149.GB20564@kroah.com>
 <1273683490-27090-4-git-send-email-gregkh@suse.de>
 <20100512173359.GA16431@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512173359.GA16431@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 10:33:59AM -0700, Dmitry Torokhov wrote:
> On Wed, May 12, 2010 at 09:58:10AM -0700, Greg Kroah-Hartman wrote:
> > From: Lee, Chun-Yi <jlee@novell.com>
> > 
> > There have some MSI netbook change devices state by EC when user press
> > wlan/bluetooth/wwan function keys. So, add a i8042 filter to sync sw
> > state with BIOS when function keys pressed.
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  drivers/platform/x86/msi-laptop.c |   59 ++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 58 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
> > index 34bec2e..3c6e160 100644
> > --- a/drivers/platform/x86/msi-laptop.c
> > +++ b/drivers/platform/x86/msi-laptop.c
> > @@ -59,6 +59,7 @@
> >  #include <linux/backlight.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/rfkill.h>
> > +#include <linux/i8042.h>
> >  
> >  #define MSI_DRIVER_VERSION "0.5"
> >  
> > @@ -581,6 +582,46 @@ static void rfkill_cleanup(void)
> >  	}
> >  }
> >  
> > +static void msi_update_rfkill(struct work_struct *ignored)
> > +{
> > +	get_wireless_state_ec_standard();
> > +
> > +	if (rfk_wlan)
> > +		rfkill_set_sw_state(rfk_wlan, !wlan_s);
> > +	if (rfk_bluetooth)
> > +		rfkill_set_sw_state(rfk_bluetooth, !bluetooth_s);
> > +	if (rfk_threeg)
> > +		rfkill_set_sw_state(rfk_threeg, !threeg_s);
> > +}
> > +static DECLARE_DELAYED_WORK(msi_rfkill_work, msi_update_rfkill);
> > +
> > +bool msi_laptop_i8042_filter(unsigned char data, unsigned char str,
> > +				struct serio *port)
> 
> Make it static bool...

Will do.

> >  static void msi_init_rfkill(struct work_struct *ignored)
> >  {
> >  	if (rfk_wlan) {
> > @@ -706,9 +747,24 @@ static int load_scm_model_init(struct platform_device *sdev)
> >  	/* initial rfkill */
> >  	result = rfkill_init(sdev);
> >  	if (result < 0)
> > -		return result;
> > +		goto fail_rfkill;
> > +
> > +	result = i8042_install_filter(msi_laptop_i8042_filter);
> > +	if (result) {
> > +		printk(KERN_WARNING
> 
> Since we fail driver load this should be error, not warning message.

Good point, I'll fix that up as well.

I'll respin this now.

thanks,

greg k-h
