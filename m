Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1HGQS7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 12:18:59 -0400
Received: from csmtp2.one.com ([91.198.169.22]:38365 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab1HGQS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 12:18:57 -0400
Date: Sun, 7 Aug 2011 18:23:25 +0200
From: Eric Andersson <eric.andersson@unixphere.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk, jic23@cam.ac.uk,
        xu.zhang@bosch-sensortec.com
Subject: Re: [PATCH v6 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110807162325.GA7280@skinner.xfiles.lan>
References: <1311800027-25982-1-git-send-email-eric.andersson@unixphere.com>
 <1311800027-25982-2-git-send-email-eric.andersson@unixphere.com>
 <20110730191726.GG5686@core.coreip.homeip.net>
 <20110730224917.GA8519@skinner.xfiles.lan>
 <20110731070844.GA23383@core.coreip.homeip.net>
 <CAH+e7S2LU7zr6fcp+f+2UuzyXX_=icBa4OtO7m1YQQ2BtOyMAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH+e7S2LU7zr6fcp+f+2UuzyXX_=icBa4OtO7m1YQQ2BtOyMAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Jul 31, 2011 at 12:49:17AM +0200, Dmitry Torokhov wrote:
> > > > +static int bma150_open(struct bma150_data *bma150)
> > > > +{
> > > > + int ret;
> > > > +
> > > > + ret = pm_runtime_set_active(&bma150->client->dev);
> > > > + if (ret < 0)
> > > > +         return ret;
> > > > +
> > > > + pm_runtime_enable(&bma150->client->dev);
> > >
> > > I am pretty sure you want to call pm_runtime_enable() in bma150_probe()
> > > so that parent controller can be suspended until somebody calls
> > > bma150_open() and we mark the device as active (which, in turn, should
> > > wake up its parent).
> >
> > If I call pm_runtime_enable() I cannot use pm_runtime_set_active() later
> > according to the comment in __pm_runtime_set_status (runtime.c):
> > "If runtime PM of the device is disabled or its power.runtime_error
> > field is different from zero, the status may be changed either to
> > RPM_ACTIVE, or to RPM_SUSPENDED..."
> >
> > If the PM of the device is enabled it will return -EAGAIN. Of course, we
> > could enable() in probe, then disable(); set_active(); enable(); in
> > open, but that seems a bit confused, right?
> 
> Hmm, indeed. I do not like the idea about disable/set_active/enable so I
> guess we'll have to keep track of the current mode themselves and call
> bma150_set_mode() ourselves if, after calling pm_runtime_get/put_sync()
> we find that our mode is different from what we expect it to be.
> 
> I also noticed that you did not properly free IRQ on device removal and
> also polled devices need to be freed always (unlike regular input
> devices that should be only unregistered). The default_cfg can't be
> __initdata because it is used by __devinit functions. And my version of
> GCC can't figure out that ipoll_dev never used uninitialized and gives
> false warning.
> 
> I tried correcting these issues in the patch below, along with renaming
> 'ret' to 'error' which I prefer when we dealing with error handling.
> Could you please git it a try and if everything still works I'll fold it
> and commit.

Thanks Dmitry! I tried your patch and it worked like a charm!

Do you take it from here or would you like me to send an updated
version that includes your patch?

-- 
Best regards,
 Eric

http://www.unixphere.com
