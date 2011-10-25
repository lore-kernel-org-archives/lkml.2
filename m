Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1JYP0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:26:41 -0400
Received: from peace.netnation.com ([204.174.223.2]:46846 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1JYP0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:26:40 -0400
Date: Tue, 25 Oct 2011 08:26:31 -0700
From: Simon Kirby <sim@hostway.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111025152631.GA17008@hostway.ca>
References: <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com> <1318874090.4172.84.camel@twins> <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com> <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos> <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins> <20111018182046.GF1309@hostway.ca> <alpine.LFD.2.02.1110182146440.3240@ionos> <CA+55aFyk50v0hRNbtfF3cskAH7U-yWpHQzA+tRDFZVa6n-F_yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyk50v0hRNbtfF3cskAH7U-yWpHQzA+tRDFZVa6n-F_yw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 01:12:41PM -0700, Linus Torvalds wrote:

> On Tue, Oct 18, 2011 at 12:48 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > It does not look related.
> 
> Yeah, the only lock held there seems to be the socket lock, and it
> looks like all CPU's are spinning on it.
> 
> > Could you try to reproduce that problem with
> > lockdep enabled? lockdep might make it go away, but it's definitely
> > worth a try.
> 
> And DEBUG_SPINLOCK / DEBUG_SPINLOCK_SLEEP too. Maybe you're triggering
> some odd networking thing.  It sounds unlikely, but maybe some error
> case you get into doesn't release the socket lock.
> 
> I think PROVE_LOCKING already enables DEBUG_SPINLOCK, but the sleeping
> lock thing is separate, iirc.

I think the config option you were trying to think of is
CONFIG_DEBUG_ATOMIC_SLEEP, which enables CONFIG_PREEMPT_COUNT.

By the way, we got this WARN_ON_ONCE while running lockdep elsewhere:

       /*
        * We can walk the hash lockfree, because the hash only
        * grows, and we are careful when adding entries to the end:
        */
       list_for_each_entry(class, hash_head, hash_entry) {
               if (class->key == key) {
                       WARN_ON_ONCE(class->name != lock->name);
                       return class;
               }
       }

[19274.691090] ------------[ cut here ]------------
[19274.691107] WARNING: at kernel/lockdep.c:690 __lock_acquire+0xfd6/0x2180()
[19274.691112] Hardware name: PowerEdge 2950
[19274.691115] Modules linked in: drbd lru_cache cn ipmi_devintf ipmi_si ipmi_msghandler sata_sil24 bnx2
[19274.691137] Pid: 4416, comm: heartbeat Not tainted 3.1.0-hw-lockdep+ #52
[19274.691141] Call Trace:
[19274.691149]  [<ffffffff81098f96>] ? __lock_acquire+0xfd6/0x2180
[19274.691156]  [<ffffffff8105c4f0>] warn_slowpath_common+0x80/0xc0
[19274.691163]  [<ffffffff8105c545>] warn_slowpath_null+0x15/0x20
[19274.691169]  [<ffffffff81098f96>] __lock_acquire+0xfd6/0x2180
[19274.691175]  [<ffffffff8109a2e9>] ? lock_release_non_nested+0x1a9/0x340
[19274.691181]  [<ffffffff8109a7b9>] lock_acquire+0x109/0x140
[19274.691185]  [<ffffffff8104a302>] ? double_rq_lock+0x52/0x80
[19274.691191]  [<ffffffff813a4f8a>] ? __delay+0xa/0x10
[19274.691197]  [<ffffffff816f55fa>] _raw_spin_lock_nested+0x3a/0x50
[19274.691201]  [<ffffffff8104a302>] ? double_rq_lock+0x52/0x80
[19274.691205]  [<ffffffff8104a302>] double_rq_lock+0x52/0x80
[19274.691210]  [<ffffffff81058167>] load_balance+0x897/0x16e0
[19274.691215]  [<ffffffff81058199>] ? load_balance+0x8c9/0x16e0
[19274.691219]  [<ffffffff8104d172>] ? update_shares+0xd2/0x150
[19274.691226]  [<ffffffff816f2572>] ? __schedule+0x842/0xa20
[19274.691232]  [<ffffffff816f2608>] __schedule+0x8d8/0xa20
[19274.691238]  [<ffffffff816f2572>] ? __schedule+0x842/0xa20
[19274.691243]  [<ffffffff81063e87>] ? local_bh_enable+0xa7/0x110
[19274.691249]  [<ffffffff8169c008>] ? unix_stream_recvmsg+0x1d8/0x7f0
[19274.691254]  [<ffffffff81614c88>] ? dev_queue_xmit+0x1a8/0x8a0
[19274.691258]  [<ffffffff816f282a>] schedule+0x3a/0x60
[19274.691265]  [<ffffffff816f4515>] schedule_hrtimeout_range_clock+0x105/0x120
[19274.691270]  [<ffffffff81096c9d>] ? trace_hardirqs_on+0xd/0x10
[19274.691276]  [<ffffffff81080d89>] ? add_wait_queue+0x49/0x60
[19274.691282]  [<ffffffff816f453e>] schedule_hrtimeout_range+0xe/0x10
[19274.691291]  [<ffffffff8113dc04>] poll_schedule_timeout+0x44/0x70
[19274.691297]  [<ffffffff8113e29c>] do_sys_poll+0x33c/0x4f0
[19274.691303]  [<ffffffff8113dcf0>] ? poll_freewait+0xc0/0xc0
[19274.691309]  [<ffffffff8113ddf0>] ? __pollwait+0x100/0x100
[19274.691317]  [<ffffffff81602c3d>] ? sock_update_classid+0xfd/0x140
[19274.691323]  [<ffffffff81602bb0>] ? sock_update_classid+0x70/0x140
[19274.691330]  [<ffffffff815ff1f7>] ? sock_recvmsg+0xf7/0x130
[19274.691336]  [<ffffffff81098450>] ? __lock_acquire+0x490/0x2180
[19274.691343]  [<ffffffff8110427e>] ? might_fault+0x4e/0xa0
[19274.691351]  [<ffffffff8101a129>] ? sched_clock+0x9/0x10
[19274.691356]  [<ffffffff810944cd>] ? trace_hardirqs_off+0xd/0x10
[19274.691363]  [<ffffffff815ffb0b>] ? sys_recvfrom+0xbb/0x120
[19274.691370]  [<ffffffff81082540>] ? process_cpu_clock_getres+0x10/0x10
[19274.691376]  [<ffffffff8110427e>] ? might_fault+0x4e/0xa0
[19274.691383]  [<ffffffff8110427e>] ? might_fault+0x4e/0xa0
[19274.691390]  [<ffffffff816fe0ca>] ? sysret_check+0x2e/0x69
[19274.691396]  [<ffffffff8113e647>] sys_poll+0x77/0x110
[19274.691402]  [<ffffffff816fe092>] system_call_fastpath+0x16/0x1b
[19274.691407] ---[ end trace 74fbaae9066aadcc ]---

Simon-
