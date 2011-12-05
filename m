Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1LED0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 22:26:42 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37542 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab1LED0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 22:26:40 -0500
MIME-Version: 1.0
In-Reply-To: <20111205085632.5976fe96@notabene.brown>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
	<201111142327.37524.rjw@sisk.pl>
	<20111115005951.GB26360@kroah.com>
	<201111160016.09174.rjw@sisk.pl>
	<20111205085632.5976fe96@notabene.brown>
Date: Mon, 5 Dec 2011 11:26:40 +0800
Message-ID: <CACVXFVNkapRDJ8QkgmJCh+n1c2+7cHBiLf1ef22Nfdd8YrPpGg@mail.gmail.com>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during shutdown
From: Ming Lei <tom.leiming@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
        Peter Chen <peter.chen@freescale.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        stern@rowland.harvard.edu, hzpeterchen@gmail.com,
        Igor Grinberg <grinberg@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 5, 2011 at 5:56 AM, NeilBrown <neilb@suse.de> wrote:
>
> Hi,
>  this patches causes a problem for me.
>
> Specifically it makes it impossible to power-down a device which uses twl4030
> for power control on an omap3 processor.
>
> To perform the shutdown we need to send a command over the i2c bus.
> The relevant bus is called omap_i2c.1 and this is normally in suspend mode.
> When a request is sent, omap_i2c_xfer uses pm_runtime_get_sync to wake it up,
> performs the transfer, then calls pm_runtime_put to let it go back to sleep.
>
> So it is asleep when the new pm_runtime_disable() call is made, so it stays
> asleep, omap_i2c_xfer cannot wake it, the transfer doesn't happen and the
> system doesn't get powered off.
>
> So here is a device that should *not* have pm disabled at shutdown.
>
> So I feel this fix is a little too heavy-handed.

Maybe the device's runtime PM should not be disabled if
there is no ->shutdown defined in its driver, how about the blew?

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d8b3d89..ca30659 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1743,14 +1743,16 @@ void device_shutdown(void)
 		 */
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
-		/* Disable all device's runtime power management */
-		pm_runtime_disable(dev);

+		/* Disable the device's runtime power management if
+		 * it is to be shutdown*/
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");
+			pm_runtime_disable(dev);
 			dev->bus->shutdown(dev);
 		} else if (dev->driver && dev->driver->shutdown) {
 			dev_dbg(dev, "shutdown\n");
+			pm_runtime_disable(dev);
 			dev->driver->shutdown(dev);
 		}
 		put_device(dev);


> I don't fully understand the problem scenario described above but it seems to
> me that if the auto-suspend timer can fire after the hardware has been shut
> down, then maybe the hardware-shutdown should be disabling that timer.  Maybe?
>
> Suggestions?
>
> Thanks,
> NeilBrown


thanks,
-- 
Ming Lei
