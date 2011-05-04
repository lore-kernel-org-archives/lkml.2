Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1EDMsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 08:48:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44982 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab1EDMsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 08:48:21 -0400
Date: Wed, 4 May 2011 14:47:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Cc: werner <w.landgraf@ru.ru>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504124729.GA9731@elte.hu>
References: <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
 <20110504101327.GA847@elte.hu>
 <20110504104140.GA5277@elte.hu>
 <20110504104520.GA5502@elte.hu>
 <20110504110650.GA6376@elte.hu>
 <20110504123753.GA8646@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504123753.GA8646@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > > index 94d2a33..27bc3be 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -30,6 +30,8 @@
> > >  
> > >  #include <trace/events/kmem.h>
> > >  
> > > +#undef CONFIG_CMPXCHG_LOCAL
> > > +
> > >  /*
> > >   * Lock order:
> > >   *   1. slab_lock(page)
> > 
> > This seems rock solid after half an hour of testing. I'll keep it running 
> > longer, i still have no good data for how frequently the crashes are occuring.
> 
> It's still rock solid after 2 hours: neither crashes nor IO/IRQ timeouts are 
> occuring.

So i removed the above patch and rebooted, and within minutes of starting the 
FS test i got:

skb_over_panic: text:c19fe045 len:98 put:98 head:  (null) data:  (null) tail:0x62 end:0x0 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:127!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/net/eth0/address
Modules linked in:

Pid: 3535, comm: dd Not tainted 2.6.39-rc5-i486-1sys+ #122586 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c1bda60d>] EFLAGS: 00010292 CPU: 1
EIP is at skb_put+0x89/0x92
EAX: 0000006b EBX: 00000000 ECX: 00000046 EDX: 00000000
ESI: c19fe045 EDI: 00000062 EBP: f64cdf20 ESP: f64cdef4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process dd (pid: 3535, ti=f64cc000 task=f5f4b570 task.ti=f53f4000)
Stack:
 c2143545 c19fe045 00000062 00000062 00000000 00000000 00000062 00000000
 c207d136 f6506000 f408d600 f64cdf4c c19fe045 c19fd92b f64cdf4c 00000040
 f6506428 00000000 34020062 f6506000 00000246 c21b799c f64cdf90 c1a004c1
Call Trace:
 [<c19fe045>] ? nv_rx_process_optimized+0x101/0x1de
 [<c19fe045>] nv_rx_process_optimized+0x101/0x1de
 [<c19fd92b>] ? nv_alloc_rx_optimized+0xe/0x18f
 [<c1a004c1>] nv_napi_poll+0x496/0x4a5
 [<c105838c>] ? hrtimer_run_pending+0xe/0xd1
 [<c1d734b4>] ? _raw_spin_lock+0x8/0x1e
 [<c1be1d59>] net_rx_action+0x94/0x1ab
 [<c1042fcd>] __do_softirq+0x9f/0x14f
 [<c1042f2e>] ? remote_softirq_receive+0x33/0x33
 <IRQ> 
 [<c10431e7>] ? irq_exit+0x3a/0x43
 [<c10047ce>] ? do_IRQ+0x8c/0xa0
 [<c116366d>] ? __ext3_journal_dirty_metadata+0x1e/0x45
 [<c1054f23>] ? wake_up_bit+0x1c/0x20
 [<c10ec726>] ? __brelse+0xb/0x36
 [<c102ea1c>] ? __wake_up_common+0xe/0x62
 [<c1d74eb0>] ? common_interrupt+0x30/0x40
 [<c14fb1ea>] ? sha_transform+0x9a/0x1be
 [<c15ff44e>] ? extract_buf+0x50/0xe3
 [<c14fe7ab>] ? __copy_to_user_ll+0xb/0x37
 [<c14fe9b5>] ? copy_to_user+0x3e/0x49
 [<c15ffd83>] ? extract_entropy_user+0x80/0xe5
 [<c15ffdfa>] ? urandom_read+0x12/0x14
 [<c10cc888>] ? vfs_read+0x93/0x115
 [<c15ffde8>] ? extract_entropy_user+0xe5/0xe5
 [<c10cc94c>] ? sys_read+0x42/0x66
 [<c1d74903>] ? sysenter_do_call+0x12/0x28
Code: 00 00 89 44 24 14 8b 81 a8 00 00 00 89 44 24 10 89 54 24 0c 8b 41 50 89 44 24 08 89 74 24 04 c7 04 24 45 35 14 c2 e8 fa 09 18 00 <0f> 0b 83 c4 24 5b 5e 5d c3 55 89 e5 57 56 53 83 ec 30 e8 ac a8 
EIP: [<c1bda60d>] skb_put+0x89/0x92 SS:ESP 0068:f64cdef4
---[ end trace 1d38b9741c67ed6b ]---

And in hindsight i have to admit that i saw this in randconfig testing in the 
past few weeks, i just never managed to reproduce it ...

So yes, the fact that this time it crashed in networking (not in block IO) 
clearly implicates SLUB as well.

And the trigger condition is the lockless SLUB code on 32-bit, 
non-64-bit-cmpxchg platforms. I'd not be surprised if some embedded platforms 
triggered this too.

	Ingo
