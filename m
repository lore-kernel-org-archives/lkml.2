Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab0ERSUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:20:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0ERSUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:20:33 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, jens.axboe@oracle.com, vgoyal@redhat.com,
       Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/4] jbd: yield the device queue when waiting for commits
Date: Tue, 18 May 2010 14:20:19 -0400
Message-Id: <1274206820-17071-4-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
References: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gets CFQ back in line with deadline for iozone runs, especially
those testing small files + fsync timings.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/jbd/journal.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index bd224ee..267108f 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -36,6 +36,7 @@
 #include <linux/poison.h>
 #include <linux/proc_fs.h>
 #include <linux/debugfs.h>
+#include <linux/blkdev.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -549,6 +550,11 @@ int log_wait_commit(journal_t *journal, tid_t tid)
 	while (tid_gt(tid, journal->j_commit_sequence)) {
 		jbd_debug(1, "JBD: want %d, j_commit_sequence=%d\n",
 				  tid, journal->j_commit_sequence);
+		/*
+		 * Give up our I/O scheduler time slice to allow the journal
+		 * thread to issue I/O.
+		 */
+		blk_yield(journal->j_dev->bd_disk->queue, journal->j_task);
 		wake_up(&journal->j_wait_commit);
 		spin_unlock(&journal->j_state_lock);
 		wait_event(journal->j_wait_done_commit,
-- 
1.6.5.2

