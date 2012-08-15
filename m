Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab2HOTzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:55:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:37441 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab2HOTxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:53:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 164/165] mfd: wm831x: Feed the device UUID into device_add_randomness()
Date: Wed, 15 Aug 2012 15:48:28 -0400
Message-ID: <1345060109-9187-165-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 27130f0cc3ab97560384da437e4621fc4e94f21c upstream.

wm831x devices contain a unique ID value. Feed this into the newly added
device_add_randomness() to add some per device seed data to the pool.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
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
1.7.12.rc2

