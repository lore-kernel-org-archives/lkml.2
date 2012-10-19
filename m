Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab2JSByZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 21:54:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62496 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2JSByY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 21:54:24 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Shuah Khan <shuah.khan@hp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jakub Kicinski <kubakici@wp.pl>, Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH v1] lib/dma-debug.c: fix __hash_bucket_find
Date: Fri, 19 Oct 2012 09:54:07 +0800
Message-Id: <1350611647-15023-1-git-send-email-ming.lei@canonical.com>
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
Cc: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
v1:
	- initialize 'last_lvl' as -1 to simplify the fix

 lib/dma-debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 94aa94e..59f4a1a 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -277,7 +277,7 @@ static struct dma_debug_entry *__hash_bucket_find(struct hash_bucket *bucket,
 						  match_fn match)
 {
 	struct dma_debug_entry *entry, *ret = NULL;
-	int matches = 0, match_lvl, last_lvl = 0;
+	int matches = 0, match_lvl, last_lvl = -1;
 
 	list_for_each_entry(entry, &bucket->list, list) {
 		if (!match(ref, entry))
@@ -306,7 +306,7 @@ static struct dma_debug_entry *__hash_bucket_find(struct hash_bucket *bucket,
 		} else if (match_lvl > last_lvl) {
 			/*
 			 * We found an entry that fits better then the
-			 * previous one
+			 * previous one or it is the 1st match.
 			 */
 			last_lvl = match_lvl;
 			ret      = entry;
-- 
1.7.9.5

