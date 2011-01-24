Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1AXKqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:46:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60537 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1AXKqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:46:00 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andy Walls <awalls@md.metrocast.net>, Jarod Wilson <jarod@redhat.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] drivers/staging/lirc: Remove obsolete cleanup for clientdata
Date: Mon, 24 Jan 2011 11:44:30 +0100
Message-Id: <1295865880-27672-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
References: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit or error. This is obsolete meanwhile, the core will do it. Simplify the
kfree() calls after that, the pointers don't need to be checked.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Joe Perches <joe@perches.com>
---

Compile tested only.

 drivers/staging/lirc/lirc_zilog.c |   28 +++++++++-------------------
 1 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 3fe5f41..df1055f 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -1214,15 +1214,12 @@ static int ir_remove(struct i2c_client *client)
 
 	/* Good-bye Rx */
 	destroy_rx_kthread(ir->rx);
-	if (ir->rx != NULL) {
-		if (ir->rx->buf.fifo_initialized)
-			lirc_buffer_free(&ir->rx->buf);
-		i2c_set_clientdata(ir->rx->c, NULL);
-		kfree(ir->rx);
-	}
+	if (ir->rx && ir->rx->buf.fifo_initialized)
+		lirc_buffer_free(&ir->rx->buf);
+
+	kfree(ir->rx);
 
 	/* Good-bye Tx */
-	i2c_set_clientdata(ir->tx->c, NULL);
 	kfree(ir->tx);
 
 	/* Good-bye IR */
@@ -1388,18 +1385,11 @@ out_unregister:
 out_free_thread:
 	destroy_rx_kthread(ir->rx);
 out_free_xx:
-	if (ir->rx != NULL) {
-		if (ir->rx->buf.fifo_initialized)
-			lirc_buffer_free(&ir->rx->buf);
-		if (ir->rx->c != NULL)
-			i2c_set_clientdata(ir->rx->c, NULL);
-		kfree(ir->rx);
-	}
-	if (ir->tx != NULL) {
-		if (ir->tx->c != NULL)
-			i2c_set_clientdata(ir->tx->c, NULL);
-		kfree(ir->tx);
-	}
+	if (ir->rx && ir->rx->buf.fifo_initialized)
+		lirc_buffer_free(&ir->rx->buf);
+
+	kfree(ir->rx);
+	kfree(ir->tx);
 out_free_ir:
 	del_ir_device(ir);
 	kfree(ir);
-- 
1.7.2.3

