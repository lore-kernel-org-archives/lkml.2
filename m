Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab2CMFq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:46:57 -0400
Received: from smtp12.mail.ru ([94.100.176.89]:34321 "EHLO smtp12.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759464Ab2CMFq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:46:56 -0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Olof Johansson <olof@lixom.net>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-tegra@vger.kernel.org, Andi <andi.shyti@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: [PATCH] arm/tegra: pcie: fix return value of function
Date: Tue, 13 Mar 2012 09:46:27 +0400
Message-Id: <1331617587-10714-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.5.1.300.gc565c
In-Reply-To: <CAOesGMi0aqCjLsJ5wWXwFVQL2T8wtUuE14rFZ9h7NKHXcWAoqQ@mail.gmail.com>
References: <CAOesGMi0aqCjLsJ5wWXwFVQL2T8wtUuE14rFZ9h7NKHXcWAoqQ@mail.gmail.com>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In previous patch (arm/tegra: add timeout to PCIe PLL lock detection loop)
tegra_pcie_enable_controller() function type has been changed from
void to int, but the last return statement wasn't converted, so
function returns undefined value. Fix it.

Also while at it, address couple of minor concerns raised by reviewers:
use usleep_range for delay, and lower the value of timeout to 300ms
to be consistent with Nvidia Vibrante kernel.

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 arch/arm/mach-tegra/pcie.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/pcie.c b/arch/arm/mach-tegra/pcie.c
index 7313059..54a816f 100644
--- a/arch/arm/mach-tegra/pcie.c
+++ b/arch/arm/mach-tegra/pcie.c
@@ -639,10 +639,10 @@ static int tegra_pcie_enable_controller(void)
 	pads_writel(0xfa5cfa5c, 0xc8);
 
 	/* Wait for the PLL to lock */
-	timeout = 2000;
+	timeout = 300;
 	do {
 		val = pads_readl(PADS_PLL_CTL);
-		mdelay(1);
+		usleep_range(1000, 1000);
 		if (--timeout == 0) {
 			pr_err("Tegra PCIe error: timeout waiting for PLL\n");
 			return -EBUSY;
@@ -677,7 +677,7 @@ static int tegra_pcie_enable_controller(void)
 	/* Disable all execptions */
 	afi_writel(0, AFI_FPCI_ERROR_MASKS);
 
-	return;
+	return 0;
 }
 
 static void tegra_pcie_xclk_clamp(bool clamp)
-- 
1.7.5.1.300.gc565c

