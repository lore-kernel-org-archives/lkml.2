Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab2F0GBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 02:01:21 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:47613 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2F0GBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 02:01:19 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmFGAFeg6k9V5qg+PGdsb2JhbABFihWsJBkBAQEBNzSCGAEBBAEnExwTAQ8FCwgDDgMDAQIvFCUKDA4TiAYJuVQUiyOFKmADlTGFZoNBiT4
X-IronPort-AV: E=Sophos;i="4.77,482,1336341600"; 
   d="scan'208";a="69678736"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 27 Jun 2012 08:04:38 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/21 v5] Input: atmel_mxt_ts - print all instances when
 dumping objects
Message-ID: <20120627060438.GA788@polaris.bitmath.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
 <1340693829-18665-10-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340693829-18665-10-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> For objects with multiple instances, dump them all, prepending each with
> its "Instance #".
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---

The number of nested for loops is in the red here... How about this
(untested) version instead?

Thanks,
Henrik

>From 7e1ae92ac21abb6215df7b0714ca809fb86116c3 Mon Sep 17 00:00:00 2001
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Tue, 26 Jun 2012 14:56:57 +0800
Subject: [PATCH] Input: atmel_mxt_ts - print all instances when dumping
 objects

For objects with multiple instances, dump them all, prepending each with
its "Instance #".

[rydberg@euromail.se: break out mxt_print_instance()]
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 36 +++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index c8cfd7b..5609372 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -877,6 +877,25 @@ static void mxt_calc_resolution(struct mxt_data *data)
 	}
 }
 
+static int mxt_print_instance(char *buf, int count,
+			      struct mxt_object *object, int i,
+			      const u8 *val)
+{
+	int j;
+
+	if (object->instances > 0)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "Instance %u\n", i);
+
+	for (j = 0; j < object->size + 1; j++)
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "\t[%2u]: %02x (%d)\n", j, val[j], val[j]);
+
+	count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
+
+	return count;
+}
+
 static ssize_t mxt_object_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
@@ -885,7 +904,6 @@ static ssize_t mxt_object_show(struct device *dev,
 	int count = 0;
 	int i, j;
 	int error;
-	u8 val;
 	u8 *obuf;
 
 	/* Pre-allocate buffer large enough to hold max sized object. */
@@ -903,18 +921,16 @@ static ssize_t mxt_object_show(struct device *dev,
 		count += scnprintf(buf + count, PAGE_SIZE - count,
 				"T%u:\n", object->type);
 
-		error = __mxt_read_reg(data->client, object->start_address,
-				object->size + 1, obuf);
-		if (error)
-			break;
+		for (j = 0; j < object->instances + 1; j++) {
+			u16 size = object->size + 1;
+			u16 addr = object->start_address + j * size;
 
-		for (j = 0; j < object->size + 1; j++) {
-			val = obuf[j];
+			error = __mxt_read_reg(data->client, addr, size, obuf);
+			if (error)
+				break;
 
-			count += scnprintf(buf + count, PAGE_SIZE - count,
-					"\t[%2d]: %02x (%d)\n", j, val, val);
+			count = mxt_print_instance(buf, count, object, j, obuf);
 		}
-		count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
 	}
 
 	kfree(obuf);
-- 
1.7.11

