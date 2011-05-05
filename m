Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1EEJj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:39:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1EEJjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:39:25 -0400
Date: Thu, 5 May 2011 12:38:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lendacky <tahm@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCH 05/18] virtio: used event index interface
Message-ID: <20110505093816.GE28378@redhat.com>
References: <cover.1304541918.git.mst@redhat.com>
 <aacced20b8109a615ee24c1bde6d9f5702850111.1304541919.git.mst@redhat.com>
 <201105041656.11009.tahm@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105041656.11009.tahm@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 04:56:09PM -0500, Tom Lendacky wrote:
> On Wednesday, May 04, 2011 03:51:09 PM Michael S. Tsirkin wrote:
> > Define a new feature bit for the guest to utilize a used_event index
> > (like Xen) instead if a flag bit to enable/disable interrupts.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/virtio_ring.h |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> > index e4d144b..f5c1b75 100644
> > --- a/include/linux/virtio_ring.h
> > +++ b/include/linux/virtio_ring.h
> > @@ -29,6 +29,10 @@
> >  /* We support indirect buffer descriptors */
> >  #define VIRTIO_RING_F_INDIRECT_DESC	28
> > 
> > +/* The Guest publishes the used index for which it expects an interrupt
> > + * at the end of the avail ring. Host should ignore the avail->flags
> > field. */ +#define VIRTIO_RING_F_USED_EVENT_IDX	29
> > +
> >  /* Virtio ring descriptors: 16 bytes.  These can chain together via
> > "next". */ struct vring_desc {
> >  	/* Address (guest-physical). */
> > @@ -83,6 +87,7 @@ struct vring {
> >   *	__u16 avail_flags;
> >   *	__u16 avail_idx;
> >   *	__u16 available[num];
> > + *	__u16 used_event_idx;
> >   *
> >   *	// Padding to the next align boundary.
> >   *	char pad[];
> > @@ -93,6 +98,10 @@ struct vring {
> >   *	struct vring_used_elem used[num];
> >   * };
> >   */
> > +/* We publish the used event index at the end of the available ring.
> > + * It is at the end for backwards compatibility. */
> > +#define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
> > +
> >  static inline void vring_init(struct vring *vr, unsigned int num, void *p,
> >  			      unsigned long align)
> >  {
> 
> You should update the vring_size procedure to account for the extra field at 
> the end of the available ring by change the "(2 + num)" to "(3 + num)":
>     return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (3 + num)
> 
> Tom

In practice it gives the same result because of the alignment, but sure.
Thanks!

-- 
MST
