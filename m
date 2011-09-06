Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1IFIIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:08:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab1IFIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:08:36 -0400
From: Thomas Weber <weber@corscience.de>
To: silesh@ti.com
Cc: Thomas Weber <weber@corscience.de>,
        Tony Lindgren <tony@atomide.com> (maintainer:OMAP SUPPORT),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-omap@vger.kernel.org (open list:OMAP SUPPORT),
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] OMAP: hsmmc: Fix mux for non-OMAP pins
Date: Tue,  6 Sep 2011 10:08:03 +0200
Message-Id: <1315296483-8442-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <4E6538A1.5090204@gmail.com>
References: <4E6538A1.5090204@gmail.com>
X-Provags-ID: V02:K0:BoYgUfgDINg7hxJylg3Xd6CES37XbCptK9NoV13ftf5
 eRTyvVPMA5/m5nj4szp5ZQhuC8FiWWTYG5BU0l73zB9YRsCNAw
 cqiiJ/f3qfj3EbOEpsevJew0pFTaDHmMaLH+kL+s5p/0J7lsSF
 0pfmq0YBGJ85M+qWyXN+3rdWXu/CWiPKjTrUK4PDWbvgiObSfm
 WTpLaFzt4PETtEuSfWqU3hWX5H4TqVKMB6FVvs8tn+qGithrdb
 NsxRK0bRUvGeJQP+Sev4A5JSy+VI+UltQW9wF7UJjfwpDT6Jmp
 HXtCpXcIryYvgH8tKAXSbP6tOtsufgt3i81svjo9SKENmXHJQm
 n5RyuieqeY/G4gRp32is7OZMFOy6lBuUER+Fp0wyEA+uKbkwyG
 b13kA+pIWenvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Devkit8000 uses a TWL4030 pin for card detection.
Thats why the error:
_omap_mux_init_gpio: Could not set gpio192
occurs.

This patch checks that the pin is on OMAP before
calling omap_mux_init_gpio.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/hsmmc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
index a9b45c7..783d0f1 100644
--- a/arch/arm/mach-omap2/hsmmc.c
+++ b/arch/arm/mach-omap2/hsmmc.c
@@ -214,10 +214,12 @@ static int nop_mmc_set_power(struct device *dev, int slot, int power_on,
 static inline void omap_hsmmc_mux(struct omap_mmc_platform_data *mmc_controller,
 			int controller_nr)
 {
-	if (gpio_is_valid(mmc_controller->slots[0].switch_pin))
+	if (gpio_is_valid(mmc_controller->slots[0].switch_pin) && \
+		(mmc_controller->slots[0].switch_pin < OMAP_MAX_GPIO_LINES))
 		omap_mux_init_gpio(mmc_controller->slots[0].switch_pin,
 					OMAP_PIN_INPUT_PULLUP);
-	if (gpio_is_valid(mmc_controller->slots[0].gpio_wp))
+	if (gpio_is_valid(mmc_controller->slots[0].gpio_wp) && \
+		(mmc_controller->slots[0].gpio_wp < OMAP_MAX_GPIO_LINES))
 		omap_mux_init_gpio(mmc_controller->slots[0].gpio_wp,
 					OMAP_PIN_INPUT_PULLUP);
 	if (cpu_is_omap34xx()) {
-- 
1.7.6.1

