Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab2DKCio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 22:38:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33265 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759998Ab2DKCiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 22:38:07 -0400
X-IronPort-AV: E=Sophos;i="4.75,402,1330876800"; 
   d="scan'208";a="4725893"
From: Ren Mingxin <renmx@cn.fujitsu.com>
To: mst@redhat.com, rusty@rustcorp.com.au
Cc: avi@redhat.com, axboe@kernel.dk, tj@kernel.org, asias@redhat.com,
        James.Bottomley@HansenPartnership.com, asamymuthupa@micron.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH v2] virtio_blk: Add help function to format mass of disks
Date: Wed, 11 Apr 2012 10:38:11 +0800
Message-Id: <1334111891-18891-1-git-send-email-renmx@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 10:37:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 10:37:31,
	Serialize complete at 2012/04/11 10:37:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current virtio block's naming algorithm just supports 18278
(26^3 + 26^2 + 26) disks. If there are mass of virtio blocks,
there will be disks with the same name.

Based on commit 3e1a7ff8a0a7b948f2684930166954f9e8e776fe, I add
function "virtblk_name_format()" for virtio block to support mass
of disks naming.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
v1->v2: wipe off the duplicate line
---
 drivers/block/virtio_blk.c |   37 +++++++++++++++++++++++++------------
 1 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c4a60ba..07b8bf9 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -374,6 +374,30 @@ static int init_vq(struct virtio_blk *vblk)
 	return err;
 }
 
+static int virtblk_name_format(char *prefix, int index, char *buf, int buflen)
+{
+	const int base = 'z' - 'a' + 1;
+	char *begin = buf + strlen(prefix);
+	char *end = buf + buflen;
+	char *p;
+	int unit;
+
+	p = end - 1;
+	*p = '\0';
+	unit = base;
+	do {
+		if (p == begin)
+			return -EINVAL;
+		*--p = 'a' + (index % unit);
+		index = (index / unit) - 1;
+	} while (index >= 0);
+
+	memmove(begin, p, end - p);
+	memcpy(buf, prefix, strlen(prefix));
+
+	return 0;
+}
+
 static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -442,18 +466,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 
 	q->queuedata = vblk;
 
-	if (index < 26) {
-		sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
-	} else if (index < (26 + 1) * 26) {
-		sprintf(vblk->disk->disk_name, "vd%c%c",
-			'a' + index / 26 - 1, 'a' + index % 26);
-	} else {
-		const unsigned int m1 = (index / 26 - 1) / 26 - 1;
-		const unsigned int m2 = (index / 26 - 1) % 26;
-		const unsigned int m3 =  index % 26;
-		sprintf(vblk->disk->disk_name, "vd%c%c%c",
-			'a' + m1, 'a' + m2, 'a' + m3);
-	}
+	virtblk_name_format("vd", index, vblk->disk->disk_name, DISK_NAME_LEN);
 
 	vblk->disk->major = major;
 	vblk->disk->first_minor = index_to_minor(index);
-- 
1.7.1

