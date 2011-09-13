Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab1IMTTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 15:19:38 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50852 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab1IMTTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 15:19:38 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-mm@kvack.org, ngupta@vflare.org,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        dan.magenheimer@oracle.com,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH] staging: zcache: fix cleancache crash
Date: Tue, 13 Sep 2011 14:19:22 -0500
Message-Id: <1315941562-25422-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <4E6FA75A.8060308@linux.vnet.ibm.com>
References: <4E6FA75A.8060308@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit, c5f5c4db, cleancache crashes on the first
successful get. This was caused by a remaining virt_to_page()
call in zcache_pampd_get_data_and_free() that only gets
run in the cleancache path.

The patch converts the virt_to_page() to struct page
casting like was done for other instances in c5f5c4db.

Based on 3.1-rc4

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index a3f5162..462fbc2 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1242,7 +1242,7 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *bufsize, bool raw,
 	int ret = 0;
 
 	BUG_ON(!is_ephemeral(pool));
-	zbud_decompress(virt_to_page(data), pampd);
+	zbud_decompress((struct page *)(data), pampd);
 	zbud_free_and_delist((struct zbud_hdr *)pampd);
 	atomic_dec(&zcache_curr_eph_pampd_count);
 	return ret;
-- 
1.7.4.1

