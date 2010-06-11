Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0FKHPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:15:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:38702 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0FKHPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:15:40 -0400
Subject: Re: blkiocg_update_io_add_stats(): INFO: trying to register
 non-static  key
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Ingo Molnar <mingo@elte.hu>, piotr@hosowicz.com,
       linux-kernel@vger.kernel.org, Divyesh Shah <dpshah@google.com>
In-Reply-To: <20100602130456.GP3564@kernel.dk>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <20100601064120.GA3407@elte.hu> <20100601064726.GG1660@kernel.dk>
	 <20100601065500.GA7876@elte.hu> <20100602111653.GA25662@elte.hu>
	 <20100602130456.GP3564@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 11 Jun 2010 09:15:27 +0200
Message-ID: <1276240527.2077.1467.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 15:04 +0200, Jens Axboe wrote:
> On Wed, Jun 02 2010, Ingo Molnar wrote:
> > 
> > btw., there's another warning triggered by the new blk-cgroups stats code:
> > 
> > sda:INFO: trying to register non-static key.
> > the code is fine but needs lockdep annotation.
> > turning off the locking correctness validator.
> > Pid: 81, comm: async/2 Not tainted 2.6.35-rc1-tip-01073-gd2f7698-dirty #6765
> > Call Trace:
> >  [<ffffffff81065d6d>] register_lock_class+0x15f/0x365
> >  [<ffffffff8105c426>] ? sched_clock_local+0x1d/0x83
> >  [<ffffffff8105c557>] ? sched_clock_cpu+0xcb/0xd9
> >  [<ffffffff81067184>] __lock_acquire+0x97/0x481
> >  [<ffffffff810088d4>] ? native_sched_clock+0x37/0x6d
> >  [<ffffffff81321b74>] ? blkiocg_update_io_add_stats+0x32/0x12e
> >  [<ffffffff81067644>] lock_acquire+0xd6/0xfd
> >  [<ffffffff81321b74>] ? blkiocg_update_io_add_stats+0x32/0x12e
> >  [<ffffffff81850859>] _raw_spin_lock_irqsave+0x47/0x82
> >  [<ffffffff81321b74>] ? blkiocg_update_io_add_stats+0x32/0x12e
> >  [<ffffffff81321b74>] blkiocg_update_io_add_stats+0x32/0x12e
> 
> So that's blkg->stats_lock - help me out, what is lockdep complaining
> about? The lock is initialized, what kind of lockdep annotation magic do
> we need to sprinkle on it?

It basically says its lock instance isn't properly initialised. Usually
spin_lock_init() will set lock->dep_map->key, for static locks,
initialised with __SPIN_LOCK_UNLOCKED() ->key doesn't get set and we use
the lock's address as key.

Now lockdep requires the key to be in static storage, so if you try to
used __SPIN_LOCK_UNLOCKED() on dynamically allocated locks (the most
common form is using static forms like DEFINE_foo() on stack variables),
things go bang.

That said, the block_cgroup.c code seems to use spin_lock_init() so it
_should_ all work out. Use before init/after free perhaps?
