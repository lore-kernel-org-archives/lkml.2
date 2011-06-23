Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605Ab1FWT7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:59:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759408Ab1FWT7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:59:38 -0400
Date: Thu, 23 Jun 2011 21:59:23 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis.Kletnieks@vt.edu, Jan Kara <jack@suse.cz>, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jgarzik@pobox.com>,
        IngIngo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: mmotm 2011-06-22 - inconsistent {SOFTIRQ-ON-W} ->
 {IN-SOFTIRQ-W} usage.
Message-ID: <20110623195923.GA14337@quack.suse.cz>
References: <201106222042.p5MKgiEe025352@imap1.linux-foundation.org>
 <6189.1308794391@turing-police.cc.vt.edu>
 <1308843516.1022.139.camel@twins>
 <47718.1308844931@turing-police.cc.vt.edu>
 <1308845285.1022.143.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308845285.1022.143.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-06-11 18:08:05, Peter Zijlstra wrote:
> On Thu, 2011-06-23 at 12:02 -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 23 Jun 2011 17:38:36 +0200, Peter Zijlstra said:
> > > On Wed, 2011-06-22 at 21:59 -0400, Valdis.Kletnieks@vt.edu wrote:
> > > > [   20.254275] {SOFTIRQ-ON-W} state was registered at:
> > > > [   20.254275]   [<ffffffff8106973b>] mark_irqflags+0xf2/0x13e
> > > > [   20.254275]   [<ffffffff810699b2>] __lock_acquire+0x22b/0x3e2
> > > > [   20.254275]   [<ffffffff8106a09f>] lock_acquire+0x103/0x153
> > > > [   20.254275]   [<ffffffff8157bb01>] _raw_spin_lock+0x36/0x45
> > > > [   20.254275]   [<ffffffff8110ddf8>] end_writeback+0x33/0x103
> > > > [   20.254275]   [<ffffffff81125425>] bdev_evict_inode+0x3e/0xbe
> > > > [   20.254275]   [<ffffffff8110df78>] evict+0xb0/0x173
> > > > [   20.254275]   [<ffffffff8110e1ea>] iput_final+0x171/0x17a
> > > > [   20.254275]   [<ffffffff8110e241>] iput+0x4e/0x53
> > > > [   20.254275]   [<ffffffff81125cad>] __blkdev_put+0x1c0/0x1eb
> > > > [   20.254275]   [<ffffffff81125ebe>] blkdev_put+0x1e6/0x1f5
> > > > [   20.254275]   [<ffffffff8121d143>] register_disk+0xea/0x13c
> > > > [   20.254275]   [<ffffffff8121d2c4>] add_disk+0x12f/0x1a4
> > > > [   20.254275]   [<ffffffff812ef339>] sd_probe_async+0x115/0x1b5
> > > > [   20.254275]   [<ffffffff8105ce2f>] async_run_entry_fn+0x99/0x12a
> > > > [   20.254275]   [<ffffffff810505e8>] process_one_work+0x25d/0x467
> > > > [   20.254275]   [<ffffffff81051ddb>] worker_thread+0x152/0x206
> > > > [   20.254275]   [<ffffffff810561fa>] kthread+0x7f/0x87
> > > > [   20.254275]   [<ffffffff815835d4>] kernel_thread_helper+0x4/0x10=20
> > > 
> > > That looks broken. Not having -mm, is there a git tree some place?, I
> > > cannot quite see how end_writeback() is taking mapping->tree_lock as my
> > > version looks like:
> > > 
> > > void end_writeback(struct inode *inode)
> > > {
> > > 	might_sleep();
> > > 	BUG_ON(inode->i_data.nrpages);
> > > 	BUG_ON(!list_empty(&inode->i_data.private_list));
> > 
> > mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback.patch does this:
> > 
> > diff -puN fs/inode.c~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback fs/inode.c
> > --- a/fs/inode.c~mm-fix-assertion-mapping-nrpages-==-0-in-end_writeback
> > +++ a/fs/inode.c
> > @@ -423,7 +423,14 @@ EXPORT_SYMBOL(remove_inode_hash);
> >  void end_writeback(struct inode *inode)
> >  {
> >         might_sleep();
> > +       /*
> > +        * We have to cycle tree_lock here because reclaim can be still in the
> > +        * process of removing the last page (in __delete_from_page_cache())
> > +        * and we must not free mapping under it.
> > +        */
> > +       spin_lock(&inode->i_data.tree_lock);
> >         BUG_ON(inode->i_data.nrpages);
> > +       spin_unlock(&inode->i_data.tree_lock);
> >         BUG_ON(!list_empty(&inode->i_data.private_list));
> >         BUG_ON(!(inode->i_state & I_FREEING));
> >         BUG_ON(inode->i_state & I_CLEAR);
> > 
> > Adding Jan Kara to the list, and stable@kernel.org because the patch was cc'ed to there...
> 
> Yep, that very much wants to be spin_{un,}lock_irq().
  Oh, right. Stupid me. I'll fix that. Thanks for debugging this.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
