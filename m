Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab1F2VSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:18:40 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19068 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1F2VSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:18:37 -0400
Date: Wed, 29 Jun 2011 23:09:27 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
        Christine Caulfield <ccaulfie@redhat.com>
Subject: [PATCH] fs, dlm: Don't leak, don't do pointless NULL checks and use
 kzalloc
Message-ID: <alpine.LNX.2.00.1106292304380.3747@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fs/dlm/lock.c in the dlm_scan_waiters() function there are 3 small
issues:

1) first time through the loop we allocate memory for 'warned', if we
then (in the loop) don't take the "if (!warned)" path and loop again,
the second time through the loop we'll allocate memory again and store
it to 'warned' without freeing the previous allocation - this leaks
memory.
Fix this by kfree'ing 'warned' just before the in-loop allocation. The
first time through the loop this will result in a pointless
kfree(NULL), but that's a small price to pay for avoiding a mem leak
IMHO.

2) There's no need to test the return value of the allocation and do a
memset if is succeedes. Just use kzalloc() to obtain zeroed memory.

3) Since kfree() handles NULL pointers gracefully, the test of
'warned' against NULL before the kfree() after the loop is completely
pointless. Remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/dlm/lock.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

  compile tested only.

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index f71d0b5..a18ecff 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -849,9 +849,8 @@ void dlm_scan_waiters(struct dlm_ls *ls)
 
 		if (!num_nodes) {
 			num_nodes = ls->ls_num_nodes;
-			warned = kmalloc(GFP_KERNEL, num_nodes * sizeof(int));
-			if (warned)
-				memset(warned, 0, num_nodes * sizeof(int));
+			kfree(warned);
+			warned = kzalloc(GFP_KERNEL, num_nodes * sizeof(int));
 		}
 		if (!warned)
 			continue;
@@ -863,9 +862,7 @@ void dlm_scan_waiters(struct dlm_ls *ls)
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

