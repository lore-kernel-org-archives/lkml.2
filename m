Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab2EYIHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:07:00 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:43364 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755800Ab2EYIFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:05:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIo8v09bdWOb/2dsb2JhbABEtRCBB4IWAQUnQBIQUVcGE4gRu0iQRwOVGI9wgmI
X-IronPort-AV: E=Sophos;i="4.75,655,1330902000"; 
   d="scan'208";a="995215620"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] Staging: ipack/devices/ipoctal: avoid kernel oops when uninstalling
Date: Fri, 25 May 2012 10:03:03 +0200
Message-Id: <1337932985-10668-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337932985-10668-1-git-send-email-siglesias@igalia.com>
References: <1337932985-10668-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When uninstalling a device, there is a loop of calls that produces, at the end,
two calls to __ipoctal_remove() function with the same ipack_device argument.

The first time works fine, but the second will fail in tty_unregister_driver()

To avoid this situation, the call to __ipoctal_remove() it is done only from the
ipack bus driver and not from the ipack device driver.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 29f6fa8..a6f424e 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -853,11 +853,6 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 
 	tty_unregister_driver(ipoctal->tty_drv);
 	put_tty_driver(ipoctal->tty_drv);
-
-	/* Tell the carrier board to free all the resources for this device */
-	if (ipoctal->dev->bus->ops->remove_device != NULL)
-		ipoctal->dev->bus->ops->remove_device(ipoctal->dev);
-
 	list_del(&ipoctal->list);
 	kfree(ipoctal);
 }
@@ -889,7 +884,7 @@ static void __exit ipoctal_exit(void)
 	struct ipoctal *p, *next;
 
 	list_for_each_entry_safe(p, next, &ipoctal_list, list)
-		__ipoctal_remove(p);
+		p->dev->bus->ops->remove_device(p->dev);
 
 	ipack_driver_unregister(&driver);
 }
-- 
1.7.10

