Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab0IZJ6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:58:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61634 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab0IZJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LZgoBvu231jOG4U6vpT7/G90WzHCLg9Li5ZIzYg7FhIBhzVpLIL728M8pMpffCSBOr
         cttLYmKHKILzGgvnmsLxljoylDHn80Jn9mV3kD+rxnvq/iNq+d7PWo4Gt5vVOxK5MZVM
         RSP2Gkn47jgzEuULbtpzW27VysLcYODCQ2xmo=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        Jeff Mahoney <jeffm@suse.com>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] staging: otus: use free_netdev(netdev) instead of kfree()
Date: Sun, 26 Sep 2010 13:58:25 +0400
Message-Id: <1285495105-22154-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freeing netdev without free_netdev() leads to net, tx leaks.
I might lead to dereferencing freed pointer.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

@@
struct net_device* dev;
@@

-kfree(dev)
+free_netdev(dev)
---
 Compile tested.

 drivers/staging/otus/usbdrv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/otus/usbdrv.c b/drivers/staging/otus/usbdrv.c
index 165a82b..9a5c415 100644
--- a/drivers/staging/otus/usbdrv.c
+++ b/drivers/staging/otus/usbdrv.c
@@ -690,7 +690,7 @@ void usbdrv_clear_structs(struct net_device *dev)
 
     kfree(macp);
 
-    kfree(dev);
+    free_netdev(dev);
 
 }
 
-- 
1.7.0.4

