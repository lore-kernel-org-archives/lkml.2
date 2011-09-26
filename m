Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1IZLXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:23:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:11072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab1IZLW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:22:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56486184"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCHv5 18/19] usb: otg: Remove OTG specific members from usb_phy
Date: Mon, 26 Sep 2011 14:21:31 +0300
Message-Id: <1317036092-3000-19-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the drivers are now converted to use struct usb_otg, so
removing the OTG specific members from struct usb_phy.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 include/linux/usb/otg.h |   50 ++++------------------------------------------
 1 files changed, 5 insertions(+), 45 deletions(-)

diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 34dea9b..ff47067 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -89,15 +89,11 @@ struct usb_phy {
 	const char		*label;
 	unsigned int		 flags;
 
-	u8			default_a;
 	enum usb_phy_state	state;
 	enum usb_phy_events	last_event;
 
 	struct usb_otg		*otg;
 
-	struct usb_bus		*host;
-	struct usb_gadget	*gadget;
-
 	struct usb_phy_io_ops	*io_ops;
 	void __iomem		*io_priv;
 
@@ -112,32 +108,14 @@ struct usb_phy {
 	int	(*init)(struct usb_phy *x);
 	void	(*shutdown)(struct usb_phy *x);
 
-	/* bind/unbind the host controller */
-	int	(*set_host)(struct usb_phy *x,
-				struct usb_bus *host);
-
-	/* bind/unbind the peripheral controller */
-	int	(*set_peripheral)(struct usb_phy *x,
-				struct usb_gadget *gadget);
-
 	/* effective for B devices, ignored for A-peripheral */
 	int	(*set_power)(struct usb_phy *x,
 				unsigned mA);
 
-	/* effective for A-peripheral, ignored for B devices */
-	int	(*set_vbus)(struct usb_phy *x,
-				bool enabled);
-
 	/* for non-OTG B devices: set transceiver into suspend mode */
 	int	(*set_suspend)(struct usb_phy *x,
 				int suspend);
 
-	/* for B devices only:  start session with A-Host */
-	int	(*start_srp)(struct usb_phy *x);
-
-	/* start or continue HNP role switch */
-	int	(*start_hnp)(struct usb_phy *x);
-
 };
 
 
@@ -219,7 +197,7 @@ otg_start_hnp(struct usb_phy *x)
 	if (x->otg && x->otg->start_hnp)
 		return x->otg->start_hnp(x->otg);
 
-	return x->start_hnp(x);
+	return -ENOTSUPP;
 }
 
 /* Context: can sleep */
@@ -229,7 +207,7 @@ otg_set_vbus(struct usb_phy *x, bool enabled)
 	if (x->otg && x->otg->set_vbus)
 		return x->otg->set_vbus(x->otg, enabled);
 
-	return x->set_vbus(x, enabled);
+	return -ENOTSUPP;
 }
 
 /* for HCDs */
@@ -239,7 +217,7 @@ otg_set_host(struct usb_phy *x, struct usb_bus *host)
 	if (x->otg && x->otg->set_host)
 		return x->otg->set_host(x->otg, host);
 
-	return x->set_host(x, host);
+	return -ENOTSUPP;
 }
 
 /* for usb peripheral controller drivers */
@@ -251,7 +229,7 @@ otg_set_peripheral(struct usb_phy *x, struct usb_gadget *periph)
 	if (x->otg && x->otg->set_peripheral)
 		return x->otg->set_peripheral(x->otg, periph);
 
-	return x->set_peripheral(x, periph);
+	return -ENOTSUPP;
 }
 
 static inline int
@@ -278,7 +256,7 @@ otg_start_srp(struct usb_phy *x)
 	if (x->otg && x->otg->start_srp)
 		return x->otg->start_srp(x->otg);
 
-	return x->start_srp(x);
+	return -ENOTSUPP;
 }
 
 /* notifiers */
@@ -297,22 +275,4 @@ usb_unregister_notifier(struct usb_phy *x, struct notifier_block *nb)
 /* for OTG controller drivers (and maybe other stuff) */
 extern int usb_bus_start_enum(struct usb_bus *bus, unsigned port_num);
 
-/* Temporary aliases for transceiver functions */
-#define otg_set_transceiver(x) usb_set_transceiver(x)
-#define otg_get_transceiver() usb_get_transceiver()
-#define otg_put_transceiver(x) usb_put_transceiver(x)
-
-#define otg_io_read(x, a) usb_phy_io_read(x, a)
-#define otg_io_write(x, a, b) usb_phy_io_write(x, a, b)
-
-#define otg_init(x) usb_phy_init(x)
-#define otg_shutdown(x) usb_phy_shutdown(x)
-#define otg_set_power(x, a) usb_phy_set_power(x, a)
-#define otg_set_suspend(x, a) usb_phy_set_suspend(x, a)
-
-#define otg_register_notifier(x, a) usb_register_notifier(x, a)
-#define otg_unregister_notifier(x, a) usb_unregiser_notifier(x, a)
-
-#define otg_io_access_ops usb_phy_io_ops
-
 #endif /* __LINUX_USB_OTG_H */
-- 
1.7.4.1

