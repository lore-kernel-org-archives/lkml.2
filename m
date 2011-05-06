Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1EFMtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:49:53 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:38897 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878Ab1EFMtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:49:49 -0400
Message-ID: <4DC3EF64.9050305@dsn.okisemi.com>
Date: Fri, 06 May 2011 21:53:56 +0900
From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: ML netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC: Tomoya Morinaga <tomoya-linux@dsn.okisemi.com>,
        LKML <linux-kernel@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Subject: [PATCH 2/2] PCH_GbE : Fixed the issue of checksum judgment
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checksum judgment was mistaken.
  Judgment result
     0:Correct 1:Wrong

This patch fixes the issue.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
---
 drivers/net/pch_gbe/pch_gbe_main.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/pch_gbe/pch_gbe_main.c b/drivers/net/pch_gbe/pch_gbe_main.c
index babe663..6f10361 100644
--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -1494,12 +1494,11 @@ pch_gbe_clean_rx(struct pch_gbe_adapter *adapter,
 			/* Write meta date of skb */
 			skb_put(skb, length);
 			skb->protocol = eth_type_trans(skb, netdev);
-			if ((tcp_ip_status & PCH_GBE_RXD_ACC_STAT_TCPIPOK) ==
-			    PCH_GBE_RXD_ACC_STAT_TCPIPOK) {
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
-			} else {
+			if (tcp_ip_status & PCH_GBE_RXD_ACC_STAT_TCPIPOK)
 				skb->ip_summed = CHECKSUM_NONE;
-			}
+			else
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+
 			napi_gro_receive(&adapter->napi, skb);
 			(*work_done)++;
 			pr_debug("Receive skb->ip_summed: %d length: %d\n",
-- 
1.6.2.5
