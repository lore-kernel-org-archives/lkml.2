Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2H1Ar6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 20:47:58 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:16314 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2H1Ar5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 20:47:57 -0400
From: T Makphaibulchoke <tmac@hp.com>
To: akpm@linux-foundation.org, linuxram@us.ibm.com,
        paul.gortmaker@windriver.com, weiyang@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Cc: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH] kernel/resource.c: fix stack overflow in __reserve_region_with_split
Date: Mon, 27 Aug 2012 18:47:54 -0600
Message-Id: <1346114874-6862-1-git-send-email-tmac@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using recurvise call to try adding a non-conflicting region in the function
__reserve_region_with_split() could result in a stack overflow in the case
that the recursive calls are too deep.  Convert the recursive calls to
an iterative loop to avoid the problem.

Signed-off-by: T Makphaibulchoke <tmac@hp.com>
---
 kernel/resource.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 34d4588..d6e9f9c 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -768,25 +768,29 @@ static void __init __reserve_region_with_split(struct resource *root,
 		return;
 
 	res->name = name;
-	res->start = start;
-	res->end = end;
 	res->flags = IORESOURCE_BUSY;
 
-	conflict = __request_resource(parent, res);
-	if (!conflict)
-		return;
+	while (1) {
+		res->start = start;
+		res->end = end;
 
-	/* failed, split and try again */
-	kfree(res);
+		conflict = __request_resource(parent, res);
+		if (!conflict)
+			break;
 
-	/* conflict covered whole area */
-	if (conflict->start <= start && conflict->end >= end)
-		return;
+		/* conflict covered whole area */
+		if (conflict->start <= start && conflict->end >= end) {
+			kfree(res);
+			break;
+		}
+
+		/* failed, split and try again */
+		if (conflict->start > start)
+			end = conflict->start - 1;
+		if (conflict->end < end)
+			start = conflict->end + 1;
+	}
 
-	if (conflict->start > start)
-		__reserve_region_with_split(root, start, conflict->start-1, name);
-	if (conflict->end < end)
-		__reserve_region_with_split(root, conflict->end+1, end, name);
 }
 
 void __init reserve_region_with_split(struct resource *root,
-- 
1.7.1

