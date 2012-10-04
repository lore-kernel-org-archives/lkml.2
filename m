Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2JDWGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:06:30 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50177 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597Ab2JDVUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:20:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 02/58] dm mpath: only retry ioctl when no paths if queue_if_no_path set
Date: Thu,  4 Oct 2012 14:19:09 -0700
Message-Id: <20121004210635.744310869@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 7ba10aa6fbac7158a50bec142132b04bc480bb29 upstream.

When there are no paths and multipath receives an ioctl, it waits until
a path becomes available.  This behaviour is incorrect if the
"queue_if_no_path" setting was not specified, as then the ioctl should
be rejected immediately, which this patch now does.

commit 35991652b ("dm mpath: allow ioctls to trigger pg init") should
have checked if queue_if_no_path was configured before queueing IO.

Checking for the queue_if_no_path feature, like is done in map_io(),
allows the following table load to work without blocking in the
multipath_ioctl retry loop:

  echo "0 1024 multipath 0 0 0 0" | dmsetup create mpath_nodevs

Without this fix the multipath_ioctl will block with the following stack
trace:

  blkid           D 0000000000000002     0 23936      1 0x00000000
   ffff8802b89e5cd8 0000000000000082 ffff8802b89e5fd8 0000000000012440
   ffff8802b89e4010 0000000000012440 0000000000012440 0000000000012440
   ffff8802b89e5fd8 0000000000012440 ffff88030c2aab30 ffff880325794040
  Call Trace:
   [<ffffffff814ce099>] schedule+0x29/0x70
   [<ffffffff814cc312>] schedule_timeout+0x182/0x2e0
   [<ffffffff8104dee0>] ? lock_timer_base+0x70/0x70
   [<ffffffff814cc48e>] schedule_timeout_uninterruptible+0x1e/0x20
   [<ffffffff8104f840>] msleep+0x20/0x30
   [<ffffffffa0000839>] multipath_ioctl+0x109/0x170 [dm_multipath]
   [<ffffffffa06bfb9c>] dm_blk_ioctl+0xbc/0xd0 [dm_mod]
   [<ffffffff8122a408>] __blkdev_driver_ioctl+0x28/0x30
   [<ffffffff8122a79e>] blkdev_ioctl+0xce/0x730
   [<ffffffff811970ac>] block_ioctl+0x3c/0x40
   [<ffffffff8117321c>] do_vfs_ioctl+0x8c/0x340
   [<ffffffff81166293>] ? sys_newfstat+0x33/0x40
   [<ffffffff81173571>] sys_ioctl+0xa1/0xb0
   [<ffffffff814d70a9>] system_call_fastpath+0x16/0x1b

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-mpath.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1520,6 +1520,7 @@ static int multipath_ioctl(struct dm_tar
 			   unsigned long arg)
 {
 	struct multipath *m = ti->private;
+	struct pgpath *pgpath;
 	struct block_device *bdev;
 	fmode_t mode;
 	unsigned long flags;
@@ -1535,12 +1536,14 @@ again:
 	if (!m->current_pgpath)
 		__choose_pgpath(m, 0);
 
-	if (m->current_pgpath) {
-		bdev = m->current_pgpath->path.dev->bdev;
-		mode = m->current_pgpath->path.dev->mode;
+	pgpath = m->current_pgpath;
+
+	if (pgpath) {
+		bdev = pgpath->path.dev->bdev;
+		mode = pgpath->path.dev->mode;
 	}
 
-	if (m->queue_io)
+	if ((pgpath && m->queue_io) || (!pgpath && m->queue_if_no_path))
 		r = -EAGAIN;
 	else if (!bdev)
 		r = -EIO;


