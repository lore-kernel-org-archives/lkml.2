Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2HMWFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:05:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61572 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2HMWE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:04:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [ 30/44] mfd: wm831x: Feed the device UUID into device_add_randomness()
Date: Mon, 13 Aug 2012 15:02:37 -0700
Message-Id: <20120813220144.799381802@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 27130f0cc3ab97560384da437e4621fc4e94f21c upstream.

wm831x devices contain a unique ID value. Feed this into the newly added
device_add_randomness() to add some per device seed data to the pool.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/wm831x-otp.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mfd/wm831x-otp.c
+++ b/drivers/mfd/wm831x-otp.c
@@ -18,6 +18,7 @@
 #include <linux/bcd.h>
 #include <linux/delay.h>
 #include <linux/mfd/core.h>
+#include <linux/random.h>
 
 #include <linux/mfd/wm831x/core.h>
 #include <linux/mfd/wm831x/otp.h>
@@ -66,6 +67,7 @@ static DEVICE_ATTR(unique_id, 0444, wm83
 
 int wm831x_otp_init(struct wm831x *wm831x)
 {
+	char uuid[WM831X_UNIQUE_ID_LEN];
 	int ret;
 
 	ret = device_create_file(wm831x->dev, &dev_attr_unique_id);
@@ -73,6 +75,12 @@ int wm831x_otp_init(struct wm831x *wm831
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
 


