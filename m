Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439Ab1FWUzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:55:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45053 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab1FWUzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:55:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MzssSZRVPSiAspFIhvf1GnR4kaRE38tSXeiNbbNpZaEt1ICFpU7nhFBxFRuxicZj5E
         KFjVBdVMe9jW3aBTkxDXSUYiYVbVscPAw3nNNos6OIqqDpTM9OwRvXLNptZY7aw/aXfz
         E9R1fozOgkZ6Ch6SbO7G1xWB4XdwpzH8XbRi0=
Date: Thu, 23 Jun 2011 13:55:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Andersson <eric.andersson@unixphere.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengguang.guo@bosch-sensortec.com,
        stefan.nilsson@unixphere.com,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v2 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110623205532.GE14950@core.coreip.homeip.net>
References: <1308840027-10724-1-git-send-email-eric.andersson@unixphere.com>
 <1308840027-10724-2-git-send-email-eric.andersson@unixphere.com>
 <20110623163631.2c43671e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623163631.2c43671e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 04:36:31PM +0100, Alan Cox wrote:
> > +
> > +
> > +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/value
> > +Date:		May 2011
> > +Contact:	Eric Andersson <eric.andersson@unixphere.com>
> > +Description:	This is used to get the current acceleration values for each
> > +		axis. The values are represented as (x,y,z), where each axis can
> > +		hold a value between -512 and 511.
> > +
> > +		Reading: returns the current acceleration values.
> 
> This was nacked in the bma023 driver by the IIO folks - and Dmitry
> pointed out you can do this without a sysfs hack. The trick is to do an
> initial poll in input_open at which point the ioctl query for the
> position will have data that is current and open/ioctl/close works and
> providing we go nail that into other drivers that need that kind of use
> the API is generic and input event based.
> 

Right, I think the patch below will do what is needed for all polled
devices.

Thanks.

-- 
Dmitry


Input: polldev - immediately poll device upon opening

To allow open/ioctl(EVIOCGABS)/close use pattern for polled devices read
the device in context of open() call instead of offloading the first read
to a workqueue. This will ensure that once call to open() returns device
would have cached reasonably recent axis values that can be retrieved via
appropriate ioctl.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/input-polldev.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index b1aabde..b253973 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -49,8 +49,10 @@ static int input_open_polled_device(struct input_dev *input)
 		dev->open(dev);
 
 	/* Only start polling if polling is enabled */
-	if (dev->poll_interval > 0)
-		queue_delayed_work(system_freezable_wq, &dev->work, 0);
+	if (dev->poll_interval > 0) {
+		dev->poll(dev);
+		input_polldev_queue_work(dev);
+	}
 
 	return 0;
 }
