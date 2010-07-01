Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab0GAUvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:51:06 -0400
Received: from kroah.org ([198.145.64.141]:47455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650Ab0GAUuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:12 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:32 2010
Message-Id: <20100701173432.052270237@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 062/164] writeback: disable periodic old data writeback for !dirty_writeback_centisecs
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <jens.axboe@oracle.com>

commit 69b62d01ec44fe0d505d89917392347732135a4d upstream.

Prior to 2.6.32, setting /proc/sys/vm/dirty_writeback_centisecs disabled
periodic dirty writeback from kupdate. This got broken and now causes
excessive sys CPU usage if set to zero, as we'll keep beating on
schedule().

Reported-by: Justin Maggard <jmaggard10@gmail.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fs-writeback.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -834,6 +834,12 @@ static long wb_check_old_data_flush(stru
 	unsigned long expired;
 	long nr_pages;
 
+	/*
+	 * When set to zero, disable periodic writeback
+	 */
+	if (!dirty_writeback_interval)
+		return 0;
+
 	expired = wb->last_old_flush +
 			msecs_to_jiffies(dirty_writeback_interval * 10);
 	if (time_before(jiffies, expired))
@@ -929,8 +935,12 @@ int bdi_writeback_task(struct bdi_writeb
 				break;
 		}
 
-		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
-		schedule_timeout_interruptible(wait_jiffies);
+		if (dirty_writeback_interval) {
+			wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
+			schedule_timeout_interruptible(wait_jiffies);
+		} else
+			schedule();
+
 		try_to_freeze();
 	}
 


