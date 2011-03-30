Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab1C3OCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:02:33 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:54202 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932543Ab1C3OCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:02:32 -0400
Date: Wed, 30 Mar 2011 15:59:11 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Colin Cross <ccross@android.com>
Cc: Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: tegra: fix error check in tegra2_clocks.c
Message-ID: <20110330155911.6dc0ef63@absol.kitzblitz>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking 'rate < 0' doesn't work because 'rate' is unsigned.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
Untested.

 arch/arm/mach-tegra/tegra2_clocks.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 6d7c4ee..4459470 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -1362,14 +1362,15 @@ static int tegra_clk_shared_bus_set_rate(struct clk *c, unsigned long rate)
 {
 	unsigned long flags;
 	int ret;
+	long new_rate = rate;
 
-	rate = clk_round_rate(c->parent, rate);
-	if (rate < 0)
-		return rate;
+	new_rate = clk_round_rate(c->parent, new_rate);
+	if (new_rate < 0)
+		return new_rate;
 
 	spin_lock_irqsave(&c->parent->spinlock, flags);
 
-	c->u.shared_bus_user.rate = rate;
+	c->u.shared_bus_user.rate = new_rate;
 	ret = tegra_clk_shared_bus_update(c->parent);
 
 	spin_unlock_irqrestore(&c->parent->spinlock, flags);
-- 
1.7.3.4
