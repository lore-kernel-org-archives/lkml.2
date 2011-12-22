Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1LVKyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:54:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:32912 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab1LVKyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:54:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99203889"
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [PATCH v3 1/1] vfs: iversion truncate bug fix
Date: Thu, 22 Dec 2011 12:54:28 +0200
Message-Id: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a file is truncated with truncate()/ftruncate() and then closed,
iversion is not updated. This patch uses ATTR_SIZE flag as an indication
to increment iversion.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 fs/attr.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 7ee7ba4..b8f55c4 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -176,6 +176,11 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 			return -EPERM;
 	}
 
+	if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
+		if (attr->ia_size != inode->i_size)
+			inode_inc_iversion(inode);
+	}
+
 	if ((ia_valid & ATTR_MODE)) {
 		mode_t amode = attr->ia_mode;
 		/* Flag setting protected by i_mutex */
-- 
1.7.4.1

