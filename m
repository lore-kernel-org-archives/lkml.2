Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2DXWfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:35:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab2DXWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:34:59 -0400
Message-Id: <20120424223243.791979022@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Christian Riesch <christian.riesch@omicron.at>,
        Cyril Chemparathy <cyril@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 21/62] davinci_mdio: Fix MDIO timeout check
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ti/davinci_mdio.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -181,6 +181,11 @@ static inline int wait_for_user_access(s
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


