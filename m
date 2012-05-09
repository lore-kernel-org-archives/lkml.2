Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab2EIGGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:06:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39114 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756629Ab2EIFxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:36 -0400
Message-Id: <20120509055049.740322865@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Grazvydas Ignotas <notasas@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 146/167] [PATCH] wl1251: fix crash on remove due to premature kfree
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grazvydas Ignotas <notasas@gmail.com>

commit 328c32f0f85467af5a6c4c3289e168d9ad2555af upstream.

Currently SDIO glue frees it's own structure before calling
wl1251_free_hw(), which in turn calls ieee80211_unregister_hw().
The later call may result in a need to communicate with the chip
to stop it (as it happens now if the interface is still up before
rmmod), which means calls are made back to the glue, resulting in
freed memory access.

Fix this by freeing glue data last.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/wl1251/sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl1251/sdio.c
index f786942..1b851f6 100644
--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -315,8 +315,8 @@ static void __devexit wl1251_sdio_remove(struct sdio_func *func)
 
 	if (wl->irq)
 		free_irq(wl->irq, wl);
-	kfree(wl_sdio);
 	wl1251_free_hw(wl);
+	kfree(wl_sdio);
 
 	sdio_claim_host(func);
 	sdio_release_irq(func);
-- 
1.7.10



