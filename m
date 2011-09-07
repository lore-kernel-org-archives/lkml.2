Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab1IGDe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 23:34:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51957 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1IGDeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 23:34:21 -0400
MIME-Version: 1.0
In-Reply-To: <20101129171637.GC4027@redhat.com>
References: <20101129170431.GA4027@redhat.com>
	<20101129171637.GC4027@redhat.com>
Date: Wed, 7 Sep 2011 11:34:19 +0800
Message-ID: <CAEH94Lhzcz207-F5r27_PNXnC52DnFPK-jjAj-ECEtpt643fBQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] tools/virtio: virtio_test tool
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. very good learning material.

On Tue, Nov 30, 2010 at 1:16 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> This is the userspace part of the tool: it includes a bunch of stubs for
> linux APIs, somewhat simular to linuxsched. This makes it possible to
> recompile the ring code in userspace.
>
> A small test example is implemented combining this with vhost_test
> module.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> ---
>
> diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
> new file mode 100644
> index 0000000..d1d442e
> --- /dev/null
> +++ b/tools/virtio/Makefile
> @@ -0,0 +1,12 @@
> +all: test mod
> +test: virtio_test
> +virtio_test: virtio_ring.o virtio_test.o
> +CFLAGS += -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow  -MMD
> +vpath %.c ../../drivers/virtio
> +mod:
> +       ${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test
> +.PHONY: all test mod clean
> +clean:
> +       ${RM} *.o vhost_test/*.o vhost_test/.*.cmd \
> +              vhost_test/Module.symvers vhost_test/modules.order *.d
> +-include *.d
> diff --git a/tools/virtio/linux/device.h b/tools/virtio/linux/device.h
> new file mode 100644
> index 0000000..4ad7e1d
> --- /dev/null
> +++ b/tools/virtio/linux/device.h
> @@ -0,0 +1,2 @@
> +#ifndef LINUX_DEVICE_H
> +#endif
> diff --git a/tools/virtio/linux/slab.h b/tools/virtio/linux/slab.h
> new file mode 100644
> index 0000000..81baeac
> --- /dev/null
> +++ b/tools/virtio/linux/slab.h
> @@ -0,0 +1,2 @@
> +#ifndef LINUX_SLAB_H
> +#endif
> diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
> new file mode 100644
> index 0000000..669bcdd
> --- /dev/null
> +++ b/tools/virtio/linux/virtio.h
> @@ -0,0 +1,223 @@
> +#ifndef LINUX_VIRTIO_H
> +#define LINUX_VIRTIO_H
> +
> +#include <stdbool.h>
> +#include <stdlib.h>
> +#include <stddef.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include <assert.h>
> +
> +#include <linux/types.h>
> +#include <errno.h>
> +
> +typedef unsigned long long dma_addr_t;
> +
> +struct scatterlist {
> +       unsigned long   page_link;
> +       unsigned int    offset;
> +       unsigned int    length;
> +       dma_addr_t      dma_address;
> +};
> +
> +struct page {
> +       unsigned long long dummy;
> +};
> +
> +#define BUG_ON(__BUG_ON_cond) assert(!(__BUG_ON_cond))
> +
> +/* Physical == Virtual */
> +#define virt_to_phys(p) ((unsigned long)p)
> +#define phys_to_virt(a) ((void *)(unsigned long)(a))
> +/* Page address: Virtual / 4K */
> +#define virt_to_page(p) ((struct page*)((virt_to_phys(p) / 4096) * \
> +                                       sizeof(struct page)))
> +#define offset_in_page(p) (((unsigned long)p) % 4096)
> +#define sg_phys(sg) ((sg->page_link & ~0x3) / sizeof(struct page) * 4096 + \
> +                    sg->offset)
> +static inline void sg_mark_end(struct scatterlist *sg)
> +{
> +       /*
> +        * Set termination bit, clear potential chain bit
> +        */
> +       sg->page_link |= 0x02;
> +       sg->page_link &= ~0x01;
> +}
> +static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
> +{
> +       memset(sgl, 0, sizeof(*sgl) * nents);
> +       sg_mark_end(&sgl[nents - 1]);
> +}
> +static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
> +{
> +       unsigned long page_link = sg->page_link & 0x3;
> +
> +       /*
> +        * In order for the low bit stealing approach to work, pages
> +        * must be aligned at a 32-bit boundary as a minimum.
> +        */
> +       BUG_ON((unsigned long) page & 0x03);
> +       sg->page_link = page_link | (unsigned long) page;
> +}
> +
> +static inline void sg_set_page(struct scatterlist *sg, struct page *page,
> +                              unsigned int len, unsigned int offset)
> +{
> +       sg_assign_page(sg, page);
> +       sg->offset = offset;
> +       sg->length = len;
> +}
> +
> +static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
> +                             unsigned int buflen)
> +{
> +       sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
> +}
> +
> +static inline void sg_init_one(struct scatterlist *sg, const void *buf, unsigned int buflen)
> +{
> +       sg_init_table(sg, 1);
> +       sg_set_buf(sg, buf, buflen);
> +}
> +
> +typedef __u16 u16;
> +
> +typedef enum {
> +       GFP_KERNEL,
> +       GFP_ATOMIC,
> +} gfp_t;
> +typedef enum {
> +       IRQ_NONE,
> +       IRQ_HANDLED
> +} irqreturn_t;
> +
> +static inline void *kmalloc(size_t s, gfp_t gfp)
> +{
> +       return malloc(s);
> +}
> +
> +static inline void kfree(void *p)
> +{
> +       free(p);
> +}
> +
> +#define container_of(ptr, type, member) ({                     \
> +       const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
> +       (type *)( (char *)__mptr - offsetof(type,member) );})
> +
> +#define uninitialized_var(x) x = x
> +
> +# ifndef likely
> +#  define likely(x)    (__builtin_expect(!!(x), 1))
> +# endif
> +# ifndef unlikely
> +#  define unlikely(x)  (__builtin_expect(!!(x), 0))
> +# endif
> +
> +#define pr_err(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
> +#ifdef DEBUG
> +#define pr_debug(format, ...) fprintf (stderr, format, ## __VA_ARGS__)
> +#else
> +#define pr_debug(format, ...) do {} while (0)
> +#endif
> +#define dev_err(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
> +#define dev_warn(dev, format, ...) fprintf (stderr, format, ## __VA_ARGS__)
> +
> +/* TODO: empty stubs for now. Broken but enough for virtio_ring.c */
> +#define list_add_tail(a, b) do {} while (0)
> +#define list_del(a) do {} while (0)
> +
> +#define BIT_WORD(nr)           ((nr) / BITS_PER_LONG)
> +#define BITS_PER_BYTE          8
> +#define BITS_PER_LONG (sizeof(long) * BITS_PER_BYTE)
> +#define BIT_MASK(nr)           (1UL << ((nr) % BITS_PER_LONG))
> +/* TODO: Not atomic as it should be:
> + * we don't use this for anything important. */
> +static inline void clear_bit(int nr, volatile unsigned long *addr)
> +{
> +       unsigned long mask = BIT_MASK(nr);
> +       unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
> +
> +       *p &= ~mask;
> +}
> +
> +static inline int test_bit(int nr, const volatile unsigned long *addr)
> +{
> +        return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
> +}
> +
> +/* The only feature we care to support */
> +#define virtio_has_feature(dev, feature) \
> +       test_bit((feature), (dev)->features)
> +/* end of stubs */
> +
> +struct virtio_device {
> +       void *dev;
> +       unsigned long features[1];
> +};
> +
> +struct virtqueue {
> +       /* TODO: commented as list macros are empty stubs for now.
> +        * Broken but enough for virtio_ring.c
> +        * struct list_head list; */
> +       void (*callback)(struct virtqueue *vq);
> +       const char *name;
> +       struct virtio_device *vdev;
> +       void *priv;
> +};
> +
> +#define EXPORT_SYMBOL_GPL(__EXPORT_SYMBOL_GPL_name) \
> +       void __EXPORT_SYMBOL_GPL##__EXPORT_SYMBOL_GPL_name() { \
> +}
> +#define MODULE_LICENSE(__MODULE_LICENSE_value) \
> +       const char *__MODULE_LICENSE_name = __MODULE_LICENSE_value
> +
> +#define CONFIG_SMP
> +
> +#if defined(__i386__) || defined(__x86_64__)
> +#define barrier() asm volatile("" ::: "memory")
> +#define mb() __sync_synchronize()
> +
> +#define smp_mb()       mb()
> +# define smp_rmb()     barrier()
> +# define smp_wmb()     barrier()
> +#else
> +#error Please fill in barrier macros
> +#endif
> +
> +/* Interfaces exported by virtio_ring. */
> +int virtqueue_add_buf_gfp(struct virtqueue *vq,
> +                         struct scatterlist sg[],
> +                         unsigned int out_num,
> +                         unsigned int in_num,
> +                         void *data,
> +                         gfp_t gfp);
> +
> +static inline int virtqueue_add_buf(struct virtqueue *vq,
> +                                   struct scatterlist sg[],
> +                                   unsigned int out_num,
> +                                   unsigned int in_num,
> +                                   void *data)
> +{
> +       return virtqueue_add_buf_gfp(vq, sg, out_num, in_num, data, GFP_ATOMIC);
> +}
> +
> +void virtqueue_kick(struct virtqueue *vq);
> +
> +void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
> +
> +void virtqueue_disable_cb(struct virtqueue *vq);
> +
> +bool virtqueue_enable_cb(struct virtqueue *vq);
> +
> +void *virtqueue_detach_unused_buf(struct virtqueue *vq);
> +struct virtqueue *vring_new_virtqueue(unsigned int num,
> +                                     unsigned int vring_align,
> +                                     struct virtio_device *vdev,
> +                                     void *pages,
> +                                     void (*notify)(struct virtqueue *vq),
> +                                     void (*callback)(struct virtqueue *vq),
> +                                     const char *name);
> +void vring_del_virtqueue(struct virtqueue *vq);
> +
> +#endif
> diff --git a/tools/virtio/vhost_test/Makefile b/tools/virtio/vhost_test/Makefile
> new file mode 100644
> index 0000000..a1d35b8
> --- /dev/null
> +++ b/tools/virtio/vhost_test/Makefile
> @@ -0,0 +1,2 @@
> +obj-m += vhost_test.o
> +EXTRA_CFLAGS += -Idrivers/vhost
> diff --git a/tools/virtio/vhost_test/vhost_test.c b/tools/virtio/vhost_test/vhost_test.c
> new file mode 100644
> index 0000000..1873518
> --- /dev/null
> +++ b/tools/virtio/vhost_test/vhost_test.c
> @@ -0,0 +1 @@
> +#include "test.c"
> diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> new file mode 100644
> index 0000000..808ae86
> --- /dev/null
> +++ b/tools/virtio/virtio_test.c
> @@ -0,0 +1,248 @@
> +#define _GNU_SOURCE
> +#include <getopt.h>
> +#include <string.h>
> +#include <poll.h>
> +#include <sys/eventfd.h>
> +#include <stdlib.h>
> +#include <assert.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <fcntl.h>
> +#include <linux/vhost.h>
> +#include <linux/virtio.h>
> +#include <linux/virtio_ring.h>
> +#include "../../drivers/vhost/test.h"
> +
> +struct vq_info {
> +       int kick;
> +       int call;
> +       int num;
> +       int idx;
> +       void *ring;
> +       /* copy used for control */
> +       struct vring vring;
> +       struct virtqueue *vq;
> +};
> +
> +struct vdev_info {
> +       struct virtio_device vdev;
> +       int control;
> +       struct pollfd fds[1];
> +       struct vq_info vqs[1];
> +       int nvqs;
> +       void *buf;
> +       size_t buf_size;
> +       struct vhost_memory *mem;
> +};
> +
> +void vq_notify(struct virtqueue *vq)
> +{
> +       struct vq_info *info = vq->priv;
> +       unsigned long long v = 1;
> +       int r;
> +       r = write(info->kick, &v, sizeof v);
> +       assert(r == sizeof v);
> +}
> +
> +void vq_callback(struct virtqueue *vq)
> +{
> +}
> +
> +
> +void vhost_vq_setup(struct vdev_info *dev, struct vq_info *info)
> +{
> +       struct vhost_vring_state state = { .index = info->idx };
> +       struct vhost_vring_file file = { .index = info->idx };
> +       unsigned long long features = dev->vdev.features[0];
> +       struct vhost_vring_addr addr = {
> +               .index = info->idx,
> +               .desc_user_addr = (uint64_t)(unsigned long)info->vring.desc,
> +               .avail_user_addr = (uint64_t)(unsigned long)info->vring.avail,
> +               .used_user_addr = (uint64_t)(unsigned long)info->vring.used,
> +       };
> +       int r;
> +       r = ioctl(dev->control, VHOST_SET_FEATURES, &features);
> +       assert(r >= 0);
> +       state.num = info->vring.num;
> +       r = ioctl(dev->control, VHOST_SET_VRING_NUM, &state);
> +       assert(r >= 0);
> +       state.num = 0;
> +       r = ioctl(dev->control, VHOST_SET_VRING_BASE, &state);
> +       assert(r >= 0);
> +       r = ioctl(dev->control, VHOST_SET_VRING_ADDR, &addr);
> +       assert(r >= 0);
> +       file.fd = info->kick;
> +       r = ioctl(dev->control, VHOST_SET_VRING_KICK, &file);
> +       assert(r >= 0);
> +       file.fd = info->call;
> +       r = ioctl(dev->control, VHOST_SET_VRING_CALL, &file);
> +       assert(r >= 0);
> +}
> +
> +static void vq_info_add(struct vdev_info *dev, int num)
> +{
> +       struct vq_info *info = &dev->vqs[dev->nvqs];
> +       int r;
> +       info->idx = dev->nvqs;
> +       info->kick = eventfd(0, EFD_NONBLOCK);
> +       info->call = eventfd(0, EFD_NONBLOCK);
> +       r = posix_memalign(&info->ring, 4096, vring_size(num, 4096));
> +       assert(r >= 0);
> +       memset(info->ring, 0, vring_size(num, 4096));
> +       vring_init(&info->vring, num, info->ring, 4096);
> +       info->vq = vring_new_virtqueue(info->vring.num, 4096, &dev->vdev, info->ring,
> +                                      vq_notify, vq_callback, "test");
> +       assert(info->vq);
> +       info->vq->priv = info;
> +       vhost_vq_setup(dev, info);
> +       dev->fds[info->idx].fd = info->call;
> +       dev->fds[info->idx].events = POLLIN;
> +       dev->nvqs++;
> +}
> +
> +static void vdev_info_init(struct vdev_info* dev, unsigned long long features)
> +{
> +       int r;
> +       memset(dev, 0, sizeof *dev);
> +       dev->vdev.features[0] = features;
> +       dev->vdev.features[1] = features >> 32;
> +       dev->buf_size = 1024;
> +       dev->buf = malloc(dev->buf_size);
> +       assert(dev->buf);
> +        dev->control = open("/dev/vhost-test", O_RDWR);
> +       assert(dev->control >= 0);
> +       r = ioctl(dev->control, VHOST_SET_OWNER, NULL);
> +       assert(r >= 0);
> +       dev->mem = malloc(offsetof(struct vhost_memory, regions) +
> +                         sizeof dev->mem->regions[0]);
> +       assert(dev->mem);
> +       memset(dev->mem, 0, offsetof(struct vhost_memory, regions) +
> +                          sizeof dev->mem->regions[0]);
> +       dev->mem->nregions = 1;
> +       dev->mem->regions[0].guest_phys_addr = (long)dev->buf;
> +       dev->mem->regions[0].userspace_addr = (long)dev->buf;
> +       dev->mem->regions[0].memory_size = dev->buf_size;
> +       r = ioctl(dev->control, VHOST_SET_MEM_TABLE, dev->mem);
> +       assert(r >= 0);
> +}
> +
> +/* TODO: this is pretty bad: we get a cache line bounce
> + * for the wait queue on poll and another one on read,
> + * plus the read which is there just to clear the
> + * current state. */
> +static void wait_for_interrupt(struct vdev_info *dev)
> +{
> +       int i;
> +       unsigned long long val;
> +       poll(dev->fds, dev->nvqs, -1);
> +       for (i = 0; i < dev->nvqs; ++i)
> +               if (dev->fds[i].revents & POLLIN) {
> +                       read(dev->fds[i].fd, &val, sizeof val);
> +               }
> +}
> +
> +static void run_test(struct vdev_info *dev, struct vq_info *vq, int bufs)
> +{
> +       struct scatterlist sl;
> +       long started = 0, completed = 0;
> +       long completed_before;
> +       int r, test = 1;
> +       unsigned len;
> +       long long spurious = 0;
> +       r = ioctl(dev->control, VHOST_TEST_RUN, &test);
> +       assert(r >= 0);
> +       for (;;) {
> +               virtqueue_disable_cb(vq->vq);
> +               completed_before = completed;
> +               do {
> +                       if (started < bufs) {
> +                               sg_init_one(&sl, dev->buf, dev->buf_size);
> +                               r = virtqueue_add_buf(vq->vq, &sl, 1, 0,
> +                                                     dev->buf + started);
> +                               if (likely(r >= 0)) {
> +                                       ++started;
> +                                       virtqueue_kick(vq->vq);
> +                               }
> +                       } else
> +                               r = -1;
> +
> +                       /* Flush out completed bufs if any */
> +                       if (virtqueue_get_buf(vq->vq, &len)) {
> +                               ++completed;
> +                               r = 0;
> +                       }
> +
> +               } while (r >= 0);
> +               if (completed == completed_before)
> +                       ++spurious;
> +               assert(completed <= bufs);
> +               assert(started <= bufs);
> +               if (completed == bufs)
> +                       break;
> +               if (virtqueue_enable_cb(vq->vq)) {
> +                       wait_for_interrupt(dev);
> +               }
> +       }
> +       test = 0;
> +       r = ioctl(dev->control, VHOST_TEST_RUN, &test);
> +       assert(r >= 0);
> +       fprintf(stderr, "spurious wakeus: 0x%llx\n", spurious);
> +}
> +
> +const char optstring[] = "h";
> +const struct option longopts[] = {
> +       {
> +               .name = "help",
> +               .val = 'h',
> +       },
> +       {
> +               .name = "indirect",
> +               .val = 'I',
> +       },
> +       {
> +               .name = "no-indirect",
> +               .val = 'i',
> +       },
> +       {
> +       }
> +};
> +
> +static void help()
> +{
> +       fprintf(stderr, "Usage: virtio_test [--help] [--no-indirect]\n");
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       struct vdev_info dev;
> +       unsigned long long features = 1ULL << VIRTIO_RING_F_INDIRECT_DESC;
> +       int o;
> +
> +       for (;;) {
> +               o = getopt_long(argc, argv, optstring, longopts, NULL);
> +               switch (o) {
> +               case -1:
> +                       goto done;
> +               case '?':
> +                       help();
> +                       exit(2);
> +               case 'h':
> +                       help();
> +                       goto done;
> +               case 'i':
> +                       features &= ~(1ULL << VIRTIO_RING_F_INDIRECT_DESC);
> +                       break;
> +               default:
> +                       assert(0);
> +                       break;
> +               }
> +       }
> +
> +done:
> +       vdev_info_init(&dev, features);
> +       vq_info_add(&dev, 256);
> +       run_test(&dev, &dev.vqs[0], 0x100000);
> +       return 0;
> +}
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,

Zhi Yong Wu
