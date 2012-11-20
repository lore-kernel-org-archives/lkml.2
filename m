Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2KTNeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:34:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab2KTNem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:34:42 -0500
Date: Tue, 20 Nov 2012 15:37:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Asias He <asias@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Hellwig <hch@infradead.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-blk: Add vhost-blk support v5
Message-ID: <20121120133714.GC3448@redhat.com>
References: <1353315222-27685-1-git-send-email-asias@redhat.com>
 <20121119202641.GB12283@redhat.com>
 <50AB25AC.2070606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AB25AC.2070606@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 02:39:40PM +0800, Asias He wrote:
> On 11/20/2012 04:26 AM, Michael S. Tsirkin wrote:
> > On Mon, Nov 19, 2012 at 04:53:42PM +0800, Asias He wrote:
> >> vhost-blk is an in-kernel virito-blk device accelerator.
> >>
> >> Due to lack of proper in-kernel AIO interface, this version converts
> >> guest's I/O request to bio and use submit_bio() to submit I/O directly.
> >> So this version any supports raw block device as guest's disk image,
> >> e.g. /dev/sda, /dev/ram0. We can add file based image support to
> >> vhost-blk once we have in-kernel AIO interface. There are some work in
> >> progress for in-kernel AIO interface from Dave Kleikamp and Zach Brown:
> >>
> >>    http://marc.info/?l=linux-fsdevel&m=133312234313122
> >>
> >> Performance evaluation:
> >> -----------------------------
> >> 1) LKVM
> >> Fio with libaio ioengine on Fusion IO device using kvm tool
> >> IOPS(k)    Before       After   Improvement
> >> seq-read   107          121     +13.0%
> >> seq-write  130          179     +37.6%
> >> rnd-read   102          122     +19.6%
> >> rnd-write  125          159     +27.0%
> >>
> >> 2) QEMU
> >> Fio with libaio ioengine on Fusion IO device using QEMU
> >> IOPS(k)    Before       After   Improvement
> >> seq-read   76           123     +61.8%
> >> seq-write  139          173     +24.4%
> >> rnd-read   73           120     +64.3%
> >> rnd-write  75           156     +108.0%
> > 
> > Could you compare with dataplane qemu as well please?
> 
> 
> Well, I will try to collect it.
> 
> > 
> >>
> >> Userspace bits:
> >> -----------------------------
> >> 1) LKVM
> >> The latest vhost-blk userspace bits for kvm tool can be found here:
> >> git@github.com:asias/linux-kvm.git blk.vhost-blk
> >>
> >> 2) QEMU
> >> The latest vhost-blk userspace prototype for QEMU can be found here:
> >> git@github.com:asias/qemu.git blk.vhost-blk
> >>
> >> Changes in v5:
> >> - Do not assume the buffer layout
> >> - Fix wakeup race
> >>
> >> Changes in v4:
> >> - Mark req->status as userspace pointer
> >> - Use __copy_to_user() instead of copy_to_user() in vhost_blk_set_status()
> >> - Add if (need_resched()) schedule() in blk thread
> >> - Kill vhost_blk_stop_vq() and move it into vhost_blk_stop()
> >> - Use vq_err() instead of pr_warn()
> >> - Fail un Unsupported request
> >> - Add flush in vhost_blk_set_features()
> >>
> >> Changes in v3:
> >> - Sending REQ_FLUSH bio instead of vfs_fsync, thanks Christoph!
> >> - Check file passed by user is a raw block device file
> >>
> >> Signed-off-by: Asias He <asias@redhat.com>
> > 
> > Since there are files shared by this and vhost net
> > it's easiest for me to merge this all through the
> > vhost tree.
> > 
> > Jens, could you ack this and the bio usage in this driver
> > please?
> > 
> >> ---
> >>  drivers/vhost/Kconfig     |   1 +
> >>  drivers/vhost/Kconfig.blk |  10 +
> >>  drivers/vhost/Makefile    |   2 +
> >>  drivers/vhost/blk.c       | 697 ++++++++++++++++++++++++++++++++++++++++++++++
> >>  drivers/vhost/blk.h       |   8 +
> >>  5 files changed, 718 insertions(+)
> >>  create mode 100644 drivers/vhost/Kconfig.blk
> >>  create mode 100644 drivers/vhost/blk.c
> >>  create mode 100644 drivers/vhost/blk.h
> >>
> >> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> >> index 202bba6..acd8038 100644
> >> --- a/drivers/vhost/Kconfig
> >> +++ b/drivers/vhost/Kconfig
> >> @@ -11,4 +11,5 @@ config VHOST_NET
> >>  
> >>  if STAGING
> >>  source "drivers/vhost/Kconfig.tcm"
> >> +source "drivers/vhost/Kconfig.blk"
> >>  endif
> >> diff --git a/drivers/vhost/Kconfig.blk b/drivers/vhost/Kconfig.blk
> >> new file mode 100644
> >> index 0000000..ff8ab76
> >> --- /dev/null
> >> +++ b/drivers/vhost/Kconfig.blk
> >> @@ -0,0 +1,10 @@
> >> +config VHOST_BLK
> >> +	tristate "Host kernel accelerator for virtio blk (EXPERIMENTAL)"
> >> +	depends on BLOCK &&  EXPERIMENTAL && m
> >> +	---help---
> >> +	  This kernel module can be loaded in host kernel to accelerate
> >> +	  guest block with virtio_blk. Not to be confused with virtio_blk
> >> +	  module itself which needs to be loaded in guest kernel.
> >> +
> >> +	  To compile this driver as a module, choose M here: the module will
> >> +	  be called vhost_blk.
> >> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> >> index a27b053..1a8a4a5 100644
> >> --- a/drivers/vhost/Makefile
> >> +++ b/drivers/vhost/Makefile
> >> @@ -2,3 +2,5 @@ obj-$(CONFIG_VHOST_NET) += vhost_net.o
> >>  vhost_net-y := vhost.o net.o
> >>  
> >>  obj-$(CONFIG_TCM_VHOST) += tcm_vhost.o
> >> +obj-$(CONFIG_VHOST_BLK) += vhost_blk.o
> >> +vhost_blk-y := blk.o
> >> diff --git a/drivers/vhost/blk.c b/drivers/vhost/blk.c
> >> new file mode 100644
> >> index 0000000..f0f118a
> >> --- /dev/null
> >> +++ b/drivers/vhost/blk.c
> >> @@ -0,0 +1,697 @@
> >> +/*
> >> + * Copyright (C) 2011 Taobao, Inc.
> >> + * Author: Liu Yuan <tailai.ly@taobao.com>
> >> + *
> >> + * Copyright (C) 2012 Red Hat, Inc.
> >> + * Author: Asias He <asias@redhat.com>
> >> + *
> >> + * This work is licensed under the terms of the GNU GPL, version 2.
> >> + *
> >> + * virtio-blk server in host kernel.
> >> + */
> >> +
> >> +#include <linux/miscdevice.h>
> >> +#include <linux/module.h>
> >> +#include <linux/vhost.h>
> >> +#include <linux/virtio_blk.h>
> >> +#include <linux/mutex.h>
> >> +#include <linux/file.h>
> >> +#include <linux/kthread.h>
> >> +#include <linux/blkdev.h>
> >> +#include <linux/llist.h>
> >> +
> >> +#include "vhost.c"
> >> +#include "vhost.h"
> >> +#include "blk.h"
> >> +
> >> +static DEFINE_IDA(vhost_blk_index_ida);
> >> +
> >> +enum {
> >> +	VHOST_BLK_VQ_REQ = 0,
> >> +	VHOST_BLK_VQ_MAX = 1,
> >> +};
> >> +
> >> +struct req_page_list {
> >> +	struct page **pages;
> >> +	int pages_nr;
> >> +};
> >> +
> >> +struct vhost_blk_req {
> >> +	struct llist_node llnode;
> >> +	struct req_page_list *pl;
> >> +	struct vhost_blk *blk;
> >> +
> >> +	struct iovec *iov;
> >> +	int iov_nr;
> >> +
> >> +	struct bio **bio;
> >> +	atomic_t bio_nr;
> >> +
> >> +	struct iovec status[1];
> >> +
> >> +	sector_t sector;
> >> +	int write;
> >> +	u16 head;
> >> +	long len;
> >> +};
> >> +
> >> +struct vhost_blk {
> >> +	struct task_struct *host_kick;
> > 
> > Could you please add a comment here explaining why
> > is this better than using the builtin vhost thread?
> 
> With separate thread model, the request submit and request completion
> can be handled in parallel. I have measured significant performance
> improvement with this model.
> In the long term, It would be nice if the
> vhost core can provide multiple thread support.

Strange, all completion does it write out the used ring.
I am guessing you didn't complete requests
in a timely manner which was what caused the issue.
OTOH I'm not sure how increasing the number of threads
scales with # of VMs. Increased scheduler pressure is
also a concern.
Did you try checking completion after each
submitted request to address this?


