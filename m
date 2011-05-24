Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1EXHxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:53:15 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:40041 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1EXHxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:53:11 -0400
In-Reply-To: <20110523111900.GB27212@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <aced8619c07018b5495f9ceb2c02d4fbf897a098.1305846412.git.mst@redhat.com> <877h9kvlps.fsf@rustcorp.com.au> <20110522121008.GA12155@redhat.com> <87boyutbjg.fsf@rustcorp.com.au> <20110523111900.GB27212@redhat.com>
Subject: Re: [PATCHv2 10/14] virtio_net: limit xmit polling
X-KeepSent: EED174CD:D3C9A726-6525789A:002661D5;
 type=4; name=$KeepSent
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFEED174CD.D3C9A726-ON6525789A.002661D5-6525789A.002B26ED@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Tue, 24 May 2011 13:24:15 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 8.5.1FP5|September 29, 2010) at
 24/05/2011 13:24:19
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> wrote on 05/23/2011 04:49:00 PM:

> > To do this properly, we should really be using the actual number of sg
> > elements needed, but we'd have to do most of xmit_skb beforehand so we
> > know how many.
> >
> > Cheers,
> > Rusty.
>
> Maybe I'm confused here.  The problem isn't the failing
> add_buf for the given skb IIUC.  What we are trying to do here is stop
> the queue *before xmit_skb fails*. We can't look at the
> number of fragments in the current skb - the next one can be
> much larger.  That's why we check capacity after xmit_skb,
> not before it, right?

Maybe Rusty means it is a simpler model to free the amount
of space that this xmit needs. We will still fail anyway
at some time but it is unlikely, since earlier iteration
freed up atleast the space that it was going to use. The
code could become much simpler:

start_xmit()
{
{
        num_sgs = get num_sgs for this skb;

        /* Free enough pending old buffers to enable queueing this one */
        free_old_xmit_skbs(vi, num_sgs * 2);     /* ?? */

        if (virtqueue_get_capacity() < num_sgs) {
                netif_stop_queue(dev);
                if (virtqueue_enable_cb_delayed(vi->svq) ||
                    free_old_xmit_skbs(vi, num_sgs)) {
                        /* Nothing freed up, or not enough freed up */
                        kfree_skb(skb);
                        return NETDEV_TX_OK;
                }
                netif_start_queue(dev);
                virtqueue_disable_cb(vi->svq);
        }

        /* xmit_skb cannot fail now, also pass 'num_sgs' */
        xmit_skb(vi, skb, num_sgs);
        virtqueue_kick(vi->svq);

        skb_orphan(skb);
        nf_reset(skb);

        return NETDEV_TX_OK;
}

We could even return TX_BUSY since that makes the dequeue
code more efficient. See dev_dequeue_skb() - you can skip a
lot of code (and avoid taking locks) to check if the queue
is already stopped but that code runs only if you return
TX_BUSY in the earlier iteration.

BTW, shouldn't the check in start_xmit be:
	if (likely(!free_old_xmit_skbs(vi, 2+MAX_SKB_FRAGS))) {
		...
	}

Thanks,

- KK

