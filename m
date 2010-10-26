Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab0JZSEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:04:44 -0400
Received: from pecan.exetel.com.au ([220.233.0.17]:45462 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933462Ab0JZSEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:04:42 -0400
From: "Alex Dubov" <oakad@yahoo.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Maxim Levitsky" <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 1/4] memstick: avert possible race condition between idr_pre_get and idr_get_new
Date: Wed, 27 Oct 2010 04:41:08 +1100
Message-Id: <1288114871-805-2-git-send-email-oakad@yahoo.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1288114871-805-1-git-send-email-oakad@yahoo.com>
References: <1288114871-805-1-git-send-email-oakad@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/memstick.c    |   18 +++++++++++-------
 drivers/memstick/core/mspro_block.c |    6 ++++--
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index c00fe82..17c556c 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -510,14 +510,18 @@ int memstick_add_host(struct memstick_host *host)
 {
 	int rc;
 
-	if (!idr_pre_get(&memstick_host_idr, GFP_KERNEL))
-		return -ENOMEM;
+	while (1) {
+		if (!idr_pre_get(&memstick_host_idr, GFP_KERNEL))
+			return -ENOMEM;
 
-	spin_lock(&memstick_host_lock);
-	rc = idr_get_new(&memstick_host_idr, host, &host->id);
-	spin_unlock(&memstick_host_lock);
-	if (rc)
-		return rc;
+		spin_lock(&memstick_host_lock);
+		rc = idr_get_new(&memstick_host_idr, host, &host->id);
+		spin_unlock(&memstick_host_lock);
+		if (!rc)
+			break;
+		else if (rc != -EAGAIN)
+			return rc;
+	}
 
 	dev_set_name(&host->dev, "memstick%u", host->id);
 
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 02362ec..a167938 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1206,10 +1206,12 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
-	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL))
+	mutex_lock(&mspro_block_disk_lock);
+	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL)) {
+		mutex_unlock(&mspro_block_disk_lock);
 		return -ENOMEM;
+	}
 
-	mutex_lock(&mspro_block_disk_lock);
 	rc = idr_get_new(&mspro_block_disk_idr, card, &disk_id);
 	mutex_unlock(&mspro_block_disk_lock);
 
-- 
1.6.5.1

