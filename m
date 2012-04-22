Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab2DVUNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 16:13:14 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12544 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2DVUNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 16:13:13 -0400
Date: Sun, 22 Apr 2012 22:13:12 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: [PATCH] ISP1704 USB Charger: Fix use-after-free error in
 isp1704_charger_probe()
Message-ID: <alpine.LNX.2.00.1204222210290.27455@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In isp1704_charger_probe() at the 'fail0:' label we kfree(isp) and
then subsequently call isp1704_charger_set_power(isp, 0). That's a
problem since isp1704_charger_set_power() dereferences the pointer it
is passed as its first argument, which is 'isp', which we already
freed.

Fixed by simply swapping the order of the two calls so that we only
kfree() *after* the call to isp1704_charger_set_power().

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/power/isp1704_charger.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 39eb50f..8a610da 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -476,11 +476,9 @@ fail2:
 fail1:
 	usb_put_transceiver(isp->phy);
 fail0:
-	kfree(isp);
-
 	dev_err(&pdev->dev, "failed to register isp1704 with error %d\n", ret);
-
 	isp1704_charger_set_power(isp, 0);
+	kfree(isp);
 	return ret;
 }
 
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

