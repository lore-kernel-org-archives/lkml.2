Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2J1QMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 12:12:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49019 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2J1QMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 12:12:15 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: davem@davemloft.net
Cc: srinivas.kandagatla@st.com, peter.senna@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/net/phy/mdio-bitbang.c: Call mdiobus_unregister before mdiobus_free
Date: Sun, 28 Oct 2012 17:12:01 +0100
Message-Id: <1351440721-9121-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351440721-9121-1-git-send-email-peter.senna@gmail.com>
References: <1351440721-9121-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on commit b27393aecf66199f5ddad37c302d3e0cfadbe6c0

Calling mdiobus_free without calling mdiobus_unregister causes
BUG_ON(). This patch fixes the issue.

The semantic patch that found this issue(http://coccinelle.lip6.fr/):
// <smpl>
@@
expression E;
@@
  ... when != mdiobus_unregister(E);

+ mdiobus_unregister(E);
  mdiobus_free(E);
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
This problem is somewhat mystifying. If the patch is correct, there were
probably many OOPSese caused by not calling mdiobus_unregister...
Reporting anyway...

 drivers/net/phy/mdio-bitbang.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
index daec9b0..6428fcb 100644
--- a/drivers/net/phy/mdio-bitbang.c
+++ b/drivers/net/phy/mdio-bitbang.c
@@ -234,6 +234,7 @@ void free_mdio_bitbang(struct mii_bus *bus)
 	struct mdiobb_ctrl *ctrl = bus->priv;
 
 	module_put(ctrl->ops->owner);
+	mdiobus_unregister(bus);
 	mdiobus_free(bus);
 }
 EXPORT_SYMBOL(free_mdio_bitbang);
-- 
1.7.11.7

