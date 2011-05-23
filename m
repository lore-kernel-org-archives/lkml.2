Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1EWN6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:58:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40672 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab1EWN6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:58:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Oy4hgXEO0cMREqUK0khMR7/gkbepbgYMPlAnaecJqi2XzptYVgupfGLd+jSoVv63pv
         7Zi01OUmp4i+QoUtv1Dg0uzotpwMlnf5EDec8PRFPm+93oyy5p1nJFKjX3R9tlZCvNhO
         Vz6vC3wNIGkkhxJ76zdihx3bvOXBJgb+sTxno=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] splice: add wakeup_pipe_readers()
Date: Mon, 23 May 2011 22:58:34 +0900
Message-Id: <1306159114-3192-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use wakeup_pipe_readers() to consolidate duplicated codes.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/splice.c |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 50a5d978da16..aa866d309695 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -162,6 +162,14 @@ static const struct pipe_buf_operations user_page_pipe_buf_ops = {
 	.get = generic_pipe_buf_get,
 };
 
+static void wakeup_pipe_readers(struct pipe_inode_info *pipe)
+{
+	smp_mb();
+	if (waitqueue_active(&pipe->wait))
+		wake_up_interruptible(&pipe->wait);
+	kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+}
+
 /**
  * splice_to_pipe - fill passed data into a pipe
  * @pipe:	pipe to fill
@@ -247,12 +255,8 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 
 	pipe_unlock(pipe);
 
-	if (do_wakeup) {
-		smp_mb();
-		if (waitqueue_active(&pipe->wait))
-			wake_up_interruptible(&pipe->wait);
-		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-	}
+	if (do_wakeup)
+		wakeup_pipe_readers(pipe);
 
 	while (page_nr < spd_pages)
 		spd->spd_release(spd, page_nr++);
@@ -1892,12 +1896,9 @@ retry:
 	/*
 	 * If we put data in the output pipe, wakeup any potential readers.
 	 */
-	if (ret > 0) {
-		smp_mb();
-		if (waitqueue_active(&opipe->wait))
-			wake_up_interruptible(&opipe->wait);
-		kill_fasync(&opipe->fasync_readers, SIGIO, POLL_IN);
-	}
+	if (ret > 0)
+		wakeup_pipe_readers(opipe);
+
 	if (input_wakeup)
 		wakeup_pipe_writers(ipipe);
 
@@ -1976,12 +1977,8 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 	/*
 	 * If we put data in the output pipe, wakeup any potential readers.
 	 */
-	if (ret > 0) {
-		smp_mb();
-		if (waitqueue_active(&opipe->wait))
-			wake_up_interruptible(&opipe->wait);
-		kill_fasync(&opipe->fasync_readers, SIGIO, POLL_IN);
-	}
+	if (ret > 0)
+		wakeup_pipe_readers(opipe);
 
 	return ret;
 }
-- 
1.7.5

