Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0LGQXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:23:43 -0500
Received: from canuck.infradead.org ([134.117.69.58]:55530 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab0LGQXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:23:42 -0500
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        MingLei <tom.leiming@gmail.com>
In-Reply-To: <AANLkTim=aqwYsyR9fb=DTj2BNA5BmwsXRAPz-+OvUZPV@mail.gmail.com>
References: <cover.1290852958.git.npiggin@kernel.dk>
	 <20101207112555.GE16103@dastard>
	 <AANLkTinAt9PEWMCP55o64E7wsfZ=depU+YXbG8DdGYdO@mail.gmail.com>
	 <1291736974.2032.665.camel@laptop>
	 <AANLkTim=aqwYsyR9fb=DTj2BNA5BmwsXRAPz-+OvUZPV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Dec 2010 17:23:02 +0100
Message-ID: <1291738982.2032.720.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 02:59 +1100, Nick Piggin wrote:
> OK, thanks. My version should not have caused any problems though,
> right? 

I tihnk so, yes, altough looking at it again I wonder why you use
spin_aquire(.trylock=1) -- but that too shouldn't cause anything like
the explosion.

> Any idea what might have caused Dave's crash?

Not directly, no. Usually lockdep crashes indicate use after free like
things, where we try to lock a lock that's been scribbled on. But that
usually explodes a bit earlier.

You faulting in the middle of that breath-first-search does suggest some
data corruption, but I'm not quite sure what kind, I can't remember ever
having seem something like this before.

I've CC'ed Ming Lei who wrote the bfs search, maybe he's got an idea.


Copy of the splat:
---

> [ 5954.061633] BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1081
> [ 5954.062466] in_atomic(): 0, irqs_disabled(): 1, pid: 2927, name: rm
> [ 5954.063122] 3 locks held by rm/2927:
> [ 5954.063476]  #0:  (&sb->s_type->i_mutex_key#12/1){+.+.+.}, at: [<ffffffff8116f5e1>] do_rmdir+0x81/0x130
> [ 5954.064014]  #1:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff8116d3a8>] vfs_rmdir+0x58/0xe0
> [ 5954.064014]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff811779c0>] shrink_dentry_list+0x0/0x430
> [ 5954.064014] irq event stamp: 1484376719
> [ 5954.064014] hardirqs last  enabled at (1484376719): [<ffffffff810ebf07>] __call_rcu+0xd7/0x1a0
> [ 5954.064014] hardirqs last disabled at (1484376718): [<ffffffff810ebe7a>] __call_rcu+0x4a/0x1a0
> [ 5954.064014] softirqs last  enabled at (1484376586): [<ffffffff8108b911>] __do_softirq+0x161/0x270
> [ 5954.064014] softirqs last disabled at (1484376581): [<ffffffff8103af1c>] call_softirq+0x1c/0x50
> [ 5954.064014] Pid: 2927, comm: rm Not tainted 2.6.37-rc4-dgc+ #794
> [ 5954.064014] Call Trace:
> [ 5954.064014]  [<ffffffff810b95b0>] ? print_irqtrace_events+0xd0/0xe0
> [ 5954.064014]  [<ffffffff81076455>] __might_sleep+0xf5/0x130
> [ 5954.064014]  [<ffffffff81b1e603>] do_page_fault+0x103/0x4f0
> [ 5954.064014]  [<ffffffff810645b8>] ? pvclock_clocksource_read+0x58/0xd0
> [ 5954.064014]  [<ffffffff810645b8>] ? pvclock_clocksource_read+0x58/0xd0
> [ 5954.064014]  [<ffffffff810645b8>] ? pvclock_clocksource_read+0x58/0xd0
> [ 5954.064014]  [<ffffffff81b19b28>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [ 5954.064014]  [<ffffffff810b8e20>] ? usage_match+0x0/0x20
> [ 5954.064014]  [<ffffffff81b1af25>] page_fault+0x25/0x30
> [ 5954.064014]  [<ffffffff810b8e20>] ? usage_match+0x0/0x20
> [ 5954.064014]  [<ffffffff810ba1c8>] ? __bfs+0xc8/0x260
> [ 5954.064014]  [<ffffffff810ba123>] ? __bfs+0x23/0x260
> [ 5954.064014]  [<ffffffff810ba4d2>] find_usage_backwards+0x42/0x80
> [ 5954.064014]  [<ffffffff810bcec4>] check_usage_backwards+0x64/0xf0
> [ 5954.064014]  [<ffffffff8104796f>] ? save_stack_trace+0x2f/0x50
> [ 5954.064014]  [<ffffffff810bce60>] ? check_usage_backwards+0x0/0xf0
> [ 5954.064014]  [<ffffffff810bd9a9>] mark_lock+0x1a9/0x440
> [ 5954.064014]  [<ffffffff810be989>] __lock_acquire+0x5a9/0x14b0
> [ 5954.064014]  [<ffffffff810be716>] ? __lock_acquire+0x336/0x14b0
> [ 5954.064014]  [<ffffffff810645b8>] ? pvclock_clocksource_read+0x58/0xd0
> [ 5954.064014]  [<ffffffff810bf944>] lock_acquire+0xb4/0x140
> [ 5954.064014]  [<ffffffff81177a1c>] ? shrink_dentry_list+0x5c/0x430
> [ 5954.064014]  [<ffffffff81b19d86>] _raw_spin_lock+0x36/0x70
> [ 5954.064014]  [<ffffffff81177a1c>] ? shrink_dentry_list+0x5c/0x430
> [ 5954.064014]  [<ffffffff81177a1c>] shrink_dentry_list+0x5c/0x430
> [ 5954.064014]  [<ffffffff811779c0>] ? shrink_dentry_list+0x0/0x430
> [ 5954.064014]  [<ffffffff816b9c7e>] ? do_raw_spin_unlock+0x5e/0xb0
> [ 5954.064014]  [<ffffffff81177f2d>] __shrink_dcache_sb+0x13d/0x1c0
> [ 5954.064014]  [<ffffffff811784bf>] shrink_dcache_parent+0x32f/0x390
> [ 5954.064014]  [<ffffffff8116d31d>] dentry_unhash+0x3d/0x70
> [ 5954.064014]  [<ffffffff8116d3b0>] vfs_rmdir+0x60/0xe0
> [ 5954.064014]  [<ffffffff8116f673>] do_rmdir+0x113/0x130
> [ 5954.064014]  [<ffffffff8103a03a>] ? sysret_check+0x2e/0x69
> [ 5954.064014]  [<ffffffff81b19ae9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 5954.064014]  [<ffffffff8116f6c5>] sys_unlinkat+0x35/0x40
> [ 5954.064014]  [<ffffffff8103a002>] system_call_fastpath+0x16/0x1b
