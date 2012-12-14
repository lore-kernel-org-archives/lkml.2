Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2LNLDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:03:14 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:58515 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab2LNLDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:03:09 -0500
Subject: [PATCH 10/12] mac802154: fix destructon ordering for ieee802154
 devices
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, netdev@vger.kernel.org,
        Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net
Date: Fri, 14 Dec 2012 15:03:03 +0400
Message-ID: <20121214110303.11019.41133.stgit@zurg>
In-Reply-To: <20121214110229.11019.63713.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mutex_destroy() must be called before wpan_phy_free(), because it puts the last
reference and frees memory. Catched as overwritten poison in kmalloc-2048.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org
---
 net/mac802154/ieee802154_dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac802154/ieee802154_dev.c b/net/mac802154/ieee802154_dev.c
index e748aed..b7c7f81 100644
--- a/net/mac802154/ieee802154_dev.c
+++ b/net/mac802154/ieee802154_dev.c
@@ -224,9 +224,9 @@ void ieee802154_free_device(struct ieee802154_dev *hw)
 
 	BUG_ON(!list_empty(&priv->slaves));
 
-	wpan_phy_free(priv->phy);
-
 	mutex_destroy(&priv->slaves_mtx);
+
+	wpan_phy_free(priv->phy);
 }
 EXPORT_SYMBOL(ieee802154_free_device);
 

