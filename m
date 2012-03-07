Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab2CGC0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:26:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60291 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2CGC0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:26:15 -0500
Date: Tue, 6 Mar 2012 18:26:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch] mm, hugetlb: add thread name and pid to SHM_HUGETLB mlock
 rlimit warning
Message-ID: <alpine.DEB.2.00.1203061825070.9015@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the thread name and pid of the application that is allocating shm
segments with MAP_HUGETLB without being a part of
/proc/sys/vm/hugetlb_shm_group or having CAP_IPC_LOCK.

This identifies the application so it may be fixed by avoiding using the
deprecated exception (see Documentation/feature-removal-schedule.txt).

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/hugetlbfs/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -946,7 +946,11 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
 		*user = current_user();
 		if (user_shm_lock(size, *user)) {
-			printk_once(KERN_WARNING "Using mlock ulimits for SHM_HUGETLB is deprecated\n");
+			task_lock(current);
+			printk_once(KERN_WARNING
+				"%s (%d): Using mlock ulimits for SHM_HUGETLB is deprecated\n",
+				current->comm, current->pid);
+			task_unlock(current);
 		} else {
 			*user = NULL;
 			return ERR_PTR(-EPERM);
