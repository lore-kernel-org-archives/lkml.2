Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1EQCtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:49:33 -0400
Received: from ozlabs.org ([203.10.76.45]:35228 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab1EQCt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:49:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
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
In-Reply-To: <20110515135541.GF24932@redhat.com>
References: <cover.1304541918.git.mst@redhat.com> <8bba6a0a8eee17e741c5155b04ff1b1c9f34bf94.1304541919.git.mst@redhat.com> <874o54h4rt.fsf@rustcorp.com.au> <20110515135541.GF24932@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 16 May 2011 16:42:21 +0930
Message-ID: <87ei3zdsq2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 May 2011 16:55:41 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, May 09, 2011 at 02:03:26PM +0930, Rusty Russell wrote:
> > On Wed, 4 May 2011 23:51:47 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > Use the new avail_event feature to reduce the number
> > > of exits from the guest.
> > 
> > Figures here would be nice :)
> 
> You mean ASCII art in comments?

I mean benchmarks of some kind.

> 
> > > @@ -228,6 +237,12 @@ add_head:
> > >  	 * new available array entries. */
> > >  	virtio_wmb();
> > >  	vq->vring.avail->idx++;
> > > +	/* If the driver never bothers to kick in a very long while,
> > > +	 * avail index might wrap around. If that happens, invalidate
> > > +	 * kicked_avail index we stored. TODO: make sure all drivers
> > > +	 * kick at least once in 2^16 and remove this. */
> > > +	if (unlikely(vq->vring.avail->idx == vq->kicked_avail))
> > > +		vq->kicked_avail_valid = true;
> > 
> > If they don't, they're already buggy.  Simply do:
> >         WARN_ON(vq->vring.avail->idx == vq->kicked_avail);
> 
> Hmm, but does it say that somewhere?

AFAICT it's a corollary of:
1) You have a finite ring of size <= 2^16.
2) You need to kick the other side once you've done some work.

> > > @@ -482,6 +517,8 @@ void vring_transport_features(struct virtio_device *vdev)
> > >  			break;
> > >  		case VIRTIO_RING_F_USED_EVENT_IDX:
> > >  			break;
> > > +		case VIRTIO_RING_F_AVAIL_EVENT_IDX:
> > > +			break;
> > >  		default:
> > >  			/* We don't understand this bit. */
> > >  			clear_bit(i, vdev->features);
> > 
> > Does this belong in a prior patch?
> > 
> > Thanks,
> > Rusty.
> 
> Well if we don't support the feature in the ring we should not
> ack the feature, right?

Ah, you're right.

Thanks,
Rusty.
