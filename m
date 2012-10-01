Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab2JAXCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:02:03 -0400
Received: from 1wt.eu ([62.212.114.60]:35470 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054Ab2JAXB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:58 -0400
Message-Id: <20121001225205.201628712@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Theodore Tso <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 179/180] mfd: wm831x: Feed the device UUID into device_add_randomness()
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 27130f0cc3ab97560384da437e4621fc4e94f21c upstream.

wm831x devices contain a unique ID value. Feed this into the newly added
device_add_randomness() to add some per device seed data to the pool.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/mfd/wm831x-otp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

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
1.7.2.1.45.g54fbc



