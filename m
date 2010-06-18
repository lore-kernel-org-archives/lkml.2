Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267Ab0FRNcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:32:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55816 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761089Ab0FRNcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EfLmngI9/hm5to2KZWYU7L5OjzDJQhE+vV2mdLR9AyR0pHU3xYO0MzdhZ14gPrg5M5
         9NBtOEFDlfq6f4EVDSf7r1Ljc+y/MmoDpIdQwwy6fdX4aqLwyMdNxqxbNJ/mxZyK4ArS
         bU40t6E3hpRPRQvekUvvoPlVHg+RqSSwMvwxg=
Date: Fri, 18 Jun 2010 17:32:12 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/2] mtd: m25p80: Rework probing/JEDEC code
Message-ID: <20100618133212.GA5276@oksana.dev.rtsoft.ru>
References: <20090818214449.GA12848@oksana.dev.rtsoft.ru>
 <20090818214622.GA22651@oksana.dev.rtsoft.ru>
 <AANLkTikg60s6ZRSEDCq9PQK1z7hJtBDk6t4VE1lYDv8u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTikg60s6ZRSEDCq9PQK1z7hJtBDk6t4VE1lYDv8u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 12, 2010 at 02:27:12PM +0800, Barry Song wrote:
> On Wed, Aug 19, 2009 at 5:46 AM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> >
> > Previosly the driver always tried JEDEC probing, assuming that non-JEDEC
> > chips will return '0'. But truly non-JEDEC chips (like CAT25) won't do
> > that, their behaviour on RDID command is undefined, so the driver should
> > not call jedec_probe() for these chips.
> >
> > Also, be less strict on error conditions, don't fail to probe if JEDEC
> > found a chip that is different from what platform code told, instead
> > just print some warnings and use an information obtained via JEDEC. In
> This patch caused a problem:
> even though the external flash doesn't exist, it will still pass the
> probe() and be registerred into kernel and given the partition table.
> You may refer to this bug report:
> http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=5975&start=0

Thanks for the report.

There's little we can do about it. Platform code asked us
to register the device, and JEDEC probing of M25Pxx chips isn't
reliable (thanks to various vendors that make these JEDEC and
non-JEDEC variants), so the best thing we can do is to register
the chip anyway.

OTOH, if the board pulls MISO line up, then the following patch
should help.

If this won't work, we'll have to add some flag to the platform
data, i.e. to force JEDEC probing, and not trust platform data.

Not-yet-Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 81e49a9..a307929 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
@@ -723,7 +724,7 @@ static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
 	if (tmp < 0) {
 		DEBUG(MTD_DEBUG_LEVEL0, "%s: error %d reading JEDEC ID\n",
 			dev_name(&spi->dev), tmp);
-		return NULL;
+		return ERR_PTR(tmp);
 	}
 	jedec = id[0];
 	jedec = jedec << 8;
@@ -737,7 +738,7 @@ static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
 	 * exist for non-JEDEC chips, but for compatibility they return ID 0.
 	 */
 	if (jedec == 0)
-		return NULL;
+		return ERR_PTR(-EEXIST);
 
 	ext_jedec = id[3] << 8 | id[4];
 
@@ -749,7 +750,7 @@ static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
 			return &m25p_ids[tmp];
 		}
 	}
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 
@@ -794,9 +795,11 @@ static int __devinit m25p_probe(struct spi_device *spi)
 		const struct spi_device_id *jid;
 
 		jid = jedec_probe(spi);
-		if (!jid) {
+		if (IS_ERR(jid) && PTR_ERR(jid) == -EEXIST) {
 			dev_info(&spi->dev, "non-JEDEC variant of %s\n",
 				 id->name);
+		} else if (IS_ERR(jid)) {
+			return PTR_ERR(jid);
 		} else if (jid != id) {
 			/*
 			 * JEDEC knows better, so overwrite platform ID. We
