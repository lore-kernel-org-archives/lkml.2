Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2KNF7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:59:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756318Ab2KNFut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:49 -0500
Message-Id: <20121114053940.780944643@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:23 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 50/82] target: Avoid integer overflow in se_dev_align_max_sectors()
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_device.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -835,20 +835,20 @@ int se_dev_check_shutdown(struct se_devi
 
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


