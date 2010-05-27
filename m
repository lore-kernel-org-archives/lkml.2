Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab0E0J5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:57:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:35046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378Ab0E0J5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:57:43 -0400
Message-ID: <4BFE4203.5010803@kernel.org>
Date: Thu, 27 May 2010 11:57:23 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: davem@davemloft.net, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, viro@ZenIV.linux.org.uk, akpm@linux-foundation.org
Subject: [PATCH] fs: run emergency remount on dedicated workqueue
References: <25328.1274886067@redhat.com>
In-Reply-To: <25328.1274886067@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 May 2010 09:57:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fa4b9074cd8428958c2adf9dc0c831f46e27c193 made s_umount depend
on keventd; however, emergency remount schedules works to keventd
which grabs s_umount creating a circular dependency.  Run emergency
remount on a separate workqueue to break it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Unless someone objects, Andrew, can you please take this patch?

Thanks.

 fs/super.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 69688b1..1ada607 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -575,6 +575,11 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	return 0;
 }

+/*
+ * For emergency remount
+ */
+static struct workqueue_struct *emergency_remount_wq;
+
 static void do_emergency_remount(struct work_struct *work)
 {
 	struct super_block *sb, *n;
@@ -605,13 +610,25 @@ void emergency_remount(void)
 {
 	struct work_struct *work;

+	if (!emergency_remount_wq)
+		return;
+
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (work) {
 		INIT_WORK(work, do_emergency_remount);
-		schedule_work(work);
+		queue_work(emergency_remount_wq, work);
 	}
 }

+static int __init emergency_remount_init(void)
+{
+	emergency_remount_wq = create_singlethread_workqueue("emerg-remount");
+	if (!emergency_remount_wq)
+		pr_warn("failed to create emergency remount workqueue\n");
+	return 0;
+}
+subsys_initcall(emergency_remount_init);
+
 /*
  * Unnamed block devices are dummy devices used by virtual
  * filesystems which don't use real block-devices.  -- jrs
