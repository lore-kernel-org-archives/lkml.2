Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3AJSjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:39:09 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:55887 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3AJSjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:39:07 -0500
MIME-Version: 1.0
In-Reply-To: <87wqvl1g9s.fsf@rustcorp.com.au>
References: <871ug75vp1.fsf@rustcorp.com.au>
	<1354718230-4486-1-git-send-email-sjur@brendeland.net>
	<20121206102750.GF10837@redhat.com>
	<877goc0wac.fsf@rustcorp.com.au>
	<CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com>
	<87pq1f2rj0.fsf@rustcorp.com.au>
	<87wqvl1g9s.fsf@rustcorp.com.au>
Date: Thu, 10 Jan 2013 19:39:05 +0100
Message-ID: <CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Thu, Jan 10, 2013 at 11:30 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
...
>I now have some lightly-tested code (via a userspace harness).

Great - thank you for looking into this. I will start integrating this
with my patches
when you send out a proper patch.

...
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 8d5bddb..fd95d3e 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -5,6 +5,12 @@ config VIRTIO
>           bus, such as CONFIG_VIRTIO_PCI, CONFIG_VIRTIO_MMIO, CONFIG_LGUEST,
>           CONFIG_RPMSG or CONFIG_S390_GUEST.
>
> +config VHOST
> +       tristate

Inclusion of drivers/virtio from drivers/Makefile depends on VIRTIO.
So I guess VHOST should select VIRTIO to ensure that
drivers/virtio/virtio_host.c
is part of the build.

> +       ---help---
> +         This option is selected by any driver which needs to access
> +         the host side of a virtio ring.
> +
...
> +/* Returns vring->num if empty, -ve on error. */
> +static inline int __vringh_get_head(const struct vringh *vrh,
> +                                   int (*getu16)(u16 *val, const u16 *p),
> +                                   u16 *last_avail_idx)
> +{
> +       u16 avail_idx, i, head;
> +       int err;
> +
> +       err = getu16(&avail_idx, &vrh->vring.avail->idx);
> +       if (err) {
> +               vringh_bad("Failed to access avail idx at %p",
> +                          &vrh->vring.avail->idx);
> +               return err;
> +       }
> +
> +       err = getu16(last_avail_idx, &vring_avail_event(&vrh->vring));
> +       if (err) {
> +               vringh_bad("Failed to access last avail idx at %p",
> +                          &vring_avail_event(&vrh->vring));
> +               return err;
> +       }
> +
> +       if (*last_avail_idx == avail_idx)
> +               return vrh->vring.num;
> +
> +       /* Only get avail ring entries after they have been exposed by guest. */
> +       smp_rmb();

We are accessing memory shared with a remote device (modem), so we probably
need mandatory barriers here, e.g. something like the virtio_rmb
defined in virtio_ring.c.

> +
> +       i = *last_avail_idx & (vrh->vring.num - 1);
> +
> +       err = getu16(&head, &vrh->vring.avail->ring[i]);
> +       if (err) {
> +               vringh_bad("Failed to read head: idx %d address %p",
> +                          *last_avail_idx, &vrh->vring.avail->ring[i]);
> +               return err;
> +       }
> +
> +       if (head >= vrh->vring.num) {
> +               vringh_bad("Guest says index %u > %u is available",
> +                          head, vrh->vring.num);
> +               return -EINVAL;
> +       }
> +       return head;
> +}
...
> +static inline int
> +__vringh_sg(struct vringh_acc *acc,
> +           struct vringh_sg *vsg,
> +           unsigned max,
> +           u16 write_flag,
> +           gfp_t gfp,
> +           int (*getdesc)(struct vring_desc *dst, const struct vring_desc *s))
> +{
> +       unsigned count = 0, num_descs = 0;
> +       struct vringh_sg *orig_vsg = vsg;
> +       int err;
> +
> +       /* This sends end marker on sg[max-1], so we know when to chain. */
> +       if (max)
> +               sg_init_table(&vsg->sg, max);
> +
> +       for (;;) {
> +               /* Exhausted this descriptor?  Read next. */
> +               if (acc->desc.len == 0) {
> +                       if (!(acc->desc.flags & VRING_DESC_F_NEXT))
> +                               break;
> +
> +                       if (num_descs++ == acc->max) {
> +                               err = -ELOOP;
> +                               goto fail;
> +                       }
> +
> +                       if (acc->desc.next >= acc->max) {
> +                               vringh_bad("Chained index %u > %u",
> +                                          acc->desc.next, acc->max);
> +                               err = -EINVAL;
> +                               goto fail;
> +                       }
> +
> +                       acc->idx = acc->desc.next;
> +                       err = getdesc(&acc->desc, acc->start + acc->idx);
> +                       if (unlikely(err))
> +                               goto fail;
> +               }
> +
> +               if (unlikely(!max)) {
> +                       vringh_bad("Unexpected %s descriptor",
> +                                  write_flag ? "writable" : "readable");
> +                       return -EINVAL;
> +               }
> +
> +               /* No more readable/writable descriptors? */
> +               if ((acc->desc.flags & VRING_DESC_F_WRITE) != write_flag) {
> +                       /* We should not have readable after writable */
> +                       if (write_flag) {
> +                               vringh_bad("Readable desc %p after writable",
> +                                          acc->start + acc->idx);
> +                               err = -EINVAL;
> +                               goto fail;
> +                       }
> +                       break;
> +               }
> +
> +               /* Append the pages into the sg. */
> +               err = add_to_sg(&vsg, (void *)(long)acc->desc.addr,
> +                               acc->desc.len, gfp);

I would prefer not to split into pages at this point, but rather provide an
iterator or the original list found in the descriptor to the client.

In our case we use virtio rings to talk to a LTE-modem over shared memory.
The IP traffic is received over the air, interleaved and arrives in
the virtio driver in
large bursts. So virtio driver on the modem receives multiple datagrams
held in large contiguous buffers. Our current approach is to handle each
buffer as a chained descriptor list, where each datagram is kept in
separate chained descriptors. When the buffers are consumed on the linux
host, the modem will read the chained descriptors from the used-ring and
free the entire contiguous buffer in one operation.

So I would prefer if we could avoid this approach of splitting buffers
received in
the ring into multiple sg-list entries as this would break the current
CAIF virtio
implementation.

Regards,
Sjur
