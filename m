Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab2F0JJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:09:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34503 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab2F0JJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:09:30 -0400
Date: Wed, 27 Jun 2012 12:08:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Neil Horman <nhorman@tuxdriver.com>, Jakub Kicinski <kubakici@wp.pl>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2 -resend] dma-debug: debugfs_create_bool() takes a u32
 pointer
Message-ID: <20120627090854.GS31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though it has "bool" in the name, you have pass a u32 pointer to
debugfs_create_bool().  Otherwise you get memory corruption in
write_file_bool().  Fortunately in this case the corruption happens in
an alignment hole between variables so it doesn't cause any problems.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This was sent on Fri, 2 Mar 2012.

It's probably my fault the bug is still there.  I submitted the patch
but the feed back was that debugfs_create_bool() has a stupid API and
should take a pointer to a bool.  I said that yes, probably that is true
but only two places use the current API incorrectly and I fixed the
other place as well.

I assumed that both my patches would be merged and the person who cared
about API would fix the API but neither of my fixes were applied.

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 518aea7..66ce414 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -78,7 +78,7 @@ static LIST_HEAD(free_entries);
 static DEFINE_SPINLOCK(free_entries_lock);
 
 /* Global disable flag - will be set in case of an error */
-static bool global_disable __read_mostly;
+static u32 global_disable __read_mostly;
 
 /* Global error count */
 static u32 error_count;
@@ -657,7 +657,7 @@ static int dma_debug_fs_init(void)
 
 	global_disable_dent = debugfs_create_bool("disabled", 0444,
 			dma_debug_dent,
-			(u32 *)&global_disable);
+			&global_disable);
 	if (!global_disable_dent)
 		goto out_err;
 
