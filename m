Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1EKPiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:38:54 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:38351 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab1EKPis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:38:48 -0400
X-IronPort-AV: E=Sophos;i="4.64,353,1301875200"; 
   d="scan'208";a="5704808"
Subject: Re: [PATCH] xen block backend driver.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "pasik@iki.fi" <pasik@iki.fi>
In-Reply-To: <1304619093-22354-2-git-send-email-konrad.wilk@oracle.com>
References: <1304619093-22354-1-git-send-email-konrad.wilk@oracle.com>
	 <1304619093-22354-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 11 May 2011 16:02:12 +0100
Message-ID: <1305126132.26692.420.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 19:11 +0100, Konrad Rzeszutek Wilk wrote:
> This is the host side counterpart to the frontend driver
> in drivers/block/xen-blkfront.c. The PV protocol is also implemented by
> frontend drivers in other OSes too, such as the BSDs and even Windows.
> 
> The patch is based on the driver from the xen.git pvops kernel tree but
> has been put through the checkpatch.pl wringer plus several manual
> cleanup passes. It has also been moved from drivers/xen/blkback to
> drivers/block/xen-blback.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: Ian Campbell <ian.campbell@citrix.com>

Not much to say below, mostly minor nits really.

> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 83c32cb..9abb646 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -470,6 +470,14 @@ config XEN_BLKDEV_FRONTEND
>           block device driver.  It communicates with a back-end driver
>           in another domain which drives the actual block device.
> 
> +config XEN_BLKDEV_BACKEND
> +       tristate "Block-device backend driver"
> +       depends on XEN_BACKEND
> +       help
> +         The block-device backend driver allows the kernel to export its
> +         block devices to other guests via a high-performance shared-memory
> +         interface.
> +

checkpatch.pl seems to think this is too short. Netback's entry has some
general pointers to the frontend and stuff along those lines:

                       These devices can be accessed by any operating
          system that implements a compatible front end.

          The corresponding Linux frontend driver is enabled by the
          CONFIG_XEN_NETDEV_FRONTEND configuration option.

          [...]

          If you are compiling a kernel to run in a Xen network driver
          domain (often this is domain 0) you should say Y here. To
          compile this driver as a module, chose M here: the module
          will be called xen-netback.

Could be worth adding the equivalent here?


> [...]
> +
> +/*
> + * Each outstanding request that we've passed to the lower device layers has a
> + * 'pending_req' allocated to it. Each buffer_head that completes decrements
> + * the pendcnt towards zero. When it hits zero, the specified domain has a
> + * response queued for it, with the saved 'id' passed back.
> + */
> +struct pending_req {
> +       struct blkif_st       *blkif;
> +       u64            id;
> +       int            nr_pages;
> +       atomic_t       pendcnt;
> +       unsigned short operation;
> +       int            status;
> +       struct list_head free_list;
> +};

There's a lot of whitespace problems here (and elsewhere) but the git
copy is OK so I guess someones MUA has nobbled it and won't worry about
it or comment further...

[...]
> +                       virt_to_page(unmap[i].host_addr), false);
> +               if (ret) {
> +                       printk(KERN_ALERT "Failed to remove M2P override for " \
> +                               "%lx\n", (unsigned long)unmap[i].host_addr);

I generally dislike the practice of splitting string literals like this,
checkpatch is (or used to be) rather overzealous about it. Doesn't
really hurt the grepability in this particular case but also doesn't
particularly help readability either...

> +                       continue;
> +               }
> +       }
> +}

Blank line missing here.

[...]
> +       ret = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, map, nseg);
> +       BUG_ON(ret);
> +
> +       /* Now swizzel the MFN in our domain with the MFN from the other domain

                 swizzle

> +        * so that when we access vaddr(pending_req,i) it has the contents of
> +        * the page from the other domain.
> +        */
> +       for (i = 0; i < nseg; i++) {
> +               if (unlikely(map[i].status != 0)) {
> +                       DPRINTK("invalid buffer -- could not remap it\n");

[DI]PRINTK should be replaced with pr_dbg/info (or dev_dbg etc if you
have the necessary parameters to hand) through. There are some bare
printks around which could stand to be changed too.

I noticed earlier that the driver maintains its own debug_lvl thing, are
all those messages still useful or do they date back to when the driver
was in development? Same question for the stats logging stuff,
especially since it comes out via sysfs too now. Is there a generic blk
subsystem stats mechanism?

[...]
> +/*
> + * Function to copy the from the ring buffer the 'struct blkif_request'

Is the blkif namespace fair game? (I was asked to change netif is all)

> [...]
> +/*
> + * Transumation of the 'struct blkif_request' to a proper 'struct bio'

      Transmutation ?

> + * and call the 'submit_bio' to pass it to the underlaying storage.

                                                  underlying ?
> + */
> +static int dispatch_rw_block_io(struct blkif_st *blkif,
> +                                struct blkif_request *req,
> +                                struct pending_req *pending_req)
> +{
> +       struct phys_req preq;
> +       struct seg_buf seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> +       unsigned int nseg;
> +       struct bio *bio = NULL;
> +       struct bio *biolist[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> +       int i, nbio = 0;
> +       int operation;
> +       struct blk_plug plug;
> +
> +       switch (req->operation) {
> +       case BLKIF_OP_READ:
> +               blkif->st_rd_req++;
> +               operation = READ;
> +               break;
> +       case BLKIF_OP_WRITE:
> +               blkif->st_wr_req++;
> +               operation = WRITE_ODIRECT;
> +               break;
> +       case BLKIF_OP_FLUSH_DISKCACHE:
> +               blkif->st_f_req++;
> +               operation = WRITE_FLUSH;
> +               /* The frontend likes to set this to -1, which vbd_translate
> +                * is alergic too. */
> +               req->u.rw.sector_number = 0;
> +               break;
> +       case BLKIF_OP_WRITE_BARRIER:
> +       default:
> +               operation = 0; /* make gcc happy */
> +               goto fail_response;
> +               break;
> +       }
> +
> +       /* Check that the number of segments is sane. */
> +       nseg = req->nr_segments;
> +       if (unlikely(nseg == 0 && operation != WRITE_FLUSH) ||
> +           unlikely(nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
> +               DPRINTK("Bad number of segments in request (%d)\n", nseg);
> +               /* Haven't submitted any bio's yet. */
> +               goto fail_response;
> +       }
> +
> +       preq.dev           = req->handle;
> +       preq.sector_number = req->u.rw.sector_number;
> +       preq.nr_sects      = 0;
> +
> +       pending_req->blkif     = blkif;
> +       pending_req->id        = req->id;
> +       pending_req->operation = req->operation;
> +       pending_req->status    = BLKIF_RSP_OKAY;
> +       pending_req->nr_pages  = nseg;
> +
> +       for (i = 0; i < nseg; i++) {
> +               seg[i].nsec = req->u.rw.seg[i].last_sect -
> +                       req->u.rw.seg[i].first_sect + 1;
> +               if ((req->u.rw.seg[i].last_sect >= (PAGE_SIZE >> 9)) ||
> +                   (req->u.rw.seg[i].last_sect < req->u.rw.seg[i].first_sect))
> +                       goto fail_response;
> +               preq.nr_sects += seg[i].nsec;
> +
> +       }
> +
> +       if (vbd_translate(&preq, blkif, operation) != 0) {
> +               DPRINTK("access denied: %s of [%llu,%llu] on dev=%04x\n",
> +                       operation == READ ? "read" : "write",
> +                       preq.sector_number,
> +                       preq.sector_number + preq.nr_sects, preq.dev);
> +               goto fail_response;
> +       }
> +       /* This check _MUST_ be done after vbd_translate as the preq.bdev
> +        * is set there. */

People seem to prefer a blank line for the first /* and last */ in a
multiline comment e.g.:

	/*
	 * This check _MUST_ be done after vbd_translate as the 
	 * preq.bdev is set there.
         */

I don't know if that is CodingStyle approved/mandated or not though.

> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> new file mode 100644
> index 0000000..9adcf80
> --- /dev/null
> +++ b/drivers/block/xen-blkback/xenbus.c
> +static int vbd_create(struct blkif_st *blkif, blkif_vdev_t handle,
> +                     unsigned major, unsigned minor, int readonly,
> +                     int cdrom)
> +{
> +       struct vbd *vbd;
> +       struct block_device *bdev;
> +       struct request_queue *q;
> +
> +       vbd = &blkif->vbd;
> +       vbd->handle   = handle;
> +       vbd->readonly = readonly;
> +       vbd->type     = 0;
> +
> +       vbd->pdevice  = MKDEV(major, minor);
> +
> +       bdev = blkdev_get_by_dev(vbd->pdevice, vbd->readonly ?
> +                                FMODE_READ : FMODE_WRITE, NULL);
> +
> +       if (IS_ERR(bdev)) {
> +               DPRINTK("vbd_creat: device %08x could not be opened.\n",

                               create

> +                       vbd->pdevice);
> +               return -ENOENT;
> +       }
> +
> +       vbd->bdev = bdev;
> +       vbd->size = vbd_sz(vbd);
> +
> +       if (vbd->bdev->bd_disk == NULL) {
> +               DPRINTK("vbd_creat: device %08x doesn't exist.\n",

                               create
> +
> +/**

This isn't really kerneldoc documentation.

> + * Entry point to this code when a new device is created.  Allocate the basic
> + * structures, and watch the store waiting for the hotplug scripts to tell us
> + * the device's physical major and minor numbers.  Switch to InitWait.
> + */
> [...]

> +
> +/**

Neither is this... (there are more of these).

> + * Callback received when the hotplug scripts have placed the physical-device
> + * node.  Read it and the mode node, and create a vbd.  If the frontend is
> + * ready, connect.
> + */
> +static void backend_changed(struct xenbus_watch *watch,
> +                           const char **vec, unsigned int len)
> +{
> +       int err;
> +       unsigned major;
> +       unsigned minor;
> +       struct backend_info *be
> +               = container_of(watch, struct backend_info, backend_watch);
> +       struct xenbus_device *dev = be->dev;
> +       int cdrom = 0;
> +       char *device_type;
> +
> +       DPRINTK("");
> +
> +       err = xenbus_scanf(XBT_NIL, dev->nodename, "physical-device", "%x:%x",
> +                          &major, &minor);
> +       if (XENBUS_EXIST_ERR(err)) {
> +               /* Since this watch will fire once immediately after it is
> +                  registered, we expect this.  Ignore it, and wait for the
> +                  hotplug scripts. */
> +               return;
> +       }
> +       if (err != 2) {
> +               xenbus_dev_fatal(dev, err, "reading physical-device");
> +               return;
> +       }
> +
> +       if ((be->major || be->minor) &&
> +           ((be->major != major) || (be->minor != minor))) {
> +               printk(KERN_WARNING
> +                      "blkback: changing physical device (from %x:%x to "
> +                      "%x:%x) not supported.\n", be->major, be->minor,

I think this is one of those cases where splitting the literal in order
to be <80 chars does more harmful than good...

> diff --git a/include/xen/blkif.h b/include/xen/blkif.h
> new file mode 100644
> index 0000000..ab79426
> --- /dev/null
> +++ b/include/xen/blkif.h
> @@ -0,0 +1,122 @@
[...]
> +static void inline blkif_get_x86_32_req(struct blkif_request *dst, struct blkif_x86_32_request *src)
> +{
[...]
> +}
> +
> +static void inline blkif_get_x86_64_req(struct blkif_request *dst, struct blkif_x86_64_request *src)
> +{
> +[...]
> +}

I think these two can be static to drivers/block/xen-blkback/blkback.c.
In fact, could this whole header go there or is it shared with the
frontend?

(sharing doesn't seem to make sense since the backend adjusts to the
frontend, not vice versa).

Ian.


