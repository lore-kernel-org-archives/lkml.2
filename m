Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab2LMODW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:03:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44139 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2LMODQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 041/241] target: Avoid integer overflow in se_dev_align_max_sectors()
Date: Thu, 13 Dec 2012 11:56:46 -0200
Message-Id: <1355407206-17100-42-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 3e03989b5868acf69a391a424dc71fcd6cc48167 upstream.

The expression (max_sectors * block_size) might overflow a u32
(indeed, since iblock sets max_hw_sectors to UINT_MAX, it is
guaranteed to overflow and end up with a much-too-small result in many
common cases).  Fix this by doing an equivalent calculation that
doesn't require multiplication.

While we're touching this code, avoid splitting a printk format across
two lines and use pr_info(...) instead of printk(KERN_INFO ...).

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_device.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 5ad9728..8542099 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -824,20 +824,20 @@ int se_dev_check_shutdown(struct se_device *dev)
 
 u32 se_dev_align_max_sectors(u32 max_sectors, u32 block_size)
 {
-	u32 tmp, aligned_max_sectors;
+	u32 aligned_max_sectors;
+	u32 alignment;
 	/*
 	 * Limit max_sectors to a PAGE_SIZE aligned value for modern
 	 * transport_allocate_data_tasks() operation.
 	 */
-	tmp = rounddown((max_sectors * block_size), PAGE_SIZE);
-	aligned_max_sectors = (tmp / block_size);
-	if (max_sectors != aligned_max_sectors) {
-		printk(KERN_INFO "Rounding down aligned max_sectors from %u"
-				" to %u\n", max_sectors, aligned_max_sectors);
-		return aligned_max_sectors;
-	}
+	alignment = max(1ul, PAGE_SIZE / block_size);
+	aligned_max_sectors = rounddown(max_sectors, alignment);
+
+	if (max_sectors != aligned_max_sectors)
+		pr_info("Rounding down aligned max_sectors from %u to %u\n",
+			max_sectors, aligned_max_sectors);
 
-	return max_sectors;
+	return aligned_max_sectors;
 }
 
 void se_dev_set_default_attribs(
-- 
1.7.9.5

