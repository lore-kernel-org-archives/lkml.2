Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab0IRTgB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:36:01 -0400
Received: from kroah.org ([198.145.64.141]:43289 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714Ab0IRTPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:00 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:00 2010
Message-Id: <20100918191259.929904981@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [031/129] fuse: flush background queue on connection close
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/dev.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1552,6 +1552,14 @@ __acquires(&fc->lock)
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
@@ -1578,8 +1586,7 @@ void fuse_abort_conn(struct fuse_conn *f
 		fc->connected = 0;
 		fc->blocked = 0;
 		end_io_requests(fc);
-		end_requests(fc, &fc->pending);
-		end_requests(fc, &fc->processing);
+		end_queued_requests(fc);
 		wake_up_all(&fc->waitq);
 		wake_up_all(&fc->blocked_waitq);
 		kill_fasync(&fc->fasync, SIGIO, POLL_IN);
@@ -1594,8 +1601,9 @@ int fuse_dev_release(struct inode *inode
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


