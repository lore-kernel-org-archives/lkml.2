Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab2KOE0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:26:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:49636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993154Ab2KOEMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 08/57] target: Avoid integer overflow in se_dev_align_max_sectors()
Date: Wed, 14 Nov 2012 20:11:16 -0800
Message-Id: <20121115040933.723179110@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_device.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -826,20 +826,20 @@ int se_dev_check_shutdown(struct se_devi
 
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
 
-	return max_sectors;
+	if (max_sectors != aligned_max_sectors)
+		pr_info("Rounding down aligned max_sectors from %u to %u\n",
+			max_sectors, aligned_max_sectors);
+
+	return aligned_max_sectors;
 }
 
 void se_dev_set_default_attribs(


