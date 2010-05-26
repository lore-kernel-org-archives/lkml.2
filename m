Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab0EZTzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:55:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab0EZTz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:55:28 -0400
Date: Wed, 26 May 2010 22:50:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: [PATCHv2-RFC 0/2] virtio: put last seen used index into ring itself
Message-ID: <cover.1274903328.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

 drivers/net/virtio_net.c     |    2 ++
 drivers/virtio/virtio_ring.c |   19 ++++++++++++++++---
 include/linux/virtio_ring.h  |   34 ++++++++++++++++++++++++++++------
 3 files changed, 46 insertions(+), 9 deletions(-)
