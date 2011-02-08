Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1BHLer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 06:34:47 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:10806 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab1BHLeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 06:34:46 -0500
Message-ID: <4D512A27.2030406@dsn.okisemi.com>
Date: Tue, 08 Feb 2011 20:33:59 +0900
From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: ML netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC: Tomoya Morinaga <tomoya-linux@dsn.okisemi.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] pch_gbe: Fix the issue which a driver locks when rx offload
 is set by ethtool
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver will be in a deadlock, When the rx offload is set by ethtool.
So, The pch_gbe_reinit_locked function was modified.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
---
 drivers/net/pch_gbe/pch_gbe_main.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/pch_gbe/pch_gbe_main.c b/drivers/net/pch_gbe/pch_gbe_main.c
index 3248313..0e6922f 100644
--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -520,7 +520,9 @@ static void pch_gbe_reset_task(struct work_struct *work)
 	struct pch_gbe_adapter *adapter;
 	adapter = container_of(work, struct pch_gbe_adapter, reset_task);
 
+	rtnl_lock();
 	pch_gbe_reinit_locked(adapter);
+	rtnl_unlock();
 }
 
 /**
@@ -531,12 +533,8 @@ void pch_gbe_reinit_locked(struct pch_gbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 
-	rtnl_lock();
-	if (netif_running(netdev)) {
-		pch_gbe_down(adapter);
-		pch_gbe_up(adapter);
-	}
-	rtnl_unlock();
+	pch_gbe_down(adapter);
+	pch_gbe_up(adapter);
 }
 
 /**
-- 
1.6.2.5
