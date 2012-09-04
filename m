Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab2IDMcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:32:05 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:57100 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab2IDMcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:32:03 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: FLUSH/FUA documentation & code discrepancy
Date: Tue, 04 Sep 2012 14:32:01 +0200
Message-ID: <8439412.RChiDciQdh@fat-tyre>
User-Agent: KMail/4.8.4 (Linux/3.2.0-29-generic; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think commit 1e87901e18 was wrong. Starting with that commit the REQ_FLUSH 
and REQ_FUA bits get stripped away if the queue does not advertise REQ_FLUSH
or REQ_FUA support.

But the REQ_FLUSH bit is also tested for when not merging requests
(blk_queue_bio()) or when it comes to the elevator (blk_flush_plug_list()).

So, since this patch the elevator reorders write requests on queues that 
do not have REQ_FLUSH or REQ_FUA set.

While on queues that have REQ_FLUSH or REQ_FUA set, the elevator does
not reorder writes across FLUSHes.

The Documentation/block/writeback_cache_control.txt file says:
--snip--
Implementation details for filesystems
--------------------------------------

Filesystems can simply set the REQ_FLUSH and REQ_FUA bits and do not have to
worry if the underlying devices need any explicit cache flushing and how
the Forced Unit Access is implemented.  The REQ_FLUSH and REQ_FUA flags
may both be set on a single bio.
--snap--

I have the impression every file system lets IO drain, and issues a
flush afterwards with the blkdev_issue_flush() function. BTW that
function turns into a non-obvious no-op as soon as the queue does not
have the REQ_FUA or REQ_FLUSH bits set. It does not look like it is
a no-op by intention.

The file systems seem to be all fine, only in DRBD we have a mode were
we depend on REQ_FUA/REQ_FLUSH requests being real boundaries for reordering
of writes. This is broken since the mentioned commit as we recently found out.

I suggest that either this commit gets reverted, or the documentation
is updated. I am ready to prepare such a patch, but I need directions
how it should be fixed.

Best regards,
 Phil
