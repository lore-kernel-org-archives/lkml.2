Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251Ab1F1QEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:04:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40455 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754739Ab1F1QCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:02:15 -0400
X-Sasl-enc: Zmek03r1JNmlf0w+o+kuYyLQQNnWw9ygt0RbBZK8DGNw 1309276934
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: J Freyensee <james_p_freyensee@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/9] pti: double-free security PTI fix
Date: Tue, 28 Jun 2011 09:02:02 -0700
Message-Id: <1309276926-1327-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309276926-1327-1-git-send-email-gregkh@suse.de>
References: <20110628153911.GD32710@kroah.com>
 <1309276926-1327-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch fixes a double-free error that will not always be
seen unless /dev/pti char interface is stressed.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.5.4

