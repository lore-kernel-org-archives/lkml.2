Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab2CSQLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:11:52 -0400
Received: from avalon.kleine-koenig.org ([78.46.226.219]:34917 "EHLO
	avalon.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab2CSQLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:11:50 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: [PATCH] block/drbd: simplify drbd_buildtag fixing a build warning
Date: Mon, 19 Mar 2012 17:11:27 +0100
Message-Id: <1332173487-14167-1-git-send-email-uwe@kleine-koenig.org>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes:
	drivers/block/drbd/drbd_main.c: In function ‘drbd_buildtag’:
	drivers/block/drbd/drbd_main.c:4187:24: warning: the comparison will always evaluate as ‘true’ for the address of ‘__this_module’ will never be NULL [-Waddress]

Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
---
 drivers/block/drbd/drbd_main.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 211fc44..9cc7178 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -4177,21 +4177,19 @@ _drbd_insert_fault(struct drbd_conf *mdev, unsigned int type)
 
 const char *drbd_buildtag(void)
 {
+#if IS_MODULE(CONFIG_BLK_DEV_DRBD)
 	/* DRBD built from external sources has here a reference to the
 	   git hash of the source code. */
 
-	static char buildtag[38] = "\0uilt-in";
+	static char buildtag[38] = "\0";
 
-	if (buildtag[0] == 0) {
-#ifdef CONFIG_MODULES
-		if (THIS_MODULE != NULL)
-			sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
-		else
-#endif
-			buildtag[0] = 'b';
-	}
+	if (buildtag[0] == '\0')
+		sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
 
 	return buildtag;
+#else
+	return "built-in";
+#endif
 }
 
 module_init(drbd_init)
-- 
1.7.9.1

