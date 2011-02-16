Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab1BPBvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:51:44 -0500
Received: from kroah.org ([198.145.64.141]:49134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758496Ab1BPBu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:01 2011
Message-Id: <20110216014701.752175538@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [075/115] dm: dont take i_mutex to change device size
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1925,13 +1925,14 @@ static void event_callback(void *context
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
 
 static int __bind(struct mapped_device *md, struct dm_table *t,


