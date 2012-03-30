Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606Ab2C3JwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:52:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27497 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760138Ab2C3JwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:52:09 -0400
X-IronPort-AV: E=Sophos;i="4.75,343,1330876800"; 
   d="scan'208";a="4658133"
Message-ID: <4F75825B.80108@cn.fujitsu.com>
Date: Fri, 30 Mar 2012 17:52:27 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: [PATCH 1/4] block: add function disk_name_format() into block core
References: <4F7581D4.4040301@cn.fujitsu.com>
In-Reply-To: <4F7581D4.4040301@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 17:49:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 17:49:52,
	Serialize complete at 2012-03-30 17:49:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  According to 3e1a7ff8a0a7b948f2684930166954f9e8e776fe,
I copied function "sd_format_disk_name()" into block core with
the name of "disk_name_format()".

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
  block/genhd.c         |   49 
+++++++++++++++++++++++++++++++++++++++++++++++++
  include/linux/genhd.h |    2 ++
  2 files changed, 51 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index df9816e..10c04b6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -357,6 +357,55 @@ void unregister_blkdev(unsigned int major, const 
char *name)

  EXPORT_SYMBOL(unregister_blkdev);

+/*
+ *     disk_name_format - format disk name
+ *     @prefix: name prefix - ie. "sd" for SCSI disks
+ *     @index: index of the disk to format name for
+ *     @buf: output buffer
+ *     @buflen: length of the output buffer
+ *
+ *     Take SCSI disks for example. Disk names starts at sda.  The
+ *     26th device is sdz and the 27th is sdaa.  The last one for
+ *     two lettered suffix is sdzz which is followed by sdaaa.
+ *
+ *     This is basically 26 base counting with one extra 'nil' entry
+ *     at the beginning from the second digit on and can be
+ *     determined using similar method as 26 base conversion with the
+ *     index shifted -1 after each digit is computed.
+ *
+ *     CONTEXT:
+ *     Don't care.
+ *
+ *     RETURNS:
+ *     0 on success, -errno on failure.
+ */
+
+int disk_name_format(char *prefix, int index, char *buf, int buflen)
+{
+       const int base = 'z' - 'a' + 1;
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
+EXPORT_SYMBOL(disk_name_format);
+
  static struct kobj_map *bdev_map;

  /**
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e61d319..cd3d5e5 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -407,6 +407,8 @@ static inline void free_part_info(struct hd_struct 
*part)
  extern void part_round_stats(int cpu, struct hd_struct *part);

  /* block/genhd.c */
+extern int disk_name_format(char *prefix, int index, char *buf, int 
buflen);
+
  extern void add_disk(struct gendisk *disk);
  extern void del_gendisk(struct gendisk *gp);
  extern struct gendisk *get_gendisk(dev_t dev, int *partno);

