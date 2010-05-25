Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab0EYVqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:46:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46801 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695Ab0EYVqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:46:42 -0400
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
       Michael Roth <mroth@nessie.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] touchscreen: ads7846: please don't touch free'd memory
References: <1274226413-8520-1-git-send-email-khilman@deeprootsystems.com>
	<20100519000019.GA17475@core.coreip.homeip.net>
	<87mxvnlpxv.fsf@deeprootsystems.com>
	<20100525202135.GC4455@core.coreip.homeip.net>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 25 May 2010 14:46:38 -0700
In-Reply-To: <20100525202135.GC4455@core.coreip.homeip.net> (Dmitry Torokhov's message of "Tue\, 25 May 2010 13\:21\:35 -0700")
Message-ID: <8739xflkn5.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> On Tue, May 25, 2010 at 12:52:12PM -0700, Kevin Hilman wrote:
>> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
>> 
>> > On Tue, May 18, 2010 at 04:46:53PM -0700, Kevin Hilman wrote:
>> >> If the _probe() method fails, the 'ts' struct is freed, yet it is
>> >> still used as the drvdata passed to suspend/resume/remove methods.
>> >> Even though the input device does not get registerd, the driver's
>> >> suspend/resume methods still get called as it's a registered SPI
>> >> device.  This patch adds sanity checks to these methods to ensure that
>> >> drvdata is valid before using it.
>> >> 
>> >
>> > This is a load of crap. If probe() fails that means that driver does not
>> > manage the device and thus ads7846_suspend() and ads7846_resume() should
>> > not be called _at all_. If SPI core manages to call random methods from
>> > the drivers that failed to bind to a device that should be fixed in SPI
>> > core.
>> 
>> Agreed, this is indeed a bug in the SPI driver core.
>> 
>> However, by fixing the SPI core to unregister the driver on failure
>> (patch below), we prevent the suspend & resume methods from being
>> called, but the driver's ->remove() method will still be called due to
>> the driver_unregister().  So at least the remove() method needs fixing
>> to prevent accessing free'd memory.
>> 
>> Unless there are objections, I'll post the below along with an updated
>> version of ads7846 patch.
>> 
>> Kevin
>> 
>> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
>> index b3a1f92..42d4d26 100644
>> --- a/drivers/spi/spi.c
>> +++ b/drivers/spi/spi.c
>> @@ -175,6 +175,8 @@ static void spi_drv_shutdown(struct device *dev)
>>   */
>>  int spi_register_driver(struct spi_driver *sdrv)
>>  {
>> +	int ret;
>> +
>>  	sdrv->driver.bus = &spi_bus_type;
>>  	if (sdrv->probe)
>>  		sdrv->driver.probe = spi_drv_probe;
>> @@ -182,7 +184,12 @@ int spi_register_driver(struct spi_driver *sdrv)
>>  		sdrv->driver.remove = spi_drv_remove;
>>  	if (sdrv->shutdown)
>>  		sdrv->driver.shutdown = spi_drv_shutdown;
>> -	return driver_register(&sdrv->driver);
>> +
>> +	ret = driver_register(&sdrv->driver);
>> +	if (!ret)
>> +		driver_unregister(&sdrv->driver);
>
> This is still wrong. driver_register() should properly clean up after
> itself and not require calls to driver_unregister() (and I believe it
> does).
>
> Besides, I do not see how this patch changes anything with regard to
> binding devices and drivers. Even if driver_register() succeeds, binding
> may still fail and we should not be calling neither ->remove(), nor
> ->suspend()/->resume() for the devices that failed to be bound.

Hmm, good point.

After digging into the driver core and realizing that it seemed to
have sane error handling itself, I took a closer look at
ads7846_probe() and discovered it doesn't actually return an error
code for certain failure cases!  That was the root cause.

The patch below fixes the problem.

Thanks,

Kevin 



>From 3588494cf6e51754f7089bb8089b99abd765c493 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Tue, 25 May 2010 14:38:04 -0700
Subject: [PATCH] input: touchscreen: ads7846: return error on probe failure

In probe(), if regulator_get() failed, an error code was not being
returned causing the driver to be successfully bound, even though
probe failed.  This in turn caused the suspend, resume and remove
methods to be registered and accessed via the SPI core.  Since these
functions all access private driver data using pointers that had been
freed during the failed probe, this would lead to unpredictable
behavior.

This patch ensures that probe() returns an error code in this failure
case so the driver is not bound.

Found using lockdep and noticing the lock used in the suspend/resum
path pointed to a bogus lock due to the freed memory.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/input/touchscreen/ads7846.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 532279c..634f6f6 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1163,8 +1163,8 @@ static int __devinit ads7846_probe(struct spi_device *spi)
 
 	ts->reg = regulator_get(&spi->dev, "vcc");
 	if (IS_ERR(ts->reg)) {
-		dev_err(&spi->dev, "unable to get regulator: %ld\n",
-			PTR_ERR(ts->reg));
+		err = PTR_ERR(ts->reg);
+		dev_err(&spi->dev, "unable to get regulator: %ld\n", err);
 		goto err_free_gpio;
 	}
 
-- 
1.7.0.2

