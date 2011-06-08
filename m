Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1FHAqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:46:04 -0400
Received: from ozlabs.org ([203.10.76.45]:54925 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab1FHAqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:46:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 RFC 4/4] Revert "virtio: make add_buf return capacity remaining:
In-Reply-To: <20110607155457.GA17436@redhat.com>
References: <cover.1307029008.git.mst@redhat.com> <7572d6fb81181e349af4a8b203ea0977f6e91ae1.1307029009.git.mst@redhat.com> <20110607155457.GA17436@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 08 Jun 2011 09:49:56 +0930
Message-ID: <877h8xgonn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011 18:54:57 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Jun 02, 2011 at 06:43:25PM +0300, Michael S. Tsirkin wrote:
> > This reverts commit 3c1b27d5043086a485f8526353ae9fe37bfa1065.
> > The only user was virtio_net, and it switched to
> > min_capacity instead.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> It turns out another place in virtio_net: receive
> buf processing - relies on the old behaviour:
> 
> try_fill_recv:
> 	do {
> 		if (vi->mergeable_rx_bufs)
> 			err = add_recvbuf_mergeable(vi, gfp);
> 		else if (vi->big_packets)
> 			err = add_recvbuf_big(vi, gfp);
> 		else
> 			err = add_recvbuf_small(vi, gfp);
> 
> 		oom = err == -ENOMEM;
> 		if (err < 0)
> 			break;
> 		++vi->num;
> 	} while (err > 0);
> 
> The point is to avoid allocating a buf if
> the ring is out of space and we are sure
> add_buf will fail.
> 
> It works well for mergeable buffers and for big
> packets if we are not OOM. small packets and
> oom will do extra get_page/put_page calls
> (but maybe we don't care).
> 
> So this is RX, I intend to drop it from this patchset and focus on the
> TX side for starters.

We could do some hack where we get the capacity, and estimate how many
packets we need to fill it, then try to do that many.

I say hack, because knowing whether we're doing indirect buffers is a
layering violation.  But that's life when you're trying to do
microoptimizations.

Cheers,
Rusty.
