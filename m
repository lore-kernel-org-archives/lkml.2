Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581Ab2C3Jww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:52:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45790 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab2C3Jwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:52:44 -0400
X-IronPort-AV: E=Sophos;i="4.75,343,1330876800"; 
   d="scan'208";a="4658135"
Message-ID: <4F75827F.2010002@cn.fujitsu.com>
Date: Fri, 30 Mar 2012 17:53:03 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: [PATCH 2/4] scsi: replace sd_format_disk_name() to disk_name_format()
References: <4F7581D4.4040301@cn.fujitsu.com>
In-Reply-To: <4F7581D4.4040301@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 17:50:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-30 17:50:27,
	Serialize complete at 2012-03-30 17:50:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Since "sd_format_disk_name()"has been copied into block
core as "disk_name_format()", the original function should
be removed, and the place used original function should be
replaced by the renamed function.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
  sd.c |   48 +-----------------------------------------------
  1 file changed, 1 insertion(+), 47 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 09e3df4..b82156a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2525,52 +2525,6 @@ static void sd_unlock_native_capacity(struct 
gendisk *disk)
                 sdev->host->hostt->unlock_native_capacity(sdev);
  }

-/**
- *     sd_format_disk_name - format disk name
- *     @prefix: name prefix - ie. "sd" for SCSI disks
- *     @index: index of the disk to format name for
- *     @buf: output buffer
- *     @buflen: length of the output buffer
- *
- *     SCSI disk names starts at sda.  The 26th device is sdz and the
- *     27th is sdaa.  The last one for two lettered suffix is sdzz
- *     which is followed by sdaaa.
- *
- *     This is basically 26 base counting with one extra 'nil' entry
- *     at the beginning from the second digit on and can be
- *     determined using similar method as 26 base conversion with the
- *     index shifted -1 after each digit is computed.
- *
- *     CONTEXT:
- *     Don't care.
- *
- *     RETURNS:
- *     0 on success, -errno on failure.
- */
-static int sd_format_disk_name(char *prefix, int index, char *buf, int 
buflen)
-{
-       const int base = 'z' - 'a' + 1;
-       char *begin = buf + strlen(prefix);
-       char *end = buf + buflen;
-       char *p;
-       int unit;
-
-       p = end - 1;
-       *p = '\0';
-       unit = base;
-       do {
-               if (p == begin)
-                       return -EINVAL;
-               *--p = 'a' + (index % unit);
-               index = (index / unit) - 1;
-       } while (index >= 0);
-
-       memmove(begin, p, end - p);
-       memcpy(buf, prefix, strlen(prefix));
-
-       return 0;
-}
-
  /*
   * The asynchronous part of sd_probe
   */
@@ -2685,7 +2639,7 @@ static int sd_probe(struct device *dev)
                 goto out_put;
         }

-       error = sd_format_disk_name("sd", index, gd->disk_name, 
DISK_NAME_LEN);
+       error = disk_name_format("sd", index, gd->disk_name, DISK_NAME_LEN);
         if (error) {
                 sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name 
length exceeded.\n");
                 goto out_free_index;

