Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0FJHUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 03:20:40 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:39068 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751542Ab0FJHUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 03:20:37 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, josef@redhat.com,
       jeffmerkey@gmail.com
Subject: [PATCH 1/5] fsfreeze: Prevent emergency thaw from looping infinitely
Date: Thu, 10 Jun 2010 17:19:50 +1000
Message-Id: <1276154395-24766-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276154395-24766-1-git-send-email-david@fromorbit.com>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The thawing of a filesystem through sysrq-j loops infinitely as it
incorrectly detects a thawed filesytsem as frozen and tries to
unfreeze repeatedly. This is a regression caused by
4504230a71566785a05d3e6b53fa1ee071b864eb ("freeze_bdev: grab active
reference to frozen superblocks") in that it no longer returned
-EINVAL for superblocks that were not frozen.

Return -EINVAL when the filesystem is already unfrozen to avoid this
problem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/block_dev.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7346c96..366ac38 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -276,22 +276,19 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 	if (!bdev->bd_fsfreeze_count)
 		goto out;
 
-	error = 0;
-	if (--bdev->bd_fsfreeze_count > 0)
+	if (!sb)
 		goto out;
 
-	if (!sb)
+	error = 0;
+	if (--bdev->bd_fsfreeze_count > 0)
 		goto out;
 
 	error = thaw_super(sb);
-	if (error) {
+	if (error)
 		bdev->bd_fsfreeze_count++;
-		mutex_unlock(&bdev->bd_fsfreeze_mutex);
-		return error;
-	}
 out:
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
-	return 0;
+	return error;
 }
 EXPORT_SYMBOL(thaw_bdev);
 
-- 
1.7.1

