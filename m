Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab1DLO4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:56:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13793 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab1DLO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:56:18 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: Samuel Ortiz <sameo@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] mfd: fix tps6586x GPIO value setting
Date: Tue, 12 Apr 2011 10:55:58 -0400
Message-Id: <1302620158-6298-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code, every time we set a TPS6586x GPIO pin,
the tps6586x_gpio_set function is resetting all other GPIO pins.
We need to update the right GPIOxOUT bit of the GPIOSET2 register instead
of overriding the full value.

Tested by setting sequentially GPIO2 and GPIO3 and verifying the
pins voltage.

Change-Id: I560edde146c5425cce37432c4ee91569eea5adcf
Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 drivers/mfd/tps6586x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index b600808..bba26d9 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -270,8 +270,8 @@ static void tps6586x_gpio_set(struct gpio_chip *chip, unsigned offset,
 {
 	struct tps6586x *tps6586x = container_of(chip, struct tps6586x, gpio);
 
-	__tps6586x_write(tps6586x->client, TPS6586X_GPIOSET2,
-			 value << offset);
+	tps6586x_update(tps6586x->dev, TPS6586X_GPIOSET2,
+			value << offset, 1 << offset);
 }
 
 static int tps6586x_gpio_output(struct gpio_chip *gc, unsigned offset,
-- 
1.7.3.1

