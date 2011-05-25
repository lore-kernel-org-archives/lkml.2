Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1EYGIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:08:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab1EYGIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:08:21 -0400
Date: Wed, 25 May 2011 09:07:59 +0300
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
Subject: Re: [PATCHv2 10/14] virtio_net: limit xmit polling
Message-ID: <20110525060759.GC26352@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
 <aced8619c07018b5495f9ceb2c02d4fbf897a098.1305846412.git.mst@redhat.com>
 <877h9kvlps.fsf@rustcorp.com.au>
 <20110522121008.GA12155@redhat.com>
 <87boyutbjg.fsf@rustcorp.com.au>
 <20110523111900.GB27212@redhat.com>
 <8739k3k1fb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8739k3k1fb.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 11:05:04AM +0930, Rusty Russell wrote:
> On Mon, 23 May 2011 14:19:00 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > I do understand how it seems a waste to leave direct space
> > in the ring while we might in practice have space
> > due to indirect. Didn't come up with a nice way to
> > solve this yet - but 'no worse than now :)'
> 
> Let's just make it "bool free_old_xmit_skbs(unsigned int max)".  max ==
> 2 for the normal xmit path, so we're low latency but we keep ahead on
> average.  max == -1 for the "we're out of capacity, we may have to stop
> the queue".
> 
> That keeps it simple and probably the right thing...
> 
> Thanks,
> Rusty.

Hmm I'm not sure I got it, need to think about this.
I'd like to go back and document how my design was supposed to work.
This really should have been in commit log or even a comment.
I thought we need a min, not a max.
We start with this:

	while ((c = (virtqueue_get_capacity(vq) < 2 + MAX_SKB_FRAGS) &&
		(skb = get_buf)))
		kfree_skb(skb);
	return !c;

This is clean and simple, right? And it's exactly asking for what we need.

But this way we always keep a lot of memory in skbs even when rate of
communication is low.

So we add the min parameter:

	int n = 0;

	while ((((c = (virtqueue_get_capacity(vq) < 2 + MAX_SKB_FRAGS)) ||
		 n++ < min) && (skb = get_buf)))
		kfree_skb(skb);
	return !c;


on the normal path min == 2 so we're low latency but we keep ahead on
average. min == 0 for the "we're out of capacity, we may have to stop
the queue".

Does the above make sense at all?

-- 
MST
