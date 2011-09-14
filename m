Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1INCZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 22:25:41 -0400
Received: from ozlabs.org ([203.10.76.45]:35823 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab1INCZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 22:25:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/2] virtio: Add AMBA bus driver for virtio device
In-Reply-To: <1315906832.3297.41.camel@hornet.cambridge.arm.com>
References: <1314966257-7503-1-git-send-email-pawel.moll@arm.com> <1314966257-7503-2-git-send-email-pawel.moll@arm.com> <877h5e5yxp.fsf@rustcorp.com.au> <1315845956.3297.7.camel@hornet.cambridge.arm.com> <87hb4h408d.fsf@rustcorp.com.au> <1315906832.3297.41.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 14 Sep 2011 09:48:26 +0930
Message-ID: <87ehzkht7x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Sep 2011 10:40:32 +0100, Pawel Moll <pawel.moll@arm.com> wrote:
> > > No problem, I've reserved 128 bits in the modified registers layout (see
> > > RFC v2), I can even change it into "offset/value" interface, which would
> > > give you variable width. One thing I don't get is how to access feature
> > > bits > 31? The get_features() seems
> > > to be limited to 32:
> > > 
> > > struct virtio_config_ops {
> > > <...>
> > > 	u32 (*get_features)(struct virtio_device *vdev);
> > > <...>
> > > }
> > 
> > There's a patch for that already :)
> 
> Ok, so how about one of the following two options:
> 
> 1. 4 * 32-bit words of feature flags, 128 bits in total:
> 
>  *  0x010   32  HostFeatures0  Features supported by the host, bits 0-31
>  *  0x014   32  HostFeatures1  Features supported by the host, bits 32-63
>  *  0x018   32  HostFeatures2  Features supported by the host, bits 64-95
>  *  0x01c   32  HostFeatures3  Features supported by the host, bits 96-127
> 
>  *  0x020   32  GuestFeatures0 Features activated by the guest, bits 0-31
>  *  0x024   32  GuestFeatures1 Features activated by the guest, bits 32-63
>  *  0x028   32  GuestFeatures2 Features activated by the guest, bits 64-95
>  *  0x02c   32  GuestFeatures3 Features activated by the guest, bits 96-127
> 
> 2. "Select word -> read flags" interface:
> 
>  *  0x010   32  HostFeaturesFlags  Features supported by the host
>  *  0x014   32  HostFeaturesWord   Set of features to access
> 
>  *  0x020   32  GuestFeaturesFlags Features activated by the guest
>  *  0x024   32  GuestFeaturesWord  Set of features to set
> 
> In this case the algorithm would be:
> 
> 	writel(0, HostFeaturesWord);
> 	bits_0_31 = readl(HostFeaturesFlags);
> 	writel(1, HostFeaturesWord);
> 	bits_32_63 = readl(HostFeaturesFlags);
> 	<etc>
> 
> The latter seems more "future-proof" to me, if slightly more complex...
> Any other suggestions?

The former is almost certainly sufficient (remember, we can abuse the
final feature bit to indicate there are extended features somewhere
else, if we really have to).  But agree the latter is preferable: this
isn't time-critical.

> > We can sort that out later... the Guest may try some ambitious large
> > allocation and fall back if it fails.
> 
> So, to my mind, the negotiations could look like this (from the Guest's
> point of view):
> 
> 1. (optional) The Guest is asking what size is "suggested" by the Host:
> 
> 	size = readl(QueueNum);
> 
> 2. The Guest requests size it would like to use:
> 
> 	writel(optimal_size(size), QueueNum);
> 
> 3. The Host does the best it can to accommodate the Guest and the Guest
> checks the effective size:
> 
> 	size = real(QueueNum);
> 
> Does it make some sense?

Does Host care?  It is sufficient for it to publish min/max values?

You might want to throw the alignment value in there; there has been
talk about adding that to PCI, for really small rings (less than a
page).

Cheers,
Rusty.
