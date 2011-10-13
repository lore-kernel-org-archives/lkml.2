Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab1JMRo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:44:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39270 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1JMRo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:44:58 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] ide: ide_port_wait_ready() fix
Date: Thu, 13 Oct 2011 19:44:07 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201110121659.55961.bzolnier@gmail.com> <201110131241.04759.bzolnier@gmail.com> <20111013.132527.2221791090526837668.davem@davemloft.net>
In-Reply-To: <20111013.132527.2221791090526837668.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131944.31645.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Thu, 13 Oct 2011 12:41:04 +0200
> 
> > David Miller wrote:
> > 
> >> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> Date: Wed, 12 Oct 2011 16:59:55 +0200
> >> 
> >> > David Miller wrote:
> >> > 
> >> >> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> >> Date: Tue, 11 Oct 2011 19:13:18 +0200
> >> >> 
> >> >> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> >> > Subject: [PATCH] ide: ide_port_wait_ready() fix
> >> >> > 
> >> >> > Fix for commit a20b2a4 ("ide: skip probe if there are no devices on
> >> >> > the port (v2)").  We must check for slave device before failing.
> >> >> > 
> >> >> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >> >> 
> >> >> This will mishandle the case where there is no slave in the device
> >> >> list.
> >> > 
> >> > I don't see it:
> >> > 
> >> > @ -598,7 +598,7 @@ static int ide_port_wait_ready(ide_hwif_
> >> >  {
> >> >  	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
> >> >  	ide_drive_t *drive;
> >> > -	int i, rc;
> >> > +	int i, rc, prev_rc = 0;
> >> >  
> >> >  	printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
> >> >  
> >> > @@ -623,8 +623,10 @@ static int ide_port_wait_ready(ide_hwif_
> >> >  			tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
> >> >  			mdelay(2);
> >> >  			rc = ide_wait_not_busy(hwif, 35000);
> >> > -			if (rc)
> >> > +			if (prev_rc && rc)
> >> >  				goto out;
> >> > +			prev_rc = rc;
> >> > +			rc = 0;
> >> >  		} else
> >> >  			printk(KERN_DEBUG "%s: ide_wait_not_busy() skipped\n",
> >> >  					  drive->name);
> >> > 
> >> > If there is no slave device but there is a master device the code falls-through
> >> > and returns a success.
> >> 
> >> That's not what we want, if there is only a master device and no slave device
> >> in the list this loop is iterating over we want to return the error code
> >> in "rc", not zero.
> > 
> > No, we want to return zero (success) since at least once device was found
> > (otherwise we fail probe on some esoteric setups returning -ENODEV from
> > ide_wait_not_busy() for master device).
> > 
> > This is how this function worked before commit a20b2a4 if you want something
> > else okay but it needs to work with aforementioned setups.
> 
> You unconditionally assign "prev_rc = rc" and set "rc = 0" so if we only run
> the loop once, we return zero.
> 
> And we do this even if that one device gave a non-zero return value.
> 
> That's not what we want.

Here is revised patch:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2] ide: ide_port_wait_ready() fix

Fix for commit a20b2a4 ("ide: skip probe if there are no devices on
the port (v2)").  We must check for slave device before failing.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -598,7 +598,7 @@ static int ide_port_wait_ready(ide_hwif_
 {
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	ide_drive_t *drive;
-	int i, rc;
+	int i, rc, prev_rc = 0;
 
 	printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
 
@@ -623,8 +623,9 @@ static int ide_port_wait_ready(ide_hwif_
 			tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 			mdelay(2);
 			rc = ide_wait_not_busy(hwif, 35000);
-			if (rc)
+			if (prev_rc && rc)
 				goto out;
+			prev_rc = rc;
 		} else
 			printk(KERN_DEBUG "%s: ide_wait_not_busy() skipped\n",
 					  drive->name);

