Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab1GCTk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 15:40:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44452 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1GCTk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 15:40:26 -0400
From: Dmitry Fink <finikk@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Dmitry Fink <dmitry.fink@palm.com>
Subject: [PATCH 1/1] mmap: Don't count shmem pages as free in __vm_enough_memory
Date: Sun,  3 Jul 2011 12:39:23 -0700
Message-Id: <1309721963-5577-1-git-send-email-dmitry.fink@palm.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shmem pages can't be reclaimed and if they are swapped out
that doesn't affect the overall available memory in the system,
so don't count them along with the rest of the file backed pages.

Signed-off-by: Dmitry Fink <dmitry.fink@palm.com>
---
 mm/mmap.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index b88624f..3a34dc2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -119,6 +119,13 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 		unsigned long n;
 
 		free = global_page_state(NR_FILE_PAGES);
+
+		/* shmem pages shouldn't be counted as free in this
+		 * case, they can't be purged, only swapped out, and
+		 * that won't affect the overall amount of available
+		 * memory in the system. */
+		free -= global_page_state(NR_SHMEM);
+
 		free += nr_swap_pages;
 
 		/*
-- 
1.6.0.4

