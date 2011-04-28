Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524Ab1D1PQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:16:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59953 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882Ab1D1PQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:16:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PtHoOr74+DivJzwd2nCxGuxDfcUxNL1oirxVNYteG5OpMRs6F5fdfUAWrKDjBuKxcw
         FVIMHiBR23fDZVmm5fTdGKFRSNGs2yLBqe0VJ4GclWX5H6mHE5k5c7Xfa4czkGat0y4B
         Zc8Lg1j7Wkp3a41Oweih833q5KwU7q+IyJcGs=
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: eric.y.miao@gmail.com, khali@linux-fr.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH 1/3] i2c: append hardware lock with bus lock
Date: Thu, 28 Apr 2011 23:15:44 +0800
Message-Id: <1304003746-12127-1-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <2011042801>
References: <2011042801>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both AP and CP are contained in Marvell PXA910 silicon. These two ARM
cores are sharing one pair of I2C pins.

In order to keep I2C transaction operated with atomic, hardware lock
(RIPC) is required. Because of this, bus lock in AP side can't afford
this requirement. Now hardware lock is appended.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>
---
 drivers/i2c/i2c-core.c |   22 ++++++++++++++++++----
 include/linux/i2c.h    |    3 +++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 045ba6e..132d46c 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -448,8 +448,11 @@ void i2c_lock_adapter(struct i2c_adapter *adapter)
 
 	if (parent)
 		i2c_lock_adapter(parent);
-	else
+	else {
 		rt_mutex_lock(&adapter->bus_lock);
+		if (adapter->hardware_lock)
+			adapter->hardware_lock(adapter);
+	}
 }
 EXPORT_SYMBOL_GPL(i2c_lock_adapter);
 
@@ -460,11 +463,19 @@ EXPORT_SYMBOL_GPL(i2c_lock_adapter);
 static int i2c_trylock_adapter(struct i2c_adapter *adapter)
 {
 	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
+	int ret = 0;
 
 	if (parent)
 		return i2c_trylock_adapter(parent);
-	else
-		return rt_mutex_trylock(&adapter->bus_lock);
+	else {
+		ret = rt_mutex_trylock(&adapter->bus_lock);
+		if (ret && adapter->hardware_trylock) {
+			ret = adapter->hardware_trylock(adapter);
+			if (!ret)
+				i2c_unlock_adapter(adapter);
+		}
+		return ret;
+	}
 }
 
 /**
@@ -477,8 +488,11 @@ void i2c_unlock_adapter(struct i2c_adapter *adapter)
 
 	if (parent)
 		i2c_unlock_adapter(parent);
-	else
+	else {
+		if (adapter->hardware_unlock)
+			adapter->hardware_unlock(adapter);
 		rt_mutex_unlock(&adapter->bus_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(i2c_unlock_adapter);
 
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 06a8d9c..f4ef5b0 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -361,6 +361,9 @@ struct i2c_adapter {
 
 	/* data fields that are valid for all devices	*/
 	struct rt_mutex bus_lock;
+	void (*hardware_lock)(struct i2c_adapter *);
+	void (*hardware_unlock)(struct i2c_adapter *);
+	int (*hardware_trylock)(struct i2c_adapter *);
 
 	int timeout;			/* in jiffies */
 	int retries;
-- 
1.7.1

