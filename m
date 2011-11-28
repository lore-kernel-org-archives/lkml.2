Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab1K1NG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:06:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:54005 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1K1NGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:06:55 -0500
Message-ID: <1322485597.2921.120.camel@twins>
Subject: Re: BUG: scheduling while atomic: swapper/0/0x10000002
From: Peter Zijlstra <peterz@infradead.org>
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
Cc: paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mingo@elte.hu, fweisbec@gmail.com, linux-acpi@vger.kernel.org
Date: Mon, 28 Nov 2011 14:06:37 +0100
In-Reply-To: <4ED37B0A.2000705@cwi.nl>
References: <4ED37B0A.2000705@cwi.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 12:14 +0000, Wouter M. Koolen wrote:
> Dear Paul and others,
> 
> On vanilla kernel 3.1.3, I got the following during boot.
> 
> BUG: scheduling while atomic: swapper/0/0x10000002
> no locks held by swapper/0.
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 3.1.3.debug+ #32
> Call Trace:
> [<ffffffff814058de>] __schedule_bug+0x60/0x65
> [<ffffffff8189b85a>] ? pidmap_init+0x84/0xc4
> [<ffffffff8140a3d9>] __schedule+0x759/0x920
> [<ffffffff8189b85a>] ? pidmap_init+0x84/0xc4
> [<ffffffff8103d855>] __cond_resched+0x25/0x40
> [<ffffffff8140a61d>] _cond_resched+0x2d/0x40
> [<ffffffff811107df>] kmem_cache_alloc_trace+0x4f/0x1d0
> [<ffffffff8189b85a>] pidmap_init+0x84/0xc4
> [<ffffffff8188ab47>] start_kernel+0x339/0x3bc
> [<ffffffff8188a322>] x86_64_start_reservations+0x132/0x136
> [<ffffffff8188a416>] x86_64_start_kernel+0xf0/0xf7
> 
> A little googling revealed that patch [2] "rcu: Avoid having 
> just-onlined CPU resched itself when RCU is idle"
> is supposed to address this issue. However, booting 3.1.3 with patch [2] 
> leads to three new "BUG: scheduling while atomic: swapper/0/0x10000002" 
> reports every boot.
> 
> The exact blurb varies a little bit, but all backtraces seem ACPI 
> related. I include three examples below. Some old [4] and new [1,3] 
> similar threads exist, but without resolution as far as I can tell.
> 
> The machine, a 2008 macbook 4.1, seems to be fine.
> 
> Is this just noise (produced by overzealous debugging checks) that I 
> should safely ignore? If not, please let me know what I can do to help 
> track this down.

Bah, looks like d86ee4809d0 ("sched: optimize cond_resched()") is
broken, what's weird is that it only now shows up.

We reset the preempt_count to 0 at sched_init()->init_idle(), which is
way before pidmap_init(), loosing the PREEMPT_ACTIVE bit that would
disable should_resched().


