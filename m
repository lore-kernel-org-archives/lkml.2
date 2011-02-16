Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab1BPHb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:31:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1BPHbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:31:24 -0500
Date: Wed, 16 Feb 2011 18:31:14 +1100
From: NeilBrown <neilb@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: blk_throtl_exit  taking q->queue_lock is problematic
Message-ID: <20110216183114.26a3613b@notabene.brown>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,

 I recently discovered that blk_throtl_exit takes ->queue_lock when a blockdev
is finally released.

This is a problem for because by that time the queue_lock doesn't exist any
more.  It is in a separate data structure controlled by the RAID personality
and by the time that the block device is being destroyed the raid personality
has shutdown and the data structure containing the lock has been freed.

This has not been a problem before.  Nothing else takes queue_lock after
blk_cleanup_queue.

I could of course set queue_lock to point to __queue_lock and initialise that,
but it seems untidy and probably violates some locking requirements.

Is there some way you could use some other lock - maybe a global lock, or
maybe used __queue_lock directly ???

Thanks,
NeilBrown
