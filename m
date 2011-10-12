Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1JLPAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:00:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47176 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1JLPAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:00:37 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] ide: ide_port_wait_ready() fix
Date: Wed, 12 Oct 2011 16:59:55 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201110111913.18492.bzolnier@gmail.com> <20111011.151739.917285592017305911.davem@davemloft.net>
In-Reply-To: <20111011.151739.917285592017305911.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110121659.55961.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 11 Oct 2011 19:13:18 +0200
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: ide_port_wait_ready() fix
> > 
> > Fix for commit a20b2a4 ("ide: skip probe if there are no devices on
> > the port (v2)").  We must check for slave device before failing.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> This will mishandle the case where there is no slave in the device
> list.

I don't see it:

@ -598,7 +598,7 @@ static int ide_port_wait_ready(ide_hwif_
 {
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	ide_drive_t *drive;
-	int i, rc;
+	int i, rc, prev_rc = 0;
 
 	printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
 
@@ -623,8 +623,10 @@ static int ide_port_wait_ready(ide_hwif_
 			tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 			mdelay(2);
 			rc = ide_wait_not_busy(hwif, 35000);
-			if (rc)
+			if (prev_rc && rc)
 				goto out;
+			prev_rc = rc;
+			rc = 0;
 		} else
 			printk(KERN_DEBUG "%s: ide_wait_not_busy() skipped\n",
 					  drive->name);

If there is no slave device but there is a master device the code falls-through
and returns a success.

The patch fixes regression introduced in commit a20b2a4 as some esoteric
setups return ide_wait_not_busy() -ENODEV error on master device while there
is slave device present in the system.
