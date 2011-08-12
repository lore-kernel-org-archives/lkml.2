Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1HLWzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:55:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59163 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab1HLWzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:55:12 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 03/12] arm/tegra: Avoid duplicate gpio/pinmux devices with dt
Date: Fri, 12 Aug 2011 16:54:48 -0600
Message-Id: <1313189697-21287-4-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A future change will set up complete gpio and pinmux platform device
registration in device-tree files, via board-dt.c. When board-dt.c calls
into harmony/seaboard_pinmux_init(), this will cause a duplicate
registration of those platform devices, which will kernel boot failure.

To solve this, modify  so that it only
registers the platform devices when actually running on Harmony; when
board-dt.c is in use, a different machine type is used.

This change is a temporary measure to ensure git bisectability. It will
be reverted when board-dt.c no longer calls harmony/seaboard_pinmux_init().

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/board-harmony-pinmux.c  |    5 ++++-
 arch/arm/mach-tegra/board-seaboard-pinmux.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony-pinmux.c b/arch/arm/mach-tegra/board-harmony-pinmux.c
index e99b456..130018d 100644
--- a/arch/arm/mach-tegra/board-harmony-pinmux.c
+++ b/arch/arm/mach-tegra/board-harmony-pinmux.c
@@ -14,6 +14,8 @@
  *
  */
 
+#include <asm/mach-types.h>
+
 #include <linux/kernel.h>
 #include <linux/gpio.h>
 #include <mach/pinmux.h>
@@ -161,7 +163,8 @@ static struct tegra_gpio_table gpio_table[] = {
 
 void harmony_pinmux_init(void)
 {
-	platform_add_devices(pinmux_devices, ARRAY_SIZE(pinmux_devices));
+	if (machine_is_harmony())
+		platform_add_devices(pinmux_devices, ARRAY_SIZE(pinmux_devices));
 
 	tegra_pinmux_config_table(harmony_pinmux, ARRAY_SIZE(harmony_pinmux));
 
diff --git a/arch/arm/mach-tegra/board-seaboard-pinmux.c b/arch/arm/mach-tegra/board-seaboard-pinmux.c
index f092298..bc4dc17 100644
--- a/arch/arm/mach-tegra/board-seaboard-pinmux.c
+++ b/arch/arm/mach-tegra/board-seaboard-pinmux.c
@@ -12,6 +12,8 @@
  *
  */
 
+#include <asm/mach-types.h>
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
@@ -176,7 +178,8 @@ static struct tegra_gpio_table gpio_table[] = {
 
 void __init seaboard_pinmux_init(void)
 {
-	platform_add_devices(pinmux_devices, ARRAY_SIZE(pinmux_devices));
+	if (machine_is_seaboard())
+		platform_add_devices(pinmux_devices, ARRAY_SIZE(pinmux_devices));
 
 	tegra_pinmux_config_table(seaboard_pinmux, ARRAY_SIZE(seaboard_pinmux));
 
-- 
1.7.0.4

