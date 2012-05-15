Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074Ab2EOC42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:56:28 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53316 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965022Ab2EOCRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 082/179] PM: Free memory bitmaps if opening /dev/snapshot fails
Date: Mon, 14 May 2012 22:12:58 -0400
Message-ID: <1337048075-6132-83-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8440f4b19494467883f8541b7aa28c7bbf6ac92b upstream.

When opening /dev/snapshot device, snapshot_open() creates memory
bitmaps which are freed in snapshot_release(). But if any of the
callbacks called by pm_notifier_call_chain() returns NOTIFY_BAD, open()
fails, snapshot_release() is never called and bitmaps are not freed.
Next attempt to open /dev/snapshot then triggers BUG_ON() check in
create_basic_memory_bitmaps(). This happens e.g. when vmwatchdog module
is active on s390x.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/power/user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index 16a7d95..37b32d5 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -113,8 +113,10 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 		if (error)
 			pm_notifier_call_chain(PM_POST_RESTORE);
 	}
-	if (error)
+	if (error) {
+		free_basic_memory_bitmaps();
 		atomic_inc(&snapshot_device_available);
+	}
 	data->frozen = 0;
 	data->ready = 0;
 	data->platform_support = 0;
-- 
1.7.9.6

