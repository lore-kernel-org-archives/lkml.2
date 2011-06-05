Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1FERm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:42:27 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:21651 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab1FERmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:42:25 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DEBBFF9.2030101@die-jansens.de>
Date: Sun, 05 Jun 2011 19:42:17 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <20110605133958.GA27812@elte.hu> <4DEB8A93.30601@die-jansens.de> <20110605141003.GB29338@elte.hu> <4DEB933C.1070900@die-jansens.de> <20110605151323.GA30590@elte.hu> <20110605152641.GA31124@elte.hu> <20110605153218.GA31471@elte.hu> <4DEBA9CC.4090503@die-jansens.de> <4DEBB05C.8090506@die-jansens.de> <4DEBB3DA.8060001@die-jansens.de> <20110605172052.GA1036@elte.hu>
In-Reply-To: <20110605172052.GA1036@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 19:20, Ingo Molnar wrote:
>
> * Arne Jansen<lists@die-jansens.de>  wrote:
>
>>>>> With the all-locks-printed output we can double check what locks are
>>>>> held.
>>
>> btw, the output posted earlier also contains some BUG: spinlock
>> lockup.
>
> hm, it's hard to interpret that without the spin_lock()/unlock()
> logic keeping the dumps apart.

The locking was in place from the beginning. As the output is still
scrambled, there are other sources for BUG/WARN outside the watchdog
that trigger in parallel. Maybe we should protect the whole BUG/WARN
mechanism with a lock and send it to early_printk from the beginning,
so we don't have to wait for the watchdog to kill printk off and the
first BUG can come through.
Or just let WARN/BUG kill off printk instead of the watchdog (though
I have to get rid of that syslog-WARN on startup).

>
> Was lockdep enabled as you started the test?

At least it was in the config, but haven't double checked. ATM, it is.

>
> but ... if the lock is reasonably sorted then it's this one:
>
> <0>BUG: spinlock lockup on CPU#3, modprobe/22211, ffffffff81e1c0c0
> Pid: 22211, comm: modprobe Tainted: G        W   2.6.39-rc3+ #19
> Call Trace:
>   [<ffffffff813af306>] do_raw_spin_lock+0x156/0x170
>   [<ffffffff8185ce71>] _raw_spin_lock+0x51/0x70
>   [<ffffffff81092df6>] ? vprintk+0x76/0x4a0
>   [<ffffffff81092df6>] vprintk+0x76/0x4a0
>   [<ffffffff810c5f8d>] ? trace_hardirqs_off+0xd/0x10
>   [<ffffffff81859e19>] printk+0x63/0x65
>   [<ffffffff813af301>] do_raw_spin_lock+0x151/0x170
>   [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
>   [<ffffffff8185ce71>] _raw_spin_lock+0x51/0x70
>   [<ffffffff81092df6>] ? vprintk+0x76/0x4a0
>   [<ffffffff81092df6>] vprintk+0x76/0x4a0
>   [<ffffffff8108758b>] ? cpuacct_charge+0x9b/0xb0
>   [<ffffffff8108750f>] ? cpuacct_charge+0x1f/0xb0
>   [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
>   [<ffffffff81859e19>] printk+0x63/0x65
>   [<ffffffff813af090>] spin_bug+0x70/0xf0
>   [<ffffffff813af2d9>] do_raw_spin_lock+0x129/0x170
>   [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
>   [<ffffffff8185ce71>] _raw_spin_lock+0x51/0x70
>   [<ffffffff81092df6>] ? vprintk+0x76/0x4a0
>
> and it occured before the lockup in the scheduler.
>
> Which could be due to a race between disabling lockdep on one CPU and
> the scheduler doing the lock-held check on another CPU.
>
> Do you get any messages after the assert is removed, during the test?

No.
