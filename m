Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1FBPeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:34:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab1FBPeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:34:22 -0400
Date: Thu, 2 Jun 2011 18:34:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Krishna Kumar2 <krkumar2@in.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>
Subject: Re: [PATCH RFC 3/3] virtio_net: limit xmit polling
Message-ID: <20110602153423.GA11300@redhat.com>
References: <cover.1306921434.git.mst@redhat.com>
 <1ec8eec325839ecf2eac9930a230361e7956047c.1306921434.git.mst@redhat.com>
 <87pqmwj3am.fsf@rustcorp.com.au>
 <20110602133425.GJ7141@redhat.com>
 <OF990F08C5.2ECE35B1-ON652578A3.004DC0FA-652578A3.004E3FE4@in.ibm.com>
 <20110602144346.GA7995@redhat.com>
 <OFFF109303.D838CAE2-ON652578A3.0053357D-652578A3.00549366@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFFF109303.D838CAE2-ON652578A3.0053357D-652578A3.00549366@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 08:56:42PM +0530, Krishna Kumar2 wrote:
> "Michael S. Tsirkin" <mst@redhat.com> wrote on 06/02/2011 08:13:46 PM:
> 
> > > Please review this patch to see if it looks reasonable:
> >
> > Hmm, since you decided to work on top of my patch,
> > I'd appreciate split-up fixes.
> 
> OK (that also explains your next comment).
> 
> > > 1. Picked comments/code from MST's code and Rusty's review.
> > > 2. virtqueue_min_capacity() needs to be called only if it returned
> > >    empty the last time it was called.
> > > 3. Fix return value bug in free_old_xmit_skbs (hangs guest).
> > > 4. Stop queue only if capacity is not enough for next xmit.
> >
> > That's what we always did ...
> 
> I had made the patch against your patch, hence this change (sorry for
> the confusion!).
> 
> > > 5. Fix/clean some likely/unlikely checks (hopefully).
> > >
> > > I have done some minimal netperf tests with this.
> > >
> > > With this patch, add_buf returning capacity seems to be useful - it
> > > allows less virtio API calls.
> >
> > Why bother? It's cheap ...
> 
> If add_buf retains it's functionality to return the capacity (it
> is going to need a change to return 0 otherwise anyway), is it
> useful to call another function at each xmit?
> 
> > > +static bool free_old_xmit_skbs(struct virtnet_info *vi, int to_free)
> > > +{
> > > +   bool empty = virtqueue_min_capacity(vi->svq) < MAX_SKB_FRAGS + 2;
> > > +
> > > +   do {
> > > +      if (!free_one_old_xmit_skb(vi)) {
> > > +         /* No more skbs to free up */
> > >           break;
> > > -      pr_debug("Sent skb %p\n", skb);
> > > -      vi->dev->stats.tx_bytes += skb->len;
> > > -      vi->dev->stats.tx_packets++;
> > > -      dev_kfree_skb_any(skb);
> > > -   }
> > > -   return r;
> > > +      }
> > > +
> > > +      if (empty) {
> > > +         /* Check again if there is enough space */
> > > +         empty = virtqueue_min_capacity(vi->svq) <
> > > +            MAX_SKB_FRAGS + 2;
> > > +      } else {
> > > +         --to_free;
> > > +      }
> > > +   } while (to_free > 0);
> > > +
> > > +   return !empty;
> > >  }
> >
> > Why bother doing the capacity check in this function?
> 
> To return whether we have enough space for next xmit. It should call
> it only once unless space is running out. Does it sound OK?
> 
> > > -   if (unlikely(ret < 0)) {
> > > +   if (unlikely(capacity < 0)) {
> > > +      /*
> > > +       * Failure to queue should be impossible. The only way to
> > > +       * reach here is if we got a cb before 3/4th of space was
> > > +       * available. We could stop the queue and re-enable
> > > +       * callbacks (and possibly return TX_BUSY), but we don't
> > > +       * bother since this is impossible.
> >
> > It's far from impossible.  The 3/4 thing is only a hint, and old devices
> > don't support it anyway.
> 
> OK, I will re-put back your comment.
> 
> > > -   if (!likely(free_old_xmit_skbs(vi, 2))) {
> > > -      netif_stop_queue(dev);
> > > -      if (unlikely(!virtqueue_enable_cb_delayed(vi->svq))) {
> > > -         /* More just got used, free them and recheck. */
> > > -         if (!likely(free_old_xmit_skbs(vi, 0))) {
> > > -            netif_start_queue(dev);
> > > -            virtqueue_disable_cb(vi->svq);
> > > +   /*
> > > +    * Apparently nice girls don't return TX_BUSY; check capacity and
> > > +    * stop the queue before it gets out of hand. Naturally, this
> wastes
> > > +    * entries.
> > > +    */
> > > +   if (capacity < 2+MAX_SKB_FRAGS) {
> > > +      /*
> > > +       * We don't have enough space for the next packet. Try
> > > +       * freeing more.
> > > +       */
> > > +      if (likely(!free_old_xmit_skbs(vi, UINT_MAX))) {
> > > +         netif_stop_queue(dev);
> > > +         if (unlikely(!virtqueue_enable_cb_delayed(vi->svq))) {
> > > +            /* More just got used, free them and recheck. */
> > > +            if (likely(free_old_xmit_skbs(vi, UINT_MAX))) {
> >
> > Is this where the bug was?
> 
> Return value in free_old_xmit() was wrong. I will re-do against the
> mainline kernel.
> 
> Thanks,
> 
> - KK

Just noting that I'm working on that patch as well, it might
be more efficient if we don't both of us do this in parallel :)

-- 
MST
