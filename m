Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab1FWRfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:35:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:34125 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932829Ab1FWRfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:35:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 071/247] dm: dont take i_mutex to change device size
Date: Thu, 23 Jun 2011 13:32:19 -0400
Message-Id: <1308850515-15242-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c217649bf2d60ac119afd71d938278cffd55962b upstream.

No longer needlessly hold md->bdev->bd_inode->i_mutex when changing the
size of a DM device.  This additional locking is unnecessary because
i_size_write() is already protected by the existing critical section in
dm_swap_table().  DM already has a reference on md->bdev so the
associated bd_inode may be changed without lifetime concerns.

A negative side-effect of having held md->bdev->bd_inode->i_mutex was
that a concurrent DM device resize and flush (via fsync) would deadlock.
Dropping md->bdev->bd_inode->i_mutex eliminates this potential for
deadlock.  The following reproducer no longer deadlocks:
  https://www.redhat.com/archives/dm-devel/2009-July/msg00284.html

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/dm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 56d192d..c955f7f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2039,13 +2039,14 @@ static void event_callback(void *context)
 	wake_up(&md->eventq);
 }
 
+/*
+ * Protected by md->suspend_lock obtained by dm_swap_table().
+ */
 static void __set_size(struct mapped_device *md, sector_t size)
 {
 	set_capacity(md->disk, size);
 
-	mutex_lock(&md->bdev->bd_inode->i_mutex);
 	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->bdev->bd_inode->i_mutex);
 }
 
 /*
-- 
1.7.4.4

