Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab1EFJlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:41:40 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:57565 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753711Ab1EFJli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:41:38 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 May 2011 05:41:38 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:X-Identified-User;
	b=ng2ze0oGky37ejii4adirwBWBOOA3ADsS4HpktUwB6x0cPZynNC+8hBpBABosQZZmSqzc4njNF5Qf2uAWWaCWx2fU3j5fEZ4M6UiIUQT3BVL+uxdEHnPG8YpEeCQ1ona;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [PATCH RESEND] block: Remove discard_alignment from hd_struct.
Date: Fri,  6 May 2011 17:34:33 +0800
Message-Id: <1304674473-18435-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303287455-3796-1-git-send-email-tm@tao.ma>
References: <1303287455-3796-1-git-send-email-tm@tao.ma>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Currently, hd_struct.discard_alignment is only used when we
show /sys/block/sdx/sdx/discard_alignment. So remove it and
calculate when it shows.

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

