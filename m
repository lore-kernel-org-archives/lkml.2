Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1E3Gbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:31:52 -0400
Received: from ozlabs.org ([203.10.76.45]:44650 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1E3Gbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:31:50 -0400
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
In-Reply-To: <20110528200204.GB7046@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <aced8619c07018b5495f9ceb2c02d4fbf897a098.1305846412.git.mst@redhat.com> <877h9kvlps.fsf@rustcorp.com.au> <20110522121008.GA12155@redhat.com> <87boyutbjg.fsf@rustcorp.com.au> <20110523111900.GB27212@redhat.com> <8739k3k1fb.fsf@rustcorp.com.au> <20110525060759.GC26352@redhat.com> <87vcwyjg2w.fsf@rustcorp.com.au> <20110528200204.GB7046@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 30 May 2011 15:57:39 +0930
Message-ID: <8739jwk8is.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011 23:02:04 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, May 26, 2011 at 12:58:23PM +0930, Rusty Russell wrote:
> > ie. free two packets for every one we're about to add.  For steady state
> > that would work really well.
> 
> Sure, with indirect buffers, but if we
> don't use indirect (and we discussed switching indirect off
> dynamically in the past) this becomes harder to
> be sure about. I think I understand why but
> does not a simple capacity check make it more obvious?

...

> >  Then we hit the case where the ring
> > seems full after we do the add: at that point, screw latency, and just
> > try to free all the buffers we can.
> 
> I see. But the code currently does this:
> 
> 	for(..)
> 		get_buf
> 	add_buf
> 	if (capacity < max_sk_frags+2) {
> 		if (!enable_cb)
> 			for(..)
> 				get_buf
> 	}
> 
> 
> In other words the second get_buf is only called
> in the unlikely case of race condition.
> 
> So we'll need to add *another* call to get_buf.
> Is it just me or is this becoming messy?

Yes, good point.  I really wonder if anyone would be able to measure the
difference between simply freeing 2 every time (with possible extra
stalls for strange cases) and the more complete version.

But it runs against my grain to implement heuristics when one more call
would make it provably reliable.

Please find a way to make that for loop less ugly though!

Thanks,
Rusty.
