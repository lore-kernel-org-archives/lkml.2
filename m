Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2AaQl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:41:57 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7971 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2AaQlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:41:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 31 Jan 2012 08:41:49 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] ARM: tegra: prepare powergate.c for multiple variants
Date: Tue, 31 Jan 2012 18:40:42 +0200
Message-Id: <1328028051-24271-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
References: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare the powergating code for other Tegra variants which have a different
number of powerdomains.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/include/mach/powergate.h |    1 -
 arch/arm/mach-tegra/powergate.c              |   33 +++++++++++++++++++++----
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/powergate.h b/arch/arm/mach-tegra/include/mach/powergate.h
index 39c396d..36846dc 100644
--- a/arch/arm/mach-tegra/include/mach/powergate.h
+++ b/arch/arm/mach-tegra/include/mach/powergate.h
@@ -27,7 +27,6 @@
 #define TEGRA_POWERGATE_VDEC	4
 #define TEGRA_POWERGATE_L2	5
 #define TEGRA_POWERGATE_MPE	6
-#define TEGRA_NUM_POWERGATE	7
 
 int tegra_powergate_power_on(int id);
 int tegra_powergate_power_off(int id);
diff --git a/arch/arm/mach-tegra/powergate.c b/arch/arm/mach-tegra/powergate.c
index 9483064..9b828f2 100644
--- a/arch/arm/mach-tegra/powergate.c
+++ b/arch/arm/mach-tegra/powergate.c
@@ -31,6 +31,8 @@
 #include <mach/iomap.h>
 #include <mach/powergate.h>
 
+#include "fuse.h"
+
 #define PWRGATE_TOGGLE		0x30
 #define  PWRGATE_TOGGLE_START	(1 << 8)
 
@@ -38,6 +40,8 @@
 
 #define PWRGATE_STATUS		0x38
 
+static int tegra_num_powerdomains;
+
 static DEFINE_SPINLOCK(tegra_powergate_lock);
 
 static void __iomem *pmc = IO_ADDRESS(TEGRA_PMC_BASE);
@@ -75,7 +79,7 @@ static int tegra_powergate_set(int id, bool new_state)
 
 int tegra_powergate_power_on(int id)
 {
-	if (id < 0 || id >= TEGRA_NUM_POWERGATE)
+	if (id < 0 || id >= tegra_num_powerdomains)
 		return -EINVAL;
 
 	return tegra_powergate_set(id, true);
@@ -83,17 +87,18 @@ int tegra_powergate_power_on(int id)
 
 int tegra_powergate_power_off(int id)
 {
-	if (id < 0 || id >= TEGRA_NUM_POWERGATE)
+	if (id < 0 || id >= tegra_num_powerdomains)
 		return -EINVAL;
 
 	return tegra_powergate_set(id, false);
 }
 
-static bool tegra_powergate_is_powered(int id)
+static int tegra_powergate_is_powered(int id)
 {
 	u32 status;
 
-	WARN_ON(id < 0 || id >= TEGRA_NUM_POWERGATE);
+	if (id < 0 || id >= tegra_num_powerdomains)
+		return -EINVAL;
 
 	status = pmc_read(PWRGATE_STATUS) & (1 << id);
 	return !!status;
@@ -103,7 +108,7 @@ int tegra_powergate_remove_clamping(int id)
 {
 	u32 mask;
 
-	if (id < 0 || id >= TEGRA_NUM_POWERGATE)
+	if (id < 0 || id >= tegra_num_powerdomains)
 		return -EINVAL;
 
 	/*
@@ -156,6 +161,22 @@ err_power:
 	return ret;
 }
 
+int __init tegra_powergate_init(void)
+{
+	switch (tegra_chip_id) {
+	case TEGRA20:
+		tegra_num_powerdomains = 7;
+		break;
+	default:
+		/* Unknown Tegra variant. Disable powergating */
+		tegra_num_powerdomains = 0;
+		break;
+	}
+
+	return 0;
+}
+arch_initcall(tegra_powergate_init);
+
 #ifdef CONFIG_DEBUG_FS
 
 static const char * const powergate_name[] = {
@@ -175,7 +196,7 @@ static int powergate_show(struct seq_file *s, void *data)
 	seq_printf(s, " powergate powered\n");
 	seq_printf(s, "------------------\n");
 
-	for (i = 0; i < TEGRA_NUM_POWERGATE; i++)
+	for (i = 0; i < tegra_num_powerdomains; i++)
 		seq_printf(s, " %9s %7s\n", powergate_name[i],
 			tegra_powergate_is_powered(i) ? "yes" : "no");
 	return 0;
-- 
1.7.7.rc0.72.g4b5ea.dirty

