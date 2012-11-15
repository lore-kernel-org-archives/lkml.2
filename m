Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992932Ab2KOHpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:45:16 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5098 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423572Ab2KOHod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:44:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 14 Nov 2012 23:44:31 -0800
From: Danny Huang <dahuang@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Danny Huang <dahuang@nvidia.com>
Subject: [PATCH V2 1/3] ARM: tegra: flexible spare fuse read function
Date: Thu, 15 Nov 2012 15:42:32 +0800
Message-ID: <1352965354-650-2-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352965354-650-1-git-send-email-dahuang@nvidia.com>
References: <1352965354-650-1-git-send-email-dahuang@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the spare fuse base from a definition to a variable.
It provides flexibilty to read spare fuse on different chip.

Signed-off-by: Danny Huang <dahuang@nvidia.com>
---
 arch/arm/mach-tegra/fuse.c | 19 ++++++++++++-------
 arch/arm/mach-tegra/fuse.h |  2 ++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index 6c752e8..bd19c2f 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -28,7 +28,8 @@
 #define FUSE_UID_LOW		0x108
 #define FUSE_UID_HIGH		0x10c
 #define FUSE_SKU_INFO		0x110
-#define FUSE_SPARE_BIT		0x200
+
+#define TEGRA20_FUSE_SPARE_BIT		0x200
 
 int tegra_sku_id;
 int tegra_cpu_process_id;
@@ -36,6 +37,8 @@ int tegra_core_process_id;
 int tegra_chip_id;
 enum tegra_revision tegra_revision;
 
+static int tegra_fuse_spare_bit;
+
 /* The BCT to use at boot is specified by board straps that can be read
  * through a APB misc register and decoded. 2 bits, i.e. 4 possible BCTs.
  */
@@ -56,14 +59,14 @@ static const char *tegra_revision_name[TEGRA_REVISION_MAX] = {
 	[TEGRA_REVISION_A04]     = "A04",
 };
 
-static inline u32 tegra_fuse_readl(unsigned long offset)
+u32 tegra_fuse_readl(unsigned long offset)
 {
 	return tegra_apb_readl(TEGRA_FUSE_BASE + offset);
 }
 
-static inline bool get_spare_fuse(int bit)
+bool tegra_spare_fuse(int bit)
 {
-	return tegra_fuse_readl(FUSE_SPARE_BIT + bit * 4);
+	return tegra_fuse_readl(tegra_fuse_spare_bit + bit * 4);
 }
 
 static enum tegra_revision tegra_get_revision(u32 id)
@@ -77,7 +80,7 @@ static enum tegra_revision tegra_get_revision(u32 id)
 		return TEGRA_REVISION_A02;
 	case 3:
 		if (tegra_chip_id == TEGRA20 &&
-			(get_spare_fuse(18) || get_spare_fuse(19)))
+			(tegra_spare_fuse(18) || tegra_spare_fuse(19)))
 			return TEGRA_REVISION_A03p;
 		else
 			return TEGRA_REVISION_A03;
@@ -99,10 +102,12 @@ void tegra_init_fuse(void)
 	reg = tegra_fuse_readl(FUSE_SKU_INFO);
 	tegra_sku_id = reg & 0xFF;
 
-	reg = tegra_fuse_readl(FUSE_SPARE_BIT);
+	tegra_fuse_spare_bit = TEGRA20_FUSE_SPARE_BIT;
+
+	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
 	tegra_cpu_process_id = (reg >> 6) & 3;
 
-	reg = tegra_fuse_readl(FUSE_SPARE_BIT);
+	reg = tegra_fuse_readl(tegra_fuse_spare_bit);
 	tegra_core_process_id = (reg >> 12) & 3;
 
 	reg = tegra_apb_readl(TEGRA_APB_MISC_BASE + STRAP_OPT);
diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
index d2107b2..aef1223 100644
--- a/arch/arm/mach-tegra/fuse.h
+++ b/arch/arm/mach-tegra/fuse.h
@@ -48,5 +48,7 @@ extern int tegra_bct_strapping;
 
 unsigned long long tegra_chip_uid(void);
 void tegra_init_fuse(void);
+bool tegra_spare_fuse(int bit);
+u32 tegra_fuse_readl(unsigned long offset);
 
 #endif
-- 
1.8.0

