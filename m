Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0IZJ6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:58:42 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59803 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab0IZJ6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:58:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AVhcoebT437YSwT9FE/6d4xRIt9i/YmVCYTiUk8stSP6/XblkQKmRLcyD/vgnVTNrF
         YFKiKuTNRi2dHxxFrr7CoNgG2s/n0Ms78UEDYjz0UmPu4KV62XlQjA3CgXCgX2iLCyLk
         8XLcYatXVX4ctI0PGRhTi7JwaLRsamca3gfEE=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Henk de Groot <pe1dnn@amsat.org>,
        Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] staging: wlags49_h2: use free_netdev(netdev) instead of kfree()
Date: Sun, 26 Sep 2010 13:58:31 +0400
Message-Id: <1285495111-22238-1-git-send-email-segooon@gmail.com>
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

 drivers/staging/wlags49_h2/wl_netdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index e2a7ad0..954bece 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -1586,7 +1586,7 @@ void wl_wds_device_dealloc( struct wl_private *lp )
                 dev_wds->flags &= ~( IFF_UP | IFF_RUNNING );
             }
 
-            kfree( dev_wds );
+            free_netdev(dev_wds);
             lp->wds_port[count].dev = NULL;
         }
     }
-- 
1.7.0.4

