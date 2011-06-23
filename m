Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab1FWRhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:37:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:34827 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933509Ab1FWRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Don Skidmore <donald.c.skidmore@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 153/247] ixgbe: fix for 82599 erratum on Header Splitting
Date: Thu, 23 Jun 2011 13:33:41 -0400
Message-Id: <1308850515-15242-94-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Skidmore <donald.c.skidmore@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a124339ad28389093ed15eca990d39c51c5736cc upstream.

We have found a hardware erratum on 82599 hardware that can lead to
unpredictable behavior when Header Splitting mode is enabled.  So
we are no longer enabling this feature on affected hardware.

Please see the 82599 Specification Update for more information.

Signed-off-by: Don Skidmore <donald.c.skidmore@intel.com>
Tested-by: Stephen Ko <stephen.s.ko@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/ixgbe/ixgbe_main.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 156dfcb..f76f4f5 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -2250,9 +2250,16 @@ static void ixgbe_configure_rx(struct ixgbe_adapter *adapter)
 	int rx_buf_len;
 
 	/* Decide whether to use packet split mode or not */
+	/* On by default */
+	adapter->flags |= IXGBE_FLAG_RX_PS_ENABLED;
+
 	/* Do not use packet split if we're in SR-IOV Mode */
-	if (!adapter->num_vfs)
-		adapter->flags |= IXGBE_FLAG_RX_PS_ENABLED;
+	if (adapter->num_vfs)
+		adapter->flags &= ~IXGBE_FLAG_RX_PS_ENABLED;
+
+	/* Disable packet split due to 82599 erratum #45 */
+	if (hw->mac.type == ixgbe_mac_82599EB)
+		adapter->flags &= ~IXGBE_FLAG_RX_PS_ENABLED;
 
 	/* Set the RX buffer length according to the mode */
 	if (adapter->flags & IXGBE_FLAG_RX_PS_ENABLED) {
-- 
1.7.4.4

