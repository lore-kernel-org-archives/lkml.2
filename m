Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab0DNVRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:17:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab0DNVRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:17:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       vgoyal@redhat.com, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/4] jbd: yield the device queue when waiting for commits
Date: Wed, 14 Apr 2010 17:17:05 -0400
Message-Id: <1271279826-30294-4-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
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
index bd224ee..c1df4b2 100644
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
+		blk_yield(journal->j_dev->bd_disk->queue);
 		wake_up(&journal->j_wait_commit);
 		spin_unlock(&journal->j_state_lock);
 		wait_event(journal->j_wait_done_commit,
-- 
1.6.2.5

