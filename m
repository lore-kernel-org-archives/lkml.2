Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab1H0KDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 06:03:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59634 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1H0KDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 06:03:05 -0400
Date: Sat, 27 Aug 2011 13:00:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch] rapidio: potential null deref in rio_setup_device()
Message-ID: <20110827100045.GL3775@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "goto cleanup" path can dereference "rswitch" which is NULL here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This is sort of embarrassing, I've patched this function before but
missed this.  Hopefully it's right now.

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 0914f49..882cef9 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -432,7 +432,7 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 		/* Assign component tag to device */
 		if (next_comptag >= 0x10000) {
 			pr_err("RIO: Component Tag Counter Overflow\n");
-			goto cleanup;
+			goto out_rdev;
 		}
 		rio_mport_write_config_32(port, destid, hopcount,
 					  RIO_COMPONENT_TAG_CSR, next_comptag);
@@ -518,7 +518,7 @@ static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 cleanup:
 	if (rio_is_switch(rdev))
 		kfree(rswitch->route_table);
-
+out_rdev:
 	kfree(rdev);
 	return NULL;
 }
