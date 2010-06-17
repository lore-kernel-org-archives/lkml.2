Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab0FQMrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:47:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39830 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab0FQMrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wcxZiTRm/Pu14Rf7I+A8EBi7GZvXLGRl01I6WqIi6HW+q+qYU2xiroxfrQIhapsPi/
         vRv0oT0kFSNyoRV2zVQhCF/GTWdeHLf4iAIsVWj7R+w/GJ9G6VGHR5HnftiNAiFZv39a
         WD7ZAZwNdbSXny8MoqSImwdvS8iJ6tKzKf6i0=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, David Brownell <david-b@pacbell.net>
Subject: [PATCH] pcf857x: support working w/o platform data
Date: Thu, 17 Jun 2010 16:47:50 +0400
Message-Id: <1276778870-1065-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide sane defaults for pcf857x, so the driver can be used w/o
providing platform data (and thus can be simply bound via OF tree).

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/gpio/pcf857x.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/pcf857x.c b/drivers/gpio/pcf857x.c
index 29f19ce..879b473 100644
--- a/drivers/gpio/pcf857x.c
+++ b/drivers/gpio/pcf857x.c
@@ -190,7 +190,6 @@ static int pcf857x_probe(struct i2c_client *client,
 	pdata = client->dev.platform_data;
 	if (!pdata) {
 		dev_dbg(&client->dev, "no platform data\n");
-		return -EINVAL;
 	}
 
 	/* Allocate, initialize, and register this gpio_chip. */
@@ -200,7 +199,7 @@ static int pcf857x_probe(struct i2c_client *client,
 
 	mutex_init(&gpio->lock);
 
-	gpio->chip.base = pdata->gpio_base;
+	gpio->chip.base = pdata ? pdata->gpio_base : -1;
 	gpio->chip.can_sleep = 1;
 	gpio->chip.dev = &client->dev;
 	gpio->chip.owner = THIS_MODULE;
@@ -278,7 +277,7 @@ static int pcf857x_probe(struct i2c_client *client,
 	 * to zero, our software copy of the "latch" then matches the chip's
 	 * all-ones reset state.  Otherwise it flags pins to be driven low.
 	 */
-	gpio->out = ~pdata->n_latch;
+	gpio->out = pdata ? ~pdata->n_latch : ~0;
 
 	status = gpiochip_add(&gpio->chip);
 	if (status < 0)
@@ -299,7 +298,7 @@ static int pcf857x_probe(struct i2c_client *client,
 	/* Let platform code set up the GPIOs and their users.
 	 * Now is the first time anyone could use them.
 	 */
-	if (pdata->setup) {
+	if (pdata && pdata->setup) {
 		status = pdata->setup(client,
 				gpio->chip.base, gpio->chip.ngpio,
 				pdata->context);
@@ -322,7 +321,7 @@ static int pcf857x_remove(struct i2c_client *client)
 	struct pcf857x			*gpio = i2c_get_clientdata(client);
 	int				status = 0;
 
-	if (pdata->teardown) {
+	if (pdata && pdata->teardown) {
 		status = pdata->teardown(client,
 				gpio->chip.base, gpio->chip.ngpio,
 				pdata->context);
-- 
1.7.1

