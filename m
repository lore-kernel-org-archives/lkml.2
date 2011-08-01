Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1HAVAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:00:48 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48635 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1HAVAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:00:41 -0400
X-Auth-Info: c/O9833IBM1xikHehqS4WZ/AvoXgnUSTjMV/iYD63+g=
From: Ilya Yanok <yanok@emcraft.com>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Cc: Ilya Yanok <yanok@emcraft.com>
Subject: [PATCH] twl-core: fix oops while calling twl_i2c_* for unbound driver
Date: Mon,  1 Aug 2011 23:00:28 +0200
Message-Id: <1312232428-31001-1-git-send-email-yanok@emcraft.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check inuse variable before trying to access twl_map to prevent
dereferencing of uninitialized variable.

Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 drivers/mfd/twl-core.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 01ecfee..c7bc222 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -362,13 +362,13 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
-	sid = twl_map[mod_no].sid;
-	twl = &twl_modules[sid];
-
 	if (unlikely(!inuse)) {
-		pr_err("%s: client %d is not initialized\n", DRIVER_NAME, sid);
+		pr_err("%s: not initialized\n", DRIVER_NAME);
 		return -EPERM;
 	}
+	sid = twl_map[mod_no].sid;
+	twl = &twl_modules[sid];
+
 	mutex_lock(&twl->xfer_lock);
 	/*
 	 * [MSG1]: fill the register address data
@@ -419,13 +419,13 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
-	sid = twl_map[mod_no].sid;
-	twl = &twl_modules[sid];
-
 	if (unlikely(!inuse)) {
-		pr_err("%s: client %d is not initialized\n", DRIVER_NAME, sid);
+		pr_err("%s: not initialized\n", DRIVER_NAME);
 		return -EPERM;
 	}
+	sid = twl_map[mod_no].sid;
+	twl = &twl_modules[sid];
+
 	mutex_lock(&twl->xfer_lock);
 	/* [MSG1] fill the register address data */
 	msg = &twl->xfer_msg[0];
-- 
1.7.6

