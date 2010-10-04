Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0JDJRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:17:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38756 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab0JDJRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kVAiqQTbDFk/wWtoE3mxymhnEbkdcrFe5ulQBvok0uAY062mc2hXRrzjwB6OhNev2J
         vckokTzSWpiTH/q2PzXgIr0b2SFW/3r61boRH4ypyzOs2aDgveC7MZjkS2BjZnrD7uEZ
         ULMTvySlGYDzIvTjWEz5WZi9fP4ln5iw7yBm8=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jbd: Use printk_ratelimit() in journal_alloc_journal_head()
Date: Mon,  4 Oct 2010 18:17:14 +0900
Message-Id: <1286183834-10548-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use printk_ratelimit() instead of doing it manually.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/journal.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 6f20a75..d66dd36 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1718,7 +1718,6 @@ static void journal_destroy_journal_head_cache(void)
 static struct journal_head *journal_alloc_journal_head(void)
 {
 	struct journal_head *ret;
-	static unsigned long last_warning;
 
 #ifdef CONFIG_JBD_DEBUG
 	atomic_inc(&nr_journal_heads);
@@ -1726,11 +1725,10 @@ static struct journal_head *journal_alloc_journal_head(void)
 	ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
 	if (ret == NULL) {
 		jbd_debug(1, "out of memory for journal_head\n");
-		if (time_after(jiffies, last_warning + 5*HZ)) {
+		if (printk_ratelimit())
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
 			       __func__);
-			last_warning = jiffies;
-		}
+
 		while (ret == NULL) {
 			yield();
 			ret = kmem_cache_alloc(journal_head_cache, GFP_NOFS);
-- 
1.7.0.4

