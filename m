Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1F0WR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:17:27 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:49044 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab1F0WPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:15:40 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/4] um: Add netpoll support
Date: Tue, 28 Jun 2011 00:15:29 +0200
Message-Id: <1309212931-19772-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309212931-19772-1-git-send-email-richard@nod.at>
References: <1309212931-19772-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make netconsole usable on UML, it's ethernet driver
needs netpoll support.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/net_kern.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 47d0c37..22745b4 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -262,6 +262,15 @@ static int uml_net_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
+#ifdef CONFIG_NET_POLL_CONTROLLER
+static void uml_net_poll_controller(struct net_device *dev)
+{
+	disable_irq(dev->irq);
+	uml_net_interrupt(dev->irq, dev);
+	enable_irq(dev->irq);
+}
+#endif
+
 static void uml_net_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
 {
@@ -364,6 +373,9 @@ static const struct net_device_ops uml_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_change_mtu 	= uml_net_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	.ndo_poll_controller = uml_net_poll_controller,
+#endif
 };
 
 /*
-- 
1.7.5.4

