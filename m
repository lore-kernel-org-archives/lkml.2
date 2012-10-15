Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab2JOLim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:38:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:48571 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2JOLhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:37:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="227002394"
From: dragos.tatulea@intel.com
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com,
        Dragos Tatulea <dragos.tatulea@intel.com>
Subject: [PATCH 7/8] pstore: make sure pstore_write exists on flush error
Date: Mon, 15 Oct 2012 14:40:09 +0300
Message-Id: <1350301210-16953-8-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350301210-16953-1-git-send-email-dragos.tatulea@intel.com>
References: <1350301210-16953-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dragos Tatulea <dragos.tatulea@intel.com>

Return error if flushing to backend failed.

Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
---
 fs/pstore/platform.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 3a4c38f..25f59ed 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -445,7 +445,7 @@ void pstore_del_timer(void)
 int pstore_write(enum pstore_type_id type, const char *buf, size_t size)
 {
 	size_t len;
-	int err = 0, err2;
+	int err = 0;
 
 	if (!psinfo)
 		return -ENODEV;
@@ -461,16 +461,14 @@ int pstore_write(enum pstore_type_id type, const char *buf, size_t size)
 		psinfo->ext_part = 1;
 	}
 
-	while (size) {
+	while (size && !err) {
 		len = min(size, psinfo->bufsize - psinfo->ext_len);
 		memcpy(psinfo->buf + psinfo->ext_len, buf, len);
 		psinfo->ext_len += len;
 		buf += len;
 		size -= len;
 		if (psinfo->ext_len == psinfo->bufsize) {
-			err2 = pstore_ext_flush();
-			if (err2 && !err)
-				err = err2;
+			err = pstore_ext_flush();
 		}
 	}
 
-- 
1.7.9.5

