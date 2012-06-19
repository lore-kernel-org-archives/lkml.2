Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2FSCSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:18:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50286 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2FSCSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:18:09 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 3/7] pstore/ram_core: Proper checking for post_init errors (e.g. improper ECC size)
Date: Mon, 18 Jun 2012 19:15:52 -0700
Message-Id: <1340072156-6225-3-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120619021050.GA19387@lizard>
References: <20120619021050.GA19387@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will implement variable-sized ECC buffers soon, so post_init routine
might fail much more likely, so we'd better check for its errors.

To make error handling simple, modify persistent_ram_free() to it be safe
at all times.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram_core.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 2653185..f62ebf2 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -427,11 +427,17 @@ static int __devinit persistent_ram_post_init(struct persistent_ram_zone *prz,
 
 void persistent_ram_free(struct persistent_ram_zone *prz)
 {
-	if (pfn_valid(prz->paddr >> PAGE_SHIFT)) {
-		vunmap(prz->vaddr);
-	} else {
-		iounmap(prz->vaddr);
-		release_mem_region(prz->paddr, prz->size);
+	if (!prz)
+		return;
+
+	if (prz->vaddr) {
+		if (pfn_valid(prz->paddr >> PAGE_SHIFT)) {
+			vunmap(prz->vaddr);
+		} else {
+			iounmap(prz->vaddr);
+			release_mem_region(prz->paddr, prz->size);
+		}
+		prz->vaddr = NULL;
 	}
 	persistent_ram_free_old(prz);
 	kfree(prz);
@@ -454,10 +460,12 @@ struct persistent_ram_zone * __devinit persistent_ram_new(phys_addr_t start,
 	if (ret)
 		goto err;
 
-	persistent_ram_post_init(prz, ecc);
+	ret = persistent_ram_post_init(prz, ecc);
+	if (ret)
+		goto err;
 
 	return prz;
 err:
-	kfree(prz);
+	persistent_ram_free(prz);
 	return ERR_PTR(ret);
 }
-- 
1.7.10.4

