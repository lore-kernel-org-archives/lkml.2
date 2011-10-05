Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935282Ab1JETzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:55:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55660
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934696Ab1JETzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:55:40 -0400
Message-Id: <20111005195403.407628164@bombadil.infradead.org>
User-Agent: quilt/0.48-1
Date: Wed, 05 Oct 2011 15:54:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] RFC: ->make_request support for virtio-blk
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset allows the virtio-blk driver to support much higher IOP
rates which can be driven out of modern PCI-e flash devices.  At this
point it really is just a RFC due to various issues.

The first four patches are infrastructure that could go in fairly
soon as far as I'm concerned.  Patch 5 implements the actual ->make_request
support and still has a few issues, see there for more details.  With
it I can driver my PCI-e test devices to 85-90% of the native IOPS
and bandwith, but be warned that this is still a fairly low end setup
as far as expensive flash storage is concerned.

One big downside that is has is that it current exposes a nasty race
in the qemu virtqueue code - just running xfstests inside a guest
using the new virtio-blk driver (even on a slow device) will trigger
it and lead to a filesystem shutdown.  I've tracked it down to getting
data I/O segments overwritten with status s/g list entries, but got
lost at that point.  I can start a separate thread on it.

Besides that it is missing a few features, and we have to decided
how to select which mode to use in virtio-blk - either a module option,
sysfs attribute or something that the host communicates.  Or maybe
decide that just going with ->make_request alone is fine, even on
my cheap laptop SSD it actually is just as fast if not slightly
faster than the request based variant on my laptop.

There are a few other bottlenecks in virtio that this exposes.  The
first one is the low queue length of just 128 entries in the virtio-blk
queue - to drive higher IOPs with a deep queue we absolutely need
to increment that.

Comments welcome!

