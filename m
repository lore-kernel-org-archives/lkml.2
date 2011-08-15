Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1HOU2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:28:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53758 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1HOU2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:28:43 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH v2 02/13] arm/tegra: Avoid duplicate gpio/pinmux devices with dt
Date: Mon, 15 Aug 2011 14:28:09 -0600
Message-Id: <1313440100-17131-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A future change will set up gpio and pinmux platform device registration
in device-tree files, via board-dt.c. When board-dt.c calls into
harmony/seaboard_pinmux_init(), this will cause a duplicate registration
of those platform devices, which will cause kernel boot failure.

To solve this, modify harmony/seaboard_pinmux_init() so that they only
register the platform devices when actually running on Harmony/Seaboard;
when board-dt.c is in use, a different machine type is used.

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

