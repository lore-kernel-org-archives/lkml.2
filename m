Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab2CFPHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:07:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab2CFPHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:07:15 -0500
Date: Tue, 6 Mar 2012 10:07:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] blkcg: accumulated blkcg updates
Message-ID: <20120306150709.GA32148@redhat.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <20120305210726.GC1263@google.com>
 <20120305210836.GD1263@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305210836.GD1263@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 01:08:36PM -0800, Tejun Heo wrote:
> On Mon, Mar 05, 2012 at 01:07:26PM -0800, Tejun Heo wrote:
> > Hello,
> > 
> > Vivek reported two different crashes.  Patch 17.5 added and patch 27
> > updated to address both issues.  Andrew reminded me a deeper problem
> > with percpu mempool approach and I'll go with Vivek's delayed
> > allocation patch.  For now, I'm dropping the stats patches.
> > 
> > I posted the two updated patches but holding off reposting all patches
> > which now generate conflicts due to the updates.  git branches are
> > updated.
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-stacking
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git unified-blkg
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-kill-pn
> > 
> > Note that blkcg-stats is dropped for now.  I'll repost the series
> > later when Jens is ready to pull.
> 
> Ooh, the commit ID of blkcg-stacking, which is on top of all other
> pending commits is fcddfec4ea9067ae6c963682dcdb5ddf783a3ff9.
> 
> Vivek, can you please verify the crashes you were seeing are gone now?

Hi Tejun,

Built and booted into blkcg-stacking. Looks likd old crashes on reading
file and scheduler change are fixed.

My system is hanging during reboot. Last message I see is "Detaching DM
devices" and nothing happens after that. I shall have to do some more 
testing to figure out when did that start happening.

I have been seeing following on boot though.

[    2.893244] ===============================
[    2.897492] [ INFO: suspicious RCU usage. ]
[    2.901741] 3.3.0-rc3-tejun-misc+ #27 Not tainted
[    2.906509] -------------------------------
[    2.910760] kernel/cgroup.c:1723 suspicious rcu_dereference_check()
usage!
[    2.917696] 
[    2.917697] other info that might help us debug this:
[    2.917698] 
[    2.925919] 
[    2.925920] rcu_scheduler_active = 1, debug_locks = 0
[    2.932588] no locks held by swapper/0/1.
[    2.936664] 
[    2.936664] stack backtrace:
[    2.941180] Pid: 1, comm: swapper/0 Not tainted 3.3.0-rc3-tejun-misc+
#27
[    2.948030] Call Trace:
[    2.950550]  [<ffffffff81093ba5>] lockdep_rcu_suspicious+0xe5/0x100
[    2.956883]  [<ffffffff810adfbe>] cgroup_path+0x1be/0x200
[    2.962350]  [<ffffffff8130af55>] blkg_lookup_create+0x1d5/0x490
[    2.968422]  [<ffffffff8130d3b5>] blk_throtl_init+0x135/0x220
[    2.974237]  [<ffffffff8130d369>] ? blk_throtl_init+0xe9/0x220
[    2.980141]  [<ffffffff8130b6e1>] blkcg_init_queue+0x31/0x90
[    2.985874]  [<ffffffff812f2c2a>] blk_alloc_queue_node+0x22a/0x270
[    2.992120]  [<ffffffff812f2c83>] blk_alloc_queue+0x13/0x20
[    2.997761]  [<ffffffff81447cba>] brd_alloc+0x7a/0x1b0
[    3.002968]  [<ffffffff81f0163e>] brd_init+0xc6/0x1ce
[    3.008086]  [<ffffffff81f01578>] ? register_node_type+0x19/0x19
[    3.014167]  [<ffffffff810001cf>] do_one_initcall+0x3f/0x170
[    3.019893]  [<ffffffff81ed4c34>] kernel_init+0xc9/0x143
[    3.025273]  [<ffffffff81844e24>] kernel_thread_helper+0x4/0x10
[    3.031258]  [<ffffffff8183b65d>] ? retint_restore_args+0xe/0xe
[    3.037244]  [<ffffffff81ed4b6b>] ? start_kernel+0x375/0x375
[    3.042968]  [<ffffffff81844e20>] ? gs_change+0xb/0xb

Thanks
Vivek
