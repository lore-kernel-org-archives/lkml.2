Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1ABICr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:02:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:34832 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1ABHWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jerome Marchand <jmarchan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 070/260] kernel/groups.c: fix integer overflow in groups_search
Date: Sun,  2 Jan 2011 02:16:06 -0500
Message-Id: <1293952756-15010-71-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:23.0523 (UTC) FILETIME=[A9076930:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Marchand <jmarchan@redhat.com>

commit 1c24de60e50fb19b94d94225458da17c720f0729 upstream.

gid_t is a unsigned int.  If group_info contains a gid greater than
MAX_INT, groups_search() function may look on the wrong side of the search
tree.

This solves some unfair "permission denied" problems.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/groups.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/groups.c b/kernel/groups.c
index 2b45b2e..f0c2528 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -143,10 +143,9 @@ int groups_search(const struct group_info *group_info, gid_t grp)
 	right = group_info->ngroups;
 	while (left < right) {
 		unsigned int mid = (left+right)/2;
-		int cmp = grp - GROUP_AT(group_info, mid);
-		if (cmp > 0)
+		if (grp > GROUP_AT(group_info, mid))
 			left = mid + 1;
-		else if (cmp < 0)
+		else if (grp < GROUP_AT(group_info, mid))
 			right = mid;
 		else
 			return 1;
-- 
1.7.3.3

