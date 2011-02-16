Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab1BPBFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:05:42 -0500
Received: from kroah.org ([198.145.64.141]:45863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185Ab1BPAuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:09 2011
Message-Id: <20110216002109.686755666@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>
Subject: [patch 106/176] i2c: Unregister dummy devices last on adapter removal
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 5219bf884b6e2b54e734ca1799b6f0014bb2b4b7 upstream.

Remove real devices first and dummy devices last. This gives device
driver which instantiated dummy devices themselves a chance to clean
them up before we do.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/i2c-core.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1005,6 +1005,14 @@ static int i2c_do_del_adapter(struct i2c
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
@@ -1059,8 +1067,12 @@ int i2c_del_adapter(struct i2c_adapter *
 	mutex_unlock(&adap->userspace_clients_lock);
 
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


