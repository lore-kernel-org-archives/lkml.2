Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2K3DB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 22:01:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab2K3DB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 22:01:58 -0500
Date: Thu, 29 Nov 2012 22:00:53 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] percpu-rwsem: use synchronize_sched_expedited
In-Reply-To: <20121129160607.06a063bb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.1211292149550.14890@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <20121120180949.GG1408@quack.suse.cz> <CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
 <CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
 <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
 <50AF7901.20401@kernel.dk> <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
 <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com>
 <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <Pine.LNX.4.64.1211272257140.18338@file.rdu.redhat.com>
 <20121129160607.06a063bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Nov 2012, Andrew Morton wrote:

> On Tue, 27 Nov 2012 22:59:52 -0500 (EST)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > percpu-rwsem: use synchronize_sched_expedited
> > 
> > Use synchronize_sched_expedited() instead of synchronize_sched()
> > to improve mount speed.
> > 
> > This patch improves mount time from 0.500s to 0.013s.
> > 
> > Note: if realtime people complain about the use
> > synchronize_sched_expedited() and synchronize_rcu_expedited(), I suggest
> > that they introduce an option CONFIG_REALTIME or
> > /proc/sys/kernel/realtime and turn off these *_expedited functions if
> > the option is enabled (i.e. turn synchronize_sched_expedited into
> > synchronize_sched and synchronize_rcu_expedited into synchronize_rcu).
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> So I read through this thread but I really didn't see a clear
> description of why mount() got slower.  The changelog for 4b05a1c74d1
> is spectacularly awful :(
> 
> 
> Apparently the slowdown occurred because a blockdev mount patch
> 62ac665ff9fc07497ca524 ("blockdev: turn a rw semaphore into a percpu rw
> semaphore") newly uses percpu rwsems, and percpu rwsems are slow on the
> down_write() path.
> 
> And using synchronize_sched_expedited() rather than synchronize_sched()
> makes percpu_down_write() somewhat less slow.  Correct?

Yes.

> Why is it OK to use synchronize_sched_expedited() here?  If it's
> faster, why can't we use synchronize_sched_expedited() everywhere and
> zap synchronize_sched()?

Because synchronize_sched_expedited sends interrupts to all processors and 
it is bad for realtime workloads.

Peter Zijlstra once complained when I used synchronize_rcu_expedited in 
bdi_remove_from_list (but he left it there).

I suggest that if it really hurts real time response for someone, let they 
introduce a switch to turn it into non-expedited call.

Mikulas
