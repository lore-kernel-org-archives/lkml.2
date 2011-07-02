Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1GBSIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 14:08:19 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13705 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1GBSIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 14:08:19 -0400
Date: Sat, 2 Jul 2011 19:59:01 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: David Teigland <teigland@redhat.com>
cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Christine Caulfield <ccaulfie@redhat.com>
Subject: [PATCH] fs, dlm: don't do pointless NULL check and use kzalloc
Message-ID: <alpine.LNX.2.00.1107021957130.16316@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fs/dlm/lock.c in the dlm_scan_waiters() function there are 2 small
issues:

1) There's no need to test the return value of the allocation and do a
memset if is succeedes. Just use kzalloc() to obtain zeroed memory.

2) Since kfree() handles NULL pointers gracefully, the test of
'warned' against NULL before the kfree() after the loop is completely
pointless. Remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index f71d0b5..26d6d88 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -849,9 +849,7 @@ void dlm_scan_waiters(struct dlm_ls *ls)
 
 		if (!num_nodes) {
 			num_nodes = ls->ls_num_nodes;
-			warned = kmalloc(GFP_KERNEL, num_nodes * sizeof(int));
-			if (warned)
-				memset(warned, 0, num_nodes * sizeof(int));
+			warned = kzalloc(GFP_KERNEL, num_nodes * sizeof(int));
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



-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

