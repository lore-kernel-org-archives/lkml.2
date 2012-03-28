Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab2C1Gy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:54:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41186 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab2C1Gy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:54:28 -0400
X-IronPort-AV: E=Sophos;i="4.75,329,1330876800"; 
   d="scan'208";a="4637671"
Message-ID: <4F72B5B3.6020602@cn.fujitsu.com>
Date: Wed, 28 Mar 2012 14:54:43 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] virtio_blk: add helper function to support mass of disks
 naming
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-28 14:52:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-28 14:52:13,
	Serialize complete at 2012-03-28 14:52:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

The current virtblk's naming algorithm just supports 26^3
disks. If there are mass of virtblks(exceeding 26^3), there
will be disks with the same name.

According to "sd_format_disk_name()", I add function
"virtblk_name_format()" for virtblk to support mass of
disks.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
  virtio_blk.c |   37 +++++++++++++++++++++++++------------
  1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c4a60ba..07b8bf9 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -374,6 +374,30 @@ static int init_vq(struct virtio_blk *vblk)
         return err;
  }

+static int virtblk_name_format(char *prefix, int index, char *buf, int 
buflen)
+{
+       const int base = 'z' - 'a' + 1;
+       char *begin = buf + strlen(prefix);
+       char *begin = buf + strlen(prefix);
+       char *end = buf + buflen;
+       char *p;
+       int unit;
+
+       p = end - 1;
+       *p = '\0';
+       unit = base;
+       do {
+               if (p == begin)
+                       return -EINVAL;
+               *--p = 'a' + (index % unit);
+               index = (index / unit) - 1;
+       } while (index >= 0);
+
+       memmove(begin, p, end - p);
+       memcpy(buf, prefix, strlen(prefix));
+
+       return 0;
+}
+
  static int __devinit virtblk_probe(struct virtio_device *vdev)
  {
         struct virtio_blk *vblk;
@@ -442,18 +466,7 @@ static int __devinit virtblk_probe(struct 
virtio_device *vdev)

         q->queuedata = vblk;

-       if (index < 26) {
-               sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
-       } else if (index < (26 + 1) * 26) {
-               sprintf(vblk->disk->disk_name, "vd%c%c",
-                       'a' + index / 26 - 1, 'a' + index % 26);
-       } else {
-               const unsigned int m1 = (index / 26 - 1) / 26 - 1;
-               const unsigned int m2 = (index / 26 - 1) % 26;
-               const unsigned int m3 =  index % 26;
-               sprintf(vblk->disk->disk_name, "vd%c%c%c",
-                       'a' + m1, 'a' + m2, 'a' + m3);
-       }
+       virtblk_name_format("vd", index, vblk->disk->disk_name, 
DISK_NAME_LEN);

         vblk->disk->major = major;
         vblk->disk->first_minor = index_to_minor(index);
