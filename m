Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2GOJOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 05:14:46 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:50609 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2GOJOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 05:14:40 -0400
Message-ID: <1342343673.28142.2.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <mgalbraith@novell.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Date: Sun, 15 Jul 2012 11:14:33 +0200
In-Reply-To: <alpine.LFD.2.02.1207151057010.32033@ionos>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
	 <alpine.LFD.2.02.1207121552111.32033@ionos>
	 <20120713123318.GB20361@quack.suse.cz>
	 <alpine.LFD.2.02.1207131444490.32033@ionos>
	 <20120713144622.GB28715@quack.suse.cz>
	 <alpine.LFD.2.02.1207151057010.32033@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-15 at 10:59 +0200, Thomas Gleixner wrote: 
> On Fri, 13 Jul 2012, Jan Kara wrote:
> > On Fri 13-07-12 16:25:05, Thomas Gleixner wrote:
> > > So the patch below should allow the unplug to take place when blocked
> > > on mutexes etc.
> >   Thanks for the patch! Mike will give it some testing.
> 
> I just found out that this patch will explode nicely when the unplug
> code runs into a contended lock. Then we try to block on that lock and
> make the rtmutex code unhappy as we are already blocked on something
> else.

Kinda like so?  My x3550 M3 just exploded.  Aw poo. 

[ 6669.133081] Kernel panic - not syncing: rt_mutex_real_waiter(task->pi_blocked_on) lock: 0xffff880175dfd588 waiter: 0xffff880121fc2d58
[ 6669.133083] 
[ 6669.133086] Pid: 28240, comm: bonnie++ Tainted: G           N  3.0.35-rt56-rt #20
[ 6669.133088] Call Trace:
[ 6669.133102]  [<ffffffff81004562>] dump_trace+0x82/0x2e0
[ 6669.133109]  [<ffffffff8154d1ee>] dump_stack+0x69/0x6f
[ 6669.133114]  [<ffffffff8154d295>] panic+0xa1/0x1e5
[ 6669.133121]  [<ffffffff81095289>] task_blocks_on_rt_mutex+0x279/0x2c0
[ 6669.133127]  [<ffffffff8154f5d5>] rt_spin_lock_slowlock+0xb5/0x290
[ 6669.133134]  [<ffffffff8131d7e4>] blk_flush_plug_list+0x164/0x200
[ 6669.133139]  [<ffffffff8154dffe>] schedule+0x5e/0xb0
[ 6669.133143]  [<ffffffff8154f1ab>] __rt_mutex_slowlock+0x4b/0xd0
[ 6669.133148]  [<ffffffff8154f39b>] rt_mutex_slowlock+0xeb/0x210
[ 6669.133154]  [<ffffffff81127bce>] page_referenced_file+0x4e/0x190
[ 6669.133160]  [<ffffffff8112954a>] page_referenced+0x6a/0x230
[ 6669.133166]  [<ffffffff8110b5e4>] shrink_active_list+0x214/0x3d0
[ 6669.133170]  [<ffffffff8110b874>] shrink_list+0xd4/0x120
[ 6669.133176]  [<ffffffff8110bc3c>] shrink_zone+0x9c/0x1d0
[ 6669.133180]  [<ffffffff8110c07f>] shrink_zones+0x7f/0x1f0
[ 6669.133185]  [<ffffffff8110c27d>] do_try_to_free_pages+0x8d/0x370
[ 6669.133189]  [<ffffffff8110c8ba>] try_to_free_pages+0xea/0x210
[ 6669.133197]  [<ffffffff810ff5e3>] __alloc_pages_nodemask+0x5b3/0x9f0
[ 6669.133205]  [<ffffffff81138294>] alloc_pages_current+0xc4/0x150
[ 6669.133211]  [<ffffffff810f6296>] find_or_create_page+0x46/0xb0
[ 6669.133217]  [<ffffffff81296cc6>] alloc_extent_buffer+0x226/0x4b0
[ 6669.133225]  [<ffffffff8126f6b9>] readahead_tree_block+0x19/0x50
[ 6669.133231]  [<ffffffff8124f4bf>] reada_for_search+0x1cf/0x230
[ 6669.133237]  [<ffffffff81252faa>] read_block_for_search+0x18a/0x200
[ 6669.133242]  [<ffffffff8125525a>] btrfs_search_slot+0x25a/0x7e0
[ 6669.133248]  [<ffffffff81269144>] btrfs_lookup_csum+0x74/0x180
[ 6669.133254]  [<ffffffff8126940f>] __btrfs_lookup_bio_sums+0x1bf/0x3b0
[ 6669.133260]  [<ffffffff812775c8>] btrfs_submit_bio_hook+0x158/0x1a0
[ 6669.133270]  [<ffffffff81291216>] submit_one_bio+0x66/0xa0
[ 6669.133274]  [<ffffffff81295017>] submit_extent_page+0x107/0x220
[ 6669.133278]  [<ffffffff81295629>] __extent_read_full_page+0x4b9/0x6e0
[ 6669.133284]  [<ffffffff8129669f>] extent_readpages+0xbf/0x100
[ 6669.133289]  [<ffffffff811020fe>] __do_page_cache_readahead+0x1ae/0x250
[ 6669.133295]  [<ffffffff811024dc>] ra_submit+0x1c/0x30
[ 6669.133299]  [<ffffffff810f67eb>] do_generic_file_read.clone.0+0x27b/0x450
[ 6669.133305]  [<ffffffff810f7a9b>] generic_file_aio_read+0x1fb/0x2a0
[ 6669.133313]  [<ffffffff8115454f>] do_sync_read+0xbf/0x100
[ 6669.133319]  [<ffffffff81154e03>] vfs_read+0xc3/0x180
[ 6669.133323]  [<ffffffff81154f11>] sys_read+0x51/0xa0
[ 6669.133329]  [<ffffffff81557092>] system_call_fastpath+0x16/0x1b
[ 6669.133347]  [<00007ff8b95bb370>] 0x7ff8b95bb36f

> So no, it's not a solution to the problem. Sigh.
> 
> Can you figure out on which lock the stuck thread which did not unplug
> due to tsk_is_pi_blocked was blocked?

I'll take a peek.

-Mike

