Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab2CBG7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:59:07 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:21063 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab2CBG7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:59:05 -0500
Date: Fri, 2 Mar 2012 09:58:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] dma-debug: debugfs_create_bool() takes a u32 pointer
Message-ID: <20120302065832.GE24508@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F506FA4.0016,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though it has "bool" in the name, you have pass a u32 pointer to
debugfs_create_bool().  Otherwise you get memory corruption in
write_file_bool().  Fortunately in this case the corruption happens in
an alignment hole between variables so it doesn't cause any problems.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 13ef233..08cd5a6 100644
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
 
