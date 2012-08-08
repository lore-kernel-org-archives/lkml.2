Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2HHKe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:34:28 -0400
Received: from mail.ispras.ru ([83.149.199.43]:42702 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2HHKeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:34:24 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] net/core: Fix potential memory leak in dev_set_alias()
Date: Wed,  8 Aug 2012 14:33:25 +0400
Message-Id: <1344422005-21993-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not leak memory by updating pointer with potentially NULL realloc return value.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 net/core/dev.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0cb3fe8..3bcc5da 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1055,6 +1055,8 @@ rollback:
  */
 int dev_set_alias(struct net_device *dev, const char *alias, size_t len)
 {
+	char *new_ifalias;
+
 	ASSERT_RTNL();
 
 	if (len >= IFALIASZ)
@@ -1068,9 +1070,10 @@ int dev_set_alias(struct net_device *dev, const char *alias, size_t len)
 		return 0;
 	}
 
-	dev->ifalias = krealloc(dev->ifalias, len + 1, GFP_KERNEL);
-	if (!dev->ifalias)
+	new_ifalias = krealloc(dev->ifalias, len + 1, GFP_KERNEL);
+	if (!new_ifalias)
 		return -ENOMEM;
+	dev->ifalias = new_ifalias;
 
 	strlcpy(dev->ifalias, alias, len+1);
 	return len;
-- 
1.7.9.5

