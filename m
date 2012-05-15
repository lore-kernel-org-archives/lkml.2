Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966776Ab2EOUhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:37:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966237Ab2EOUhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:37:21 -0400
Date: Tue, 15 May 2012 13:36:55 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Jones <davej@redhat.com>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: fix oops in processing workqueue
In-Reply-To: <20120515153136.GF6119@google.com>
Message-ID: <alpine.LSU.2.00.1205151307350.1416@eggly.anvils>
References: <alpine.LSU.2.00.1205081106160.4071@eggly.anvils> <1336516260.8226.61.camel@twins> <alpine.LSU.2.00.1205081553250.4497@eggly.anvils> <20120509092536.GC8585@gmail.com> <alpine.LSU.2.00.1205091219590.20881@eggly.anvils> <alpine.LSU.2.00.1205101049460.17714@eggly.anvils>
 <20120514212753.GM2366@google.com> <1337080288.27694.38.camel@twins> <20120515151048.GA6119@google.com> <20120515152952.GA27838@redhat.com> <20120515153136.GF6119@google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Tejun Heo wrote:
> On Tue, May 15, 2012 at 11:29:52AM -0400, Dave Jones wrote:
> > On Tue, May 15, 2012 at 08:10:48AM -0700, Tejun Heo wrote:
> >  > >From 4d82a1debbffec129cc387aafa8f40b7bbab3297 Mon Sep 17 00:00:00 2001
> >  > From: Peter Zijlstra <peterz@infradead.org>
> >  > Date: Tue, 15 May 2012 08:06:19 -0700
> >  > 
> >  > Under memory load, on x86_64, with lockdep enabled, the workqueue's
> >  > process_one_work() has been seen to oops in __lock_acquire(), barfing
> >  > on a 0xffffffff00000000 pointer in the lockdep_map's class_cache[].
> > 
> > can you elaborate what 'memory load' means here ?
> > I'm curious if I can add something to my fuzzing tool to shake out bugs like this.
> 
> I think Hugh knows and can explain this much better than I do.  Hugh?

Quoting from myself, quoting from myself, on an earlier occasion:

"It's the tmpfs swapping test that I've been running, with variations,
for years.  System booted with mem=700M and 1.5G swap, two repetitious
make -j20 kernel builds (of a 2.6.24 kernel: I stuck with that because
the balance of built to unbuilt source grows smaller with later kernels),
one directly in a tmpfs, the other in a 1k-block ext2 (that I drive with
ext4's CONFIG_EXT4_USE_FOR_EXT23) on /dev/loop0 on a 450MB tmpfs file."

Most of those details will be irrelevant in this case, but it's been a
useful test down the years, catching lots of bugs and races.  On this
occasion I was running a variation which further puts each of the builds
in its own 300M mem cgroup, with a concurrent script which cycles around
making a new 300M mem cgroup, moving all the tasks from one old into the
new (with memory.move_charge_at_immigrate set to 3), then rmdir the old.

It was probably the moving of memcg charges (or the rmdir'ing of memcg,
which also involves moving memcg charges) which was making so many calls
to lru_add_drain_all() to show the problem - lru_add_drain_all() has to
schedule work on each cpu and then flush_work() on each.

(But it only came up as a problem in linux-next, which has added some
lockmap accesses to flush_work() - Tejun spotted that upstream could
already be vulnerable via other routes, but this was all I ever hit.)

Hugh
