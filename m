Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab1BIINg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:13:36 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:41419 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab1BIINf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 03:13:35 -0500
Message-ID: <4D524C7F.1000700@dsn.okisemi.com>
Date: Wed, 09 Feb 2011 17:12:47 +0900
From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: ML netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC: LKML <linux-kernel@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        Tomoya Morinaga <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH v2] pch_gbe: Fix the issue which a driver locks when rx offload
 is set by ethtool
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Devid

I resubmit this patch that removed compiler warning.

Best regards
Toshiharu Okada(OKI semiconductor)
---
This driver will be in a deadlock, When the rx offload is set by ethtool.
The pch_gbe_reinit_locked function was modified.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
---
 drivers/net/pch_gbe/pch_gbe_main.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/pch_gbe/pch_gbe_main.c b/drivers/net/pch_gbe/pch_gbe_main.c
index 76a31b0..8ec48ad 100644
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
@@ -529,14 +531,8 @@ static void pch_gbe_reset_task(struct work_struct *work)
  */
 void pch_gbe_reinit_locked(struct pch_gbe_adapter *adapter)
 {
-	struct net_device *netdev = adapter->netdev;
-
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
