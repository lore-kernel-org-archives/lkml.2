Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab2HVPOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:14:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab2HVPNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:13:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 4/6] ARM: imx: fix ksz9021rn_phy_fixup
Date: Wed, 22 Aug 2012 17:13:08 +0200
Message-Id: <1345648390-4234-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1345648390-4234-1-git-send-email-arnd@arndb.de>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:yeNTznFeg/AxPskmSMXnwocGpizSDBQzyf9vH6z4twR
 /HW/KT1MrZSlq2tDVlcj+3V33iaX4bNkujaY+7cPVnOagPdTWd
 mvAN3KudztF5LL37YPVjhTHzdl1LyXfAFxpywo265sXESFNuCT
 YDOVdHbbw32/QjavawUNGVmFgLKjvWD8KsGMWdb02u8xAgw38E
 bo+OKY/Zqzw4QHmcD3vwHng72wvGOBOgTcciJa1lNc5NOKk6cH
 9/jxx7qKeRbOFL740c7RxZwD0yrwGv0gfhirfY8Cs9jHKx35Vt
 gh3hxaNl3YML5y9H1EgxXRFl3Br3MjdqDF4wWf9ZWvBnG5mIJt
 JlKPbU+eBsjAai1hm3ByiUEPUcgs9don5KudiEySwzHZan+QPE
 UQZd1kKyVRdzA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ksz9021rn_phy_fixup and mx6q_sabrelite functions try to
set up an ethernet phy if they can. They do check whether
phylib is enabled, but unfortunately the functions can only
be called from platform code if phylib is builtin, not
if it is a module

Without this patch, building with a modular phylib results in:

arch/arm/mach-imx/mach-imx6q.c: In function 'imx6q_sabrelite_init':
arch/arm/mach-imx/mach-imx6q.c:120:5: error: 'ksz9021rn_phy_fixup' undeclared (first use in this function)
arch/arm/mach-imx/mach-imx6q.c:120:5: note: each undeclared identifier is reported only once for each function it appears in

The bug was originally reported by Artem Bityutskiy but only
partially fixed in ef441806 "ARM: imx6q: register phy fixup only when
CONFIG_PHYLIB is enabled".

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-imx/mach-imx6q.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 5ec0608..045b3f6 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -71,7 +71,7 @@ soft:
 /* For imx6q sabrelite board: set KSZ9021RN RGMII pad skew */
 static int ksz9021rn_phy_fixup(struct phy_device *phydev)
 {
-	if (IS_ENABLED(CONFIG_PHYLIB)) {
+	if (IS_BUILTIN(CONFIG_PHYLIB)) {
 		/* min rx data delay */
 		phy_write(phydev, 0x0b, 0x8105);
 		phy_write(phydev, 0x0c, 0x0000);
@@ -112,7 +112,7 @@ put_clk:
 
 static void __init imx6q_sabrelite_init(void)
 {
-	if (IS_ENABLED(CONFIG_PHYLIB))
+	if (IS_BUILTIN(CONFIG_PHYLIB))
 		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
 				ksz9021rn_phy_fixup);
 	imx6q_sabrelite_cko1_setup();
-- 
1.7.10

