Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab1FAVnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:43:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63355 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab1FAVnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CXsG02hFqlFMXQ35GX0jL2EJN142mS5lstYrVDlsHjCTYw2j4HZHq/uLgDVBwkxcEB
         cegn3yemiwe+qV8UzoWE4Raksdjgl0IwCqz9O2fxvIH7iwDZYOrAtvhVBQdz8URWH5eR
         CbhKqc2dNuhsBNw6PaNFgS+aboZmOaqDuG3jA=
Date: Thu, 2 Jun 2011 00:43:13 +0300
From: Maxin B John <maxin.john@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dima@android.com,
        eike-kernel@sf-tec.de, willy@linux.intel.com
Subject: [PATCH] mm: dmapool: fix possible use after free in
 dmam_pool_destroy()
Message-ID: <20110601214313.GA3724@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"dma_pool_destroy(pool)" calls "kfree(pool)". The freed pointer "pool"
is again passed as an argument to the function "devres_destroy()".
This patch fixes the possible use after free.

Please let me know your comments.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/mm/dmapool.c b/mm/dmapool.c
index 03bf3bb..fbb58e3 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -500,7 +500,7 @@ void dmam_pool_destroy(struct dma_pool *pool)
 {
 	struct device *dev = pool->dev;
 
-	dma_pool_destroy(pool);
 	WARN_ON(devres_destroy(dev, dmam_pool_release, dmam_pool_match, pool));
+	dma_pool_destroy(pool);
 }
 EXPORT_SYMBOL(dmam_pool_destroy);
