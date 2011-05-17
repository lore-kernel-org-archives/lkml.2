Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1EQGKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 02:10:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab1EQGKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 02:10:47 -0400
Date: Tue, 17 May 2011 09:10:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCH 09/18] virtio: use avail_event index
Message-ID: <20110517061031.GC26989@redhat.com>
References: <cover.1304541918.git.mst@redhat.com>
 <8bba6a0a8eee17e741c5155b04ff1b1c9f34bf94.1304541919.git.mst@redhat.com>
 <874o54h4rt.fsf@rustcorp.com.au>
 <20110515135541.GF24932@redhat.com>
 <87ei3zdsq2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ei3zdsq2.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 04:42:21PM +0930, Rusty Russell wrote:
> On Sun, 15 May 2011 16:55:41 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Mon, May 09, 2011 at 02:03:26PM +0930, Rusty Russell wrote:
> > > On Wed, 4 May 2011 23:51:47 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > Use the new avail_event feature to reduce the number
> > > > of exits from the guest.
> > > 
> > > Figures here would be nice :)
> > 
> > You mean ASCII art in comments?
> 
> I mean benchmarks of some kind.

:)

> > 
> > > > @@ -228,6 +237,12 @@ add_head:
> > > >  	 * new available array entries. */
> > > >  	virtio_wmb();
> > > >  	vq->vring.avail->idx++;
> > > > +	/* If the driver never bothers to kick in a very long while,
> > > > +	 * avail index might wrap around. If that happens, invalidate
> > > > +	 * kicked_avail index we stored. TODO: make sure all drivers
> > > > +	 * kick at least once in 2^16 and remove this. */
> > > > +	if (unlikely(vq->vring.avail->idx == vq->kicked_avail))
> > > > +		vq->kicked_avail_valid = true;
> > > 
> > > If they don't, they're already buggy.  Simply do:
> > >         WARN_ON(vq->vring.avail->idx == vq->kicked_avail);
> > 
> > Hmm, but does it say that somewhere?
> 
> AFAICT it's a corollary of:
> 1) You have a finite ring of size <= 2^16.
> 2) You need to kick the other side once you've done some work.

Well one can imagine a driver doing:

	while (virtqueue_get_buf()) {
		virtqueue_add_buf()
	}
	virtqueue_kick()

which looks sensible (batch kicks) but might
process any number of bufs between kicks.

If we look at drivers closely enough, I think none
of them do the equivalent of the above, but not 100% sure.


> > > > @@ -482,6 +517,8 @@ void vring_transport_features(struct virtio_device *vdev)
> > > >  			break;
> > > >  		case VIRTIO_RING_F_USED_EVENT_IDX:
> > > >  			break;
> > > > +		case VIRTIO_RING_F_AVAIL_EVENT_IDX:
> > > > +			break;
> > > >  		default:
> > > >  			/* We don't understand this bit. */
> > > >  			clear_bit(i, vdev->features);
> > > 
> > > Does this belong in a prior patch?
> > > 
> > > Thanks,
> > > Rusty.
> > 
> > Well if we don't support the feature in the ring we should not
> > ack the feature, right?
> 
> Ah, you're right.
> 
> Thanks,
> Rusty.
