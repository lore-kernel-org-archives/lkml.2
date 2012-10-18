Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2JRLDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:03:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:54470 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab2JRLDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:03:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="157620868"
From: dragos.tatulea@intel.com
To: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com,
        Dragos Tatulea <dragos.tatulea@intel.com>
Subject: [PATCH v3 7/9] pstore: make sure pstore_write exists on flush error
Date: Thu, 18 Oct 2012 14:06:05 +0300
Message-Id: <1350558367-31801-8-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
References: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
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

