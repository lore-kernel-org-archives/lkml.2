Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0GIT5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:57:44 -0400
Received: from mx1.emlix.com ([193.175.82.87]:37798 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab0GIT5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:57:42 -0400
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org,
       =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH 2/2] gpiolib: allow nested threaded irqs for poll(2)
Date: Fri,  9 Jul 2010 21:24:18 +0200
Message-Id: <1278703458-26412-2-git-send-email-dg@emlix.com>
In-Reply-To: <1278703458-26412-1-git-send-email-dg@emlix.com>
References: <1278703458-26412-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pca953x driver requires the use of threaded irqs as its irq
demultiplexer can sleep. Our irq handler can be called from any
context, so use request_any_context_irq to allow threaded irqs
as well.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
Reported-by: Ian Jeffray <ian@jeffray.co.uk>
---
 drivers/gpio/gpiolib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 67e6136..b4ba1ec 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -385,9 +385,9 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 		}
 	}
 
-	ret = request_irq(irq, gpio_sysfs_irq, irq_flags,
+	ret = request_any_context_irq(irq, gpio_sysfs_irq, irq_flags,
 				"gpiolib", value_sd);
-	if (ret)
+	if (ret < 0)
 		goto free_id;
 
 	desc->flags |= gpio_flags;
-- 
1.7.1

