Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab2IJT6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758399Ab2IJT6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:58:11 -0400
Date: Mon, 10 Sep 2012 22:59:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mike Waychison <mikew@google.com>
Cc: Frank Swiderski <fes@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
Message-ID: <20120910195931.GD20721@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com>
 <20120910090521.GB18544@redhat.com>
 <CAGTjWtBa5jW6+y1k6zZmD9TUNHBgv8WRbO_iy7huY_dJSumStw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGTjWtBa5jW6+y1k6zZmD9TUNHBgv8WRbO_iy7huY_dJSumStw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 01:37:06PM -0400, Mike Waychison wrote:
> On Mon, Sep 10, 2012 at 5:05 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Tue, Jun 26, 2012 at 01:32:58PM -0700, Frank Swiderski wrote:
> >> This implementation of a virtio balloon driver uses the page cache to
> >> "store" pages that have been released to the host.  The communication
> >> (outside of target counts) is one way--the guest notifies the host when
> >> it adds a page to the page cache, allowing the host to madvise(2) with
> >> MADV_DONTNEED.  Reclaim in the guest is therefore automatic and implicit
> >> (via the regular page reclaim).  This means that inflating the balloon
> >> is similar to the existing balloon mechanism, but the deflate is
> >> different--it re-uses existing Linux kernel functionality to
> >> automatically reclaim.
> >>
> >> Signed-off-by: Frank Swiderski <fes@google.com>
> 
> Hi Michael,
> 
> I'm very sorry that Frank and I have been silent on these threads.
> I've been out of the office and Frank has been been swamped :)
> 
> I'll take a stab at answering some of your questions below, and
> hopefully we can end up on the same page.
> 
> > I've been trying to understand this, and I have
> > a question: what exactly is the benefit
> > of this new device?
> 
> The key difference between this device/driver and the pre-existing
> virtio_balloon device/driver is in how the memory pressure loop is
> controlled.
> 
> With the pre-existing balloon device/driver, the control loop for how
> much memory a given VM is allowed to use is controlled completely by
> the host.  This is probably fine if the goal is to pack as much work
> on a given host as possible, but it says nothing about the expected
> performance that any given VM is expecting to have.  Specifically, it
> allows the host to set a target goal for the size of a VM, and the
> driver in the guest does whatever is needed to get to that goal.  This
> is great for systems where one wants to "grow or shrink" a VM from the
> outside.
> 
> 
> This behaviour however doesn't match what applications actually expect
> from a memory control loop however.  In a native setup, an application
> can usually expect to allocate memory from the kernel on an as-needed
> basis, and can in turn return memory back to the system (using a heap
> implementation that actually releases memory that is).  The dynamic
> size of an application is completely controlled by the application,
> and there is very little that cluster management software can do to
> ensure that the application fits some prescribed size.
> 
> We recognized this in the development of our cluster management
> software long ago, so our systems are designed for managing tasks that
> have a dynamic memory footprint.  Overcommit is possible (as most
> applications do not use the full reservation of memory they asked for
> originally), letting us do things like schedule lower priority/lower
> service-classification work using resources that are otherwise
> available in stand-by for high-priority/low-latency workloads.

OK I am not sure I got this right so pls tell me if this summary is
correct (note: this does not talk about what guest does with memory, 
ust what it is that device does):

- existing balloon is told lower limit on target size by host and pulls in at least
  target size. Guest can inflate > target size if it likes
  and then it is OK to deflate back to target size but not less.
- your balloon is told upper limit on target size by host and pulls at most
  target size. Guest can deflate down to 0 at any point.

If so I think both approaches make sense and in fact they
can be useful at the same time for the same guest.
In that case, I see two ways how this can be done:

1. two devices: existing ballon + cache balloon
2. add "upper limit" to existing ballon

A single device looks a bit more natural in that we don't
really care in which balloon a page is as long as we
are between lower and upper limit. Right?
>From implementation POV we could have it use
pagecache for pages above lower limit but that
is a separate question about driver design,
I would like to make sure I understand the high
level design first.





> >
> > Note that users could not care less about how a driver
> > is implemented internally.
> >
> > Is there some workload where you see VM working better with
> > this than regular balloon? Any numbers?
> 
> This device is less about performance as it is about getting the
> memory size of a job (or in this case, a job in a VM) to grow and
> shrink as the application workload sees fit, much like how processes
> today can grow and shrink without external direction.

Still, e.g. swap in host achieves more or less the same functionality.
I am guessing balloon can work better by getting more cooperation
from guest but aren't there any tests showing this is true in practice?


> >
> > Also, can't we just replace existing balloon implementation
> > with this one?
> 
> Perhaps, but as described above, both devices have very different
> characteristics.
> 
> > Why it is so important to deflate silently?
> 
> It may not be so important to deflate silently.  I'm not sure why it
> is important that we deflate "loudly" though either :)  Doing so seems
> like unnecessary guest/host communication IMO, especially if the guest
> is expecting to be able to grow to totalram (and the host isn't able
> to nack any pages reclaimed anyway...).

First, we could add nack easily enough :)
Second, access gets an exit anyway. If you tell
host first you can maybe batch these and actually speed things up.
It remains to be measured but historically we told host
so the onus of proof would be on whoever wants to remove this.

Third, see discussion on ML - we came up with
the idea of locking/unlocking balloon memory
which is useful for an assigned device.
Requires telling host first.

Also knowing how much memory there is in a balloon
would be useful for admin.

There could be other uses.

> > I guess filesystem does not currently get a callback
> > before page is reclaimed but this isan implementation detail -
> > maybe this can be fixed?
> 
> I do not follow this question.

Assume we want to tell host before use.
Can you implement this on top of your patch?

> >
> > Also can you pls answer Avi's question?
> > How is overcommit managed?
> 
> Overcommit in our deployments is managed using memory cgroups on the
> host.  This allows us to have very directed policies as to how
> competing VMs on a host may overcommit.

So you push VM out to swap if it's over allowed memory?
Existing balloon does this better as it is cooperative,
it seems.


> >
> >
> >> ---
> >>  drivers/virtio/Kconfig              |   13 +
> >>  drivers/virtio/Makefile             |    1 +
> >>  drivers/virtio/virtio_fileballoon.c |  636 +++++++++++++++++++++++++++++++++++
> >>  include/linux/virtio_balloon.h      |    9 +
> >>  include/linux/virtio_ids.h          |    1 +
> >>  5 files changed, 660 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/virtio/virtio_fileballoon.c
> >>
> >> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> >> index f38b17a..cffa2a7 100644
> >> --- a/drivers/virtio/Kconfig
> >> +++ b/drivers/virtio/Kconfig
> >> @@ -35,6 +35,19 @@ config VIRTIO_BALLOON
> >>
> >>        If unsure, say M.
> >>
> >> +config VIRTIO_FILEBALLOON
> >> +     tristate "Virtio page cache-backed balloon driver"
> >> +     select VIRTIO
> >> +     select VIRTIO_RING
> >> +     ---help---
> >> +      This driver supports decreasing and automatically reclaiming the
> >> +      memory within a guest VM.  Unlike VIRTIO_BALLOON, this driver instead
> >> +      tries to maintain a specific target balloon size using the page cache.
> >> +      This allows the guest to implicitly deflate the balloon by flushing
> >> +      pages from the cache and touching the page.
> >> +
> >> +      If unsure, say N.
> >> +
> >>   config VIRTIO_MMIO
> >>       tristate "Platform bus driver for memory mapped virtio devices (EXPERIMENTAL)"
> >>       depends on HAS_IOMEM && EXPERIMENTAL
> >> diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
> >> index 5a4c63c..7ca0a3f 100644
> >> --- a/drivers/virtio/Makefile
> >> +++ b/drivers/virtio/Makefile
> >> @@ -3,3 +3,4 @@ obj-$(CONFIG_VIRTIO_RING) += virtio_ring.o
> >>  obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
> >>  obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
> >>  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
> >> +obj-$(CONFIG_VIRTIO_FILEBALLOON) += virtio_fileballoon.o
> >> diff --git a/drivers/virtio/virtio_fileballoon.c b/drivers/virtio/virtio_fileballoon.c
> >> new file mode 100644
> >> index 0000000..ff252ec
> >> --- /dev/null
> >> +++ b/drivers/virtio/virtio_fileballoon.c
> >> @@ -0,0 +1,636 @@
> >> +/* Virtio file (page cache-backed) balloon implementation, inspired by
> >> + * Dor Loar and Marcelo Tosatti's implementations, and based on Rusty Russel's
> >> + * implementation.
> >> + *
> >> + * This implementation of the virtio balloon driver re-uses the page cache to
> >> + * allow memory consumed by inflating the balloon to be reclaimed by linux.  It
> >> + * creates and mounts a bare-bones filesystem containing a single inode.  When
> >> + * the host requests the balloon to inflate, it does so by "reading" pages at
> >> + * offsets into the inode mapping's page_tree.  The host is notified when the
> >> + * pages are added to the page_tree, allowing it (the host) to madvise(2) the
> >> + * corresponding host memory, reducing the RSS of the virtual machine.  In this
> >> + * implementation, the host is only notified when a page is added to the
> >> + * balloon.  Reclaim happens under the existing TTFP logic, which flushes unused
> >> + * pages in the page cache.  If the host used MADV_DONTNEED, then when the guest
> >> + * uses the page, the zero page will be mapped in, allowing automatic (and fast,
> >> + * compared to requiring a host notification via a virtio queue to get memory
> >> + * back) reclaim.
> >> + *
> >> + *  Copyright 2008 Rusty Russell IBM Corporation
> >> + *  Copyright 2011 Frank Swiderski Google Inc
> >> + *
> >> + *  This program is free software; you can redistribute it and/or modify
> >> + *  it under the terms of the GNU General Public License as published by
> >> + *  the Free Software Foundation; either version 2 of the License, or
> >> + *  (at your option) any later version.
> >> + *
> >> + *  This program is distributed in the hope that it will be useful,
> >> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + *  GNU General Public License for more details.
> >> + *
> >> + *  You should have received a copy of the GNU General Public License
> >> + *  along with this program; if not, write to the Free Software
> >> + *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >> + */
> >> +#include <linux/backing-dev.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/file.h>
> >> +#include <linux/freezer.h>
> >> +#include <linux/fs.h>
> >> +#include <linux/jiffies.h>
> >> +#include <linux/kthread.h>
> >> +#include <linux/module.h>
> >> +#include <linux/mount.h>
> >> +#include <linux/pagemap.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/swap.h>
> >> +#include <linux/virtio.h>
> >> +#include <linux/virtio_balloon.h>
> >> +#include <linux/writeback.h>
> >> +
> >> +#define VIRTBALLOON_PFN_ARRAY_SIZE 256
> >> +
> >> +struct virtio_balloon {
> >> +     struct virtio_device *vdev;
> >> +     struct virtqueue *inflate_vq;
> >> +
> >> +     /* Where the ballooning thread waits for config to change. */
> >> +     wait_queue_head_t config_change;
> >> +
> >> +     /* The thread servicing the balloon. */
> >> +     struct task_struct *thread;
> >> +
> >> +     /* Waiting for host to ack the pages we released. */
> >> +     struct completion acked;
> >> +
> >> +     /* The array of pfns we tell the Host about. */
> >> +     unsigned int num_pfns;
> >> +     u32 pfns[VIRTBALLOON_PFN_ARRAY_SIZE];
> >> +
> >> +     struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
> >> +
> >> +     /* The last page offset read into the mapping's page_tree */
> >> +     unsigned long last_scan_page_array;
> >> +
> >> +     /* The last time a page was reclaimed */
> >> +     unsigned long last_reclaim;
> >> +};
> >> +
> >> +/* Magic number used for the skeleton filesystem in the call to mount_pseudo */
> >> +#define BALLOONFS_MAGIC 0x42414c4c
> >> +
> >> +static struct virtio_device_id id_table[] = {
> >> +     { VIRTIO_ID_FILE_BALLOON, VIRTIO_DEV_ANY_ID },
> >> +     { 0 },
> >> +};
> >> +
> >> +/*
> >> + * The skeleton filesystem contains a single inode, held by the structure below.
> >> + * Using the containing structure below allows easy access to the struct
> >> + * virtio_balloon.
> >> + */
> >> +static struct balloon_inode {
> >> +     struct inode inode;
> >> +     struct virtio_balloon *vb;
> >> +} the_inode;
> >> +
> >> +/*
> >> + * balloon_alloc_inode is called when the single inode for the skeleton
> >> + * filesystem is created in init() with the call to new_inode.
> >> + */
> >> +static struct inode *balloon_alloc_inode(struct super_block *sb)
> >> +{
> >> +     static bool already_inited;
> >> +     /* We should only ever be called once! */
> >> +     BUG_ON(already_inited);
> >> +     already_inited = true;
> >> +     inode_init_once(&the_inode.inode);
> >> +     return &the_inode.inode;
> >> +}
> >> +
> >> +/* Noop implementation of destroy_inode.  */
> >> +static void balloon_destroy_inode(struct inode *inode)
> >> +{
> >> +}
> >> +
> >> +static int balloon_sync_fs(struct super_block *sb, int wait)
> >> +{
> >> +     return filemap_write_and_wait(the_inode.inode.i_mapping);
> >> +}
> >> +
> >> +static const struct super_operations balloonfs_ops = {
> >> +     .alloc_inode    = balloon_alloc_inode,
> >> +     .destroy_inode  = balloon_destroy_inode,
> >> +     .sync_fs        = balloon_sync_fs,
> >> +};
> >> +
> >> +static const struct dentry_operations balloonfs_dentry_operations = {
> >> +};
> >> +
> >> +/*
> >> + * balloonfs_writepage is called when linux needs to reclaim memory held using
> >> + * the balloonfs' page cache.exactlyexactlyexactly
> >> + */
> >> +static int balloonfs_writepage(struct page *page, struct writeback_control *wbc)
> >> +{
> >> +     the_inode.vb->last_reclaim = jiffies;
> >> +     SetPageUptodate(page);
> >> +     ClearPageDirty(page);
> >> +     /*
> >> +      * If the page isn't being flushed from the page allocator, go ahead and
> >> +      * drop it from the page cache anyway.
> >> +      */
> >> +     if (!wbc->for_reclaim)
> >> +             delete_from_page_cache(page);
> >> +     unlock_page(page);
> >> +     return 0;
> >> +}
> >> +
> >> +/* Nearly no-op implementation of readpage */
> >> +static int balloonfs_readpage(struct file *file, struct page *page)
> >> +{
> >> +     SetPageUptodate(page);
> >> +     unlock_page(page);
> >> +     return 0;
> >> +}
> >> +
> >> +static const struct address_space_operations balloonfs_aops = {
> >> +     .writepage      = balloonfs_writepage,
> >> +     .readpage       = balloonfs_readpage
> >> +};
> >> +
> >> +static struct backing_dev_info balloonfs_backing_dev_info = {
> >> +     .name           = "balloonfs",
> >> +     .ra_pages       = 0,
> >> +     .capabilities   = BDI_CAP_NO_ACCT_AND_WRITEBACK
> >> +};
> >> +
> >> +static struct dentry *balloonfs_mount(struct file_system_type *fs_type,
> >> +                      int flags, const char *dev_name, void *data)
> >> +{
> >> +     struct dentry *root;
> >> +     struct inode *inode;
> >> +     root = mount_pseudo(fs_type, "balloon:", &balloonfs_ops,
> >> +                         &balloonfs_dentry_operations, BALLOONFS_MAGIC);
> >> +     inode = root->d_inode;
> >> +     inode->i_mapping->a_ops = &balloonfs_aops;
> >> +     mapping_set_gfp_mask(inode->i_mapping,
> >> +                          (GFP_HIGHUSER | __GFP_NOMEMALLOC));
> >> +     inode->i_mapping->backing_dev_info = &balloonfs_backing_dev_info;
> >> +     return root;
> >> +}
> >> +
> >> +/* The single mounted skeleton filesystem */
> >> +static struct vfsmount *balloon_mnt __read_mostly;
> >> +
> >> +static struct file_system_type balloon_fs_type = {
> >> +     .name =         "balloonfs",
> >> +     .mount =        balloonfs_mount,
> >> +     .kill_sb =      kill_anon_super,
> >> +};
> >> +
> >> +/* Acknowledges a message from the specified virtqueue. */
> >> +static void balloon_ack(struct virtqueue *vq)
> >> +{
> >> +     struct virtio_balloon *vb;
> >> +     unsigned int len;
> >> +
> >> +     vb = virtqueue_get_buf(vq, &len);
> >> +     if (vb)
> >> +             complete(&vb->acked);
> >> +}
> >> +
> >> +/*
> >> + * Scans the page_tree for the inode's mapping, looking for an offset that is
> >> + * currently empty, returning that index (or 0 if it could not fill the
> >> + * request).
> >> + */
> >> +static unsigned long find_available_inode_page(struct virtio_balloon *vb)exactlyexactly
> >> +{
> >> +     unsigned long radix_index, index, max_scan;
> >> +     struct address_space *mapping = the_inode.inode.i_mapping;
> >> +
> >> +     /*
> >> +      * This function is a serialized call (only happens on the free-to-host
> >> +      * thread), so no locking is necessary here.
> >> +      */
> >> +     index = vb->last_scan_page_array;
> >> +     max_scan = totalram_pages - vb->last_scan_page_array;
> >> +
> >> +     /*
> >> +      * Scan starting at the last scanned offset, then wrap around if
> >> +      * necessary.
> >> +      */
> >> +     if (index == 0)
> >> +             index = 1;
> >> +     rcu_read_lock();
> >> +     radix_index = radix_tree_next_hole(&mapping->page_tree,
> >> +                                        index, max_scan);
> >> +     rcu_read_unlock();
> >> +     /*
> >> +      * If we hit the end of the tree, wrap and search up to the original
> >> +      * index.
> >> +      */
> >> +     if (radix_index - index >= max_scan) {
> >> +             if (index != 1) {
> >> +                     rcu_read_lock();
> >> +                     radix_index = radix_tree_next_hole(&mapping->page_tree,
> >> +                                                        1, index);
> >> +                     rcu_read_unlock();
> >> +                     if (radix_index - 1 >= index)
> >> +                             radix_index = 0;
> >> +             } else {
> >> +                     radix_index = 0;
> >> +             }
> >> +     }
> >> +     vb->last_scan_page_array = radix_index;
> >> +
> >> +     return radix_index;
> >> +}
> >> +
> >> +/* Notifies the host of pages in the specified virtqueue. */
> >> +static int tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> >> +{
> >> +     int err;
> >> +     struct scatterlist sg;
> >> +
> >> +     sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
> >> +
> >> +     init_completion(&vb->acked);
> >> +
> >> +     /* We should always be able to add one buffer to an empty queue. */
> >> +     err = virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL);
> >> +     if (err  < 0)
> >> +             return err;
> >> +     virtqueue_kick(vq);
> >> +
> >> +     /* When host has read buffer, this completes via balloon_ack */
> >> +     wait_for_completion(&vb->acked);
> >> +     return err;
> >> +}
> >> +
> >> +static void fill_balloon(struct virtio_balloon *vb, size_t num)
> >> +{
> >> +     int err;
> >> +
> >> +     /* We can only do one array worth at a time. */
> >> +     num = min(num, ARRAY_SIZE(vb->pfns));
> >> +
> >> +     for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
> >> +             struct page *page;
> >> +             unsigned long inode_pfn = find_available_inode_page(vb);
> >> +             /* Should always be able to find a page. */
> >> +             BUG_ON(!inode_pfn);
> >> +             page = read_mapping_page(the_inode.inode.i_mapping, inode_pfn,
> >> +                                      NULL);
> >> +             if (IS_ERR(page)) {
> >> +                     if (printk_ratelimit())
> >> +                             dev_printk(KERN_INFO, &vb->vdev->dev,
> >> +                                        "Out of puff! Can't get %zu pages\n",
> >> +                                        num);
> >> +                     break;
> >> +             }
> >> +
> >> +             /* Set the page to be dirty */
> >> +             set_page_dirty(page);
> >> +
> >> +             vb->pfns[vb->num_pfns] = page_to_pfn(page);
> >> +     }
> >> +
> >> +     /* Didn't get any?  Oh well. */
> >> +     if (vb->num_pfns == 0)
> >> +             return;
> >> +
> >> +     /* Notify the host of the pages we just added to the page_tree. */
> >> +     err = tell_host(vb, vb->inflate_vq);
> >> +
> >> +     for (; vb->num_pfns != 0; vb->num_pfns--) {
> >> +             struct page *page = pfn_to_page(vb->pfns[vb->num_pfns - 1]);
> >> +             /*
> >> +              * Release our refcount on the page so that it can be reclaimed
> >> +              * when necessary.
> >> +              */
> >> +             page_cache_release(page);
> >> +     }
> >> +     __mark_inode_dirty(&the_inode.inode, I_DIRTY_PAGES);
> >> +}
> >> +
> >> +static inline void update_stat(struct virtio_balloon *vb, int idx,
> >> +                            u64 val)
> >> +{
> >> +     BUG_ON(idx >= VIRTIO_BALLOON_S_NR);
> >> +     vb->stats[idx].tag = idx;
> >> +     vb->stats[idx].val = val;
> >> +}
> >> +
> >> +#define pages_to_bytes(x) ((u64)(x) << PAGE_SHIFT)
> >> +
> >> +static inline u32 config_pages(struct virtio_balloon *vb);
> >> +static void update_balloon_stats(struct virtio_balloon *vb)
> >> +{
> >> +     unsigned long events[NR_VM_EVENT_ITEMS];
> >> +     struct sysinfo i;
> >> +
> >> +     all_vm_events(events);
> >> +     si_meminfo(&i);
> >> +
> >> +     update_stat(vb, VIRTIO_BALLOON_S_SWAP_IN,
> >> +                 pages_to_bytes(events[PSWPIN]));
> >> +     update_stat(vb, VIRTIO_BALLOON_S_SWAP_OUT,
> >> +                 pages_to_bytes(events[PSWPOUT]));
> >> +     update_stat(vb, VIRTIO_BALLOON_S_MAJFLT, events[PGMAJFAULT]);
> >> +     update_stat(vb, VIRTIO_BALLOON_S_MINFLT, events[PGFAULT]);
> >> +
> >> +     /* Total and Free Mem */
> >> +     update_stat(vb, VIRTIO_BALLOON_S_MEMFREE, pages_to_bytes(i.freeram));
> >> +     update_stat(vb, VIRTIO_BALLOON_S_MEMTOT, pages_to_bytes(i.totalram));
> >> +}
> >> +
> >> +static void virtballoon_changed(struct virtio_device *vdev)
> >> +{
> >> +     struct virtio_balloon *vb = vdev->priv;
> >> +
> >> +     wake_up(&vb->config_change);
> >> +}
> >> +
> >> +static inline bool config_need_stats(struct virtio_balloon *vb)
> >> +{
> >> +     u32 v = 0;
> >> +
> >> +     vb->vdev->config->get(vb->vdev,
> >> +                           offsetof(struct virtio_balloon_config,
> >> +                                    need_stats),
> >> +                           &v, sizeof(v));
> >> +     return (v != 0);
> >> +}
> >> +
> >> +static inline u32 config_pages(struct virtio_balloon *vb)
> >> +{
> >> +     u32 v = 0;
> >> +
> >> +     vb->vdev->config->get(vb->vdev,
> >> +                           offsetof(struct virtio_balloon_config, num_pages),
> >> +                           &v, sizeof(v));
> >> +     return v;
> >> +}
> >> +
> >> +static inline s64 towards_target(struct virtio_balloon *vb)
> >> +{
> >> +     struct address_space *mapping = the_inode.inode.i_mapping;
> >> +     u32 v = config_pages(vb);
> >> +
> >> +     return (s64)v - (mapping ? mapping->nrpages : 0);
> >> +}
> >> +
> >> +static void update_balloon_size(struct virtio_balloon *vb)
> >> +{
> >> +     struct address_space *mapping = the_inode.inode.i_mapping;
> >> +     __le32 actual = cpu_to_le32((mapping ? mapping->nrpages : 0));
> >> +
> >> +     vb->vdev->config->set(vb->vdev,
> >> +                           offsetof(struct virtio_balloon_config, actual),
> >> +                           &actual, sizeof(actual));
> >> +}
> >> +
> >> +static void update_free_and_total(struct virtio_balloon *vb)
> >> +{
> >> +     struct sysinfo i;
> >> +     u32 value;
> >> +
> >> +     si_meminfo(&i);
> >> +
> >> +     update_balloon_stats(vb);
> >> +     value = i.totalram;
> >> +     vb->vdev->config->set(vb->vdev,
> >> +                           offsetof(struct virtio_balloon_config,
> >> +                                    pages_total),
> >> +                           &value, sizeof(value));
> >> +     value = i.freeram;
> >> +     vb->vdev->config->set(vb->vdev,
> >> +                           offsetof(struct virtio_balloon_config,
> >> +                                    pages_free),
> >> +                           &value, sizeof(value));
> >> +     value = 0;
> >> +     vb->vdev->config->set(vb->vdev,
> >> +                           offsetof(struct virtio_balloon_config,
> >> +                                    need_stats),
> >> +                           &value, sizeof(value));
> >> +}
> >> +
> >> +static int balloon(void *_vballoon)
> >> +{
> >> +     struct virtio_balloon *vb = _vballoon;
> >> +
> >> +     set_freezable();
> >> +     while (!kthread_should_stop()) {
> >> +             s64 diff;
> >> +             try_to_freeze();
> >> +             wait_event_interruptible(vb->config_change,
> >> +                                      (diff = towards_target(vb)) > 0
> >> +                                      || config_need_stats(vb)
> >> +                                      || kthread_should_stop()
> >> +                                      || freezing(current));
> >> +             if (config_need_stats(vb))
> >> +                     update_free_and_total(vb);
> >> +             if (diff > 0) {
> >> +                     unsigned long reclaim_time = vb->last_reclaim + 2 * HZ;
> >> +                     /*
> >> +                      * Don't fill the balloon if a page reclaim happened in
> >> +                      * the past 2 seconds.
> >> +                      */
> >> +                     if (time_after_eq(reclaim_time, jiffies)) {
> >> +                             /* Inflating too fast--sleep and skip. */
> >> +                             msleep(500);
> >> +                     } else {
> >> +                             fill_balloon(vb, diff);
> >> +                     }
> >> +             } else if (diff < 0 && config_pages(vb) == 0) {
> >> +                     /*
> >> +                      * Here we are specifically looking to detect the case
> >> +                      * where there are pages in the page cache, but the
> >> +                      * device wants us to go to 0.  This is used in save/
> >> +                      * restore since the host device doesn't keep track of
> >> +                      * PFNs, and must flush the page cache on restore
> >> +                      * (which loses the context of the original device
> >> +                      * instance).  However, we still suggest syncing the
> >> +                      * diff so that we can get within the target range.
> >> +                      */
> >> +                     s64 nr_to_write =
> >> +                             (!config_pages(vb) ? LONG_MAX : -diff);
> >> +                     struct writeback_control wbc = {
> >> +                             .sync_mode = WB_SYNC_ALL,
> >> +                             .nr_to_write = nr_to_write,
> >> +                             .range_start = 0,
> >> +                             .range_end = LLONG_MAX,
> >> +                     };
> >> +                     sync_inode(&the_inode.inode, &wbc);
> >> +             }
> >> +             update_balloon_size(vb);
> >> +     }
> >> +     return 0;
> >> +}
> >> +
> >> +static ssize_t virtballoon_attr_show(struct device *dev,
> >> +                                  struct device_attribute *attr,
> >> +                                  char *buf);
> >> +
> >> +static DEVICE_ATTR(total_memory, 0644,
> >> +     virtballoon_attr_show, NULL);
> >> +
> >> +static DEVICE_ATTR(free_memory, 0644,
> >> +     virtballoon_attr_show, NULL);
> >> +
> >> +static DEVICE_ATTR(target_pages, 0644,
> >> +     virtballoon_attr_show, NULL);
> >> +
> >> +static DEVICE_ATTR(actual_pages, 0644,
> >> +     virtballoon_attr_show, NULL);
> >> +
> >> +static struct attribute *virtballoon_attrs[] = {
> >> +     &dev_attr_total_memory.attr,
> >> +     &dev_attr_free_memory.attr,
> >> +     &dev_attr_target_pages.attr,
> >> +     &dev_attr_actual_pages.attr,
> >> +     NULL
> >> +};
> >> +static struct attribute_group virtballoon_attr_group = {
> >> +     .name   = "virtballoon",
> >> +     .attrs  = virtballoon_attrs,
> >> +};
> >> +
> >> +static ssize_t virtballoon_attr_show(struct device *dev,
> >> +                                  struct device_attribute *attr,
> >> +                                  char *buf)
> >> +{
> >> +     struct address_space *mapping = the_inode.inode.i_mapping;
> >> +     struct virtio_device *vdev = container_of(dev, struct virtio_device,
> >> +                                               dev);
> >> +     struct virtio_balloon *vb = vdev->priv;
> >> +     unsigned long long value = 0;
> >> +     if (attr == &dev_attr_total_memory)
> >> +             value = vb->stats[VIRTIO_BALLOON_S_MEMTOT].val;
> >> +     else if (attr == &dev_attr_free_memory)
> >> +             value = vb->stats[VIRTIO_BALLOON_S_MEMFREE].val;
> >> +     else if (attr == &dev_attr_target_pages)
> >> +             value = config_pages(vb);
> >> +     else if (attr == &dev_attr_actual_pages)
> >> +             value = cpu_to_le32((mapping ? mapping->nrpages : 0));
> >> +     return sprintf(buf, "%llu\n", value);
> >> +}
> >> +
> >> +static int virtballoon_probe(struct virtio_device *vdev)
> >> +{
> >> +     struct virtio_balloon *vb;
> >> +     struct virtqueue *vq[1];
> >> +     vq_callback_t *callback = balloon_ack;
> >> +     const char *name = "inflate";
> >> +     int err;
> >> +
> >> +     vdev->priv = vb = kmalloc(sizeof(*vb), GFP_KERNEL);
> >> +     if (!vb) {
> >> +             err = -ENOMEM;
> >> +             goto out;
> >> +     }
> >> +
> >> +     init_waitqueue_head(&vb->config_change);
> >> +     vb->vdev = vdev;
> >> +
> >> +     /* We use one virtqueue: inflate */
> >> +     err = vdev->config->find_vqs(vdev, 1, vq, &callback, &name);
> >> +     if (err)
> >> +             goto out_free_vb;
> >> +
> >> +     vb->inflate_vq = vq[0];
> >> +
> >> +     err = sysfs_create_group(&vdev->dev.kobj, &virtballoon_attr_group);
> >> +     if (err) {
> >> +             pr_err("Failed to create virtballoon sysfs node\n");
> >> +             goto out_free_vb;
> >> +     }
> >> +
> >> +     vb->last_scan_page_array = 0;
> >> +     vb->last_reclaim = 0;
> >> +     the_inode.vb = vb;
> >> +
> >> +     vb->thread = kthread_run(balloon, vb, "vballoon");
> >> +     if (IS_ERR(vb->thread)) {
> >> +             err = PTR_ERR(vb->thread);
> >> +             goto out_del_vqs;
> >> +     }
> >> +
> >> +     return 0;
> >> +
> >> +out_del_vqs:
> >> +     vdev->config->del_vqs(vdev);
> >> +out_free_vb:
> >> +     kfree(vb);
> >> +out:
> >> +     return err;
> >> +}
> >> +
> >> +static void __devexit virtballoon_remove(struct virtio_device *vdev)
> >> +{
> >> +     struct virtio_balloon *vb = vdev->priv;
> >> +
> >> +     kthread_stop(vb->thread);
> >> +
> >> +     sysfs_remove_group(&vdev->dev.kobj, &virtballoon_attr_group);
> >> +
> >> +     /* Now we reset the device so we can clean up the queues. */
> >> +     vdev->config->reset(vdev);
> >> +
> >> +     vdev->config->del_vqs(vdev);
> >> +     kfree(vb);
> >> +}
> >> +
> >> +static struct virtio_driver virtio_balloon_driver = {
> >> +     .feature_table          = NULL,
> >> +     .feature_table_size     = 0,
> >> +     .driver.name            = KBUILD_MODNAME,
> >> +     .driver.owner           = THIS_MODULE,
> >> +     .id_table               = id_table,
> >> +     .probe                  = virtballoon_probe,
> >> +     .remove                 = __devexit_p(virtballoon_remove),
> >> +     .config_changed         = virtballoon_changed,
> >> +};
> >> +
> >> +static int __init init(void)
> >> +{
> >> +     int err = register_filesystem(&balloon_fs_type);
> >> +     if (err)
> >> +             goto out;
> >> +
> >> +     balloon_mnt = kern_mount(&balloon_fs_type);
> >> +     if (IS_ERR(balloon_mnt)) {
> >> +             err = PTR_ERR(balloon_mnt);
> >> +             goto out_filesystem;
> >> +     }
> >> +
> >> +     err = register_virtio_driver(&virtio_balloon_driver);
> >> +     if (err)
> >> +             goto out_filesystem;
> >> +
> >> +     goto out;
> >> +
> >> +out_filesystem:
> >> +     unregister_filesystem(&balloon_fs_type);
> >> +
> >> +out:
> >> +     return err;
> >> +}
> >> +
> >> +static void __exit fini(void)
> >> +{
> >> +     if (balloon_mnt) {
> >> +             unregister_filesystem(&balloon_fs_type);
> >> +             balloon_mnt = NULL;
> >> +     }
> >> +     unregister_virtio_driver(&virtio_balloon_driver);
> >> +}
> >> +module_init(init);
> >> +module_exit(fini);
> >> +
> >> +MODULE_DEVICE_TABLE(virtio, id_table);
> >> +MODULE_DESCRIPTION("Virtio file (page cache-backed) balloon driver");
> >> +MODULE_LICENSE("GPL");
> >> diff --git a/include/linux/virtio_balloon.h b/include/linux/virtio_balloon.h
> >> index 652dc8b..2be9a02 100644
> >> --- a/include/linux/virtio_balloon.h
> >> +++ b/include/linux/virtio_balloon.h
> >> @@ -41,6 +41,15 @@ struct virtio_balloon_config
> >>       __le32 num_pages;
> >>       /* Number of pages we've actually got in balloon. */
> >>       __le32 actual;
> >> +#if defined(CONFIG_VIRTIO_FILEBALLOON) ||\
> >> +     defined(CONFIG_VIRTIO_FILEBALLOON_MODULE)
> >> +     /* Total pages on this system. */
> >> +     __le32 pages_total;
> >> +     /* Free pages on this system. */
> >> +     __le32 pages_free;
> >> +     /* If the device needs pages_total/pages_free updated. */
> >> +     __le32 need_stats;
> >> +#endif
> >>  };
> >>
> >>  #define VIRTIO_BALLOON_S_SWAP_IN  0   /* Amount of memory swapped in */
> >> diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
> >> index 7529b85..2f081d7 100644
> >> --- a/include/linux/virtio_ids.h
> >> +++ b/include/linux/virtio_ids.h
> >> @@ -37,5 +37,6 @@
> >>  #define VIRTIO_ID_RPMSG              7 /* virtio remote processor messaging */
> >>  #define VIRTIO_ID_SCSI               8 /* virtio scsi */
> >>  #define VIRTIO_ID_9P         9 /* 9p virtio console */
> >> +#define VIRTIO_ID_FILE_BALLOON       10 /* virtio file-backed balloon */
> >>
> >>  #endif /* _LINUX_VIRTIO_IDS_H */
> >> --
> >> 1.7.7.3
