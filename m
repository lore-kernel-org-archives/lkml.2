Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab1KVK1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:27:01 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:64930 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514Ab1KVK0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:26:50 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: kurt.hackel@oracle.com, paul.durrant@citrix.com, Ian.Campbell@citrix.com,
        annie.li@oracle.com
Subject: [PATCH 2/4] xen/granttable: Refactor some code
Date: Tue, 22 Nov 2011 18:26:46 +0800
Message-Id: <1321957606-10253-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4ECB77BB.9090401@oracle.com>
References: <4ECB77BB.9090401@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4ECB78E6.007A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Annie Li <annie.li@oracle.com>

Signed-off-by: Annie Li <annie.li@oracle.com>
---
 drivers/xen/grant-table.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 18355a5..0518d04 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -257,15 +257,17 @@ EXPORT_SYMBOL_GPL(gnttab_query_foreign_access);
 static int gnttab_end_foreign_access_ref_v1(grant_ref_t ref, int readonly)
 {
 	u16 flags, nflags;
+	u16 *pflags;
 
-	nflags = gnttab_shared.v1[ref].flags;
+	pflags = &gnttab_shared.v1[ref].flags;
+	nflags = *pflags;
 	do {
 		flags = nflags;
 		if (flags & (GTF_reading|GTF_writing)) {
 			printk(KERN_ALERT "WARNING: g.e. still in use!\n");
 			return 0;
 		}
-	} while ((nflags = sync_cmpxchg(&gnttab_shared.v1[ref].flags, flags, 0)) != flags);
+	} while ((nflags = sync_cmpxchg(pflags, flags, 0)) != flags);
 
 	return 1;
 }
@@ -316,20 +318,23 @@ static unsigned long gnttab_end_foreign_transfer_ref_v1(grant_ref_t ref)
 {
 	unsigned long frame;
 	u16           flags;
+	u16          *pflags;
+
+	pflags = &gnttab_shared.v1[ref].flags;
 
 	/*
 	 * If a transfer is not even yet started, try to reclaim the grant
 	 * reference and return failure (== 0).
 	 */
-	while (!((flags = gnttab_shared.v1[ref].flags) & GTF_transfer_committed)) {
-		if (sync_cmpxchg(&gnttab_shared.v1[ref].flags, flags, 0) == flags)
+	while (!((flags = *pflags) & GTF_transfer_committed)) {
+		if (sync_cmpxchg(pflags, flags, 0) == flags)
 			return 0;
 		cpu_relax();
 	}
 
 	/* If a transfer is in progress then wait until it is completed. */
 	while (!(flags & GTF_transfer_completed)) {
-		flags = gnttab_shared.v1[ref].flags;
+		flags = *pflags;
 		cpu_relax();
 	}
 
-- 
1.7.6.4

