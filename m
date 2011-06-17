Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab1FQQ5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:57:02 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:56031 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab1FQQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:56:59 -0400
X-Greylist: delayed 1926 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jun 2011 12:56:58 EDT
From: Pavel Shved <shved@ispras.ru>
Cc: Pavel Shved <shved@ispras.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] farsync: add module_put to error path in fst_open()
Date: Fri, 17 Jun 2011 20:25:10 +0400
Message-Id: <1308327913-23220-1-git-send-email-shved@ispras.ru>
X-Mailer: git-send-email 1.7.0.2
To: Kevin Curtis <kevin.curtis@farsite.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fst_open() function, after a successful try_module_get() may return
an error code if hdlc_open() returns it.  However, it does not put the
module on this error path.

This patch adds the necessary module_put() call.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Pavel Shved <shved@ispras.ru>
---
 drivers/net/wan/farsync.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index e050bd6..777d1a4 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -2203,8 +2203,10 @@ fst_open(struct net_device *dev)
 
 	if (port->mode != FST_RAW) {
 		err = hdlc_open(dev);
-		if (err)
+		if (err) {
+			module_put(THIS_MODULE);
 			return err;
+		}
 	}
 
 	fst_openport(port);
-- 
1.7.0.2

