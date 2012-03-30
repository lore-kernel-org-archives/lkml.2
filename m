Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2C3Jxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:53:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18383 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760591Ab2C3Jxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:53:33 -0400
X-IronPort-AV: E=Sophos;i="4.75,343,1330876800"; 
   d="scan'208";a="4658146"
Message-ID: <4F7582B0.5010609@cn.fujitsu.com>
Date: Fri, 30 Mar 2012 17:53:52 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass of
 disks naming
References: <4F7581D4.4040301@cn.fujitsu.com>
In-Reply-To: <4F7581D4.4040301@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 17:51:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 17:51:16,
	Serialize complete at 2012-03-30 17:51:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  The current virtblk's naming algorithm only supports 263  disks.
If there are mass of virtblks(exceeding 263), there will be disks
with the same name.

By renaming "sd_format_disk_name()" to "disk_name_format()"
and moving it into block core, virtio_blk can use this function to
support mass of disks.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
   virtio_blk.c |   13 +------------
  1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c4a60ba..54612c2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -442,18 +442,7 @@ static int __devinit virtblk_probe(struct 
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
+       disk_name_format("vd", index, vblk->disk->disk_name, DISK_NAME_LEN);

         vblk->disk->major = major;
         vblk->disk->first_minor = index_to_minor(index);

