Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab1C3VGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:65216 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228Ab1C3VGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132942"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: khali@linux-fr.org, ak@linux.intel.com, hverkuil@xs4all.nl, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [59/275] i2c: Unregister dummy devices last on adapter removal
Message-Id: <20110330210455.C7B1F3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit 5219bf884b6e2b54e734ca1799b6f0014bb2b4b7 upstream.

Remove real devices first and dummy devices last. This gives device
driver which instantiated dummy devices themselves a chance to clean
them up before we do.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/i2c-core.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/i2c/i2c-core.c
===================================================================
--- linux-2.6.35.y.orig/drivers/i2c/i2c-core.c	2011-03-29 22:51:46.201540988 -0700
+++ linux-2.6.35.y/drivers/i2c/i2c-core.c	2011-03-29 23:02:59.377316103 -0700
@@ -923,6 +923,14 @@
 static int __unregister_client(struct device *dev, void *dummy)
 {
 	struct i2c_client *client = i2c_verify_client(dev);
+	if (client && strcmp(client->name, "dummy"))
+		i2c_unregister_device(client);
+	return 0;
+}
+
+static int __unregister_dummy(struct device *dev, void *dummy)
+{
+	struct i2c_client *client = i2c_verify_client(dev);
 	if (client)
 		i2c_unregister_device(client);
 	return 0;
@@ -977,8 +985,12 @@
 	i2c_unlock_adapter(adap);
 
 	/* Detach any active clients. This can't fail, thus we do not
-	   checking the returned value. */
+	 * check the returned value. This is a two-pass process, because
+	 * we can't remove the dummy devices during the first pass: they
+	 * could have been instantiated by real devices wishing to clean
+	 * them up properly, so we give them a chance to do that first. */
 	res = device_for_each_child(&adap->dev, NULL, __unregister_client);
+	res = device_for_each_child(&adap->dev, NULL, __unregister_dummy);
 
 #ifdef CONFIG_I2C_COMPAT
 	class_compat_remove_link(i2c_adapter_compat_class, &adap->dev,
