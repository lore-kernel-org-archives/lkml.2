Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab1G3WpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:45:11 -0400
Received: from csmtp1.one.com ([195.47.247.21]:17756 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab1G3WpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:45:07 -0400
Date: Sun, 31 Jul 2011 00:49:17 +0200
From: Eric Andersson <eric.andersson@unixphere.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk, jic23@cam.ac.uk,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v6 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110730224917.GA8519@skinner.xfiles.lan>
References: <1311800027-25982-1-git-send-email-eric.andersson@unixphere.com>
 <1311800027-25982-2-git-send-email-eric.andersson@unixphere.com>
 <20110730191726.GG5686@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110730191726.GG5686@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int bma150_open(struct bma150_data *bma150)
> > +{
> > +	int ret;
> > +
> > +	ret = pm_runtime_set_active(&bma150->client->dev);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	pm_runtime_enable(&bma150->client->dev);
> 
> I am pretty sure you want to call pm_runtime_enable() in bma150_probe()
> so that parent controller can be suspended until somebody calls
> bma150_open() and we mark the device as active (which, in turn, should
> wake up its parent).

If I call pm_runtime_enable() I cannot use pm_runtime_set_active() later
according to the comment in __pm_runtime_set_status (runtime.c):
"If runtime PM of the device is disabled or its power.runtime_error
field is different from zero, the status may be changed either to
RPM_ACTIVE, or to RPM_SUSPENDED..."

If the PM of the device is enabled it will return -EAGAIN. Of course, we
could enable() in probe, then disable(); set_active(); enable(); in
open, but that seems a bit confused, right?

> > +
> > +	return bma150_set_mode(bma150->client, BMA150_MODE_NORMAL);
> > +}
> > +
> > +static void bma150_close(struct bma150_data *bma150)
> > +{
> > +	pm_runtime_disable(&bma150->client->dev);
> 
> And disable should go into bma150_remove() unless I misunderstand
> runtime PM framework.

This is once again to make sure the PM is disabled when changing status.

I am not entirely familiar with the details of runtime PM, but either
the above works or we have to revert back to using #ifdefs which I would
prefer not to.

-- 
Best regards,
 Eric

http://www.unixphere.com
