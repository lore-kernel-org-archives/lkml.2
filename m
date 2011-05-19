Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368Ab1ESXKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:10:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab1ESXKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:10:51 -0400
Date: Fri, 20 May 2011 02:10:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
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
Subject: [PATCHv2 00/14] virtio and vhost-net performance enhancements
Message-ID: <cover.1305846412.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, here is the large patchset that implements the virtio spec update
that I sent earlier (the spec itself needs a minor update, will send
that out too next week, but I think we are on the same page here
already). It supercedes the PUBLISH_USED_IDX patches I sent
out earlier.

What will follow will be a patchset that actually includes 4 sets of
patches.  I note below their status.  Please consider for 2.6.40, at
least partially. Rusty, do you think it's feasible?

List of patches and what they do:

I) With the first patchset, we change virtio ring notification
hand-off to work like the one in Xen -
each side publishes an event index, the other one
notifies when it reaches that value -
With the one difference that event index starts at 0,
same as request index (in xen event index starts at 1).

These are the patches in this set:
virtio: event index interface
virtio ring: inline function to check for events
virtio_ring: support event idx feature
vhost: support event index
virtio_test: support event index

Changes in this part of the patchset from v1 - address comments by Rusty et al.

I tested this a lot with virtio net block and with the simulator and esp
with the simulator it's easy to see drastic performance improvement
here:

[virtio]# time ./virtio_test 
spurious wakeus: 0x7

real    0m0.169s
user    0m0.140s
sys     0m0.019s
[virtio]# time ./virtio_test --no-event-idx
spurious wakeus: 0x11

real    0m0.649s
user    0m0.295s
sys     0m0.335s

And these patches are mostly unchanged from the very first version,
changes being almost exclusively code cleanups.  So I consider this part
the most stable, I strongly think these patches should go into 2.6.40.
One extra reason besides performance is that maintaining
them out of tree is very painful as guest/host ABI is affected.

II) Second set of patches: new apis and use in virtio_net
With the indexes in place it becomes possibile to request an event after
many requests (and not just on the next one as done now). This shall fix
the TX queue overrun which currently triggers a storm of interrupts.

Another issue I tried to fix is capacity checks in virtio-net,
there's a new API for that, and on top of that,
I implemented a patch improving real-time characteristics
of virtio_net

Thus we get the second patchset:
virtio: add api for delayed callbacks
virtio_net: delay TX callbacks
virtio_ring: Add capacity check API
virtio_net: fix TX capacity checks using new API
virtio_net: limit xmit polling

This has some fixes that I posted previously applied,
but otherwise ideantical to v1. I tried to change API
for enable_cb_delayed as Rusty suggested but failed to do this.
I think it's not possible to define cleanly.

These work fine for me, I think they can be merged for 2.6.40
too but would be nice to hear back from Shirley, Tom, Krishna.

III) There's also a patch that adds a tweak to virtio ring
virtio: don't delay avail index update

This seems to help small message sizes where we are constantly draining
the RX VQ.

I'll need to benchmark this to be able to give any numbers
with confidence, but I don't see how it can hurt anything.
Thoughts?

IV) Last part is a set of patches to extend feature bits
to 64 bit. I tested this by using feature bit 32.
vhost: fix 64 bit features
virtio_test: update for 64 bit features
virtio: 64 bit features

It's nice to have as set I used up the last free bit.
But not a must now that a single bit controls
use of event index on both sides.

The patchset is on top of net-next which at the time
I last rebased was 15ecd03 - so roughly 2.6.39-rc2.
For testing I usually do merge v2.6.39 on top.

qemu patch is also ready.  Code can be pulled from here:

git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net-next-event-idx-v3
git://git.kernel.org/pub/scm/linux/kernel/git/mst/qemu-kvm.git virtio-net-event-idx-v3

Rusty, I think it will be easier to merge vhost and virtio bits in one
go. Can it all go in through your tree (Dave in the past acked
sending a very similar patch through you so should not be a problem)?



-- 
1.7.5.53.gc233e


Michael S. Tsirkin (13):
  virtio: event index interface
  virtio ring: inline function to check for events
  virtio_ring: support event idx feature
  vhost: support event index
  virtio_test: support event index
  virtio: add api for delayed callbacks
  virtio_net: delay TX callbacks
  virtio_net: fix TX capacity checks using new API
  virtio_net: limit xmit polling
  virtio: don't delay avail index update
  virtio: 64 bit features
  virtio_test: update for 64 bit features
  vhost: fix 64 bit features

Shirley Ma (1):
  virtio_ring: Add capacity check API

 drivers/lguest/lguest_device.c |    8 +-
 drivers/net/virtio_net.c       |   27 +++++---
 drivers/s390/kvm/kvm_virtio.c  |    8 +-
 drivers/vhost/net.c            |   12 ++--
 drivers/vhost/test.c           |    6 +-
 drivers/vhost/vhost.c          |  138 ++++++++++++++++++++++++++++++----------
 drivers/vhost/vhost.h          |   29 +++++---
 drivers/virtio/virtio.c        |    8 +-
 drivers/virtio/virtio_pci.c    |   34 ++++++++--
 drivers/virtio/virtio_ring.c   |   87 ++++++++++++++++++++++---
 include/linux/virtio.h         |   16 ++++-
 include/linux/virtio_config.h  |   15 +++--
 include/linux/virtio_pci.h     |    9 ++-
 include/linux/virtio_ring.h    |   29 ++++++++-
 tools/virtio/virtio_test.c     |   27 +++++++-
 15 files changed, 348 insertions(+), 105 deletions(-)

-- 
1.7.5.53.gc233e
