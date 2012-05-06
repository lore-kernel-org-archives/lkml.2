Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab2EFQZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 12:25:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49251 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab2EFQZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 12:25:13 -0400
From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: langwell: Prevent possible NULL pointer dereference in the demux handler.
Date: Sun,  6 May 2012 17:25:08 +0100
Message-Id: <1336321508-20981-1-git-send-email-krzysztof.wilczynski@linux.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to address a possible NULL pointer dereference on a platform that might
use this driver but its underlying IRQ chip does not provide an irq_eoi callback.

A commit 0766d20 added an conditional to the code, but then it was later
super-seeded by commit 20e2aa9 which introduced number of helper functions
for accessing various members of the irq_desc struct, but removed said
conditional from the code.

This change will re-introduce conditional guarding against possible NULL
pointer dereference caused by missing EIO handler.

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
---
 drivers/gpio/gpio-langwell.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 00692e8..5749738 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -260,7 +260,8 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 		}
 	}
 
-	chip->irq_eoi(data);
+	if (data)
+		chip->irq_eoi(data);
 }
 
 #ifdef CONFIG_PM
-- 
1.7.2.5

