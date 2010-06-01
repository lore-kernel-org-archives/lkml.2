Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0FAOve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:51:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756695Ab0FAOvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:51:31 -0400
Date: Tue, 1 Jun 2010 17:47:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: [PATCHv3 0/2] virtio: put last seen used index into ring itself
Message-ID: <cover.1275403477.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v2: added padding between avail idx and flags,
and changed virtio to only publish used index when callbacks
are enabled.

Here's a rewrite of the original patch with a new layout.
I haven't tested it yet so no idea how this performs, but
I think this addresses the cache bounce issue raised by Avi.
Posting for early flames/comments.

Generally, the Host end of the virtio ring doesn't need to see where
Guest is up to in consuming the ring.  However, to completely understand
what's going on from the outside, this information must be exposed.
For example, host can reduce the number of interrupts by detecting
that the guest is currently handling previous buffers.

We add a feature bit so the guest can tell the host that it's writing
out the current value there, if it wants to use that.

This differs from original approach in that the used index
is put after avail index (they are typically written out together).
To avoid cache bounces on descriptor access,
and make future extensions easier, we put the ring itself at start of
page, and move the control after it.


Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


Michael S. Tsirkin (2):
  virtio: support layout with avail ring before idx
  virtio: publish used idx

 drivers/net/virtio_net.c     |    2 +
 drivers/virtio/virtio_ring.c |   25 +++++++++++++++------
 include/linux/virtio_ring.h  |   50 ++++++++++++++++++++++++++++++++++++-----
 3 files changed, 64 insertions(+), 13 deletions(-)
