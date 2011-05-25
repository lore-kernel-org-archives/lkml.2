Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1EYViW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:38:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:7825 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab1EYViT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:38:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,269,1304319600"; 
   d="scan'208";a="4873170"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, christophe.guerard@intel.com,
        james_p_freyensee@linux.intel.com, rocher.jeremy@gmail.com
Subject: [PATCH] double-free security PTI fix
Date: Wed, 25 May 2011 14:38:18 -0700
Message-Id: <1306359498-6839-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch fixes a double-free error that will not always be
seen unless /dev/pti char interface is stressed.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index bb6f925..be48573 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -317,7 +317,8 @@ EXPORT_SYMBOL_GPL(pti_request_masterchannel);
  *				a master, channel ID address
  *				used to write to PTI HW.
  *
- * @mc: master, channel apeture ID address to be released.
+ * @mc: master, channel apeture ID address to be released.  This
+ *      will de-allocate the structure via kfree().
  */
 void pti_release_masterchannel(struct pti_masterchannel *mc)
 {
@@ -581,7 +582,7 @@ static int pti_char_open(struct inode *inode, struct file *filp)
 static int pti_char_release(struct inode *inode, struct file *filp)
 {
 	pti_release_masterchannel(filp->private_data);
-	kfree(filp->private_data);
+	filp->private_data = NULL;
 	return 0;
 }
 
-- 
1.7.2.3

