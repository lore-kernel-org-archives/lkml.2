Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab2EIGdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:33:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38677 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720Ab2EIFwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:42 -0400
Message-Id: <20120509055031.816478498@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Christian Riesch <christian.riesch@omicron.at>,
        Cyril Chemparathy <cyril@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 016/167] [PATCH] davinci_mdio: Fix MDIO timeout check
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Riesch <christian.riesch@omicron.at>

commit 5b76d0600b2b08eef77f8e9226938b7b6bde3099 upstream.

Under heavy load (flood ping) it is possible for the MDIO timeout to
expire before the loop checks the GO bit again. This patch adds an
additional check whether the operation was done before actually
returning -ETIMEDOUT.

To reproduce this bug, flood ping the device, e.g., ping -f -l 1000
After some time, a "timed out waiting for user access" warning
may appear. And even worse, link may go down since the PHY reported a
timeout.

Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
Cc: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/ti/davinci_mdio.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 2757c7d..e4e4708 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -181,6 +181,11 @@ static inline int wait_for_user_access(struct davinci_mdio_data *data)
 		__davinci_mdio_reset(data);
 		return -EAGAIN;
 	}
+
+	reg = __raw_readl(&regs->user[0].access);
+	if ((reg & USERACCESS_GO) == 0)
+		return 0;
+
 	dev_err(data->dev, "timed out waiting for user access\n");
 	return -ETIMEDOUT;
 }
-- 
1.7.10



