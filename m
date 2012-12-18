Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2LRLxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 06:53:24 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:33760 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab2LRLxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 06:53:22 -0500
Date: Tue, 18 Dec 2012 12:53:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Uwe =?ISO-8859-1?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] at24: make module parameters changeable via sysfs
Message-ID: <20121218125315.5adb1fef@endymion.delvare>
In-Reply-To: <20120914102536.1ebd248d@endymion.delvare>
References: <1347443012-21302-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20120914102536.1ebd248d@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe,

On Fri, 14 Sep 2012 10:25:36 +0200, Jean Delvare wrote:
> On Wed, 12 Sep 2012 11:43:32 +0200, Uwe Kleine-König wrote:
> > The respective values are evaluated at each read/write, so no further
> > action is required than to change the perm argument to module_param.
> > 
> > Note there is no sanity check so root can make the driver effectively
> > unusable but that's what root is for :-)
> >
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/misc/eeprom/at24.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
> > index ab1ad41..8a5a192 100644
> > --- a/drivers/misc/eeprom/at24.c
> > +++ b/drivers/misc/eeprom/at24.c
> > @@ -85,7 +85,7 @@ struct at24_data {
> >   * This value is forced to be a power of two so that writes align on pages.
> >   */
> >  static unsigned io_limit = 128;
> > -module_param(io_limit, uint, 0);
> > +module_param(io_limit, uint, S_IRUGO | S_IWUSR);
> 
> This won't work. Not only there is no validation of the value, while
> there is such a validation (and value adjustment!) in at24_init(); you
> seem to not care, but I do. But the more important problem is that
> changing io_limit at run-time will only affect reads, not writes. The
> size limit from writes is computed at device probing time:
> 
> static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
> {
> (...)
> 	if (writable) {
> 	(...)
> 			if (write_max > io_limit)
> 				write_max = io_limit;
> 
> So changing the value through sysfs will have no effect. If you want it
> to have an effect, you have to move the check from at24_probe() to
> at24_eeprom_write().
> 
> Back to the validation issue, I think it would be worth looking into
> module_param_cb(). Using it, it may not be that difficult to get
> validation when the value is changed through sysfs. Otherwise I'll ask
> you to check what exactly happens if someone sets io_limit to 0. We
> can't afford infinite loops or EEPROM corruption on root mistyping.
> 
> >  MODULE_PARM_DESC(io_limit, "Maximum bytes per I/O (default 128)");
> >  
> >  /*
> > @@ -93,7 +93,7 @@ MODULE_PARM_DESC(io_limit, "Maximum bytes per I/O (default 128)");
> >   * it's important to recover from write timeouts.
> >   */
> >  static unsigned write_timeout = 25;
> > -module_param(write_timeout, uint, 0);
> > +module_param(write_timeout, uint, S_IRUGO | S_IWUSR);
> 
> This one is OK.
> 
> >  MODULE_PARM_DESC(write_timeout, "Time (in ms) to try writes (default 25)");
> >  
> >  #define AT24_SIZE_BYTELEN 5

I reviewed this patch 3 months ago and did not hear back. Are you going
to update this patch and resubmit, or should I just drop it?

-- 
Jean Delvare
