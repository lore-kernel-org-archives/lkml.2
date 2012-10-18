Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2JRIZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:25:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:17377 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab2JRIZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="207551991"
From: dragos.tatulea@intel.com
To: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com,
        Dragos Tatulea <dragos.tatulea@intel.com>
Subject: [PATCH v2 4/8] pstore: allow storing different type id's in ram backend
Date: Thu, 18 Oct 2012 11:28:24 +0300
Message-Id: <1350548908-24407-5-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350548908-24407-1-git-send-email-dragos.tatulea@intel.com>
References: <1350548908-24407-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dragos Tatulea <dragos.tatulea@intel.com>

Added pstore_type_id in message header when storing to ram.
On write, take into account the contents of this header and
set the type accordingly.

Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
---
 fs/pstore/ram.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1a4f6da..e1684ef 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -157,23 +157,30 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	time->tv_nsec = 0;
 
 	size = persistent_ram_old_size(prz);
+	if (!size)
+		return 0;
 	*buf = kmalloc(size, GFP_KERNEL);
 	if (*buf == NULL)
 		return -ENOMEM;
 	memcpy(*buf, persistent_ram_old(prz), size);
+	/* Read header. */
+	sscanf(*buf, "%u" RAMOOPS_KERNMSG_HDR "%lu.%lu",
+		type, &time->tv_sec, &time->tv_nsec);
+	time->tv_nsec *= 1000;
 
 	return size;
 }
 
-static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
+static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz,
+				     enum pstore_type_id type)
 {
 	char *hdr;
 	struct timeval timestamp;
 	size_t len;
 
 	do_gettimeofday(&timestamp);
-	hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
-		(long)timestamp.tv_sec, (long)timestamp.tv_usec);
+	hdr = kasprintf(GFP_ATOMIC, "%u" RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
+		type, (long)timestamp.tv_sec, (long)timestamp.tv_usec);
 	WARN_ON_ONCE(!hdr);
 	len = hdr ? strlen(hdr) : 0;
 	persistent_ram_write(prz, hdr, len);
@@ -204,9 +211,6 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 		return 0;
 	}
 
-	if (type != PSTORE_TYPE_DMESG)
-		return -EINVAL;
-
 	/* Out of the various dmesg dump types, ramoops is currently designed
 	 * to only store crash logs, rather than storing general kernel logs.
 	 */
@@ -226,7 +230,7 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 	if (part != 1)
 		return -ENOSPC;
 
-	hlen = ramoops_write_kmsg_hdr(prz);
+	hlen = ramoops_write_kmsg_hdr(prz, type);
 	if (size + hlen > prz->buffer_size)
 		size = prz->buffer_size - hlen;
 	persistent_ram_write(prz, buf, size);
-- 
1.7.9.5

