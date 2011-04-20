Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab1DTIS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:18:28 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:45237 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750808Ab1DTIS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:18:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=CneybqELo9weJ9KineTONKdbOgWGAMn1XpKH/qEWcG3Datb49CFdX4Pot9msMAOaAVRQHej6hpmAT0ZyYf0Q+YNVmajydAgfEptBs0VsloPkECGKMyLNcIZiwlePryFe;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [PATCH] block: Remove extra discard_alignment from hd_struct.
Date: Wed, 20 Apr 2011 16:17:35 +0800
Message-Id: <1303287455-3796-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Currently, hd_struct.discard_alignment is only used when we
show /sys/block/sdx/sdx/discard_alignment. So remove it and
calculate when it is asked to show.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/partitions/check.c |    9 ++++++---
 include/linux/genhd.h |    1 -
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index ac54697..ec4f4ae 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -255,7 +255,12 @@ ssize_t part_discard_alignment_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%u\n", p->discard_alignment);
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%u\n",
+		       (unsigned long long)queue_limit_discard_alignment(
+							&disk->queue->limits,
+							p->start_sect));
 }
 
 ssize_t part_stat_show(struct device *dev,
@@ -449,8 +454,6 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	p->start_sect = start;
 	p->alignment_offset =
 		queue_limit_alignment_offset(&disk->queue->limits, start);
-	p->discard_alignment =
-		queue_limit_discard_alignment(&disk->queue->limits, start);
 	p->nr_sects = len;
 	p->partno = partno;
 	p->policy = get_disk_ro(disk);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index d764a42..b4c233f 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -100,7 +100,6 @@ struct hd_struct {
 	sector_t start_sect;
 	sector_t nr_sects;
 	sector_t alignment_offset;
-	unsigned int discard_alignment;
 	struct device __dev;
 	struct kobject *holder_dir;
 	int policy, partno;
-- 
1.7.4

