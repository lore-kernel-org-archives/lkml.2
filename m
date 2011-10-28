Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1J1Mfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:35:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:32370 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721Ab1J1Mfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:35:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013538"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv6 03/19] usb: otg: Separate otg members from usb_phy
Date: Fri, 28 Oct 2011 15:35:09 +0300
Message-Id: <1319805325-24689-4-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing struct otg and collecting otg specific members
to it from struct usb_phy. There are no changes to
struct usb_phy at this stage. This also renames
transceiver specific functions, and offers aliases for the
old otg ones.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/otg/otg.c   |   18 ++++----
 include/linux/usb/otg.h |   96 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 88 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
index c6f2bed..5fcc020 100644
--- a/drivers/usb/otg/otg.c
+++ b/drivers/usb/otg/otg.c
@@ -17,7 +17,7 @@
 static struct usb_phy *xceiv;
 
 /**
- * otg_get_transceiver - find the (single) OTG transceiver
+ * usb_get_transceiver - find the (single) OTG transceiver
  *
  * Returns the transceiver driver, after getting a refcount to it; or
  * null if there is no such transceiver.  The caller is responsible for
@@ -25,45 +25,45 @@ static struct usb_phy *xceiv;
  *
  * For use by USB host and peripheral drivers.
  */
-struct usb_phy *otg_get_transceiver(void)
+struct usb_phy *usb_get_transceiver(void)
 {
 	if (xceiv)
 		get_device(xceiv->dev);
 	return xceiv;
 }
-EXPORT_SYMBOL(otg_get_transceiver);
+EXPORT_SYMBOL(usb_get_transceiver);
 
 /**
- * otg_put_transceiver - release the (single) OTG transceiver
+ * usb_put_transceiver - release the (single) OTG transceiver
  * @x: the transceiver returned by otg_get_transceiver()
  *
  * Releases a refcount the caller received from otg_get_transceiver().
  *
  * For use by USB host and peripheral drivers.
  */
-void otg_put_transceiver(struct usb_phy *x)
+void usb_put_transceiver(struct usb_phy *x)
 {
 	if (x)
 		put_device(x->dev);
 }
-EXPORT_SYMBOL(otg_put_transceiver);
+EXPORT_SYMBOL(usb_put_transceiver);
 
 /**
- * otg_set_transceiver - declare the (single) OTG transceiver
+ * usb_set_transceiver - declare the (single) OTG transceiver
  * @x: the USB OTG transceiver to be used; or NULL
  *
  * This call is exclusively for use by transceiver drivers, which
  * coordinate the activities of drivers for host and peripheral
  * controllers, and in some cases for VBUS current regulation.
  */
-int otg_set_transceiver(struct usb_phy *x)
+int usb_set_transceiver(struct usb_phy *x)
 {
 	if (xceiv && x)
 		return -EBUSY;
 	xceiv = x;
 	return 0;
 }
-EXPORT_SYMBOL(otg_set_transceiver);
+EXPORT_SYMBOL(usb_set_transceiver);
 
 const char *usb_phy_state_string(enum usb_phy_state state)
 {
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 926e04c..34dea9b 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -48,11 +48,36 @@ struct usb_phy;
 /* for transceivers connected thru an ULPI interface, the user must
  * provide access ops
  */
-struct otg_io_access_ops {
+struct usb_phy_io_ops {
 	int (*read)(struct usb_phy *x, u32 reg);
 	int (*write)(struct usb_phy *x, u32 val, u32 reg);
 };
 
+struct usb_otg {
+	u8			default_a;
+
+	struct usb_phy		*xceiv;
+	struct usb_bus		*host;
+	struct usb_gadget	*gadget;
+
+	/* bind/unbind the host controller */
+	int	(*set_host)(struct usb_otg *otg, struct usb_bus *host);
+
+	/* bind/unbind the peripheral controller */
+	int	(*set_peripheral)(struct usb_otg *otg,
+					struct usb_gadget *gadget);
+
+	/* effective for A-peripheral, ignored for B devices */
+	int	(*set_vbus)(struct usb_otg *otg, bool enabled);
+
+	/* for B devices only:  start session with A-Host */
+	int	(*start_srp)(struct usb_otg *otg);
+
+	/* start or continue HNP role switch */
+	int	(*start_hnp)(struct usb_otg *otg);
+
+};
+
 /*
  * the otg driver needs to interact with both device side and host side
  * usb controllers.  it decides which controller is active at a given
@@ -68,11 +93,13 @@ struct usb_phy {
 	enum usb_phy_state	state;
 	enum usb_phy_events	last_event;
 
+	struct usb_otg		*otg;
+
 	struct usb_bus		*host;
 	struct usb_gadget	*gadget;
 
-	struct otg_io_access_ops	*io_ops;
-	void __iomem			*io_priv;
+	struct usb_phy_io_ops	*io_ops;
+	void __iomem		*io_priv;
 
 	/* for notification of usb_phy_events */
 	struct atomic_notifier_head	notifier;
@@ -115,7 +142,7 @@ struct usb_phy {
 
 
 /* for board-specific init logic */
-extern int otg_set_transceiver(struct usb_phy *);
+extern int usb_set_transceiver(struct usb_phy *);
 
 #if defined(CONFIG_NOP_USB_XCEIV) || (defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
 /* sometimes transceivers are accessed only through e.g. ULPI */
@@ -132,7 +159,7 @@ static inline void usb_nop_xceiv_unregister(void)
 #endif
 
 /* helpers for direct access thru low-level io interface */
-static inline int otg_io_read(struct usb_phy *x, u32 reg)
+static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
 {
 	if (x->io_ops && x->io_ops->read)
 		return x->io_ops->read(x, reg);
@@ -140,7 +167,7 @@ static inline int otg_io_read(struct usb_phy *x, u32 reg)
 	return -EINVAL;
 }
 
-static inline int otg_io_write(struct usb_phy *x, u32 val, u32 reg)
+static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
 {
 	if (x->io_ops && x->io_ops->write)
 		return x->io_ops->write(x, val, reg);
@@ -149,7 +176,7 @@ static inline int otg_io_write(struct usb_phy *x, u32 val, u32 reg)
 }
 
 static inline int
-otg_init(struct usb_phy *x)
+usb_phy_init(struct usb_phy *x)
 {
 	if (x->init)
 		return x->init(x);
@@ -158,7 +185,7 @@ otg_init(struct usb_phy *x)
 }
 
 static inline void
-otg_shutdown(struct usb_phy *x)
+usb_phy_shutdown(struct usb_phy *x)
 {
 	if (x->shutdown)
 		x->shutdown(x);
@@ -166,16 +193,16 @@ otg_shutdown(struct usb_phy *x)
 
 /* for usb host and peripheral controller drivers */
 #ifdef CONFIG_USB_OTG_UTILS
-extern struct usb_phy *otg_get_transceiver(void);
-extern void otg_put_transceiver(struct usb_phy *);
+extern struct usb_phy *usb_get_transceiver(void);
+extern void usb_put_transceiver(struct usb_phy *);
 extern const char *usb_phy_state_string(enum usb_phy_state state);
 #else
-static inline struct usb_phy *otg_get_transceiver(void)
+static inline struct usb_phy *usb_get_transceiver(void)
 {
 	return NULL;
 }
 
-static inline void otg_put_transceiver(struct usb_phy *x)
+static inline void usb_put_transceiver(struct usb_phy *x)
 {
 }
 
@@ -189,6 +216,9 @@ static inline const char *usb_phy_state_string(enum usb_phy_state state)
 static inline int
 otg_start_hnp(struct usb_phy *x)
 {
+	if (x->otg && x->otg->start_hnp)
+		return x->otg->start_hnp(x->otg);
+
 	return x->start_hnp(x);
 }
 
@@ -196,6 +226,9 @@ otg_start_hnp(struct usb_phy *x)
 static inline int
 otg_set_vbus(struct usb_phy *x, bool enabled)
 {
+	if (x->otg && x->otg->set_vbus)
+		return x->otg->set_vbus(x->otg, enabled);
+
 	return x->set_vbus(x, enabled);
 }
 
@@ -203,6 +236,9 @@ otg_set_vbus(struct usb_phy *x, bool enabled)
 static inline int
 otg_set_host(struct usb_phy *x, struct usb_bus *host)
 {
+	if (x->otg && x->otg->set_host)
+		return x->otg->set_host(x->otg, host);
+
 	return x->set_host(x, host);
 }
 
@@ -212,18 +248,23 @@ otg_set_host(struct usb_phy *x, struct usb_bus *host)
 static inline int
 otg_set_peripheral(struct usb_phy *x, struct usb_gadget *periph)
 {
+	if (x->otg && x->otg->set_peripheral)
+		return x->otg->set_peripheral(x->otg, periph);
+
 	return x->set_peripheral(x, periph);
 }
 
 static inline int
-otg_set_power(struct usb_phy *x, unsigned mA)
+usb_phy_set_power(struct usb_phy *x, unsigned mA)
 {
-	return x->set_power(x, mA);
+	if (x && x->set_power)
+		return x->set_power(x, mA);
+	return 0;
 }
 
 /* Context: can sleep */
 static inline int
-otg_set_suspend(struct usb_phy *x, int suspend)
+usb_phy_set_suspend(struct usb_phy *x, int suspend)
 {
 	if (x->set_suspend != NULL)
 		return x->set_suspend(x, suspend);
@@ -234,18 +275,21 @@ otg_set_suspend(struct usb_phy *x, int suspend)
 static inline int
 otg_start_srp(struct usb_phy *x)
 {
+	if (x->otg && x->otg->start_srp)
+		return x->otg->start_srp(x->otg);
+
 	return x->start_srp(x);
 }
 
 /* notifiers */
 static inline int
-otg_register_notifier(struct usb_phy *x, struct notifier_block *nb)
+usb_register_notifier(struct usb_phy *x, struct notifier_block *nb)
 {
 	return atomic_notifier_chain_register(&x->notifier, nb);
 }
 
 static inline void
-otg_unregister_notifier(struct usb_phy *x, struct notifier_block *nb)
+usb_unregister_notifier(struct usb_phy *x, struct notifier_block *nb)
 {
 	atomic_notifier_chain_unregister(&x->notifier, nb);
 }
@@ -253,4 +297,22 @@ otg_unregister_notifier(struct usb_phy *x, struct notifier_block *nb)
 /* for OTG controller drivers (and maybe other stuff) */
 extern int usb_bus_start_enum(struct usb_bus *bus, unsigned port_num);
 
+/* Temporary aliases for transceiver functions */
+#define otg_set_transceiver(x) usb_set_transceiver(x)
+#define otg_get_transceiver() usb_get_transceiver()
+#define otg_put_transceiver(x) usb_put_transceiver(x)
+
+#define otg_io_read(x, a) usb_phy_io_read(x, a)
+#define otg_io_write(x, a, b) usb_phy_io_write(x, a, b)
+
+#define otg_init(x) usb_phy_init(x)
+#define otg_shutdown(x) usb_phy_shutdown(x)
+#define otg_set_power(x, a) usb_phy_set_power(x, a)
+#define otg_set_suspend(x, a) usb_phy_set_suspend(x, a)
+
+#define otg_register_notifier(x, a) usb_register_notifier(x, a)
+#define otg_unregister_notifier(x, a) usb_unregiser_notifier(x, a)
+
+#define otg_io_access_ops usb_phy_io_ops
+
 #endif /* __LINUX_USB_OTG_H */
-- 
1.7.4.1

