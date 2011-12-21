Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab1LUBBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:01:16 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:51566 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1LUBBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:01:11 -0500
From: Minchan Kim <minchan@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
Date: Wed, 21 Dec 2011 10:00:48 +0900
Message-Id: <1324429254-28383-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is follow-up of Christohp Hellwig's work
[RFC: ->make_request support for virtio-blk].
http://thread.gmane.org/gmane.linux.kernel/1199763

Quote from hch
"This patchset allows the virtio-blk driver to support much higher IOP
rates which can be driven out of modern PCI-e flash devices.  At this
point it really is just a RFC due to various issues."

I fixed race bug and add batch I/O for enhancing sequential I/O,
FLUSH/FUA emulation.

I tested this patch on fusion I/O device by aio-stress.
Result is following as.

Benchmark : aio-stress (64 thread, test file size 512M, 8K io per IO, O_DIRECT write)
Environment: 8 socket - 8 core, 2533.372Hz, Fusion IO 320G storage
Test repeated by 20 times
Guest I/O scheduler : CFQ
Host I/O scheduler : NOOP

            Request            	BIO(patch 1-4)          BIO-batch(patch 1-6)
         (MB/s)  stddev 	(MB/s)  stddev  	(MB/s)  stddev
w        737.820 4.063  	613.735 31.605  	730.288 24.854
rw       208.754 20.450 	314.630 37.352  	317.831 41.719
r        770.974 2.340  	347.483 51.370  	750.324 8.280
rr       250.391 16.910 	350.053 29.986  	325.976 24.846

This patch enhances ramdom I/O performance compared to request-based I/O path.
It's still RFC so welcome to any comment and review.

Christoph Hellwig (3):
  block: add bio_map_sg
  virtio: support unlocked queue kick
  virtio-blk: remove the unused list of pending requests

Minchan Kim (3):
  virtio-blk: implement ->make_request
  virtio-blk: Support batch I/O for enhancing sequential IO
  virtio-blk: Emulate Flush/FUA

 block/blk-merge.c            |   63 ++++
 drivers/block/virtio_blk.c   |  690 ++++++++++++++++++++++++++++++++++++++----
 drivers/virtio/virtio_ring.c |   33 ++-
 include/linux/blkdev.h       |    2 +
 include/linux/virtio.h       |   21 ++
 5 files changed, 737 insertions(+), 72 deletions(-)

-- 
1.7.6.4

