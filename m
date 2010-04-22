Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab0DVUKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:10:33 -0400
Received: from kroah.org ([198.145.64.141]:60036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130Ab0DVUBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:47 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:17 2010
Message-Id: <20100422195417.248096583@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
       Alex Elder <aelder@sgi.com>
Subject: [118/139] xfs: check for more work before sleeping in xfssyncd
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit 20f6b2c785cf187445f126321638ab8ba7aa7494 upstream.

xfssyncd processes a queue of work by detaching the queue and
then iterating over all the work items. It then sleeps for a
time period or until new work comes in. If new work is queued
while xfssyncd is actively processing the detached work queue,
it will not process that new work until after a sleep timeout
or the next work event queued wakes it.

Fix this by checking the work queue again before going to sleep.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_sync.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -613,7 +613,8 @@ xfssyncd(
 	set_freezable();
 	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
 	for (;;) {
-		timeleft = schedule_timeout_interruptible(timeleft);
+		if (list_empty(&mp->m_sync_list))
+			timeleft = schedule_timeout_interruptible(timeleft);
 		/* swsusp */
 		try_to_freeze();
 		if (kthread_should_stop() && list_empty(&mp->m_sync_list))
@@ -633,8 +634,7 @@ xfssyncd(
 			list_add_tail(&mp->m_sync_work.w_list,
 					&mp->m_sync_list);
 		}
-		list_for_each_entry_safe(work, n, &mp->m_sync_list, w_list)
-			list_move(&work->w_list, &tmp);
+		list_splice_init(&mp->m_sync_list, &tmp);
 		spin_unlock(&mp->m_sync_lock);
 
 		list_for_each_entry_safe(work, n, &tmp, w_list) {


