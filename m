Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab0EYWSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:18:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53107 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020Ab0EYWSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:18:17 -0400
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-omap@vger.kernel.org, Michael Roth <mroth@nessie.de>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] touchscreen: ads7846: please don't touch free'd memory
References: <1274226413-8520-1-git-send-email-khilman@deeprootsystems.com>
	<20100519000019.GA17475@core.coreip.homeip.net>
	<87mxvnlpxv.fsf@deeprootsystems.com>
	<20100525202135.GC4455@core.coreip.homeip.net>
	<8739xflkn5.fsf@deeprootsystems.com>
	<AANLkTik72Q50eHX5cLW4uZ13BiMVCKQ0_bKdrCGZxpeE@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 25 May 2010 15:18:13 -0700
In-Reply-To: <AANLkTik72Q50eHX5cLW4uZ13BiMVCKQ0_bKdrCGZxpeE@mail.gmail.com> (Mike Frysinger's message of "Tue\, 25 May 2010 17\:56\:27 -0400")
Message-ID: <87r5kzk4m2.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> writes:

> On Tue, May 25, 2010 at 17:46, Kevin Hilman wrote:
>> After digging into the driver core and realizing that it seemed to
>> have sane error handling itself, I took a closer look at
>> ads7846_probe() and discovered it doesn't actually return an error
>> code for certain failure cases!  That was the root cause.
>
> that is crappy
>
>> Subject: [PATCH] input: touchscreen: ads7846: return error on probe failure
>
> i'd refer to the specific probe issue rather than just "probe".  maybe:
> input: touchscreen: ads7846: return error on regulator_get() failure

Thanks for the review, here's one with updated subject and ack added.

Kevin

>From 8ce49a91341d8713f870d2a931969f227a82b8ad Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Tue, 25 May 2010 14:38:04 -0700
Subject: [PATCH] input: touchscreen: ads7846: return error on regulator_get() failure

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
Acked-by: Mike Frysinger <vapier@gentoo.org>
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

