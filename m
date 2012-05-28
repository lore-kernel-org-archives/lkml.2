Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2E1Dy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:54:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51827 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab2E1D27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:28:59 -0400
Message-Id: <20120528031204.261900733@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        Szymon Gruszczynski <sz.gruszczynski@googlemail.com>,
        Will Drewry <wad@chromium.org>, Jens Axboe <axboe@kernel.dk>
Subject: [ 010/117] block: fix buffer overflow when printing partition UUIDs
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 05c69d298c96703741cac9a5cbbf6c53bd55a6e2 upstream.

6d1d8050b4bc8 "block, partition: add partition_meta_info to hd_struct"
added part_unpack_uuid() which assumes that the passed in buffer has
enough space for sprintfing "%pU" - 37 characters including '\0'.

Unfortunately, b5af921ec0233 "init: add support for root devices
specified by partition UUID" supplied 33 bytes buffer to the function
leading to the following panic with stackprotector enabled.

  Kernel panic - not syncing: stack-protector: Kernel stack corrupted in: ffffffff81b14c7e

  [<ffffffff815e226b>] panic+0xba/0x1c6
  [<ffffffff81b14c7e>] ? printk_all_partitions+0x259/0x26xb
  [<ffffffff810566bb>] __stack_chk_fail+0x1b/0x20
  [<ffffffff81b15c7e>] printk_all_paritions+0x259/0x26xb
  [<ffffffff81aedfe0>] mount_block_root+0x1bc/0x27f
  [<ffffffff81aee0fa>] mount_root+0x57/0x5b
  [<ffffffff81aee23b>] prepare_namespace+0x13d/0x176
  [<ffffffff8107eec0>] ? release_tgcred.isra.4+0x330/0x30
  [<ffffffff81aedd60>] kernel_init+0x155/0x15a
  [<ffffffff81087b97>] ? schedule_tail+0x27/0xb0
  [<ffffffff815f4d24>] kernel_thread_helper+0x5/0x10
  [<ffffffff81aedc0b>] ? start_kernel+0x3c5/0x3c5
  [<ffffffff815f4d20>] ? gs_change+0x13/0x13

Increase the buffer size, remove the dangerous part_unpack_uuid() and
use snprintf() directly from printk_all_partitions().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Szymon Gruszczynski <sz.gruszczynski@googlemail.com>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/genhd.c         |   10 ++++++----
 include/linux/genhd.h |    6 ------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index df9816e..9cf5583 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -743,7 +743,7 @@ void __init printk_all_partitions(void)
 		struct hd_struct *part;
 		char name_buf[BDEVNAME_SIZE];
 		char devt_buf[BDEVT_SIZE];
-		u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
+		char uuid_buf[PARTITION_META_INFO_UUIDLTH * 2 + 5];
 
 		/*
 		 * Don't show empty devices or things that have been
@@ -762,14 +762,16 @@ void __init printk_all_partitions(void)
 		while ((part = disk_part_iter_next(&piter))) {
 			bool is_part0 = part == &disk->part0;
 
-			uuid[0] = 0;
+			uuid_buf[0] = '\0';
 			if (part->info)
-				part_unpack_uuid(part->info->uuid, uuid);
+				snprintf(uuid_buf, sizeof(uuid_buf), "%pU",
+					 part->info->uuid);
 
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(disk, part->partno, name_buf), uuid);
+			       disk_name(disk, part->partno, name_buf),
+			       uuid_buf);
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
 				    disk->driverfs_dev->driver != NULL)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e61d319..017a7fb 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -222,12 +222,6 @@ static inline void part_pack_uuid(const u8 *uuid_str, u8 *to)
 	}
 }
 
-static inline char *part_unpack_uuid(const u8 *uuid, char *out)
-{
-	sprintf(out, "%pU", uuid);
-	return out;
-}
-
 static inline int disk_max_parts(struct gendisk *disk)
 {
 	if (disk->flags & GENHD_FL_EXT_DEVT)


