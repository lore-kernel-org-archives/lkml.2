Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1FUSqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:46:14 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:42487 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab1FUSqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:46:10 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jun 2011 14:46:09 EDT
Date: Tue, 21 Jun 2011 20:39:54 +0200
From: Marc Koschewski <marc@osknowledge.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mei driver breaks suspend on 3.0git
Message-ID: <20110621183954.GA17528@marc.osknowledge.org>
References: <201106121314.26394.a.miskiewicz@gmail.com>
 <201106122016.33399.a.miskiewicz@gmail.com>
 <201106122038.36623.a.miskiewicz@gmail.com>
 <201106122040.21950.a.miskiewicz@gmail.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401AD318B15@hasmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F0401AD318B15@hasmsx504.ger.corp.intel.com>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.39-dezzy
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Winkler, Tomas <tomas.winkler@intel.com> [2011-06-12 22:41:59 +0300]:

I suffer the same. After booting 3.0.0-r4 with that module not being loaded
it suspends, however, it doesn't resume (screen black, hard power-off needed).

Regards,
Marc

> 
> 
> > -----Original Message-----
> > From: Arkadiusz Miskiewicz [mailto:a.miskiewicz@gmail.com]
> > Sent: Sunday, June 12, 2011 9:40 PM
> > To: Winkler, Tomas
> > Cc: Weil, Oren jer; linux-kernel@vger.kernel.org
> > Subject: Re: mei driver breaks suspend on 3.0git
> > 
> > On Sunday 12 of June 2011, Arkadiusz Miskiewicz wrote:
> > > On Sunday 12 of June 2011, Arkadiusz Miskiewicz wrote:
> > > > On Sunday 12 of June 2011, Winkler, Tomas wrote:
> > > > > > -----Original Message-----
> > > > > > From: Weil, Oren jer
> > > > > > Sent: Sunday, June 12, 2011 8:36 PM
> > > > > > To: Arkadiusz Miskiewicz
> > > > > > Cc: Winkler, Tomas; linux-kernel@vger.kernel.org
> > > > > > Subject: RE: mei driver breaks suspend on 3.0git
> > > > > >
> > > > > > >It's thinkpad t400 with
> > > > > > >00:03.0 Communication controller [0780]: Intel Corporation
> > > > > > >Mobile 4 Series Chipset MEI Controller [8086:2a44] (rev 07)
> > > > > >
> > > > > > Can you send us more details? Does it happened in stress? How do
> > > > > > I reproduce it?
> > > >
> > > > No stress. This is my daily use notebook and I simply suspend to ram
> > > > when sitting under X in kde4.
> > > >
> > > > > > Can you send us the debug prints?
> > > >
> > > > Attached. suspend starts, tries to resume devices, MEI suspend fails
> > > > causing whole suspend to be aborted.
> > >
> > > Shouldn't ret > 0 in mei_wd_stop to be "success"?
> > 
> > I meant this one:
> > 
> >         ret = wait_event_interruptible_timeout(dev->wait_stop_wd,
> >                                         dev->wd_stopped, 10 * HZ);
> > 
> > 
> > And that was possible untested solution that relies on wd being stopped and
> > not anything else.
> > 
> > >
> > > diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c index
> > > 2564b03..608245a 100644
> > > --- a/drivers/staging/mei/wd.c
> > > +++ b/drivers/staging/mei/wd.c
> > > @@ -171,8 +171,10 @@ int mei_wd_stop(struct mei_device *dev, bool
> > preserve)
> > >         mutex_lock(&dev->device_lock);
> > >         if (!dev->wd_stopped)
> > >                 dev_dbg(&dev->pdev->dev, "stop wd failed to complete.\n");
> > > -       else
> > > +       else {
> > > +               ret = 0;
> > >                 dev_dbg(&dev->pdev->dev, "stop wd complete.\n");
> > > +       }
> > >
> > >         if (preserve)
> > >                 dev->wd_timeout = wd_timeout;
> > 
> 
> Looks like your patch is correct 
> wait_event_interruptible_timeout() returns  >0 on success unlike wait_even_interruptable()
> 
> I wil check all the instances we have and issue a patch.
> Thanks for your effort
> Tomas
> 
> ---------------------------------------------------------------------
> Intel Israel (74) Limited
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

-- 
Marc Koschewski
