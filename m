Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2DDB0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 21:26:15 -0400
Received: from mx4.wp.pl ([212.77.101.8]:50100 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab2DDB0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 21:26:13 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2012 21:26:13 EDT
From: Jakub Kicinski <kubakici@wp.pl>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH] dma-debug: release free_entries_lock before saving stack trace
Date: Wed,  4 Apr 2012 03:19:10 +0200
Message-Id: <1333502350-19420-1-git-send-email-kubakici@wp.pl>
X-Mailer: git-send-email 1.7.7.6
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0U00000 [cQOk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saving stack trace can take a while and once the entry
is allocated free_entries_lock is no longer needed.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
This gives me 20-25% increase in throughput of Ethernet NIC
on system with Intel Atom DN2800.
---
 lib/dma-debug.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index fea790a..2567755 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -431,7 +431,7 @@ static struct dma_debug_entry *__dma_entry_alloc(void)
  */
 static struct dma_debug_entry *dma_entry_alloc(void)
 {
-	struct dma_debug_entry *entry = NULL;
+	struct dma_debug_entry *entry;
 	unsigned long flags;
 
 	spin_lock_irqsave(&free_entries_lock, flags);
@@ -439,11 +439,14 @@ static struct dma_debug_entry *dma_entry_alloc(void)
 	if (list_empty(&free_entries)) {
 		pr_err("DMA-API: debugging out of memory - disabling\n");
 		global_disable = true;
-		goto out;
+		spin_unlock_irqrestore(&free_entries_lock, flags);
+		return NULL;
 	}
 
 	entry = __dma_entry_alloc();
 
+	spin_unlock_irqrestore(&free_entries_lock, flags);
+
 #ifdef CONFIG_STACKTRACE
 	entry->stacktrace.max_entries = DMA_DEBUG_STACKTRACE_ENTRIES;
 	entry->stacktrace.entries = entry->st_entries;
@@ -451,9 +454,6 @@ static struct dma_debug_entry *dma_entry_alloc(void)
 	save_stack_trace(&entry->stacktrace);
 #endif
 
-out:
-	spin_unlock_irqrestore(&free_entries_lock, flags);
-
 	return entry;
 }
 
-- 
1.7.7.6

