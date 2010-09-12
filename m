Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab0ILS4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:56:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41655 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0ILS4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sAH3Sp+Xw/3FhEZtEGnhVrx2Kugdi44bKCMpc96EG6+vgdIHtzi/M8DGHJ3DGNIxvi
         ya6wSqCvKl6Rnom1byiBLUhExgsNPUhkNAG8dy1GUD4OnN5caznCujJ1PcHPbRWK2sUh
         V+tlscHDXtM2fwF4ySK8IDs3yvi59ckK2zKog=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jason Wong <tsanghan@gmail.com>,
        Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Julia Lawall <julia@diku.dk>, Jiri Kosina <jkosina@suse.cz>,
        Morgan Gatti <morgan.gatti@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: fix signess bug
Date: Sun, 12 Sep 2010 22:56:35 +0400
Message-Id: <1284317799-4804-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ai_count and ao_counter are unsigned, check for < 0 doesn't make sense.
Cast them to int.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/staging/comedi/drivers/cb_pcidas64.c |    2 +-
 drivers/staging/comedi/drivers/usbdux.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 9b1dd3c..2583e16 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -3078,7 +3078,7 @@ static void handle_ai_interrupt(struct comedi_device *dev,
 			spin_unlock_irqrestore(&dev->spinlock, flags);
 	}
 	/*  if we are have all the data, then quit */
-	if ((cmd->stop_src == TRIG_COUNT && priv(dev)->ai_count <= 0) ||
+	if ((cmd->stop_src == TRIG_COUNT && (int)priv(dev)->ai_count <= 0) ||
 	    (cmd->stop_src == TRIG_EXT && (status & ADC_STOP_BIT))) {
 		async->events |= COMEDI_CB_EOA;
 	}
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 4b320b1..6131e2d 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -649,7 +649,7 @@ static void usbduxsub_ao_IsocIrq(struct urb *urb)
 
 	/* normal operation: executing a command in this subdevice */
 	this_usbduxsub->ao_counter--;
-	if (this_usbduxsub->ao_counter <= 0) {
+	if ((int)this_usbduxsub->ao_counter <= 0) {
 		/* timer zero */
 		this_usbduxsub->ao_counter = this_usbduxsub->ao_timer;
 
-- 
1.7.0.4

