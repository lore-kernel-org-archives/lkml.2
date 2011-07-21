Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1GUQEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:04:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab1GUQEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:12 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] dlm: don't do pointless NULL check, use kzalloc and fix order of arguments
Date: Thu, 21 Jul 2011 11:04:01 -0500
Message-Id: <1311264247-28129-5-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

In fs/dlm/lock.c in the dlm_scan_waiters() function there are 3 small
issues:

1) There's no need to test the return value of the allocation and do a
memset if is succeedes. Just use kzalloc() to obtain zeroed memory.

2) Since kfree() handles NULL pointers gracefully, the test of
'warned' against NULL before the kfree() after the loop is completely
pointless. Remove it.

3) The arguments to kmalloc() (now kzalloc()) were swapped. Thanks to
Dr. David Alan Gilbert for pointing this out.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index f71d0b5..84c52e6 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -849,9 +849,7 @@ void dlm_scan_waiters(struct dlm_ls *ls)
 
 		if (!num_nodes) {
 			num_nodes = ls->ls_num_nodes;
-			warned = kmalloc(GFP_KERNEL, num_nodes * sizeof(int));
-			if (warned)
-				memset(warned, 0, num_nodes * sizeof(int));
+			warned = kzalloc(num_nodes * sizeof(int), GFP_KERNEL);
 		}
 		if (!warned)
 			continue;
@@ -863,9 +861,7 @@ void dlm_scan_waiters(struct dlm_ls *ls)
 			  dlm_config.ci_waitwarn_us, lkb->lkb_wait_nodeid);
 	}
 	mutex_unlock(&ls->ls_waiters_mutex);
-
-	if (warned)
-		kfree(warned);
+	kfree(warned);
 
 	if (debug_expired)
 		log_debug(ls, "scan_waiters %u warn %u over %d us max %lld us",
-- 
1.7.6

