Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1HVTb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:31:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51167 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1HVTbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:31:17 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: ascardo@holoscopio.com, dan.magenheimer@oracle.com,
        sjenning@linux.vnet.ibm.com, rdunlap@xenotime.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: zcache: fix possible sleep under lock
Date: Mon, 22 Aug 2011 14:30:38 -0500
Message-Id: <1314041438-19156-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zcache_new_pool() calls kmalloc() with GFP_KERNEL which has
__GFP_WAIT set.  However, zcache_new_pool() gets called on
a stack that holds the swap_lock spinlock, leading to a
possible sleep-with-lock situation. The lock is obtained
in enable_swap_info().

The patch replaces GFP_KERNEL with GFP_ATOMIC.

v2: replace with GFP_ATOMIC, not GFP_IOFS

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 855a5bb..cdf0128 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1668,7 +1668,7 @@ static int zcache_new_pool(uint16_t cli_id, uint32_t flags)
 	if (cli == NULL)
 		goto out;
 	atomic_inc(&cli->refcount);
-	pool = kmalloc(sizeof(struct tmem_pool), GFP_KERNEL);
+	pool = kmalloc(sizeof(struct tmem_pool), GFP_ATOMIC);
 	if (pool == NULL) {
 		pr_info("zcache: pool creation failed: out of memory\n");
 		goto out;
-- 
1.7.4.1

