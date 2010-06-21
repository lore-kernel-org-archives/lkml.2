Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0FUD1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 23:27:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47400 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab0FUD1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 23:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rdL+hKkyWXw1KGayk7xyJjajtMkHaOFCVlLdY6D6AQuVz3GArEj8tdeXHzarUtoH39
         B94cH+ZZ+xkbdueKldPPPPpPFbezbnHeJnhLmS8oI4w3riyVUjr47XOp3IDltwNBpgsU
         byoCxc6EbBOjUtS0o2b9hsRNCGy9sGnJaq2N4=
MIME-Version: 1.0
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA065551D8@chinexm1.ad.analog.com>
References: <20090818214449.GA12848@oksana.dev.rtsoft.ru> <20090818214622.GA22651@oksana.dev.rtsoft.ru> 
	<AANLkTikg60s6ZRSEDCq9PQK1z7hJtBDk6t4VE1lYDv8u@mail.gmail.com> 
	<20100618133212.GA5276@oksana.dev.rtsoft.ru> <0F1B54C89D5F954D8535DB252AF412FA065551D8@chinexm1.ad.analog.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 21 Jun 2010 11:27:31 +0800
Message-ID: <AANLkTiksYofs6hhWta6uFX2cla_g8pBu0Mtbtcbv-2tl@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 1/2] mtd: m25p80: Reworkprobing/JEDEC 
	code
To: "Song, Barry" <Barry.Song@analog.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 10:42 AM, Song, Barry <Barry.Song@analog.com> wrote:
>
>
>>-----Original Message-----
>>From: uclinux-dist-devel-bounces@blackfin.uclinux.org
>>[mailto:uclinux-dist-devel-bounces@blackfin.uclinux.org] On
>>Behalf Of Anton Vorontsov
>>Sent: Friday, June 18, 2010 9:32 PM
>>To: Barry Song
>>Cc: David Brownell; Artem Bityutskiy;
>>linux-kernel@vger.kernel.org; linuxppc-dev@ozlabs.org;
>>linux-mtd@lists.infradead.org;
>>uclinux-dist-devel@blackfin.uclinux.org; Andrew Morton
>>Subject: Re: [Uclinux-dist-devel] [PATCH 1/2] mtd: m25p80:
>>Reworkprobing/JEDEC code
>>
>>On Sat, Jun 12, 2010 at 02:27:12PM +0800, Barry Song wrote:
>>> On Wed, Aug 19, 2009 at 5:46 AM, Anton Vorontsov
>>> <avorontsov@ru.mvista.com> wrote:
>>> >
>>> > Previosly the driver always tried JEDEC probing, assuming
>>that non-JEDEC
>>> > chips will return '0'. But truly non-JEDEC chips (like
>>CAT25) won't do
>>> > that, their behaviour on RDID command is undefined, so the
>>driver should
>>> > not call jedec_probe() for these chips.
>>> >
>>> > Also, be less strict on error conditions, don't fail to
>>probe if JEDEC
>>> > found a chip that is different from what platform code
>>told, instead
>>> > just print some warnings and use an information obtained
>>via JEDEC. In
>>> This patch caused a problem:
>>> even though the external flash doesn't exist, it will still pass the
>>> probe() and be registerred into kernel and given the partition table.
>>> You may refer to this bug report:
>>>
>>http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?ac
>>tion=TrackerItemEdit&tracker_item_id=5975&start=0
>>
>>Thanks for the report.
>>
>>There's little we can do about it. Platform code asked us
>>to register the device, and JEDEC probing of M25Pxx chips isn't
>>reliable (thanks to various vendors that make these JEDEC and
>>non-JEDEC variants), so the best thing we can do is to register
>>the chip anyway.
>>
>>OTOH, if the board pulls MISO line up, then the following patch
>>should help.
> Make sense with pullup to keep the value high while external device
> doesn't exist.
>>
>>If this won't work, we'll have to add some flag to the platform
>>data, i.e. to force JEDEC probing, and not trust platform data.
>
> How about we add a non_jedec flag in platform_data, if the flag is 1, we
> let the detection pass even though the ID is 0? Otherwise, we need a
> valid ID?
Here i mean:
Index: drivers/mtd/devices/m25p80.c
===================================================================
--- drivers/mtd/devices/m25p80.c	(revision 8927)
+++ drivers/mtd/devices/m25p80.c	(revision 8929)
@@ -795,8 +795,13 @@

 		jid = jedec_probe(spi);
 		if (!jid) {
-			dev_info(&spi->dev, "non-JEDEC variant of %s\n",
-				 id->name);
+			if (!data->non_jedec) {
+				dev_err(&spi->dev, "fail to detect%s\n",
+						id->name);
+				return -ENODEV;
+			} else
+				dev_info(&spi->dev, "non-JEDEC variant of %s\n",
+						id->name);
 		} else if (jid != id) {
 			/*
 			 * JEDEC knows better, so overwrite platform ID. We
Index: include/linux/spi/flash.h
===================================================================
--- include/linux/spi/flash.h	(revision 8927)
+++ include/linux/spi/flash.h	(revision 8929)
@@ -25,6 +25,11 @@

 	char		*type;

+	/*
+	 * For non-JEDEC, id will be 0. In this case, we can't be sure
+	 * whether the flash exists with runtime probing.
+	 */
+	int             non_jedec;
 	/* we'll likely add more ... use JEDEC IDs, etc */
 };

>
>>
>>Not-yet-Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
>>---
>>
>>diff --git a/drivers/mtd/devices/m25p80.c
>>b/drivers/mtd/devices/m25p80.c
>>index 81e49a9..a307929 100644
>>--- a/drivers/mtd/devices/m25p80.c
>>+++ b/drivers/mtd/devices/m25p80.c
>>@@ -16,6 +16,7 @@
>>  */
>>
>> #include <linux/init.h>
>>+#include <linux/errno.h>
>> #include <linux/module.h>
>> #include <linux/device.h>
>> #include <linux/interrupt.h>
>>@@ -723,7 +724,7 @@ static const struct spi_device_id
>>*__devinit jedec_probe(struct spi_device *spi)
>>       if (tmp < 0) {
>>               DEBUG(MTD_DEBUG_LEVEL0, "%s: error %d reading
>>JEDEC ID\n",
>>                       dev_name(&spi->dev), tmp);
>>-              return NULL;
>>+              return ERR_PTR(tmp);
>>       }
>>       jedec = id[0];
>>       jedec = jedec << 8;
>>@@ -737,7 +738,7 @@ static const struct spi_device_id
>>*__devinit jedec_probe(struct spi_device *spi)
>>        * exist for non-JEDEC chips, but for compatibility
>>they return ID 0.
>>        */
>>       if (jedec == 0)
>>-              return NULL;
>>+              return ERR_PTR(-EEXIST);
>>
>>       ext_jedec = id[3] << 8 | id[4];
>>
>>@@ -749,7 +750,7 @@ static const struct spi_device_id
>>*__devinit jedec_probe(struct spi_device *spi)
>>                       return &m25p_ids[tmp];
>>               }
>>       }
>>-      return NULL;
>>+      return ERR_PTR(-ENODEV);
>> }
>>
>>
>>@@ -794,9 +795,11 @@ static int __devinit m25p_probe(struct
>>spi_device *spi)
>>               const struct spi_device_id *jid;
>>
>>               jid = jedec_probe(spi);
>>-              if (!jid) {
>>+              if (IS_ERR(jid) && PTR_ERR(jid) == -EEXIST) {
>>                       dev_info(&spi->dev, "non-JEDEC variant of %s\n",
>>                                id->name);
>>+              } else if (IS_ERR(jid)) {
>>+                      return PTR_ERR(jid);
>>               } else if (jid != id) {
>>                       /*
>>                        * JEDEC knows better, so overwrite
>>platform ID. We
>>_______________________________________________
>>Uclinux-dist-devel mailing list
>>Uclinux-dist-devel@blackfin.uclinux.org
>>https://blackfin.uclinux.org/mailman/listinfo/uclinux-dist-devel
>>
>
