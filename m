Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab1JTXDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 19:03:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39235 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1JTXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 19:03:09 -0400
Date: Fri, 21 Oct 2011 02:00:40 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111020230040.GC3586@swordfish.minsk.epam.com>
References: <alpine.DEB.2.00.1110151436420.15894@chino.kir.corp.google.com>
 <20111015222324.GA16432@liondog.tnic>
 <alpine.DEB.2.00.1110151529570.25063@chino.kir.corp.google.com>
 <20111020183913.GA21918@liondog.tnic>
 <20111020185329.GA3586@swordfish.minsk.epam.com>
 <20111020190701.GB3586@swordfish.minsk.epam.com>
 <alpine.DEB.2.00.1110201412070.5552@chino.kir.corp.google.com>
 <20111020212353.GZ25124@google.com>
 <alpine.DEB.2.00.1110201425560.5552@chino.kir.corp.google.com>
 <20111020213644.GB25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020213644.GB25124@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/20/11 14:36), Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 20, 2011 at 02:31:39PM -0700, David Rientjes wrote:
> > > So, according to this thread, the problem is that the memset() clears
> > > lock->name field, right?
> > 
> > Right, and reverting f59de8992aa6 ("lockdep: Clear whole lockdep_map on 
> > initialization") seems to fix the lockdep warning.
> > 
> > > But how can that be a problem?  lock->name
> > > is always set to either "NULL" or @name.  Why would clearing it before
> > > setting make any difference?  What am I missing?
> > > 
> > 
> > The scheduler (in sched_fair and sched_rt) calls lock_set_subclass() which 
> > sets the name in double_unlock_balance() to set the name but there's a 
> > race between when that is cleared with the memset() and setting of 
> > lock->name where lockdep can find them to match.
> 
> Hmmm... so lock_set_subclass() is racing against lockdep_init()?  That
> sounds very fishy and probably needs better fix.  Anyways, if someone
> can't come up with proper solution, please feel free to revert the
> commit.
> 

I thought I've started understand this, but it was wrong feeling.

The error indeed is that class name and lock name are mismatch

 689                 if (class->key == key) {                                                                                                                                                                                      
 690                         WARN_ON_ONCE(class->name != lock->name);                                            
 691                         return class;                                                                       
 692                 }  

And the problem as far as I understand only shows up when active_load_balance_cpu_stop() gets
called on rq with active_balance.

double_unlock_balance() is called with busiest_rq spin lock held and I don't see who
calls lockdep_init_map() on busiest_rq somewhere around. work_struct has its
own lockdep_map touched after __queue_work(cpu, wq, work).

I'm not sure that reverting is the best option we have, since it's not fixing
the possible race condition it's just mask it.


I'm not very lucky at reproducing issue, in fact I had only one trace so far.

[10172.218213] ------------[ cut here ]------------
[10172.218233] WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
[10172.218346]  [<ffffffff8103e7c8>] warn_slowpath_common+0x7e/0x96
[10172.218353]  [<ffffffff8103e7f5>] warn_slowpath_null+0x15/0x17
[10172.218361]  [<ffffffff8106fee5>] __lock_acquire+0x168/0x164b
[10172.218370]  [<ffffffff81034645>] ? find_busiest_group+0x7b6/0x941
[10172.218381]  [<ffffffff8102a5e3>] ? double_rq_lock+0x4d/0x52
[10172.218389]  [<ffffffff8107197e>] lock_acquire+0x138/0x1ac
[10172.218397]  [<ffffffff8102a5e3>] ? double_rq_lock+0x4d/0x52
[10172.218404]  [<ffffffff8102a5c4>] ? double_rq_lock+0x2e/0x52
[10172.218414]  [<ffffffff8148fb49>] _raw_spin_lock_nested+0x3a/0x49
[10172.218421]  [<ffffffff8102a5e3>] ? double_rq_lock+0x4d/0x52
[10172.218428]  [<ffffffff8148fabe>] ? _raw_spin_lock+0x3e/0x45
[10172.218435]  [<ffffffff8102a5c4>] ? double_rq_lock+0x2e/0x52
[10172.218442]  [<ffffffff8102a5e3>] double_rq_lock+0x4d/0x52
[10172.218449]  [<ffffffff810349cc>] load_balance+0x1fc/0x769
[10172.218458]  [<ffffffff810075c5>] ? native_sched_clock+0x38/0x65
[10172.218466]  [<ffffffff8148ca17>] ? __schedule+0x2f5/0xa2d
[10172.218474]  [<ffffffff8148caf5>] __schedule+0x3d3/0xa2d
[10172.218480]  [<ffffffff8148ca17>] ? __schedule+0x2f5/0xa2d
[10172.218490]  [<ffffffff8104db06>] ? add_timer_on+0xd/0x196
[10172.218497]  [<ffffffff8148fc02>] ? _raw_spin_lock_irq+0x4a/0x51
[10172.218505]  [<ffffffff8105907b>] ? process_one_work+0x3ed/0x54c
[10172.218512]  [<ffffffff81059126>] ? process_one_work+0x498/0x54c
[10172.218518]  [<ffffffff81058e1b>] ? process_one_work+0x18d/0x54c
[10172.218526]  [<ffffffff814902d0>] ? _raw_spin_unlock_irq+0x28/0x56
[10172.218533]  [<ffffffff81033950>] ? get_parent_ip+0xe/0x3e
[10172.218540]  [<ffffffff8148d26e>] schedule+0x55/0x57
[10172.218547]  [<ffffffff8105970f>] worker_thread+0x217/0x21c
[10172.218554]  [<ffffffff810594f8>] ? manage_workers.isra.21+0x16c/0x16c
[10172.218564]  [<ffffffff8105d4de>] kthread+0x9a/0xa2
[10172.218573]  [<ffffffff81497984>] kernel_thread_helper+0x4/0x10
[10172.218580]  [<ffffffff8102d6d2>] ? finish_task_switch+0x76/0xf3
[10172.218587]  [<ffffffff81490778>] ? retint_restore_args+0x13/0x13
[10172.218595]  [<ffffffff8105d444>] ? __init_kthread_worker+0x53/0x53
[10172.218602]  [<ffffffff81497980>] ? gs_change+0x13/0x13
[10172.218607] ---[ end trace 9d11d6b5e4b96730 ]---



	Sergey
