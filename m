Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab0IXQfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:35:16 -0400
Received: from kroah.org ([198.145.64.141]:37095 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953Ab0IXQfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:45 2010
Message-Id: <20100924163345.355303074@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [15/68] r8169: fix random mdio_write failures
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Timo Teräs <timo.teras@iki.fi>

[ Upstream commit 024a07bacf8287a6ddfa83e9d5b951c5e8b4070e ]

Some configurations need delay between the "write completed" indication
and new write to work reliably.

Realtek driver seems to use longer delay when polling the "write complete"
bit, so it waits long enough between writes with high probability (but
could probably break too). This patch adds a new udelay to make sure we
wait unconditionally some time after the write complete indication.

This caused a regression with XID 18000000 boards when the board specific
phy configuration writing many mdio registers was added in commit
2e955856ff (r8169: phy init for the 8169scd). Some of the configration
mdio writes would almost always fail, and depending on failure might leave
the PHY in non-working state.

Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Acked-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/r8169.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -557,6 +557,11 @@ static void mdio_write(void __iomem *ioa
 			break;
 		udelay(25);
 	}
+	/*
+	 * Some configurations require a small delay even after the write
+	 * completed indication or the next write might fail.
+	 */
+	udelay(25);
 }
 
 static int mdio_read(void __iomem *ioaddr, int reg_addr)


