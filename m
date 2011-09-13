Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1IMJot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 05:44:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61077 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295Ab1IMJor convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 05:44:47 -0400
Subject: Re: [RFC 1/2] virtio: Add AMBA bus driver for virtio device
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <87hb4h408d.fsf@rustcorp.com.au>
References: <1314966257-7503-1-git-send-email-pawel.moll@arm.com>
	 <1314966257-7503-2-git-send-email-pawel.moll@arm.com>
	 <877h5e5yxp.fsf@rustcorp.com.au>
	 <1315845956.3297.7.camel@hornet.cambridge.arm.com>
	 <87hb4h408d.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 10:40:32 +0100
Message-ID: <1315906832.3297.41.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Sep 2011 09:40:32.0629 (UTC) FILETIME=[2E686250:01CC71F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No problem, I've reserved 128 bits in the modified registers layout (see
> > RFC v2), I can even change it into "offset/value" interface, which would
> > give you variable width. One thing I don't get is how to access feature
> > bits > 31? The get_features() seems
> > to be limited to 32:
> > 
> > struct virtio_config_ops {
> > <...>
> > 	u32 (*get_features)(struct virtio_device *vdev);
> > <...>
> > }
> 
> There's a patch for that already :)

Ok, so how about one of the following two options:

1. 4 * 32-bit words of feature flags, 128 bits in total:

 *  0x010   32  HostFeatures0  Features supported by the host, bits 0-31
 *  0x014   32  HostFeatures1  Features supported by the host, bits 32-63
 *  0x018   32  HostFeatures2  Features supported by the host, bits 64-95
 *  0x01c   32  HostFeatures3  Features supported by the host, bits 96-127

 *  0x020   32  GuestFeatures0 Features activated by the guest, bits 0-31
 *  0x024   32  GuestFeatures1 Features activated by the guest, bits 32-63
 *  0x028   32  GuestFeatures2 Features activated by the guest, bits 64-95
 *  0x02c   32  GuestFeatures3 Features activated by the guest, bits 96-127

2. "Select word -> read flags" interface:

 *  0x010   32  HostFeaturesFlags  Features supported by the host
 *  0x014   32  HostFeaturesWord   Set of features to access

 *  0x020   32  GuestFeaturesFlags Features activated by the guest
 *  0x024   32  GuestFeaturesWord  Set of features to set

In this case the algorithm would be:

	writel(0, HostFeaturesWord);
	bits_0_31 = readl(HostFeaturesFlags);
	writel(1, HostFeaturesWord);
	bits_32_63 = readl(HostFeaturesFlags);
	<etc>

The latter seems more "future-proof" to me, if slightly more complex...
Any other suggestions?

> > > > + *  0x008   32  QueuePFN      PFN for the currently selected queue
> > > > + *  0x00c   32  QueueNum      Queue size for the currently selected queue
> > > 
> > > You should, I believe, seriously consider allowing the guest to set the
> > > queue size, rather than the host (perhaps the host could suggest one,
> > > but the guest should be able to override it).
> > 
> > I guess the QueueNum could be simply a read/write register - guest can
> > read suggestion and override it writing it back. The same question
> > though - how can guest change it? (I mean some API?)
> 
> We can sort that out later... the Guest may try some ambitious large
> allocation and fall back if it fails.

So, to my mind, the negotiations could look like this (from the Guest's
point of view):

1. (optional) The Guest is asking what size is "suggested" by the Host:

	size = readl(QueueNum);

2. The Guest requests size it would like to use:

	writel(optimal_size(size), QueueNum);

3. The Host does the best it can to accommodate the Guest and the Guest
checks the effective size:

	size = real(QueueNum);

Does it make some sense?

> > > Anthony or Michael might suggest other changes, since they are most
> > > familiar with virtio_pci limitations...
> > 
> > I've added them on the RFC v2 Cc as well - all feedback more then
> > welcome!
> 
> Excellent...  of course, the virtualization list is down at the moment,
> making this a bit more awkward.

Haha - at least once I can't blame our corporate IT for making my job
harder ;-)

Cheers!

Paweł

