Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab2BIXsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:48:37 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16399 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab2BIXsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:48:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 09 Feb 2012 15:48:34 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/10] ARM: tegra: cleanup use of chipid register
Date: Fri, 10 Feb 2012 01:47:41 +0200
Message-Id: <1328831277-21002-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chipid register contains information about the Tegra variant and revision.
We want differentiate between Tegra variants for powergating and secondary
core bringup. This patch cleans up the reading and decoding of this register.
In subsequent patches the variant will exported as a global variable.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/fuse.c |   18 +++++++++++-------
 arch/arm/mach-tegra/fuse.h |    3 +++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index adfa429..032a936 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -34,6 +34,7 @@
 int tegra_sku_id;
 int tegra_cpu_process_id;
 int tegra_core_process_id;
+static int tegra_chip_id;
 enum tegra_revision tegra_revision;
 
 /* The BCT to use at boot is specified by board straps that can be read
@@ -66,12 +67,9 @@ static inline bool get_spare_fuse(int bit)
 	return tegra_fuse_readl(FUSE_SPARE_BIT + bit * 4);
 }
 
-static enum tegra_revision tegra_get_revision(void)
+static enum tegra_revision tegra_get_revision(u32 id)
 {
-	void __iomem *chip_id = IO_ADDRESS(TEGRA_APB_MISC_BASE) + 0x804;
-	u32 id = readl(chip_id);
 	u32 minor_rev = (id >> 16) & 0xf;
-	u32 chipid = (id >> 8) & 0xff;
 
 	switch (minor_rev) {
 	case 1:
@@ -79,7 +77,8 @@ static enum tegra_revision tegra_get_revision(void)
 	case 2:
 		return TEGRA_REVISION_A02;
 	case 3:
-		if (chipid == 0x20 && (get_spare_fuse(18) || get_spare_fuse(19)))
+		if (tegra_chip_id == TEGRA20 &&
+			(get_spare_fuse(18) || get_spare_fuse(19)))
 			return TEGRA_REVISION_A03p;
 		else
 			return TEGRA_REVISION_A03;
@@ -92,6 +91,8 @@ static enum tegra_revision tegra_get_revision(void)
 
 void tegra_init_fuse(void)
 {
+	u32 id;
+
 	u32 reg = readl(IO_TO_VIRT(TEGRA_CLK_RESET_BASE + 0x48));
 	reg |= 1 << 28;
 	writel(reg, IO_TO_VIRT(TEGRA_CLK_RESET_BASE + 0x48));
@@ -108,10 +109,13 @@ void tegra_init_fuse(void)
 	reg = tegra_apb_readl(TEGRA_APB_MISC_BASE + STRAP_OPT);
 	tegra_bct_strapping = (reg & RAM_ID_MASK) >> RAM_CODE_SHIFT;
 
-	tegra_revision = tegra_get_revision();
+	id = readl_relaxed(IO_ADDRESS(TEGRA_APB_MISC_BASE) + 0x804);
+	tegra_chip_id = (id >> 8) & 0xff;
+
+	tegra_revision = tegra_get_revision(id);
 
 	pr_info("Tegra Revision: %s SKU: %d CPU Process: %d Core Process: %d\n",
-		tegra_revision_name[tegra_get_revision()],
+		tegra_revision_name[tegra_revision],
 		tegra_sku_id, tegra_cpu_process_id,
 		tegra_core_process_id);
 }
diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
index d65d2ab..c554572 100644
--- a/arch/arm/mach-tegra/fuse.h
+++ b/arch/arm/mach-tegra/fuse.h
@@ -35,6 +35,9 @@ enum tegra_revision {
 #define SKU_ID_AP25E	27
 #define SKU_ID_T25E	28
 
+#define TEGRA20		0x20
+#define TEGRA30		0x30
+
 extern int tegra_sku_id;
 extern int tegra_cpu_process_id;
 extern int tegra_core_process_id;
-- 
1.7.4.1

