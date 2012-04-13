Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab2DMJ7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:59:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53039 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934357Ab2DMJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:59:05 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: cl@linux.com, akpm@linux-foundation.org
Cc: hughd@google.com, dave@linux.vnet.ibm.com, ebiederm@xmission.com,
        davej@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 2/2] mm: fix NULL ptr dereference in move_pages
Date: Fri, 13 Apr 2012 08:58:22 -0400
Message-Id: <1334321902-7143-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334321902-7143-1-git-send-email-levinsasha928@gmail.com>
References: <1334321902-7143-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3268c63 ("mm: fix move/migrate_pages() race on task struct") has added
an odd construct where 'mm' is checked for being NULL, and if it is, it would
get dereferenced anyways by mput()ing it.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/migrate.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 51c08a0..1107238 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1388,14 +1388,14 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
 	mm = get_task_mm(task);
 	put_task_struct(task);
 
-	if (mm) {
-		if (nodes)
-			err = do_pages_move(mm, task_nodes, nr_pages, pages,
-					    nodes, status, flags);
-		else
-			err = do_pages_stat(mm, nr_pages, pages, status);
-	} else
-		err = -EINVAL;
+	if (!mm)
+		return -EINVAL;
+
+	if (nodes)
+		err = do_pages_move(mm, task_nodes, nr_pages, pages,
+				    nodes, status, flags);
+	else
+		err = do_pages_stat(mm, nr_pages, pages, status);
 
 	mmput(mm);
 	return err;
-- 
1.7.8.5

