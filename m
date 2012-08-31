Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2HaVEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:04:30 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:36223 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HaVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:04:28 -0400
From: T Makphaibulchoke <tmac@hp.com>
To: akpm@linux-foundation.org, linuxram@us.ibm.com,
        paul.gortmaker@windriver.com, weiyang@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Cc: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH v2] kernel/resource.c: fix stack overflow in __reserve_region_with_split
Date: Fri, 31 Aug 2012 15:04:25 -0600
Message-Id: <1346447065-15399-1-git-send-email-tmac@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using recurvise call to try adding a non-conflicting region in the function
__reserve_region_with_split() could result in a stack overflow in the case
that the recursive calls are too deep.  Convert the recursive calls to
an iterative loop to avoid the problem.

Signed-off-by: T Makphaibulchoke <tmac@hp.com>

--
Change since v1:
* Fixing __resrve_region_with_split() to ensure a reqioon reserve request is
  satisfied to the fullest extent, minus any overlapping conflicting regions.
---
 kernel/resource.c |   47 +++++++++++++++++++++++++++++++++++------------
 1 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 34d4588..f0cdeb6 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -763,6 +763,7 @@ static void __init __reserve_region_with_split(struct resource *root,
 	struct resource *parent = root;
 	struct resource *conflict;
 	struct resource *res = kzalloc(sizeof(*res), GFP_ATOMIC);
+	struct resource *next_res = NULL;
 
 	if (!res)
 		return;
@@ -772,21 +773,43 @@ static void __init __reserve_region_with_split(struct resource *root,
 	res->end = end;
 	res->flags = IORESOURCE_BUSY;
 
-	conflict = __request_resource(parent, res);
-	if (!conflict)
-		return;
+	while (1) {
 
-	/* failed, split and try again */
-	kfree(res);
+		conflict = __request_resource(parent, res);
+		if (!conflict) {
+			if (!next_res)
+				break;
+			res = next_res;
+			next_res = NULL;
+			continue;
+		}
 
-	/* conflict covered whole area */
-	if (conflict->start <= start && conflict->end >= end)
-		return;
+		/* conflict covered whole area */
+		if (conflict->start <= res->start &&
+				conflict->end >= res->end) {
+			kfree(res);
+			WARN_ON(next_res);
+			break;
+		}
+
+		/* failed, split and try again */
+		if (conflict->start > res->start) {
+			end = res->end;
+			res->end = conflict->start - 1;
+			if (conflict->end < end) {
+				next_res = kzalloc(sizeof(*res), GFP_ATOMIC);
+				if (!next_res) {
+					kfree(res);
+					break;
+				}
+				next_res->start = conflict->end + 1;
+				next_res->end = end;
+			}
+		} else {
+			res->start = conflict->end + 1;
+		}
+	}
 
-	if (conflict->start > start)
-		__reserve_region_with_split(root, start, conflict->start-1, name);
-	if (conflict->end < end)
-		__reserve_region_with_split(root, conflict->end+1, end, name);
 }
 
 void __init reserve_region_with_split(struct resource *root,
-- 
1.7.1

