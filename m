Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425Ab1C3V4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:56:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:51403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933343Ab1C3VG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236631"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: snitzer@redhat.com, mpatocka@redhat.com, agk@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [77/275] dm: dont take i_mutex to change device size
Message-Id: <20110330210514.BD8FB3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/md/dm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/md/dm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/dm.c	2011-03-29 22:51:39.284717971 -0700
+++ linux-2.6.35.y/drivers/md/dm.c	2011-03-29 23:02:59.762306252 -0700
@@ -2040,13 +2040,14 @@
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
