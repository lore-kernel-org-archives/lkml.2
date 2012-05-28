Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab2E1DdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:33:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52162 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab2E1D3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:50 -0400
Message-Id: <20120528031217.060562005@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 103/117] ethtool: Null-terminate filename passed to ethtool_ops::flash_device
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit 786f528119722f564a22ad953411374e06116333 upstream.

The parameters for ETHTOOL_FLASHDEV include a filename, which ought to
be null-terminated.  Currently the only driver that implements
ethtool_ops::flash_device attempts to add a null terminator if
necessary, but does it wrongly.  Do it in the ethtool core instead.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/emulex/benet/be_ethtool.c |    6 +-----
 net/core/ethtool.c                             |    2 ++
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 6db6b6a..802e5dd 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -716,12 +716,8 @@ static int
 be_do_flash(struct net_device *netdev, struct ethtool_flash *efl)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
-	char file_name[ETHTOOL_FLASH_MAX_FILENAME];
 
-	file_name[ETHTOOL_FLASH_MAX_FILENAME - 1] = 0;
-	strcpy(file_name, efl->data);
-
-	return be_load_fw(adapter, file_name);
+	return be_load_fw(adapter, efl->data);
 }
 
 static int
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 369b418..3f79db1 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1190,6 +1190,8 @@ static noinline_for_stack int ethtool_flash_device(struct net_device *dev,
 	if (!dev->ethtool_ops->flash_device)
 		return -EOPNOTSUPP;
 
+	efl.data[ETHTOOL_FLASH_MAX_FILENAME - 1] = 0;
+
 	return dev->ethtool_ops->flash_device(dev, &efl);
 }
 


