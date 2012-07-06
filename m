Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab2GFWvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:51:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37471 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab2GFWve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:51:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org
Subject: [PATCH 12/12] mfd: wm831x: Feed the device UUID into device_add_randomness()
Date: Fri,  6 Jul 2012 18:45:04 -0400
Message-Id: <1341614704-24965-13-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341614704-24965-1-git-send-email-tytso@mit.edu>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

wm831x devices contain a unique ID value. Feed this into the newly added
device_add_randomness() to add some per device seed data to the pool.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 drivers/mfd/wm831x-otp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/wm831x-otp.c b/drivers/mfd/wm831x-otp.c
index f742745..b90f3e0 100644
--- a/drivers/mfd/wm831x-otp.c
+++ b/drivers/mfd/wm831x-otp.c
@@ -18,6 +18,7 @@
 #include <linux/bcd.h>
 #include <linux/delay.h>
 #include <linux/mfd/core.h>
+#include <linux/random.h>
 
 #include <linux/mfd/wm831x/core.h>
 #include <linux/mfd/wm831x/otp.h>
@@ -66,6 +67,7 @@ static DEVICE_ATTR(unique_id, 0444, wm831x_unique_id_show, NULL);
 
 int wm831x_otp_init(struct wm831x *wm831x)
 {
+	char uuid[WM831X_UNIQUE_ID_LEN];
 	int ret;
 
 	ret = device_create_file(wm831x->dev, &dev_attr_unique_id);
@@ -73,6 +75,12 @@ int wm831x_otp_init(struct wm831x *wm831x)
 		dev_err(wm831x->dev, "Unique ID attribute not created: %d\n",
 			ret);
 
+	ret = wm831x_unique_id_read(wm831x, uuid);
+	if (ret == 0)
+		add_device_randomness(uuid, sizeof(uuid));
+	else
+		dev_err(wm831x->dev, "Failed to read UUID: %d\n", ret);
+
 	return ret;
 }
 
-- 
1.7.11.1.108.gb129051

