Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241Ab1ETHwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:52:51 -0400
Received: from ozlabs.org ([203.10.76.45]:51957 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733Ab1ETHws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:52:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 00/14] virtio and vhost-net performance enhancements
In-Reply-To: <cover.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Fri, 20 May 2011 17:21:31 +0930
Message-ID: <87ipt5vmgs.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 02:10:07 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> OK, here is the large patchset that implements the virtio spec update
> that I sent earlier (the spec itself needs a minor update, will send
> that out too next week, but I think we are on the same page here
> already). It supercedes the PUBLISH_USED_IDX patches I sent
> out earlier.
> 
> What will follow will be a patchset that actually includes 4 sets of
> patches.  I note below their status.  Please consider for 2.6.40, at
> least partially. Rusty, do you think it's feasible?

Erk.  I'm still unsure that we should be using ring capacity as the
thresholding mechanism, given that *descriptor* exhaustion is what we
actually face.

That said, I will review these thoroughly in 14 hours (Sat morning my
time).  Perhaps I can convince myself that it's not a problem, because
it *is* simpler...

> List of patches and what they do:
> 
> I) With the first patchset, we change virtio ring notification
> hand-off to work like the one in Xen -
> each side publishes an event index, the other one
> notifies when it reaches that value -
> With the one difference that event index starts at 0,
> same as request index (in xen event index starts at 1).
> 
> These are the patches in this set:
> virtio: event index interface
> virtio ring: inline function to check for events
> virtio_ring: support event idx feature
> vhost: support event index
> virtio_test: support event index
> 
> Changes in this part of the patchset from v1 - address comments by Rusty et al.
> 
> I tested this a lot with virtio net block and with the simulator and esp
> with the simulator it's easy to see drastic performance improvement
> here:
> 
> [virtio]# time ./virtio_test 
> spurious wakeus: 0x7
> 
> real    0m0.169s
> user    0m0.140s
> sys     0m0.019s
> [virtio]# time ./virtio_test --no-event-idx
> spurious wakeus: 0x11
> 
> real    0m0.649s
> user    0m0.295s
> sys     0m0.335s
> 
> And these patches are mostly unchanged from the very first version,
> changes being almost exclusively code cleanups.  So I consider this part
> the most stable, I strongly think these patches should go into 2.6.40.
> One extra reason besides performance is that maintaining
> them out of tree is very painful as guest/host ABI is affected.
> 
> II) Second set of patches: new apis and use in virtio_net
> With the indexes in place it becomes possibile to request an event after
> many requests (and not just on the next one as done now). This shall fix
> the TX queue overrun which currently triggers a storm of interrupts.
> 
> Another issue I tried to fix is capacity checks in virtio-net,
> there's a new API for that, and on top of that,
> I implemented a patch improving real-time characteristics
> of virtio_net
> 
> Thus we get the second patchset:
> virtio: add api for delayed callbacks
> virtio_net: delay TX callbacks
> virtio_ring: Add capacity check API
> virtio_net: fix TX capacity checks using new API
> virtio_net: limit xmit polling
> 
> This has some fixes that I posted previously applied,
> but otherwise ideantical to v1. I tried to change API
> for enable_cb_delayed as Rusty suggested but failed to do this.
> I think it's not possible to define cleanly.
> 
> These work fine for me, I think they can be merged for 2.6.40
> too but would be nice to hear back from Shirley, Tom, Krishna.

See other mail.

> III) There's also a patch that adds a tweak to virtio ring
> virtio: don't delay avail index update
> 
> This seems to help small message sizes where we are constantly draining
> the RX VQ.

This is independent.  If someone shows some benchmark improvement I'm
definitely happy to put this in .40, if nothing else.

> I'll need to benchmark this to be able to give any numbers
> with confidence, but I don't see how it can hurt anything.
> Thoughts?
> 
> IV) Last part is a set of patches to extend feature bits
> to 64 bit. I tested this by using feature bit 32.
> vhost: fix 64 bit features
> virtio_test: update for 64 bit features
> virtio: 64 bit features

Sweetness, but .41 material at this stage.

Thanks,
Rusty.
