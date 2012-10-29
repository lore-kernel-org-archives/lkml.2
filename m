Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab2J2Qzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:55:44 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36105 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2J2Qzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:55:42 -0400
Date: Mon, 29 Oct 2012 09:55:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Alasdair G Kergon <agk@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] dm: stay in blk_queue_bypass until queue becomes
 initialized
Message-ID: <20121029165516.GI3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50890937.7010809@ce.jp.nec.com>
 <20121026202105.GF24687@redhat.com>
 <508E572C.6000707@ce.jp.nec.com>
 <20121029163845.GB7709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029163845.GB7709@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102916-2398-0000-0000-00000CFFF4A8
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00186712; UDB=6.00042295; UTC=2012-10-29
 16:55:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 12:38:45PM -0400, Vivek Goyal wrote:
> On Mon, Oct 29, 2012 at 07:15:08PM +0900, Jun'ichi Nomura wrote:
> > On 10/27/12 05:21, Vivek Goyal wrote:
> > > On Thu, Oct 25, 2012 at 06:41:11PM +0900, Jun'ichi Nomura wrote:
> > >> [PATCH] dm: stay in blk_queue_bypass until queue becomes initialized
> > >>
> > >> With 749fefe677 ("block: lift the initial queue bypass mode on
> > >> blk_register_queue() instead of blk_init_allocated_queue()"),
> > >> add_disk() eventually calls blk_queue_bypass_end().
> > >> This change invokes the following warning when multipath is used.
> > >>
> > >>   BUG: scheduling while atomic: multipath/2460/0x00000002

Looks like preemption has been disabled, nested two deep, based
on the /0x00000002, which dumps out preempt_count().

So is someone invoking this with preemption disabled?

> > >>   1 lock held by multipath/2460:
> > >>    #0:  (&md->type_lock){......}, at: [<ffffffffa019fb05>] dm_lock_md_type+0x17/0x19 [dm_mod]
> > >>   Modules linked in: ...
> > >>   Pid: 2460, comm: multipath Tainted: G        W    3.7.0-rc2 #1
> > >>   Call Trace:
> > >>    [<ffffffff810723ae>] __schedule_bug+0x6a/0x78
> > >>    [<ffffffff81428ba2>] __schedule+0xb4/0x5e0
> > >>    [<ffffffff814291e6>] schedule+0x64/0x66
> > >>    [<ffffffff8142773a>] schedule_timeout+0x39/0xf8
> > >>    [<ffffffff8108ad5f>] ? put_lock_stats+0xe/0x29
> > >>    [<ffffffff8108ae30>] ? lock_release_holdtime+0xb6/0xbb
> > >>    [<ffffffff814289e3>] wait_for_common+0x9d/0xee
> > >>    [<ffffffff8107526c>] ? try_to_wake_up+0x206/0x206
> > >>    [<ffffffff810c0eb8>] ? kfree_call_rcu+0x1c/0x1c
> > >>    [<ffffffff81428aec>] wait_for_completion+0x1d/0x1f
> > >>    [<ffffffff810611f9>] wait_rcu_gp+0x5d/0x7a
> > >>    [<ffffffff81061216>] ? wait_rcu_gp+0x7a/0x7a
> > >>    [<ffffffff8106fb18>] ? complete+0x21/0x53
> > >>    [<ffffffff810c0556>] synchronize_rcu+0x1e/0x20
> > >>    [<ffffffff811dd903>] blk_queue_bypass_start+0x5d/0x62
> > >>    [<ffffffff811ee109>] blkcg_activate_policy+0x73/0x270
> > >>    [<ffffffff81130521>] ? kmem_cache_alloc_node_trace+0xc7/0x108
> > >>    [<ffffffff811f04b3>] cfq_init_queue+0x80/0x28e
> > >>    [<ffffffffa01a1600>] ? dm_blk_ioctl+0xa7/0xa7 [dm_mod]
> > >>    [<ffffffff811d8c41>] elevator_init+0xe1/0x115
> > >>    [<ffffffff811e229f>] ? blk_queue_make_request+0x54/0x59
> > >>    [<ffffffff811dd743>] blk_init_allocated_queue+0x8c/0x9e
> > >>    [<ffffffffa019ffcd>] dm_setup_md_queue+0x36/0xaa [dm_mod]
> > >>    [<ffffffffa01a60e6>] table_load+0x1bd/0x2c8 [dm_mod]
> > >>    [<ffffffffa01a7026>] ctl_ioctl+0x1d6/0x236 [dm_mod]
> > >>    [<ffffffffa01a5f29>] ? table_clear+0xaa/0xaa [dm_mod]
> > >>    [<ffffffffa01a7099>] dm_ctl_ioctl+0x13/0x17 [dm_mod]
> > >>    [<ffffffff811479fc>] do_vfs_ioctl+0x3fb/0x441
> > >>    [<ffffffff811b643c>] ? file_has_perm+0x8a/0x99
> > >>    [<ffffffff81147aa0>] sys_ioctl+0x5e/0x82
> > >>    [<ffffffff812010be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > >>    [<ffffffff814310d9>] system_call_fastpath+0x16/0x1b
> > >>
> > >> The warning means during queue initialization blk_queue_bypass_start()
> > >> calls sleeping function (synchronize_rcu) while dm holds md->type_lock.
> > > 
> > > md->type_lock is a mutex, isn't it? I thought we are allowed to block
> > > and schedule out under mutex?
> > 
> > Hm, you are right. It's a mutex.
> > The warning occurs only if I turned on CONFIG_PREEMPT=y.
> 
> Ok, so the question is what's wrong with calling synchronize_rcu() inside
> a mutex with CONFIG_PREEMPT=y. I don't know. Ccing paul mckenney  and
> peterz.

Nothing is wrong with calling synchronize_rcu() inside a mutex, this has
been used and does work.  Last I tried it, anyway.  ;-)

> > > add_disk() also calls disk_alloc_events() which does kzalloc(GFP_KERNEL).
> > > So we already have code which can block/wait under md->type_lock. I am
> > > not sure why should we get this warning under a mutex.
> > 
> > add_disk() is called without md->type_lock.
> > 
> > Call flow is like this:
> > 
> > dm_create
> >   alloc_dev
> >     blk_alloc_queue
> >     alloc_disk
> >     add_disk
> >       blk_queue_bypass_end [with 3.7-rc2]
> > 
> > table_load
> >   dm_lock_md_type [takes md->type_lock]
> >   dm_setup_md_queue
> >     blk_init_allocated_queue [when DM_TYPE_REQUEST_BASED]
> >       elevator_init
> >         blkcg_activate_policy
> >           blk_queue_bypass_start <-- THIS triggers the warning
> >           blk_queue_bypass_end
> >       blk_queue_bypass_end [with 3.6]
> >   dm_unlock_md_type
> > 
> > blk_queue_bypass_start() in blkcg_activate_policy was nested call,
> > that did nothing, with 3.6.
> > With 3.7-rc2, it becomes the initial call and does
> > actual draining stuff.
> 
> Ok. Once we know what's wrong, we should be able to figure out the 
> right solution. Artificially putting queue one level deep in bypass
> to avoid calling synchronize_rcu() sounds bad.

Also should be unnecessary.  I suggest finding out where preemption is
disabled. Scattering checks for preempt_count()!=0 might help locate it.

							Thanx, Paul

