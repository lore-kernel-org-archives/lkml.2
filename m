Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab2KPDc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 22:32:56 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37848 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2KPDcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 22:32:55 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: jeffrey.t.kirsher@intel.com
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH] net/ethernet/intel/ixgbe/ixgbe_debugfs.c: fix error handling in ixgbe_dbg_reg_ops_read().
Date: Fri, 16 Nov 2012 04:26:50 +0100
Message-Id: <1353036410-14439-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() cannot return a negative value: it returns the number of bytes
that could not be copied.

Return -EFAULT on failure rather than the number of bytes that could not be
copied, as this seems more standard.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
index 8d3a218..77a3598 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
@@ -62,7 +62,6 @@ static ssize_t ixgbe_dbg_reg_ops_read(struct file *filp, char __user *buffer,
 {
 	struct ixgbe_adapter *adapter = filp->private_data;
 	char buf[256];
-	int bytes_not_copied;
 	int len;
 
 	/* don't allow partial reads */
@@ -73,9 +72,8 @@ static ssize_t ixgbe_dbg_reg_ops_read(struct file *filp, char __user *buffer,
 		       adapter->netdev->name, ixgbe_dbg_reg_ops_buf);
 	if (count < len)
 		return -ENOSPC;
-	bytes_not_copied = copy_to_user(buffer, buf, len);
-	if (bytes_not_copied < 0)
-		return bytes_not_copied;
+	if (copy_to_user(buffer, buf, len) > 0)
+		return -EFAULT;
 
 	*ppos = len;
 	return len;
-- 
1.7.10.4

