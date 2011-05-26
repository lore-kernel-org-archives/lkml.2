Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1E0WeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 18:34:22 -0400
Received: from ozlabs.org ([203.10.76.45]:34419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806Ab1E0WeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 18:34:21 -0400
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
Subject: Re: [PATCHv2 10/14] virtio_net: limit xmit polling
In-Reply-To: <20110525060759.GC26352@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <aced8619c07018b5495f9ceb2c02d4fbf897a098.1305846412.git.mst@redhat.com> <877h9kvlps.fsf@rustcorp.com.au> <20110522121008.GA12155@redhat.com> <87boyutbjg.fsf@rustcorp.com.au> <20110523111900.GB27212@redhat.com> <8739k3k1fb.fsf@rustcorp.com.au> <20110525060759.GC26352@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 26 May 2011 12:58:23 +0930
Message-ID: <87vcwyjg2w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 09:07:59 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Wed, May 25, 2011 at 11:05:04AM +0930, Rusty Russell wrote:
> Hmm I'm not sure I got it, need to think about this.
> I'd like to go back and document how my design was supposed to work.
> This really should have been in commit log or even a comment.
> I thought we need a min, not a max.
> We start with this:
> 
> 	while ((c = (virtqueue_get_capacity(vq) < 2 + MAX_SKB_FRAGS) &&
> 		(skb = get_buf)))
> 		kfree_skb(skb);
> 	return !c;
> 
> This is clean and simple, right? And it's exactly asking for what we need.

No, I started from the other direction:

        for (i = 0; i < 2; i++) {
                skb = get_buf();
                if (!skb)
                        break;
                kfree_skb(skb);
        }

ie. free two packets for every one we're about to add.  For steady state
that would work really well.  Then we hit the case where the ring seems
full after we do the add: at that point, screw latency, and just try to
free all the buffers we can.

> on the normal path min == 2 so we're low latency but we keep ahead on
> average. min == 0 for the "we're out of capacity, we may have to stop
> the queue".
> 
> Does the above make sense at all?

It makes sense, but I think it's a classic case where incremental
improvements aren't as good as starting from scratch.

Cheers,
Rusty.
