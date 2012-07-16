Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2GPQQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:16:23 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50459 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2GPQQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:16:17 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Sasha Levin <levinsasha928@gmail.com>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH 2/3] mm: fix possible incorrect return value of migrate_pages() syscall
Date: Tue, 17 Jul 2012 01:14:31 +0900
Message-Id: <1342455272-32703-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342455272-32703-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1342455272-32703-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_migrate_pages() can return the number of pages not migrated.
Because migrate_pages() syscall return this value directly,
migrate_pages() syscall may return the number of pages not migrated.
In fail case in migrate_pages() syscall, we should return error value.
So change err to -EIO

Additionally, Correct comment above do_migrate_pages()

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Christoph Lameter <cl@linux.com>

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 1d771e4..f7df271 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -948,7 +948,7 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
  * Move pages between the two nodesets so as to preserve the physical
  * layout as much as possible.
  *
- * Returns the number of page that could not be moved.
+ * Returns error or the number of pages not migrated.
  */
 int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
 		     const nodemask_t *to, int flags)
@@ -1382,6 +1382,8 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 
 	err = do_migrate_pages(mm, old, new,
 		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
+	if (err > 0)
+		err = -EIO;
 
 	mmput(mm);
 out:
-- 
1.7.9.5

