Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab0KBQV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:21:28 -0400
Received: from claw.goop.org ([74.207.240.146]:49541 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0KBQVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:21:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 0/4] FLUSH/FUA updates for Xen blkfront
Date: Tue,  2 Nov 2010 12:20:43 -0400
Message-Id: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Update the Xen blockfront driver to deal with the block layer's cache
flush and FUA operations.

The only primitive we have for implementing these is
BLKIF_OP_WRITE_BARRIER, which is a fully ordered write operation.
This is much stronger than a simple cache flush which Linux requires,
but it will do the job.

It can also implement FUA, since it will guarantee that the data is
written to stable storage when it completes - however it also
implements full ordering, which makes it equivalent to a FLUSH+FUA.

Unfortunately it appears that the actual Xen backend implementation
will fail an empty BLKIF_OP_WRITE_BARRIER operation.  If that happens,
disable use of WRITE_BARRIER.  (Daniel, I don't know if this is
deliberate or not; I couldn't see where the error was coming from).

Jeremy Fitzhardinge (4):
  xen/blkfront: map REQ_FLUSH into a full barrier
  xen/blkfront: change blk_shadow.request to proper pointer
  xen/blkfront: Implement FUA with BLKIF_OP_WRITE_BARRIER
  xen/blkfront: cope with backend that fail empty
    BLKIF_OP_WRITE_BARRIER requests

 drivers/block/xen-blkfront.c |   53 +++++++++++++++++++++++------------------
 1 files changed, 30 insertions(+), 23 deletions(-)

-- 
1.7.2.3

