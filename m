Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab2K3Nm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:42:29 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35800 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab2K3NmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:42:24 -0500
Date: Fri, 30 Nov 2012 05:42:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] percpu-rwsem: use synchronize_sched_expedited
Message-ID: <20121130134213.GI2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50AF7901.20401@kernel.dk>
 <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
 <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com>
 <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk>
 <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <Pine.LNX.4.64.1211272257140.18338@file.rdu.redhat.com>
 <20121129160607.06a063bb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.1211292149550.14890@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211292149550.14890@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12113013-5406-0000-0000-0000028C7F34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:00:53PM -0500, Mikulas Patocka wrote:
> On Thu, 29 Nov 2012, Andrew Morton wrote:
> > On Tue, 27 Nov 2012 22:59:52 -0500 (EST)
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > percpu-rwsem: use synchronize_sched_expedited
> > > 
> > > Use synchronize_sched_expedited() instead of synchronize_sched()
> > > to improve mount speed.
> > > 
> > > This patch improves mount time from 0.500s to 0.013s.
> > > 
> > > Note: if realtime people complain about the use
> > > synchronize_sched_expedited() and synchronize_rcu_expedited(), I suggest
> > > that they introduce an option CONFIG_REALTIME or
> > > /proc/sys/kernel/realtime and turn off these *_expedited functions if
> > > the option is enabled (i.e. turn synchronize_sched_expedited into
> > > synchronize_sched and synchronize_rcu_expedited into synchronize_rcu).
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > So I read through this thread but I really didn't see a clear
> > description of why mount() got slower.  The changelog for 4b05a1c74d1
> > is spectacularly awful :(
> > 
> > 
> > Apparently the slowdown occurred because a blockdev mount patch
> > 62ac665ff9fc07497ca524 ("blockdev: turn a rw semaphore into a percpu rw
> > semaphore") newly uses percpu rwsems, and percpu rwsems are slow on the
> > down_write() path.
> > 
> > And using synchronize_sched_expedited() rather than synchronize_sched()
> > makes percpu_down_write() somewhat less slow.  Correct?
> 
> Yes.
> 
> > Why is it OK to use synchronize_sched_expedited() here?  If it's
> > faster, why can't we use synchronize_sched_expedited() everywhere and
> > zap synchronize_sched()?
> 
> Because synchronize_sched_expedited sends interrupts to all processors and 
> it is bad for realtime workloads.
> 
> Peter Zijlstra once complained when I used synchronize_rcu_expedited in 
> bdi_remove_from_list (but he left it there).
> 
> I suggest that if it really hurts real time response for someone, let they 
> introduce a switch to turn it into non-expedited call.

Once Frederic's adaptive-ticks work reaches mainline, it will be possible
to avoid the IPIs to CPUs that are executing in user mode, in addition to
the current code's avoiding sending IPIs to CPUs that are idle.  That said,
it will still be necessary to send IPIs to CPUs that are executing in
the kernel.

So things will get better, but won't be perfect.  Sort of like this was
real life or something.  ;-)

							Thanx, Paul

