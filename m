Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3AJKuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:50:22 -0500
Received: from ozlabs.org ([203.10.76.45]:37211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3AJKuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:50:20 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
In-Reply-To: <87pq1f2rj0.fsf@rustcorp.com.au>
References: <871ug75vp1.fsf@rustcorp.com.au> <1354718230-4486-1-git-send-email-sjur@brendeland.net> <20121206102750.GF10837@redhat.com> <877goc0wac.fsf@rustcorp.com.au> <CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com> <87pq1f2rj0.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 10 Jan 2013 21:00:55 +1030
Message-ID: <87wqvl1g9s.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
> It basically involves moving much of vring.c into a virtio_host.c: the
> parts which actually touch the ring.  Then it provides accessors for
> vring.c to use which are __user-safe (all casts are inside
> virtio_host.c).
>
> I should have something to post by end of today, my time...

Well, that was optimistic.

I now have some lightly-tested code (via a userspace harness).  The
interface will probably change again as I try to adapt vhost to use it.

The emphasis is getting a sglist out of the vring as efficiently as
possible.  This involves some hacks: I'm still wondering if we should
move the address mapping logic into the virtio_host core, with a callout
if an address we want is outside a single range.

Not sure why vring/net doesn't built a packet and feed it in
netif_rx_ni().  This is what tun seems to do, and with this code it
should be fairly optimal.

Cheers,
Rusty.

virtio_host: host-side implementation of virtio rings.

Getting use of virtio rings correct is tricky, and a recent patch saw
an implementation of in-kernel rings (as separate from userspace).

This patch attempts to abstract the business of dealing with the
virtio ring layout from the access (userspace or direct); to do this,
we use function pointers, which gcc inlines correctly.

The new API should be more efficient than the existing vhost code,
too, since we convert directly to chained sg lists, which can be
modified in place to map the pages.

Disadvantages:
1) The spec allows chained indirect entries, we don't.  Noone does this,
   but it's not as crazy as it sounds, so perhaps we should support it.  If
   we did, we'd almost certainly invoke an function ptr call to check the
   validity of the indirect mem.

2) Getting an accessor is ugly; if it's indirect, the caller has to check
   that it's valid.  Efficient, but it's a horrible API.

No doubt this will change as I try to adapt existing vhost drivers.

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 202bba6..38ec470 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -1,6 +1,7 @@
 config VHOST_NET
 	tristate "Host kernel accelerator for virtio net (EXPERIMENTAL)"
 	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP) && EXPERIMENTAL
+	select VHOST
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest networking with virtio_net. Not to be confused with virtio_net
diff --git a/drivers/vhost/Kconfig.tcm b/drivers/vhost/Kconfig.tcm
index a9c6f76..f4c3704 100644
--- a/drivers/vhost/Kconfig.tcm
+++ b/drivers/vhost/Kconfig.tcm
@@ -1,6 +1,7 @@
 config TCM_VHOST
 	tristate "TCM_VHOST fabric module (EXPERIMENTAL)"
 	depends on TARGET_CORE && EVENTFD && EXPERIMENTAL && m
+	select VHOST
 	default n
 	---help---
 	Say M here to enable the TCM_VHOST fabric module for use with virtio-scsi guests
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 8d5bddb..fd95d3e 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -5,6 +5,12 @@ config VIRTIO
 	  bus, such as CONFIG_VIRTIO_PCI, CONFIG_VIRTIO_MMIO, CONFIG_LGUEST,
 	  CONFIG_RPMSG or CONFIG_S390_GUEST.
 
+config VHOST
+	tristate
+	---help---
+	  This option is selected by any driver which needs to access
+	  the host side of a virtio ring.
+
 menu "Virtio drivers"
 
 config VIRTIO_PCI
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 9076635..9833cd5 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_VIRTIO) += virtio.o virtio_ring.o
 obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
+obj-$(CONFIG_VHOST) += virtio_host.o
diff --git a/drivers/virtio/virtio_host.c b/drivers/virtio/virtio_host.c
new file mode 100644
index 0000000..169c8e2
--- /dev/null
+++ b/drivers/virtio/virtio_host.c
@@ -0,0 +1,668 @@
+/*
+ * Helpers for the host side of a virtio ring.
+ *
+ * Since these may be in userspace, we use (inline) accessors.
+ */
+#include <linux/virtio_host.h>
+#include <linux/kernel.h>
+#include <linux/ratelimit.h>
+#include <linux/uaccess.h>
+
+/* An inline function, for easy cold marking. */
+static __cold bool __vringh_bad(void)
+{
+	static DEFINE_RATELIMIT_STATE(vringh_rs,
+				      DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
+	return __ratelimit(&vringh_rs);
+}
+
+#define vringh_bad(fmt, ...)						\
+	do { if (__vringh_bad())					\
+			printk(KERN_NOTICE "vringh: " fmt "\n", __VA_ARGS__); \
+	} while(0)
+
+/* Returns vring->num if empty, -ve on error. */
+static inline int __vringh_get_head(const struct vringh *vrh,
+				    int (*getu16)(u16 *val, const u16 *p),
+				    u16 *last_avail_idx)
+{
+	u16 avail_idx, i, head;
+	int err;
+
+	err = getu16(&avail_idx, &vrh->vring.avail->idx);
+	if (err) {
+		vringh_bad("Failed to access avail idx at %p",
+			   &vrh->vring.avail->idx);
+		return err;
+	}
+
+	err = getu16(last_avail_idx, &vring_avail_event(&vrh->vring));
+	if (err) {
+		vringh_bad("Failed to access last avail idx at %p",
+			   &vring_avail_event(&vrh->vring));
+		return err;
+	}
+
+	if (*last_avail_idx == avail_idx)
+		return vrh->vring.num;
+
+	/* Only get avail ring entries after they have been exposed by guest. */
+	smp_rmb();
+
+	i = *last_avail_idx & (vrh->vring.num - 1);
+
+	err = getu16(&head, &vrh->vring.avail->ring[i]);
+	if (err) {
+		vringh_bad("Failed to read head: idx %d address %p",
+			   *last_avail_idx, &vrh->vring.avail->ring[i]);
+		return err;
+	}
+
+	if (head >= vrh->vring.num) {
+		vringh_bad("Guest says index %u > %u is available",
+			   head, vrh->vring.num);
+		return -EINVAL;
+	}
+	return head;
+}
+
+/*
+ * Initialize the vringh_access structure for this head.
+ *
+ * For direct buffers, the range is simply the desc[] array in the vring.
+ *
+ * For indirect buffers, the range is the indirect entry; check() is called
+ * to validate this range.
+ *
+ * -error otherwise.
+ */
+static inline int __vringh_get_access(const struct vringh *vrh, u16 head,
+				      int (*getdesc)(struct vring_desc *dst,
+						     const struct vring_desc *),
+				      struct vringh_acc *acc)
+{
+	int err;
+
+	acc->head = head;
+
+	err = getdesc(&acc->desc, &vrh->vring.desc[head]);
+	if (unlikely(err))
+		return err;
+
+	if (acc->desc.flags & VRING_DESC_F_INDIRECT) {
+		/* We don't support chained indirects. */
+		if (acc->desc.flags & VRING_DESC_F_NEXT)
+			return -EINVAL;
+		if (unlikely(acc->desc.len % sizeof(acc->desc)))
+			return -EINVAL;
+
+		acc->start = (void *)(long)acc->desc.addr;
+		acc->max = acc->desc.len / sizeof(acc->desc);
+
+		if (acc->max > vrh->vring.num)
+			return -EINVAL;
+
+		/* Force us to read first desc next time. */
+		acc->desc.len = 0;
+		acc->desc.next = 0;
+		acc->desc.flags = VRING_DESC_F_NEXT;
+	} else {
+		acc->start = vrh->vring.desc;
+		acc->max = vrh->vring.num;
+		acc->idx = head;
+	}
+	return 0;
+}
+
+/* Copy some bytes to/from the vring descriptor.  Returns num copied. */
+static inline int vsg_xfer(struct vringh_sg **vsg,
+			   unsigned int *num,
+			   void *ptr, size_t len,
+			   int (*xfer)(void *sgaddr, void *ptr, size_t len))
+{
+	int err, done = 0;
+
+	while (len && *num) {
+		size_t partlen;
+		struct scatterlist *sg = &(*vsg)->sg;
+
+		partlen = min(sg->length, len);
+		err = xfer(vringh_sg_addr(*vsg), ptr, partlen);
+		if (err)
+			return err;
+		sg->offset += partlen;
+		sg->length -= partlen;
+		len -= partlen;
+		done += partlen;
+		ptr += partlen;
+
+		if (sg->length == 0) {
+			*vsg = (struct vringh_sg *)sg_next(sg);
+			(*num)--;
+		}
+	}
+	return done;
+}
+
+static unsigned int rest_of_page(void *data)
+{
+	return PAGE_SIZE - ((unsigned long)data % PAGE_SIZE);
+}
+
+static struct vringh_sg *add_sg_chain(struct vringh_sg *end, gfp_t gfp)
+{
+	struct vringh_sg *vsg = (void *)__get_free_page(gfp);
+
+	if (!vsg)
+		return NULL;
+
+	sg_init_table(&vsg->sg, PAGE_SIZE / sizeof(*vsg));
+	sg_chain(&end->sg, 1, &vsg->sg);
+	return vsg;
+}
+
+/* We add a chain to the sg if we hit end: we're putting addresses in sg_page,
+ * as caller needs to map them itself. */
+static inline int add_to_sg(struct vringh_sg **vsg,
+			    void *addr, u32 len, gfp_t gfp)
+{
+	int done = 0;
+
+	while (len) {
+		int partlen;
+		void *paddr;
+
+		paddr = (void *)((long)addr & PAGE_MASK);
+
+		if (unlikely(sg_is_last(&(*vsg)->sg))) {
+			*vsg = add_sg_chain(*vsg, gfp);
+			if (!*vsg)
+				return -ENOMEM;
+		}
+
+		partlen = rest_of_page(addr);
+		if (partlen > len)
+			partlen = len;
+		sg_set_page(&(*vsg)->sg, paddr, partlen, offset_in_page(addr));
+		(*vsg)++;
+		len -= partlen;
+		addr += partlen;
+		done++;
+	}
+	return done;
+}
+
+static inline int
+__vringh_sg(struct vringh_acc *acc,
+	    struct vringh_sg *vsg,
+	    unsigned max,
+	    u16 write_flag,
+	    gfp_t gfp,
+	    int (*getdesc)(struct vring_desc *dst, const struct vring_desc *s))
+{
+	unsigned count = 0, num_descs = 0;
+	struct vringh_sg *orig_vsg = vsg;
+	int err;
+
+	/* This sends end marker on sg[max-1], so we know when to chain. */
+	if (max)
+		sg_init_table(&vsg->sg, max);
+
+	for (;;) {
+		/* Exhausted this descriptor?  Read next. */
+		if (acc->desc.len == 0) {
+			if (!(acc->desc.flags & VRING_DESC_F_NEXT))
+				break;
+
+			if (num_descs++ == acc->max) {
+				err = -ELOOP;
+				goto fail;
+			}
+
+			if (acc->desc.next >= acc->max) {
+				vringh_bad("Chained index %u > %u",
+					   acc->desc.next, acc->max);
+				err = -EINVAL;
+				goto fail;
+			}
+
+			acc->idx = acc->desc.next;
+			err = getdesc(&acc->desc, acc->start + acc->idx);
+			if (unlikely(err))
+				goto fail;
+		}
+
+		if (unlikely(!max)) {
+			vringh_bad("Unexpected %s descriptor",
+				   write_flag ? "writable" : "readable");
+			return -EINVAL;
+		}
+
+		/* No more readable/writable descriptors? */
+		if ((acc->desc.flags & VRING_DESC_F_WRITE) != write_flag) {
+			/* We should not have readable after writable */
+			if (write_flag) {
+				vringh_bad("Readable desc %p after writable",
+					   acc->start + acc->idx);
+				err = -EINVAL;
+				goto fail;
+			}
+			break;
+		}
+
+		/* Append the pages into the sg. */
+		err = add_to_sg(&vsg, (void *)(long)acc->desc.addr,
+				acc->desc.len, gfp);
+		if (err < 0)
+			goto fail;
+		count += err;
+		acc->desc.len = 0;
+	}
+	if (count)
+		sg_mark_end(&vsg->sg);
+	return count;
+
+fail:
+	vringh_sg_free(orig_vsg);
+	return err;
+}
+
+static inline int __vringh_complete(struct vringh *vrh, u16 idx, u16 len,
+				    int (*getu16)(u16 *val, const u16 *p),
+				    int (*putu16)(u16 *p, u16 val),
+				    int (*putused)(struct vring_used_elem *dst,
+						   const struct vring_used_elem
+						   *s),
+				    bool *notify)
+{
+	struct vring_used_elem used;
+	struct vring_used *used_ring;
+	int err;
+	u16 used_idx, old, used_event;
+
+	used.id = idx;
+	used.len = len;
+
+	err = getu16(&used_idx, &vring_used_event(&vrh->vring));
+	if (err) {
+		vringh_bad("Failed to access used event %p",
+			   &vring_used_event(&vrh->vring));
+		return err;
+	}
+
+	used_ring = vrh->vring.used;
+
+	err = putused(&used_ring->ring[used_idx % vrh->vring.num], &used);
+	if (err) {
+		vringh_bad("Failed to write used entry %u at %p",
+			   used_idx % vrh->vring.num,
+			   &used_ring->ring[used_idx % vrh->vring.num]);
+		return err;
+	}
+
+	/* Make sure buffer is written before we update index. */
+	smp_wmb();
+
+	old = vrh->last_used_idx;
+	vrh->last_used_idx++;
+
+	err = putu16(&vrh->vring.used->idx, vrh->last_used_idx);
+	if (err) {
+		vringh_bad("Failed to update used index at %p",
+			   &vrh->vring.used->idx);
+		return err;
+	}
+
+	/* If we already know we need to notify, skip re-checking */
+	if (*notify)
+		return 0;
+
+	/* Flush out used index update. This is paired with the
+	 * barrier that the Guest executes when enabling
+	 * interrupts. */
+	smp_mb();
+
+	/* Old-style, without event indices. */
+	if (!vrh->event_indices) {
+		u16 flags;
+		err = getu16(&flags, &vrh->vring.avail->flags);
+		if (err) {
+			vringh_bad("Failed to get flags at %p",
+				   &vrh->vring.avail->flags);
+			return err;
+		}
+		if (!(flags & VRING_AVAIL_F_NO_INTERRUPT))
+			*notify = true;
+		return 0;
+	}
+
+	/* Modern: we know where other side is up to. */
+	err = getu16(&used_event, &vring_used_event(&vrh->vring));
+	if (err) {
+		vringh_bad("Failed to get used event idx at %p",
+			   &vring_used_event(&vrh->vring));
+		return err;
+	}
+	if (vring_need_event(used_event, vrh->last_used_idx, old))
+		*notify = true;
+	return 0;
+}
+
+static inline bool __vringh_notify_enable(struct vringh *vrh,
+					  int (*getu16)(u16 *val, const u16 *p),
+					  int (*putu16)(u16 *p, u16 val))
+{
+	u16 avail;
+
+	/* Already enabled? */
+	if (vrh->listening)
+		return false;
+
+	vrh->listening = true;
+
+	if (!vrh->event_indices) {
+		/* Old-school; update flags. */
+		if (putu16(&vrh->vring.used->flags, 0) != 0) {
+			vringh_bad("Clearing used flags %p",
+				   &vrh->vring.used->flags);
+			return false;
+		}
+	} else {
+		if (putu16(&vring_avail_event(&vrh->vring),
+			   vrh->last_avail_idx) != 0) {
+			vringh_bad("Updating avail event index %p",
+				   &vring_avail_event(&vrh->vring));
+			return false;
+		}
+	}
+
+	/* They could have slipped one in as we were doing that: make
+	 * sure it's written, then check again. */
+	smp_mb();
+
+	if (getu16(&avail, &vrh->vring.avail->idx) != 0) {
+		vringh_bad("Failed to check avail idx at %p",
+			   &vrh->vring.avail->idx);
+		return false;
+	}
+
+	/* This is so unlikely, we just leave notifications enabled. */
+	return avail != vrh->last_avail_idx;
+}
+
+static inline void __vringh_notify_disable(struct vringh *vrh,
+					   int (*putu16)(u16 *p, u16 val))
+{
+	/* Already disabled? */
+	if (!vrh->listening)
+		return;
+
+	vrh->listening = false;
+	if (!vrh->event_indices) {
+		/* Old-school; update flags. */
+		if (putu16(&vrh->vring.used->flags, VRING_USED_F_NO_NOTIFY)) {
+			vringh_bad("Setting used flags %p",
+				   &vrh->vring.used->flags);
+		}
+	}
+}
+
+/* Userspace access helpers. */
+static inline int getu16_user(u16 *val, const u16 *p)
+{
+	return get_user(*val, (__force u16 __user *)p);
+}
+
+static inline int putu16_user(u16 *p, u16 val)
+{
+	return put_user(val, (__force u16 __user *)p);
+}
+
+static inline int getdesc_user(struct vring_desc *dst,
+			       const struct vring_desc *src)
+{
+	return copy_from_user(dst, (__force void *)src, sizeof(*dst)) == 0 ? 0 :
+		-EFAULT;
+}
+
+static inline int putused_user(struct vring_used_elem *dst,
+			       const struct vring_used_elem *s)
+{
+	return copy_to_user((__force void __user *)dst, s, sizeof(*dst)) == 0
+		? 0 : -EFAULT;
+}
+
+static inline int xfer_from_user(void *src, void *dst, size_t len)
+{
+	return copy_from_user(dst, (__force void *)src, len) == 0 ? 0 :
+		-EFAULT;
+}
+
+static inline int xfer_to_user(void *dst, void *src, size_t len)
+{
+	return copy_to_user((__force void *)dst, src, len) == 0 ? 0 :
+		-EFAULT;
+}
+
+/**
+ * vringh_init_user - initialize a vringh for a userspace vring.
+ * @vrh: the vringh to initialize.
+ * @features: the feature bits for this ring.
+ * @num: the number of elements.
+ * @desc: the userpace descriptor pointer.
+ * @avail: the userpace avail pointer.
+ * @used: the userpace used pointer.
+ *
+ * Returns an error if num is invalid: you should check pointers
+ * yourself!
+ */
+int vringh_init_user(struct vringh *vrh, u32 features,
+		     unsigned int num,
+		     struct vring_desc __user *desc,
+		     struct vring_avail __user *avail,
+		     struct vring_used __user *used)
+{
+	/* Sane power of 2 please! */
+	if (!num || num > 0xffff || (num & (num - 1))) {
+		vringh_bad("Bad ring size %zu", num);
+		return -EINVAL;
+	}
+
+	vrh->event_indices = (features & VIRTIO_RING_F_EVENT_IDX);
+	vrh->listening = false;
+	vrh->last_avail_idx = 0;
+	vrh->last_used_idx = 0;
+	vrh->vring.num = num;
+	vrh->vring.desc = (__force struct vring_desc *)desc;
+	vrh->vring.avail = (__force struct vring_avail *)avail;
+	vrh->vring.used = (__force struct vring_used *)used;
+	return 0;
+}
+
+/**
+ * vringh_getdesc_user - get next available descriptor from userspace ring.
+ * @vrh: the userspace vring.
+ * @acc: the accessor structure to fill in.
+ *
+ * Returns 0 if it filled in @acc, or -errno.  @acc->max is 0 if the ring is
+ * empty.
+ *
+ * Make sure you check that acc->start to acc->start + acc->max is
+ * valid memory!
+ */
+int vringh_getdesc_user(struct vringh *vrh, struct vringh_acc *acc)
+{
+	int err;
+
+	err = __vringh_get_head(vrh, getu16_user, &vrh->last_avail_idx);
+	if (unlikely(err))
+		return err;
+
+	/* Empty... */
+	if (err == vrh->vring.num) {
+		acc->max = 0;
+		return 0;
+	}
+
+	return __vringh_get_access(vrh, err, getdesc_user, acc);
+}
+
+/**
+ * vringh_rsg_user - form an sg from the remaining readable bytes.
+ * @acc: the accessor from vringh_get_user.
+ * @sg: the scatterlist to populate
+ * @num: the number of elements in @sg
+ * @gfp: the allocation flags if we need to chain onto @sg.
+ *
+ * This puts the page addresses into @sg: not the struct pages!  You must
+ * map the pages.  It will allocate and chained sgs if required: in this
+ * case the return value will be >= num - 1, and vringh_sg_free()
+ * must be called to free the chained elements.
+ *
+ * You are expected to pull / rsg all readable bytes before accessing writable
+ * bytes.
+ *
+ * Returns -errno, or number of @sg elements created.
+ */
+int vringh_rsg_user(struct vringh_acc *acc,
+		    struct vringh_sg *vsg, unsigned num, gfp_t gfp)
+{
+	return __vringh_sg(acc, vsg, num, 0, gfp, getdesc_user);
+}
+
+/**
+ * vringh_rsg_pull_user - copy bytes from vsg.
+ * @vsg: the vsg from vringh_rsg_user() (updated as we consume)
+ * @num: the number of elements in @vsg (updated as we consume)
+ * @dst: the place to copy.
+ * @len: the maximum length to copy.
+ *
+ * Returns the bytes copied <= len or a negative errno.
+ */
+ssize_t vringh_rsg_pull_user(struct vringh_sg **vsg, unsigned *num,
+			     void *dst, size_t len)
+{
+	return vsg_xfer(vsg, num, dst, len, xfer_from_user);
+}
+
+/**
+ * vringh_wsg_user - form an sg from the remaining writable bytes.
+ * @acc: the accessor from vringh_get_user.
+ * @sg: the scatterlist to populate
+ * @num: the number of elements in @sg
+ * @gfp: the allocation flags if we need to chain onto @sg.
+ *
+ * This puts the page addresses into @sg: not the struct pages!  You must
+ * map the pages.  It will allocate and chained sgs if required: in this
+ * case the return value will be >= num - 1, and vringh_sg_free()
+ * must be called to free the chained elements.
+ *
+ * You are expected to pull / rsg all readable bytes before calling this!
+ *
+ * Returns -errno, or number of @sg elements created.
+ */
+int vringh_wsg_user(struct vringh_acc *acc,
+		    struct vringh_sg *vsg, unsigned num, gfp_t gfp)
+{
+	return __vringh_sg(acc, vsg, num, VRING_DESC_F_WRITE, gfp,
+			   getdesc_user);
+}
+
+/**
+ * vringh_wsg_push_user - copy bytes to vsg.
+ * @vsg: the vsg from vringh_wsg_user() (updated as we consume)
+ * @num: the number of elements in @vsg (updated as we consume)
+ * @dst: the place to copy.
+ * @len: the maximum length to copy.
+ *
+ * Returns the bytes copied <= len or a negative errno.
+ */
+ssize_t vringh_wsg_push_user(struct vringh_sg **vsg, unsigned *num,
+			     const void *src, size_t len)
+{
+	return vsg_xfer(vsg, num, (void *)src, len, xfer_to_user);
+}
+
+/**
+ * vringh_abandon_user - we've decided not to handle the descriptor(s).
+ * @vrh: the vring.
+ * @num: the number of descriptors to put back (ie. num
+ *	 vringh_get_user() to undo).
+ *
+ * The next vringh_get_user() will return the old descriptor(s) again.
+ */
+void vringh_abandon_user(struct vringh *vrh, unsigned int num)
+{
+	/* We only update vring_avail_event(vr) when we want to be notified,
+	 * so we haven't changed that yet. */
+	vrh->last_avail_idx -= num;
+}
+
+/**
+ * vringh_complete_user - we've finished with descriptor, publish it.
+ * @vrh: the vring.
+ * @acc: the accessor from vringh_get_user.
+ * @len: the length of data we have written.
+ * @notify: set if we should notify the other side, otherwise left alone.
+ */
+int vringh_complete_user(struct vringh *vrh,
+			 const struct vringh_acc *acc,
+			 u16 len,
+			 bool *notify)
+{
+	return __vringh_complete(vrh, acc->head, len,
+				 getu16_user, putu16_user, putused_user,
+				 notify);
+}
+
+/**
+ * vringh_sg_free - free a chained sg.
+ * @vsg: the vsg from vringh_wsg_user/vringh_rsg_user
+ *
+ * If vringh_wsg_user/vringh_rsg_user chains your sg, you should call
+ * this to free it.
+ */
+void __cold vringh_sg_free(struct vringh_sg *vsg)
+{
+	struct scatterlist *next, *curr_start, *orig, *sg;
+
+	sg = &vsg->sg;
+	curr_start = orig = sg;
+
+	while (sg) {
+		next = sg_next(sg);
+		if (sg_is_chain(sg+1)) {
+			if (curr_start != orig)
+				free_page((long)curr_start);
+			curr_start = next;
+		}
+		sg = next;
+	}
+	if (curr_start != orig)
+		free_page((long)curr_start);
+}
+
+/**
+ * vringh_notify_enable_user - we want to know if something changes.
+ * @vrh: the vring.
+ *
+ * This always enables notifications, but returns true if there are
+ * now more buffers available in the vring.
+ */
+bool vringh_notify_enable_user(struct vringh *vrh)
+{
+	return __vringh_notify_enable(vrh, getu16_user, putu16_user);
+}
+
+/**
+ * vringh_notify_disable_user - don't tell us if something changes.
+ * @vrh: the vring.
+ *
+ * This is our normal running state: we disable and then only enable when
+ * we're going to sleep.
+ */
+void vringh_notify_disable_user(struct vringh *vrh)
+{
+	__vringh_notify_disable(vrh, putu16_user);
+}
diff --git a/include/linux/virtio_host.h b/include/linux/virtio_host.h
new file mode 100644
index 0000000..cb4b693
--- /dev/null
+++ b/include/linux/virtio_host.h
@@ -0,0 +1,136 @@
+/*
+ * Linux host-side vring helpers; for when the kernel needs to access
+ * someone else's vring.
+ *
+ * Copyright IBM Corporation, 2013.
+ * Parts taken from drivers/vhost/vhost.c Copyright 2009 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Written by: Rusty Russell <rusty@rustcorp.com.au>
+ */
+#ifndef _LINUX_VIRTIO_HOST_H
+#define _LINUX_VIRTIO_HOST_H
+#include <uapi/linux/virtio_ring.h>
+#include <linux/scatterlist.h>
+
+/* virtio_ring with information needed for host access. */
+struct vringh {
+	/* Guest publishes used event idx (note: we always do). */
+	bool event_indices;
+
+	/* Have we told the other end we want to be notified? */
+	bool listening;
+
+	/* Last available index we saw (ie. where we're up to). */
+	u16 last_avail_idx;
+
+	/* Last index we used. */
+	u16 last_used_idx;
+
+	/* The vring (note: it may contain user pointers!) */
+	struct vring vring;
+};
+
+/**
+ * struct vringh_sg - a scatterlist containing addresses.
+ *
+ * This data structure is trivially mapped in-place to a real sg, but
+ * the method is best left to the users (they may have to map user
+ * pages and add offsets to addresses).
+ */
+struct vringh_sg {
+	struct scatterlist sg;
+} __packed;
+
+static inline void *vringh_sg_addr(const struct vringh_sg *vsg)
+{
+	return (void *)sg_page((struct scatterlist *)&vsg->sg) + vsg->sg.offset;
+}
+
+/* Accessor structure for a single descriptor. */
+struct vringh_acc {
+	/* Start address. */
+	struct vring_desc *start;
+
+	/* Maximum number of entries, <= ring size. */
+	u32 max;
+
+	/* Head index we got, for vringh_complete_user, and current index. */
+	u16 head, idx;
+
+	/* Cached descriptor. */
+	struct vring_desc desc;
+};
+
+/* Helpers for userspace vrings. */
+int vringh_init_user(struct vringh *vrh, u32 features,
+		     unsigned int num,
+		     struct vring_desc __user *desc,
+		     struct vring_avail __user *avail,
+		     struct vring_used __user *used);
+
+/* Get accessor to userspace vring: make sure start to start+max is valid! */
+int vringh_getdesc_user(struct vringh *vrh, struct vringh_acc *acc);
+
+/* Fetch readable descriptor in vsg (num == 0 gives error if any). */
+int vringh_rsg_user(struct vringh_acc *acc,
+		    struct vringh_sg *vsg, unsigned num, gfp_t gfp);
+
+/* Then fetch writable descriptor in sg (num == 0 gives error if any). */
+int vringh_wsg_user(struct vringh_acc *acc,
+		    struct vringh_sg *vsg, unsigned num, gfp_t gfp);
+
+/* Copy bytes from readable vsg, consuming it. */
+ssize_t vringh_rsg_pull_user(struct vringh_sg **vsg, unsigned *num,
+			     void *dst, size_t len);
+
+/* Copy bytes into writable vsg, consuming it. */
+ssize_t vringh_rsg_push_user(struct vringh_sg **vsg, unsigned *num,
+			     const void *src, size_t len);
+
+/* Unmap all the pages mapped in this sg. */
+void vringh_unmap_pages(struct scatterlist *sg, unsigned num);
+
+/* Map a vring_sg, turning it into a real sg. */
+static inline struct scatterlist *vringh_sg_map(struct vringh_sg *vsg,
+						unsigned num,
+						struct page *(*map)(void *addr))
+{
+	struct scatterlist *orig_sg = (struct scatterlist *)vsg, *sg;
+	int i;
+
+	for_each_sg(orig_sg, sg, num, i) {
+		struct page *p = map(sg_page(sg));
+		if (unlikely(IS_ERR(p))) {
+			vringh_unmap_pages(orig_sg, i);
+			return (struct scatterlist *)p;
+		}
+	}
+	return orig_sg;
+}
+
+/* If wsg or rsg returns > num - 1, call this to free sg chains. */
+void vringh_sg_free(struct vringh_sg *sg);
+
+/* Mark a descriptor as used.  Sets notify if you should fire eventfd. */
+int vringh_complete_user(struct vringh *vrh,
+			 const struct vringh_acc *acc,
+			 u16 len,
+			 bool *notify);
+
+/* Pretend we've never seen descriptor (for easy error handling). */
+void vringh_abandon_user(struct vringh *vrh, unsigned int num);
+#endif /* _LINUX_VIRTIO_HOST_H */
