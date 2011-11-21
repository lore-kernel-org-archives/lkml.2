Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1KUDfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 22:35:55 -0500
Received: from ozlabs.org ([203.10.76.45]:33604 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1KUDfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 22:35:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, penberg@kernel.org, mingo@elte.hu
Subject: Re: [RFC 1/5] virtio-pci: flexible configuration layout
In-Reply-To: <1321314197-5265-2-git-send-email-levinsasha928@gmail.com>
References: <20111114181854.GA24953@redhat.com> <1321314197-5265-1-git-send-email-levinsasha928@gmail.com> <1321314197-5265-2-git-send-email-levinsasha928@gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 21 Nov 2011 11:31:31 +1030
Message-ID: <878vnab85w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011 01:43:13 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> 
> Add a flexible mechanism to specify virtio configuration layout, using
> pci vendor-specific capability.  A separate capability is used for each
> of common, device specific and data-path accesses.

OK, a couple of minor suggestions:

> +static int virtio_pci_iomap(struct virtio_pci_device *vp_dev)
> +{
> +	vp_dev->isr_map = virtio_pci_map_cfg(vp_dev,
> +					     VIRTIO_PCI_CAP_ISR_CFG,
> +					     sizeof(u8));
> +	vp_dev->notify_map = virtio_pci_map_cfg(vp_dev,
> +						VIRTIO_PCI_CAP_NOTIFY_CFG,
> +						sizeof(u16));
> +	vp_dev->common_map = virtio_pci_map_cfg(vp_dev,
> +						VIRTIO_PCI_CAP_COMMON_CFG,
> +						sizeof(u32));
> +	vp_dev->device_map = virtio_pci_map_cfg(vp_dev,
> +						VIRTIO_PCI_CAP_DEVICE_CFG,
> +						sizeof(u8));
> +
> +	if (!vp_dev->notify_map || !vp_dev->common_map ||
> +	    !vp_dev->device_map) {
> +		/*
> +		 * If not all capabilities present, map legacy PIO.
> +		 * Legacy access is at BAR 0. We never need to map
> +		 * more than 256 bytes there, since legacy config space
> +		 * used PIO which has this size limit.
> +		 * */
> +		vp_dev->legacy_map = pci_iomap(vp_dev->pci_dev, 0, 256);
> +		if (!vp_dev->legacy_map) {
> +			dev_err(&vp_dev->vdev.dev, "Unable to map legacy PIO");
> +			goto err;
> +		}
> +	}

Please don't mix the two.  Ever, under any circumstances.  If it helps,
put CONFIG_VIRTIO_PCI_LEGACY #ifdefs in there:

	vp_dev->common_map = virtio_pci_map_cfg(vp_dev,
						VIRTIO_PCI_CAP_COMMON_CFG,
						sizeof(u32));
        /* Something horribly wrong? */
        if (IS_ERR(vp_dev->common_map)) {
                err = PTR_ERR(vp_dev->common_map);
                goto fail;
        }

        /* Not found? */
        if (!vp_dev->common_map)
                return legacy_setup(vp_dev, ...);

        ...

Practice has shown that if we allow something, it'll be done.  We should
break horribly on malformed devices, and really really only fall back
when we have a well-formed, but old, device.

And various other legacy paths can happily use:

#ifdef CONFIG_VIRTIO_PCI_LEGACY
#define is_legacy(vp_dev) ((vp_dev)->legacy_map != NULL)
#else
#define is_legacy(vp_dev) false
#endif

Here's suggested Kconfig entry:

config VIRTIO_PCI_LEGACY
	bool
        default y
	depends on VIRTIO_PCI
	---help---
	  Look out into your driveway.  Do you have a flying car?  If
          so, you can happily disable this option and virtio will not
          break.  Otherwise, leave it set.  Unless you're testing what
          life will be like in The Future.

Cheers,
Rusty.
