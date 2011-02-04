Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1BDKNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 05:13:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35362 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab1BDKNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:13:47 -0500
Date: Fri, 4 Feb 2011 11:13:38 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andres Salomon <dilinger@queued.net>
Cc: Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 15/19] mc13xxx: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110204101338.GI30452@pengutronix.de>
References: <20110202195417.228e2656@queued.net>
 <20110202202015.0fe392a9@queued.net>
 <20110204093458.GH30452@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110204093458.GH30452@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 04, 2011 at 10:34:58AM +0100, Uwe Kleine-König wrote:
> And I think this patch has a conceptual problem, too.  In my opionion
> platform_data is the point to hand over platform specific data to a
> driver.  driver_data is something that is private to the driver and has
> to be considered opaque for the platform.  The driver was sort of OK
> before ...

So consequently I propose the patch below.  I'm sure that a few drivers
will break, but IMHO that's OK.

And by the way, did you know that platform_set_drvdata can fail and you
have no nice way to notice that but to do:

	dev_set_drvdata(dev, mypreciousdata);
	if (dev_get_drvdata(dev) != mypreciousdata)
		goto fail;

Best regards
Uwe

------>8-----------
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date: Fri, 4 Feb 2011 11:00:42 +0100
Subject: [PATCH] MFD: platform_set_drvdata should be only called by drivers

driver data is data private to drivers so it's not a point to hand over
data to the driver by the platform.  That's what platform_data is available
for.  The only place platform_set_drvdata should be called is in a
driver that has bound the device in question.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mfd-core.c   |    1 -
 include/linux/mfd/core.h |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index d83ad0f..8d06e0c 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -37,7 +37,6 @@ static int mfd_add_device(struct device *parent, int id,
 		goto fail_device;
 
 	pdev->dev.parent = parent;
-	platform_set_drvdata(pdev, cell->driver_data);
 
 	if (cell->data_size) {
 		ret = platform_device_add_data(pdev,
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 835996e..88bb7b5 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -30,9 +30,6 @@ struct mfd_cell {
 	int			(*suspend)(struct platform_device *dev);
 	int			(*resume)(struct platform_device *dev);
 
-	/* driver-specific data for MFD-aware "cell" drivers */
-	void			*driver_data;
-
 	/* platform_data can be used to either pass data to "generic"
 	   driver or as a hook to mfd_cell for the "cell" drivers */
 	void			*platform_data;
-- 
1.7.2.3

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
