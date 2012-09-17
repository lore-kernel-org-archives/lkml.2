Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2IQAuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33336 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970Ab2IQAt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:26 -0400
Message-Id: <20120917003627.027819750@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 006/135] iwlwifi: protect SRAM debugfs
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 4fc79db178f0a0ede479b4713e00df2d106028b3 upstream.

If the device is not started, we can't read its
SRAM and attempting to do so will cause issues.
Protect the debugfs read.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Pass iwl_shared not iwl_priv pointer to iwl_is_ready_rf()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -232,6 +232,9 @@ static ssize_t iwl_dbgfs_sram_read(struc
 	struct iwl_priv *priv = file->private_data;
 	size_t bufsz;
 
+	if (!iwl_is_ready_rf(priv->shrd))
+		return -EAGAIN;
+
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
 		priv->dbgfs_sram_offset = 0x800000;


