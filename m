Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703Ab1FWPj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:39:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:50280 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759689Ab1FWPj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:39:26 -0400
Subject: Re: mmotm 2011-06-22 - inconsistent {SOFTIRQ-ON-W} ->
 {IN-SOFTIRQ-W} usage.
From: Peter Zijlstra <peterz@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jgarzik@pobox.com>,
        IngIngo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
In-Reply-To: <6189.1308794391@turing-police.cc.vt.edu>
References: <201106222042.p5MKgiEe025352@imap1.linux-foundation.org>
	 <6189.1308794391@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 17:38:36 +0200
Message-ID: <1308843516.1022.139.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 21:59 -0400, Valdis.Kletnieks@vt.edu wrote:
> [   20.254275] {SOFTIRQ-ON-W} state was registered at:
> [   20.254275]   [<ffffffff8106973b>] mark_irqflags+0xf2/0x13e
> [   20.254275]   [<ffffffff810699b2>] __lock_acquire+0x22b/0x3e2
> [   20.254275]   [<ffffffff8106a09f>] lock_acquire+0x103/0x153
> [   20.254275]   [<ffffffff8157bb01>] _raw_spin_lock+0x36/0x45
> [   20.254275]   [<ffffffff8110ddf8>] end_writeback+0x33/0x103
> [   20.254275]   [<ffffffff81125425>] bdev_evict_inode+0x3e/0xbe
> [   20.254275]   [<ffffffff8110df78>] evict+0xb0/0x173
> [   20.254275]   [<ffffffff8110e1ea>] iput_final+0x171/0x17a
> [   20.254275]   [<ffffffff8110e241>] iput+0x4e/0x53
> [   20.254275]   [<ffffffff81125cad>] __blkdev_put+0x1c0/0x1eb
> [   20.254275]   [<ffffffff81125ebe>] blkdev_put+0x1e6/0x1f5
> [   20.254275]   [<ffffffff8121d143>] register_disk+0xea/0x13c
> [   20.254275]   [<ffffffff8121d2c4>] add_disk+0x12f/0x1a4
> [   20.254275]   [<ffffffff812ef339>] sd_probe_async+0x115/0x1b5
> [   20.254275]   [<ffffffff8105ce2f>] async_run_entry_fn+0x99/0x12a
> [   20.254275]   [<ffffffff810505e8>] process_one_work+0x25d/0x467
> [   20.254275]   [<ffffffff81051ddb>] worker_thread+0x152/0x206
> [   20.254275]   [<ffffffff810561fa>] kthread+0x7f/0x87
> [   20.254275]   [<ffffffff815835d4>] kernel_thread_helper+0x4/0x10 

That looks broken. Not having -mm, is there a git tree some place?, I
cannot quite see how end_writeback() is taking mapping->tree_lock as my
version looks like:

void end_writeback(struct inode *inode)
{
	might_sleep();
	BUG_ON(inode->i_data.nrpages);
	BUG_ON(!list_empty(&inode->i_data.private_list));
	BUG_ON(!(inode->i_state & I_FREEING));
	BUG_ON(inode->i_state & I_CLEAR);
	inode_sync_wait(inode);
	/* don't need i_lock here, no concurrent mods to i_state */
	inode->i_state = I_FREEING | I_CLEAR;
}

and I couldn't find tree_lock used in inode_sync_wait() either.

Anyway, mapping->tree_lock is supposed to be an IRQ-safe lock, look at
all the spin_lock_irq(&mapping->tree_lock) usage in mm/filemap.c.


