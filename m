Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030426Ab2K3NSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:18:43 -0500
Received: from netconsequence.de ([85.214.40.104]:37776 "EHLO
	mx.netconsequence.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632Ab2K3NSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:18:41 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 08:18:41 EST
From: Peter Turczak <pt@netconsequence.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] smsc: RFC: Workaround for problems with lan8710 phy auto MDI-X
Message-Id: <8D7E9026-6276-452B-9E0C-AEB8CF38C9FD@netconsequence.de>
Date: Fri, 30 Nov 2012 14:11:19 +0100
To: David Miller <davem@davemloft.net>,
        "Otavio Salvador" <otavio@ossystems.com.br>,
        "Javier Martinez Canillas" <javier@dowhile0.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Christian Hohnstaedt" <chohnstaedt@innominate.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

while debugging network outages on a customers hardware I found, that the MDI-X function of the lan8710 phy seemed to cause trouble.
When connecting to almost any kind of 100/1000MBit switch, the link would seem to come up and data where sent out to the network. But all incoming packets got lost somehow. This is quite bad, as the system runs from nfsroot while booting up during development.

When I disabled the auto MDI-X function of the phy the problem went away.

Signed-off-by: Peter Turczak <pt@netconsequence.de>
---
 drivers/net/phy/Kconfig |   10 ++++++++++
 drivers/net/phy/smsc.c  |   15 +++++++++++++++
 include/linux/smscphy.h |    5 +++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 961f0b2..341f5aa 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -60,6 +60,16 @@ config SMSC_PHY
 	---help---
 	  Currently supports the LAN83C185, LAN8187 and LAN8700 PHYs
 
+config SMSC_PHY_DISABLE_AUTOX
+	bool "Disable MDI-X upon start"
+	depends on SMSC_PHY
+	---help---
+	  When you experience problems estabishing a stable connection
+	  to a network and you have e.g. a LAN8710 ethernet phy
+	  this option might help you out.
+
+	  In doubt, say N
+
 config BROADCOM_PHY
 	tristate "Drivers for Broadcom PHYs"
 	---help---
diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 88e3991..651f71e 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -24,6 +24,8 @@
 #include <linux/netdevice.h>
 #include <linux/smscphy.h>
 
+static struct phy_driver lan8710_driver;
+
 static int smsc_phy_config_intr(struct phy_device *phydev)
 {
 	int rc = phy_write (phydev, MII_LAN83C185_IM,
@@ -53,6 +55,19 @@ static int smsc_phy_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+#ifdef CONFIG_SMSC_PHY_DISABLE_AUTOX
+	if (phydev->drv == &lan8710_driver) {
+		rc = phy_read(phydev, MII_LAN8710_SCSI);
+		if (rc < 0)
+			return rc;
+		rc = phy_write(phydev, MII_LAN8710_SCSI,
+			rc | MII_LAN8710_SCSI_AMDIXCTRL);
+
+		if (rc < 0)
+			return rc;
+	}
+#endif
+
 	return smsc_phy_ack_interrupt (phydev);
 }
 
diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
index ce718cb..4084b64 100644
--- a/include/linux/smscphy.h
+++ b/include/linux/smscphy.h
@@ -22,4 +22,9 @@
 #define MII_LAN83C185_EDPWRDOWN (1 << 13) /* EDPWRDOWN */
 #define MII_LAN83C185_ENERGYON  (1 << 1)  /* ENERGYON */
 
+#define MII_LAN8710_SCSI  27 /* Special Control/Status register */
+
+#define MII_LAN8710_SCSI_AMDIXCTRL (1<<15) /* Flag to disable Auto-MDIX */
+
+
 #endif /* __LINUX_SMSCPHY_H__ */
-- 
1.7.0.4


