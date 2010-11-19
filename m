Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0KSWNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:13:30 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13838 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab0KSWN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:13:26 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>, Cyril Chemparathy <cyril@ti.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v2] of/phylib: Use device tree properties to initialize Marvell PHYs.
Date: Fri, 19 Nov 2010 14:13:18 -0800
Message-Id: <1290204798-28569-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 19 Nov 2010 22:14:17.0248 (UTC) FILETIME=[1B481A00:01CB8837]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some aspects of PHY initialization are board dependent, things like
indicator LED connections and some clocking modes cannot be determined
by probing.  The dev_flags element of struct phy_device can be used to
control these things if an appropriate value can be passed from the
Ethernet driver.  We run into problems however if the PHY connections
are specified by the device tree.  There is no way for the Ethernet
driver to know what flags it should pass.

If we are using the device tree, the struct phy_device will be
populated with the device tree node corresponding to the PHY, and we
can extract extra configuration information from there.

The next question is what should the format of that information be?
It is highly device specific, and the device tree representation
should not be tied to any arbitrary kernel defined constants.  A
straight forward representation is just to specify the exact bits that
should be set using the "marvell,reg-init" property:

      phy5: ethernet-phy@5 {
        reg = <5>;
        compatible = "marvell,88e1149r";
        marvell,reg-init =
                /* led[0]:1000, led[1]:100, led[2]:10, led[3]:tx */
                <3 0x10 0 0x5777>, /* Reg 3,16 <- 0x5777 */
                /* mix %:0, led[0123]:drive low off hiZ */
                <3 0x11 0 0x00aa>, /* Reg 3,17 <- 0x00aa */
                /* default blink periods. */
                <3 0x12 0 0x4105>, /* Reg 3,18 <- 0x4105 */
                /* led[4]:rx, led[5]:dplx, led[45]:drive low off hiZ */
                <3 0x13 0 0x0a60>; /* Reg 3,19 <- 0x0a60 */
      };

      phy6: ethernet-phy@6 {
        reg = <6>;
        compatible = "marvell,88e1118";
        marvell,reg-init =
                /* Fix rx and tx clock transition timing */
                <2 0x15 0xffcf 0>, /* Reg 2,21 Clear bits 4, 5 */
                /* Adjust LED drive. */
                <3 0x11 0 0x442a>, /* Reg 3,17 <- 0442a */
                /* irq, blink-activity, blink-link */
                <3 0x10 0 0x0242>; /* Reg 3,16 <- 0x0242 */
      };

The Marvell PHYs have a page select register at register 22 (0x16), we
can specify any register by its page and register number.  These are
the first and second word.  The third word contains a mask to be ANDed
with the existing register value, and the fourth word is ORed with the
result to yield the new register value.  The new marvell_of_reg_init
function leaves the page select register unchanged, so a call to it
can be dropped into the .config_init functions without unduly
affecting the state of the PHY.

If CONFIG_OF_MDIO is not set, there is no of_node, or no
"marvell,reg-init" property, the PHY initialization is unchanged.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Cyril Chemparathy <cyril@ti.com>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Note: this patch now depends on the recently sent 88E1149R support
patch, which was seperated into its own patch set.

I think I have incororated all feedback from Grant Likely and Cyril
Chemparathy, and Milton Miller.

David Daney

 drivers/net/phy/marvell.c |   97 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index def19d7..e8b9c53 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -30,6 +30,7 @@
 #include <linux/ethtool.h>
 #include <linux/phy.h>
 #include <linux/marvell_phy.h>
+#include <linux/of.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -187,6 +188,87 @@ static int marvell_config_aneg(struct phy_device *phydev)
 	return 0;
 }
 
+#ifdef CONFIG_OF_MDIO
+/*
+ * Set and/or override some configuration registers based on the
+ * marvell,reg-init property stored in the of_node for the phydev.
+ *
+ * marvell,reg-init = <reg-page reg mask value>,...;
+ *
+ * There may be one or more sets of <reg-page reg mask value>:
+ *
+ * reg-page: which register bank to use.
+ * reg: the register.
+ * mask: if non-zero, ANDed with existing register value.
+ * value: ORed with the masked value and written to the regiser.
+ *
+ */
+static int marvell_of_reg_init(struct phy_device *phydev)
+{
+	const __be32 *paddr;
+	int len, i, saved_page, current_page, page_changed, ret;
+
+	if (!phydev->dev.of_node)
+		return 0;
+
+	paddr = of_get_property(phydev->dev.of_node, "marvell,reg-init", &len);
+	if (!paddr || len < (4 * sizeof(*paddr)))
+		return 0;
+
+	saved_page = phy_read(phydev, MII_MARVELL_PHY_PAGE);
+	if (saved_page < 0)
+		return saved_page;
+	page_changed = 0;
+	current_page = saved_page;
+
+	ret = 0;
+	len /= sizeof(*paddr);
+	for (i = 0; i < len - 3; i += 4) {
+		u16 reg_page = be32_to_cpup(paddr + i);
+		u16 reg = be32_to_cpup(paddr + i + 1);
+		u16 mask = be32_to_cpup(paddr + i + 2);
+		u16 val_bits = be32_to_cpup(paddr + i + 3);
+		int val;
+
+		if (reg_page != current_page) {
+			current_page = reg_page;
+			page_changed = 1;
+			ret = phy_write(phydev, MII_MARVELL_PHY_PAGE, reg_page);
+			if (ret < 0)
+				goto err;
+		}
+
+		val = 0;
+		if (mask) {
+			val = phy_read(phydev, reg);
+			if (val < 0) {
+				ret = val;
+				goto err;
+			}
+			val &= mask;
+		}
+		val |= val_bits;
+
+		ret = phy_write(phydev, reg, val);
+		if (ret < 0)
+			goto err;
+
+	}
+err:
+	if (page_changed) {
+		i = phy_write(phydev, MII_MARVELL_PHY_PAGE, saved_page);
+		if (ret == 0)
+			ret = i;
+	}
+	return ret;
+}
+#else
+static int marvell_of_reg_init(struct phy_device *phydev)
+{
+	return 0;
+}
+#endif /* CONFIG_OF_MDIO */
+
 static int m88e1121_config_aneg(struct phy_device *phydev)
 {
 	int err, oldpage, mscr;
@@ -369,6 +451,9 @@ static int m88e1111_config_init(struct phy_device *phydev)
 			return err;
 	}
 
+	err = marvell_of_reg_init(phydev);
+	if (err < 0)
+		return err;
 
 	err = phy_write(phydev, MII_BMCR, BMCR_RESET);
 	if (err < 0)
@@ -421,6 +506,10 @@ static int m88e1118_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	err = marvell_of_reg_init(phydev);
+	if (err < 0)
+		return err;
+
 	/* Reset address */
 	err = phy_write(phydev, MII_MARVELL_PHY_PAGE, 0x0);
 	if (err < 0)
@@ -447,6 +536,10 @@ static int m88e1149_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	err = marvell_of_reg_init(phydev);
+	if (err < 0)
+		return err;
+
 	/* Reset address */
 	err = phy_write(phydev, MII_MARVELL_PHY_PAGE, 0x0);
 	if (err < 0)
@@ -518,6 +611,10 @@ static int m88e1145_config_init(struct phy_device *phydev)
 		}
 	}
 
+	err = marvell_of_reg_init(phydev);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
-- 
1.7.2.3

