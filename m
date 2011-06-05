Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1FERVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:21:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59380 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab1FERVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:21:14 -0400
Date: Sun, 5 Jun 2011 19:20:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110605172052.GA1036@elte.hu>
References: <20110605133958.GA27812@elte.hu>
 <4DEB8A93.30601@die-jansens.de>
 <20110605141003.GB29338@elte.hu>
 <4DEB933C.1070900@die-jansens.de>
 <20110605151323.GA30590@elte.hu>
 <20110605152641.GA31124@elte.hu>
 <20110605153218.GA31471@elte.hu>
 <4DEBA9CC.4090503@die-jansens.de>
 <4DEBB05C.8090506@die-jansens.de>
 <4DEBB3DA.8060001@die-jansens.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEBB3DA.8060001@die-jansens.de>
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


* Arne Jansen <lists@die-jansens.de> wrote:

> >>>With the all-locks-printed output we can double check what locks are
> >>>held.
> 
> btw, the output posted earlier also contains some BUG: spinlock 
> lockup.

hm, it's hard to interpret that without the spin_lock()/unlock() 
logic keeping the dumps apart.

Was lockdep enabled as you started the test?

but ... if the lock is reasonably sorted then it's this one:

<0>BUG: spinlock lockup on CPU#3, modprobe/22211, ffffffff81e1c0c0
Pid: 22211, comm: modprobe Tainted: G        W   2.6.39-rc3+ #19
Call Trace:
 [<ffffffff813af306>] do_raw_spin_lock+0x156/0x170
 [<ffffffff8185ce71>] _raw_spin_lock+0x51/0x70
 [<ffffffff81092df6>] ? vprintk+0x76/0x4a0
 [<ffffffff81092df6>] vprintk+0x76/0x4a0
 [<ffffffff810c5f8d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff81859e19>] printk+0x63/0x65
 [<ffffffff813af301>] do_raw_spin_lock+0x151/0x170
 [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
 [<ffffffff8185ce71>] _raw_spin_lock+0x51/0x70
 [<ffffffff81092df6>] ? vprintk+0x76/0x4a0
 [<ffffffff81092df6>] vprintk+0x76/0x4a0
 [<ffffffff8108758b>] ? cpuacct_charge+0x9b/0xb0
 [<ffffffff8108750f>] ? cpuacct_charge+0x1f/0xb0
 [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
 [<ffffffff81859e19>] printk+0x63/0x65
 [<ffffffff813af090>] spin_bug+0x70/0xf0
 [<ffffffff813af2d9>] do_raw_spin_lock+0x129/0x170
 [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
 [<ffffffff8185ce71>] _raw_spin_lock+0x51/0x70
 [<ffffffff81092df6>] ? vprintk+0x76/0x4a0

and it occured before the lockup in the scheduler.

Which could be due to a race between disabling lockdep on one CPU and 
the scheduler doing the lock-held check on another CPU.

Do you get any messages after the assert is removed, during the test?

Thanks,

	Ingo
