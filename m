Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841Ab2EJWOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:14:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44594 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761814Ab2EJWOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:14:40 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] printk: correctly align __log_buf
Date: Thu, 10 May 2012 16:14:33 -0600
Message-Id: <1336688073-10664-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

__log_buf must be aligned, because a 64-bit value is written directly
to it as part of struct log. Alignment of the log entries is typically
handled by log_store(), but this only triggers for subsequent entries,
not the very first (or wrapped) entries.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 kernel/printk.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 7b43295..7e82fb7 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -227,8 +227,13 @@ static u32 clear_idx;
 #define LOG_LINE_MAX 1024
 
 /* record buffer */
+#if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#define LOG_ALIGN 4
+#else
+#define LOG_ALIGN 8
+#endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-static char __log_buf[__LOG_BUF_LEN];
+static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
@@ -279,12 +284,6 @@ static u32 log_next(u32 idx)
 	return idx + msg->len;
 }
 
-#if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-#define LOG_ALIGN 4
-#else
-#define LOG_ALIGN 8
-#endif
-
 /* insert record into the buffer, discard old ones, update heads */
 static void log_store(int facility, int level,
 		      const char *dict, u16 dict_len,
-- 
1.7.0.4

