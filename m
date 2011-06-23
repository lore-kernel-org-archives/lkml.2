Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab1FWR37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:29:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:65255 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab1FWR3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:29:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 055/247] i2c: Unregister dummy devices last on adapter removal
Date: Thu, 23 Jun 2011 13:25:54 -0400
Message-Id: <1308850146-15061-14-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5219bf884b6e2b54e734ca1799b6f0014bb2b4b7 upstream.

Remove real devices first and dummy devices last. This gives device
driver which instantiated dummy devices themselves a chance to clean
them up before we do.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/i2c/i2c-core.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index c2258a5..b67109c 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -837,6 +837,14 @@ static int i2c_do_del_adapter(struct i2c_driver *driver,
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
@@ -891,8 +899,12 @@ int i2c_del_adapter(struct i2c_adapter *adap)
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
-- 
1.7.4.4

