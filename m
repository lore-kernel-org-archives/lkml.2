Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab1LMGck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:32:40 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:54542 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab1LMGcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:32:39 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Jason Liu <jason.hui@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 09/19] clock-imx35: fix reboot in internal boot mode
Date: Tue, 13 Dec 2011 07:31:41 +0100
Message-Id: <1323757911-25217-9-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8d75a2620dc3e33ce504044c375c443ed7ed4128 disable IIM
clock after reading silicon revision which will prevent
reboot in internal boot mode (see comment a few line before)

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Jason Liu <jason.hui@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/clock-imx35.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-imx/clock-imx35.c b/arch/arm/mach-imx/clock-imx35.c
index 8116f11..b49a732 100644
--- a/arch/arm/mach-imx/clock-imx35.c
+++ b/arch/arm/mach-imx/clock-imx35.c
@@ -538,7 +538,10 @@ int __init mx35_clocks_init()
 
 	clk_enable(&iim_clk);
 	imx_print_silicon_rev("i.MX35", mx35_revision());
-	clk_disable(&iim_clk);
+	/* Don't disable IIM clock if we came up in internal boot mode */
+	if (__raw_readl(CCM_BASE + CCM_RCSR) & (3 << 10)) {
+		clk_disable(&iim_clk);
+	}
 
 #ifdef CONFIG_MXC_USE_EPIT
 	epit_timer_init(&epit1_clk,
-- 
1.7.6.4

