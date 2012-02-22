Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2BVH6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 02:58:14 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44129 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab2BVH6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:58:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.243.144 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1329897485.27727.0.camel@phoenix>
Subject: [PATCH] mfd: Fix section mismatch warning in wm8994
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 22 Feb 2012 15:58:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 423682 "mfd: Add __devinit and __devexit annotations in wm8994",
we need to add __devinit/__devexit for wm8994_i2c_probe/wm8994_i2c_remove.
This fixes below build warnings:

WARNING: vmlinux.o(.text+0x169e44): Section mismatch in reference from the function wm8994_i2c_remove() to the function .devexit.text:wm8994_device_exit()
The function wm8994_i2c_remove() references a function in an exit section.
Often the function wm8994_device_exit() has valid usage outside the exit section
and the fix is to remove the __devexit annotation of wm8994_device_exit.

WARNING: vmlinux.o(.text+0x16a1bc): Section mismatch in reference from the function wm8994_i2c_probe() to the function .devinit.text:wm8994_device_init()
The function wm8994_i2c_probe() references
the function __devinit wm8994_device_init().
This is often because wm8994_i2c_probe lacks a __devinit
annotation or the annotation of wm8994_device_init is wrong.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/wm8994-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index b2de65b..0042c7c 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -670,7 +670,7 @@ static const struct of_device_id wm8994_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, wm8994_of_match);
 
-static int wm8994_i2c_probe(struct i2c_client *i2c,
+static __devinit int wm8994_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct wm8994 *wm8994;
@@ -696,7 +696,7 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	return wm8994_device_init(wm8994, i2c->irq);
 }
 
-static int wm8994_i2c_remove(struct i2c_client *i2c)
+static __devexit int wm8994_i2c_remove(struct i2c_client *i2c)
 {
 	struct wm8994 *wm8994 = i2c_get_clientdata(i2c);
 
@@ -725,7 +725,7 @@ static struct i2c_driver wm8994_i2c_driver = {
 		.of_match_table = wm8994_of_match,
 	},
 	.probe = wm8994_i2c_probe,
-	.remove = wm8994_i2c_remove,
+	.remove = __devexit_p(wm8994_i2c_remove),
 	.id_table = wm8994_i2c_id,
 };
 
-- 
1.7.5.4



