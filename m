Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab1IATir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:38:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:48653 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812Ab1IATiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:38:46 -0400
Date: Thu, 1 Sep 2011 21:38:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, efault@gmx.de,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.0.4 + rt12: deadlock
In-Reply-To: <4E5E6A75.5030404@localhost>
Message-ID: <alpine.LFD.2.02.1109012136300.2723@ionos>
References: <4E5E6A75.5030404@localhost>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011, Fernando Lopez-Lezcano wrote:

> Booting 3.0.4 + rt12 on a quadcore workstation (running fc14) gave me this:
> 
> ----
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.0.4-1.rt12.1.fc14.ccrma.i686.rtPAE #1
> ---------------------------------------------
> swapper/0 is trying to acquire lock:
>  (&parent->list_lock){+.+...}, at: [<c05054ce>]
> __cache_free.clone.27+0x45/0xc4
> 
> but task is already holding lock:
>  (&parent->list_lock){+.+...}, at: [<c050662c>] do_tune_cpucache+0xf0/0x2b0
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&parent->list_lock);
>   lock(&parent->list_lock);

That's something which has to do with debugging options (debugobjects
IIRC). There was some attempt to fix that, but that might have gone
lost in my vacation and the following futile attempt to take care of
the resulting backlog. Peter ???

Thanks,

	tglx

 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 3 locks held by swapper/0:
>  #0:  (cache_chain_mutex){+.+...}, at: [<c0bedb96>]
> kmem_cache_init_late+0x15/0x61
>  #1:  (&per_cpu(slab_lock, __cpu).lock){+.+...}, at: [<c0504a53>]
> __local_lock_irq+0x1e/0x5b
>  #2:  (&parent->list_lock){+.+...}, at: [<c050662c>]
> do_tune_cpucache+0xf0/0x2b0
> 
> stack backtrace:
> Pid: 0, comm: swapper Not tainted 3.0.4-1.rt12.1.fc14.ccrma.i686.rtPAE #1
> Call Trace:
>  [<c086e6f6>] ? printk+0x2d/0x2f
>  [<c0479b36>] __lock_acquire+0x8b3/0xc2f
>  [<c086fd96>] ? rt_spin_lock_slowlock+0x67/0x170
>  [<c04790ee>] ? mark_lock+0x26/0x1bb
>  [<c05054ce>] ? __cache_free.clone.27+0x45/0xc4
>  [<c047a372>] lock_acquire+0xde/0x11d
>  [<c05054ce>] ? __cache_free.clone.27+0x45/0xc4
>  [<c08703b4>] rt_spin_lock+0x3d/0x43
>  [<c05054ce>] ? __cache_free.clone.27+0x45/0xc4
>  [<c05054ce>] __cache_free.clone.27+0x45/0xc4
>  [<c0437c83>] ? test_ti_thread_flag+0x8/0x10
>  [<c0505303>] kmem_cache_free+0x73/0xe1
>  [<c05053c0>] slab_destroy+0x4f/0x53
>  [<c0505458>] free_block+0x94/0xc5
>  [<c0506645>] do_tune_cpucache+0x109/0x2b0
>  [<c05069c7>] enable_cpucache+0x7b/0xa7
>  [<c0bedba7>] kmem_cache_init_late+0x26/0x61
>  [<c0bcd68a>] start_kernel+0x24f/0x367
>  [<c0bcd1d1>] ? loglevel+0x1a/0x1a
>  [<c0bcd13b>] ? reserve_ebda_region+0x70/0x72
>  [<c0bcd0c3>] i386_start_kernel+0xb2/0xba
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:  8
> ... MAX_LOCK_DEPTH:          48
> ... MAX_LOCKDEP_KEYS:        8191
> ... CLASSHASH_SIZE:          4096
> ... MAX_LOCKDEP_ENTRIES:     32768
> ... MAX_LOCKDEP_CHAINS:      65536
> ... CHAINHASH_SIZE:          32768
> ----
> 
> I started working and a little while later the machine froze (jack + heavy
> prioritized udp traffic in eth1 - with the r8169 driver). It recognized
> alt-sysrq boot so it was not completely dead. Nothing left on the logs to see.
> 
> Full config attached.
> -- Fernando
> 
