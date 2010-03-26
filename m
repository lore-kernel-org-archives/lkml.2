Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0CZBcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:32:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50276 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0CZBcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:32:07 -0400
Message-ID: <4BAC0E7D.9080305@cn.fujitsu.com>
Date: Fri, 26 Mar 2010 09:31:41 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Chad Talbott <ctalbott@google.com>, vgoyal@redhat.com,
       jens.axboe@oracle.com
CC: mrubin@google.com, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, dpshah@google.com,
       Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 0/4] io-controller: Use names rather than major:minor
References: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com>
In-Reply-To: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chad Talbott wrote:
> This stack (which includes Gui's patch for per-device weights),
> changes the various blkio.* stats to use the disks' names (sda, sdb,
> etc.) rather than major:minor pairs when printing statistics.

Hi Chad,

I have the same concern with Vivek. We'v already exported device number
pair to user since 2.6.33, It's better to keep the original ABI.

> Additionally setting a per-device policy can be done via the disk's
> name.

To keep things simple, can we add new API in block layer to lookup
device name by device number as following.

+int blk_lookup_devname(dev_t devt, char *name)
+{
+       struct class_dev_iter iter;
+       struct device *dev;
+       struct gendisk *disk;
+
+       class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
+       while ((dev = class_dev_iter_next(&iter))) {
+               if (dev->devt != devt)
+                       continue;
+
+               disk = dev_to_disk(dev);
+
+               disk_name(disk, 0, name);
+
+               return 0;
+       }
+       class_dev_iter_exit(&iter);
+
+       return 1;
+}
+EXPORT_SYMBOL(blk_lookup_devname);
+

So we can keep dev_t in blkio layer, and export to user a device name by calling 
this function. Also, we retrive device number by calling blk_lookup_devt().
This change might keep things much simple. Jens, do you have any thoughts?

Thanks,
Gui

> 
> This has the side effect of fixing the "root cgroup shows no stats"
> problem that Ricky mentioned.
> 
> Chad
> 
> ---
> 
> Chad Talbott (4):
>       blkio_group key change: void * -> request_queue *
>       Adds an RCU-protected pointer to request_queue that makes it easy to
>       io-controller: Add a new interface "weight_device" for IO-Controller
>       Use disk-names to set blkio.weight_device policy
> 
> 
>  block/blk-cgroup.c     |  224 +++++++++++++++++++++++++++++++++++++++++++++---
>  block/blk-cgroup.h     |   23 ++++-
>  block/blk-sysfs.c      |    4 +
>  block/cfq-iosched.c    |   27 ++----
>  include/linux/blkdev.h |    6 +
>  5 files changed, 248 insertions(+), 36 deletions(-)
> 
> 
> 
> 

