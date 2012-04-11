Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761152Ab2DKUKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:10:23 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16512 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2DKUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:10:22 -0400
Date: Wed, 11 Apr 2012 22:10:20 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>
Subject: [PATCH] staging: android: fix mem leaks in __persistent_ram_init()
Message-ID: <alpine.LNX.2.00.1204112209040.2137@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If, in __persistent_ram_init(), the call to
persistent_ram_buffer_init() fails or the call to
persistent_ram_init_ecc() fails then we fail to free the memory we
allocated to 'prz' with kzalloc() - thus leaking it.

To prevent the leaks I consolidated all error exits from the function
at a 'err:' label at the end and made all error cases jump to that
label where we can then make sure we always free 'prz'. This is safe
since all the situations where the code bails out happen before 'prz'
has been stored anywhere and although we'll do a redundant kfree(NULL)
call in the case of kzalloc() itself failing that's OK since kfree()
deals gracefully with NULL pointers and I felt it was more important
to keep all error exits at a single location than to avoid that one
harmless/redundant kfree() on a error path.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/android/persistent_ram.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index e08f257..8d8c1e3 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -399,12 +399,12 @@ static  __init
 struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
 {
 	struct persistent_ram_zone *prz;
-	int ret;
+	int ret = -ENOMEM;
 
 	prz = kzalloc(sizeof(struct persistent_ram_zone), GFP_KERNEL);
 	if (!prz) {
 		pr_err("persistent_ram: failed to allocate persistent ram zone\n");
-		return ERR_PTR(-ENOMEM);
+		goto err;
 	}
 
 	INIT_LIST_HEAD(&prz->node);
@@ -412,13 +412,13 @@ struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
 	ret = persistent_ram_buffer_init(dev_name(dev), prz);
 	if (ret) {
 		pr_err("persistent_ram: failed to initialize buffer\n");
-		return ERR_PTR(ret);
+		goto err;
 	}
 
 	prz->ecc = ecc;
 	ret = persistent_ram_init_ecc(prz, prz->buffer_size);
 	if (ret)
-		return ERR_PTR(ret);
+		goto err;
 
 	if (prz->buffer->sig == PERSISTENT_RAM_SIG) {
 		if (buffer_size(prz) > prz->buffer_size ||
@@ -442,6 +442,9 @@ struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
 	atomic_set(&prz->buffer->size, 0);
 
 	return prz;
+err:
+	kfree(prz);
+	return ERR_PTR(ret);
 }
 
 struct persistent_ram_zone * __init
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

