Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1LNQla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:41:30 -0500
Received: from mga12.intel.com ([143.182.124.36]:11737 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751047Ab1LNQl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:41:28 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Subject: [PATCH 1/1] do_truncate needs to increment iversion
Date: Wed, 14 Dec 2011 18:44:57 +0200
Message-Id: <09b6266e3209433bac9b57baf39e073945533d5a.1323880769.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA/EVM uses iversion to identify if file content has been changed.
It has been found that when file is opened, truncated with ftruncate()
and then closed, iversion is not updated.

This patch adds iversion incrementation to do_truncate().

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 fs/open.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 22c41b5..d7e8df2 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -56,6 +56,8 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 		newattrs.ia_valid |= ret | ATTR_FORCE;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
+	if (IS_I_VERSION(dentry->d_inode))
+		inode_inc_iversion(dentry->d_inode);
 	ret = notify_change(dentry, &newattrs);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return ret;
-- 
1.7.4.1

