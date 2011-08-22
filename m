Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab1HVStI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:49:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44415 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1HVStG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:49:06 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: ascardo@holoscopio.com, dan.magenheimer@oracle.com,
        sjenning@linux.vnet.ibm.com, rdunlap@xenotime.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: zcache: fix possible sleep under lock
Date: Mon, 22 Aug 2011 13:47:49 -0500
Message-Id: <1314038869-8164-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zcache_new_pool() calls kmalloc() with GFP_KERNEL which has
__GFP_WAIT set.  However, zcache_new_pool() gets called on
a stack that holds the swap_lock spinlock, leading to a
possible sleep-with-lock situation. The lock is obtained
in enable_swap_info().

The patch replaces GFP_KERNEL with GFP_IOFS, which is
GFP_KERNEL & ~__GFP_WAIT.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 855a5bb..96ca0ee 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1668,7 +1668,7 @@ static int zcache_new_pool(uint16_t cli_id, uint32_t flags)
 	if (cli == NULL)
 		goto out;
 	atomic_inc(&cli->refcount);
-	pool = kmalloc(sizeof(struct tmem_pool), GFP_KERNEL);
+	pool = kmalloc(sizeof(struct tmem_pool), GFP_IOFS);
 	if (pool == NULL) {
 		pr_info("zcache: pool creation failed: out of memory\n");
 		goto out;
-- 
1.7.4.1

