Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab2EDVF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:05:29 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab2EDUrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:47:37 -0400
Message-Id: <20120504204230.339849276@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Grazvydas Ignotas <notasas@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 70/75] wl1251: fix crash on remove due to premature kfree
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -315,8 +315,8 @@ static void __devexit wl1251_sdio_remove
 
 	if (wl->irq)
 		free_irq(wl->irq, wl);
-	kfree(wl_sdio);
 	wl1251_free_hw(wl);
+	kfree(wl_sdio);
 
 	sdio_claim_host(func);
 	sdio_release_irq(func);


