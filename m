Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0D3VkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:40:17 -0400
Received: from tex.lwn.net ([70.33.254.29]:36250 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759688Ab0D3VkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:40:08 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/3] viafb: Do not remove gpiochip under spinlock
Date: Fri, 30 Apr 2010 15:39:47 -0600
Message-Id: <1272663589-4950-2-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272663589-4950-1-git-send-email-corbet@lwn.net>
References: <1272663589-4950-1-git-send-email-corbet@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpiochip_remove() is not meant to be called with interrupts disabled, and
there is no need for the lock here in any case.

Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-gpio.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/video/via/via-gpio.c b/drivers/video/via/via-gpio.c
index 44537be..63cb7ac 100644
--- a/drivers/video/via/via-gpio.c
+++ b/drivers/video/via/via-gpio.c
@@ -246,7 +246,6 @@ static int viafb_gpio_remove(struct platform_device *platdev)
 	unsigned long flags;
 	int ret = 0, i;
 
-	spin_lock_irqsave(&gpio_config.vdev->reg_lock, flags);
 	/*
 	 * Get unregistered.
 	 */
@@ -254,16 +253,16 @@ static int viafb_gpio_remove(struct platform_device *platdev)
 		ret = gpiochip_remove(&gpio_config.gpio_chip);
 		if (ret) { /* Somebody still using it? */
 			printk(KERN_ERR "Viafb: GPIO remove failed\n");
-			goto out;
+			return ret;
 		}
 	}
 	/*
 	 * Disable the ports.
 	 */
+	spin_lock_irqsave(&gpio_config.vdev->reg_lock, flags);
 	for (i = 0; i < gpio_config.gpio_chip.ngpio; i += 2)
 		viafb_gpio_disable(gpio_config.active_gpios[i]);
 	gpio_config.gpio_chip.ngpio = 0;
-out:
 	spin_unlock_irqrestore(&gpio_config.vdev->reg_lock, flags);
 	return ret;
 }
-- 
1.7.0.1

