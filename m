Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab1CWTz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:55:58 -0400
Received: from mail.perches.com ([173.55.12.10]:4259 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab1CWTzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:55:45 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [trivial PATCH 2/2] arm: mach-u300/gpio: Fix mem_region resource size miscalculations
Date: Wed, 23 Mar 2011 12:55:37 -0700
Message-Id: <798d0aea7272beadf2ee838f7aa27f86cfe7f9ba.1300909446.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1300909445.git.joe@perches.com>
References: <cover.1300909445.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert off-by-1 r->end - r->start to resource_size(r)

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-u300/gpio.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-u300/gpio.c b/arch/arm/mach-u300/gpio.c
index d927901..94837a4 100644
--- a/arch/arm/mach-u300/gpio.c
+++ b/arch/arm/mach-u300/gpio.c
@@ -581,8 +581,7 @@ static int __init gpio_probe(struct platform_device *pdev)
 	if (!memres)
 		goto err_no_resource;
 
-	if (request_mem_region(memres->start, memres->end - memres->start, "GPIO Controller")
-	    == NULL) {
+	if (!request_mem_region(memres->start, resource_size(memres), "GPIO Controller")) {
 		err = -ENODEV;
 		goto err_no_ioregion;
 	}
@@ -640,7 +639,7 @@ static int __init gpio_probe(struct platform_device *pdev)
 		free_irq(gpio_ports[i].irq, &gpio_ports[i]);
 	iounmap(virtbase);
  err_no_ioremap:
-	release_mem_region(memres->start, memres->end - memres->start);
+	release_mem_region(memres->start, resource_size(memres));
  err_no_ioregion:
  err_no_resource:
 	clk_disable(clk);
@@ -660,7 +659,7 @@ static int __exit gpio_remove(struct platform_device *pdev)
 	for (i = 0 ; i < U300_GPIO_NUM_PORTS; i++)
 		free_irq(gpio_ports[i].irq, &gpio_ports[i]);
 	iounmap(virtbase);
-	release_mem_region(memres->start, memres->end - memres->start);
+	release_mem_region(memres->start, resource_size(memres));
 	clk_disable(clk);
 	clk_put(clk);
 	return 0;
-- 
1.7.4.2.g597a6.dirty

