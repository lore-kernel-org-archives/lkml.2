Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0CZPUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:20:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0CZPU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:20:29 -0400
Date: Fri, 26 Mar 2010 11:20:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Chad Talbott <ctalbott@google.com>, jens.axboe@oracle.com,
       mrubin@google.com, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, dpshah@google.com,
       Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 0/4] io-controller: Use names rather than major:minor
Message-ID: <20100326152012.GB18128@redhat.com>
References: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com> <4BAC0E7D.9080305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAC0E7D.9080305@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 09:31:41AM +0800, Gui Jianfeng wrote:
> Chad Talbott wrote:
> > This stack (which includes Gui's patch for per-device weights),
> > changes the various blkio.* stats to use the disks' names (sda, sdb,
> > etc.) rather than major:minor pairs when printing statistics.
> 
> Hi Chad,
> 
> I have the same concern with Vivek. We'v already exported device number
> pair to user since 2.6.33, It's better to keep the original ABI.
> 
> > Additionally setting a per-device policy can be done via the disk's
> > name.
> 
> To keep things simple, can we add new API in block layer to lookup
> device name by device number as following.
> 
> +int blk_lookup_devname(dev_t devt, char *name)
> +{
> +       struct class_dev_iter iter;
> +       struct device *dev;
> +       struct gendisk *disk;
> +
> +       class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
> +       while ((dev = class_dev_iter_next(&iter))) {
> +               if (dev->devt != devt)
> +                       continue;
> +
> +               disk = dev_to_disk(dev);
> +
> +               disk_name(disk, 0, name);
> +
> +               return 0;
> +       }
> +       class_dev_iter_exit(&iter);
> +
> +       return 1;
> +}
> +EXPORT_SYMBOL(blk_lookup_devname);
> +
> 
> So we can keep dev_t in blkio layer, and export to user a device name by calling 
> this function. Also, we retrive device number by calling blk_lookup_devt().
> This change might keep things much simple. Jens, do you have any thoughts?
> 

Hi Chad,

I agree with Gui that lets keep the dev_t the core in blkio layer. Keeping
a pointer to gendisk in request queue is becoming little messy.

To me device major and minor numbers are just fine. Looking it up with is
really easy. If you want to put a policy on /dev/sda or just use "stat -c
%t:%T /dev/sda". Or just do cat /sys/block/sda/dev.

But if that does not work for you, then I would also like to keep things
simple and translate dev_t to diskname during read routine. Similiarly,
while somebody is putting policy, use blk_lookup_devt().

But this will lead to issue of how do you now display both device number
and disk name in the output. May be following.

major:minor  diskname  data

I am not sure if people are fond of multiple values in a single file. At
the same time for setting the rules or deleting the rules, it will make
syntax complicated/confusing. Also will require breaking ABI for existing
blkio.time, blkio.sectors, blkio.dequeue files.

So I would prefer to keep the major/minor number based interface for
follwing reasons.

- Chaning it now breaks ABI.
- Other cgroup controller "device" is also using major/minor number based
  interface for device access policy. So it is consistent with other
  controller.
- Displaying both device major/minor and diskname is an option but that
  makes the file format syntax little complicated and new rule setting
  or removoal confusing.

Thanks
Vivek

> Thanks,
> Gui
> 
> > 
> > This has the side effect of fixing the "root cgroup shows no stats"
> > problem that Ricky mentioned.
> > 
> > Chad
> > 
> > ---
> > 
> > Chad Talbott (4):
> >       blkio_group key change: void * -> request_queue *
> >       Adds an RCU-protected pointer to request_queue that makes it easy to
> >       io-controller: Add a new interface "weight_device" for IO-Controller
> >       Use disk-names to set blkio.weight_device policy
> > 
> > 
> >  block/blk-cgroup.c     |  224 +++++++++++++++++++++++++++++++++++++++++++++---
> >  block/blk-cgroup.h     |   23 ++++-
> >  block/blk-sysfs.c      |    4 +
> >  block/cfq-iosched.c    |   27 ++----
> >  include/linux/blkdev.h |    6 +
> >  5 files changed, 248 insertions(+), 36 deletions(-)
> > 
> > 
> > 
> > 
