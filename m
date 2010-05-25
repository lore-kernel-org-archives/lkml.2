Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab0EYTwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:52:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59077 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab0EYTwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:52:16 -0400
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
       Michael Roth <mroth@nessie.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] touchscreen: ads7846: please don't touch free'd memory
References: <1274226413-8520-1-git-send-email-khilman@deeprootsystems.com>
	<20100519000019.GA17475@core.coreip.homeip.net>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 25 May 2010 12:52:12 -0700
In-Reply-To: <20100519000019.GA17475@core.coreip.homeip.net> (Dmitry Torokhov's message of "Tue\, 18 May 2010 17\:00\:20 -0700")
Message-ID: <87mxvnlpxv.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> On Tue, May 18, 2010 at 04:46:53PM -0700, Kevin Hilman wrote:
>> If the _probe() method fails, the 'ts' struct is freed, yet it is
>> still used as the drvdata passed to suspend/resume/remove methods.
>> Even though the input device does not get registerd, the driver's
>> suspend/resume methods still get called as it's a registered SPI
>> device.  This patch adds sanity checks to these methods to ensure that
>> drvdata is valid before using it.
>> 
>
> This is a load of crap. If probe() fails that means that driver does not
> manage the device and thus ads7846_suspend() and ads7846_resume() should
> not be called _at all_. If SPI core manages to call random methods from
> the drivers that failed to bind to a device that should be fixed in SPI
> core.

Agreed, this is indeed a bug in the SPI driver core.

However, by fixing the SPI core to unregister the driver on failure
(patch below), we prevent the suspend & resume methods from being
called, but the driver's ->remove() method will still be called due to
the driver_unregister().  So at least the remove() method needs fixing
to prevent accessing free'd memory.

Unless there are objections, I'll post the below along with an updated
version of ads7846 patch.

Kevin

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index b3a1f92..42d4d26 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -175,6 +175,8 @@ static void spi_drv_shutdown(struct device *dev)
  */
 int spi_register_driver(struct spi_driver *sdrv)
 {
+	int ret;
+
 	sdrv->driver.bus = &spi_bus_type;
 	if (sdrv->probe)
 		sdrv->driver.probe = spi_drv_probe;
@@ -182,7 +184,12 @@ int spi_register_driver(struct spi_driver *sdrv)
 		sdrv->driver.remove = spi_drv_remove;
 	if (sdrv->shutdown)
 		sdrv->driver.shutdown = spi_drv_shutdown;
-	return driver_register(&sdrv->driver);
+
+	ret = driver_register(&sdrv->driver);
+	if (!ret)
+		driver_unregister(&sdrv->driver);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(spi_register_driver);
 

