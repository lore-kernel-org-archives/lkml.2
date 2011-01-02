Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1ABIJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:09:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:34367 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1ABHV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:57 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 042/260] fuse: flush background queue on connection close
Date: Sun,  2 Jan 2011 02:15:38 -0500
Message-Id: <1293952756-15010-43-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:52.0288 (UTC) FILETIME=[96695400:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

commit 595afaf9e6ee1b48e13ec4b8bcc8c7dee888161a upstream.

David Bartly reported that fuse can hang in fuse_get_req_nofail() when
the connection to the filesystem server is no longer active.

If bg_queue is not empty then flush_bg_queue() called from
request_end() can put more requests on to the pending queue.  If this
happens while ending requests on the processing queue then those
background requests will be queued to the pending list and never
ended.

Another problem is that fuse_dev_release() didn't wake up processes
sleeping on blocked_waitq.

Solve this by:

 a) flushing the background queue before calling end_requests() on the
    pending and processing queues

 b) setting blocked = 0 and waking up processes waiting on
    blocked_waitq()

Thanks to David for an excellent bug report.

Reported-by: David Bartley <andareed@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/fuse/dev.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index eb7e942..c235afc 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1158,6 +1158,14 @@ __acquires(&fc->lock)
 	}
 }
 
+static void end_queued_requests(struct fuse_conn *fc)
+{
+	fc->max_background = UINT_MAX;
+	flush_bg_queue(fc);
+	end_requests(fc, &fc->pending);
+	end_requests(fc, &fc->processing);
+}
+
 /*
  * Abort all requests.
  *
@@ -1184,8 +1192,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		fc->connected = 0;
 		fc->blocked = 0;
 		end_io_requests(fc);
-		end_requests(fc, &fc->pending);
-		end_requests(fc, &fc->processing);
+		end_queued_requests(fc);
 		wake_up_all(&fc->waitq);
 		wake_up_all(&fc->blocked_waitq);
 		kill_fasync(&fc->fasync, SIGIO, POLL_IN);
@@ -1200,8 +1207,9 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 	if (fc) {
 		spin_lock(&fc->lock);
 		fc->connected = 0;
-		end_requests(fc, &fc->pending);
-		end_requests(fc, &fc->processing);
+		fc->blocked = 0;
+		end_queued_requests(fc);
+		wake_up_all(&fc->blocked_waitq);
 		spin_unlock(&fc->lock);
 		fuse_conn_put(fc);
 	}
-- 
1.7.3.3

