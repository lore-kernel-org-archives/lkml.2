Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1EXNxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:53:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327Ab1EXNxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:53:42 -0400
Date: Tue, 24 May 2011 16:52:38 +0300
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
Subject: Re: [PATCHv2 10/14] virtio_net: limit xmit polling
Message-ID: <20110524135238.GB20209@redhat.com>
References: <aced8619c07018b5495f9ceb2c02d4fbf897a098.1305846412.git.mst@redhat.com>
 <877h9kvlps.fsf@rustcorp.com.au>
 <20110522121008.GA12155@redhat.com>
 <87boyutbjg.fsf@rustcorp.com.au>
 <20110523111900.GB27212@redhat.com>
 <OFEED174CD.D3C9A726-ON6525789A.002661D5-6525789A.002B26ED@in.ibm.com>
 <20110524091255.GB16886@redhat.com>
 <OF69E520FD.340352AC-ON6525789A.003308A2-6525789A.0033F2DF@in.ibm.com>
 <20110524112901.GB17087@redhat.com>
 <OF2D4A7890.FFA91132-ON6525789A.0043E0AC-6525789A.00464690@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF2D4A7890.FFA91132-ON6525789A.0043E0AC-6525789A.00464690@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 06:20:35PM +0530, Krishna Kumar2 wrote:
> "Michael S. Tsirkin" <mst@redhat.com> wrote on 05/24/2011 04:59:39 PM:
> 
> > > > > Maybe Rusty means it is a simpler model to free the amount
> > > > > of space that this xmit needs. We will still fail anyway
> > > > > at some time but it is unlikely, since earlier iteration
> > > > > freed up atleast the space that it was going to use.
> > > >
> > > > Not sure I nderstand.  We can't know space is freed in the previous
> > > > iteration as buffers might not have been used by then.
> > >
> > > Yes, the first few iterations may not have freed up space, but
> > > later ones should. The amount of free space should increase
> > > from then on, especially since we try to free double of what
> > > we consume.
> >
> > Hmm. This is only an upper limit on the # of entries in the queue.
> > Assume that vq size is 4 and we transmit 4 enties without
> > getting anything in the used ring. The next transmit will fail.
> >
> > So I don't really see why it's unlikely that we reach the packet
> > drop code with your patch.
> 
> I was assuming 256 entries :) I will try to get some
> numbers to see how often it is true tomorrow.

That would depend on how fast the hypervisor is.
Try doing something to make hypervisor slower than the guest.  I don't
think we need measurements to realize that with the host being slower
than guest that would happen a lot, though.

> > > I am not sure of why it was changed, since returning TX_BUSY
> > > seems more efficient IMHO.
> > > qdisc_restart() handles requeue'd
> > > packets much better than a stopped queue, as a significant
> > > part of this code is skipped if gso_skb is present
> >
> > I think this is the argument:
> > http://www.mail-archive.com/virtualization@lists.linux-
> > foundation.org/msg06364.html
> 
> Thanks for digging up that thread! Yes, that one skb would get
> sent first ahead of possibly higher priority skbs. However,
> from a performance point, TX_BUSY code skips a lot of checks
> and code for all subsequent packets till the device is
> restarted. I can test performance with both cases and report
> what I find (the requeue code has become very simple and clean
> from "horribly complex", thanks to Herbert and Dave).

Cc Herbert, and try to convince him :)

> > > (qdisc
> > > will eventually start dropping packets when tx_queue_len is
> >
> > tx_queue_len is a pretty large buffer so maybe no.
> 
> I remember seeing tons of drops (pfifo_fast_enqueue) when
> xmit returns TX_BUSY.
> 
> > I think the packet drops from the scheduler queue can also be
> > done intelligently (e.g. with CHOKe) which should
> > work better than dropping a random packet?
> 
> I am not sure of that - choke_enqueue checks against a random
> skb to drop current skb, and also during congestion. But for
> my "sample driver xmit", returning TX_BUSY could still allow
> to be used with CHOKe.
> 
> thanks,
> 
> - KK
