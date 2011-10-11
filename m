Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1JKROo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:14:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41848 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab1JKROk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:14:40 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [PATCH] ide: ide_port_wait_ready() fix
Date: Tue, 11 Oct 2011 19:13:18 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201110111913.18492.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: ide_port_wait_ready() fix

Fix for commit a20b2a4 ("ide: skip probe if there are no devices on
the port (v2)").  We must check for slave device before failing.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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
