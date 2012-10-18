Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2JRPir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:38:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52672 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2JRPiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:38:46 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Shuah Khan <shuah.khan@hp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH] lib/dma-debug.c: fix __hash_bucket_find
Date: Thu, 18 Oct 2012 23:38:19 +0800
Message-Id: <1350574699-6419-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is only one match, the unique matched entry should be returned.

Without the fix, the commit f62566214fe31c9f9b3218a42f1b19e6a9e6844a

	dma-debug: new interfaces to debug dma mapping errors

can't work reliably because only device and dma_addr are passed to
dma_mapping_error().

Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Shuah Khan <shuah.khan@hp.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 lib/dma-debug.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 94aa94e..be132f3 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -283,6 +283,10 @@ static struct dma_debug_entry *__hash_bucket_find(struct hash_bucket *bucket,
 		if (!match(ref, entry))
 			continue;
 
+		/* record the first match */
+		if (!ret)
+			ret = entry;
+
 		/*
 		 * Some drivers map the same physical address multiple
 		 * times. Without a hardware IOMMU this results in the
-- 
1.7.9.5

