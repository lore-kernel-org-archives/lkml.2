Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054Ab2EDUuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:50:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759918Ab2EDUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:50:16 -0400
Message-Id: <20120504204248.747128524@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Grazvydas Ignotas <notasas@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 45/47] wl1251: fix crash on remove due to premature kfree
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/wl1251/sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -314,8 +314,8 @@ static void __devexit wl1251_sdio_remove
 
 	if (wl->irq)
 		free_irq(wl->irq, wl);
-	kfree(wl_sdio);
 	wl1251_free_hw(wl);
+	kfree(wl_sdio);
 
 	sdio_claim_host(func);
 	sdio_release_irq(func);


