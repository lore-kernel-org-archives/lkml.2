Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab2AKGfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 01:35:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40835 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964Ab2AKGfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 01:35:20 -0500
Message-ID: <4F0D2D9B.8030501@gmail.com>
Date: Tue, 10 Jan 2012 23:35:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [BUG] kernel freezes with latest tree
References: <1326171444.6638.3.camel@edumazet-laptop> <1326171798.6638.4.camel@edumazet-laptop> <1326183371.6638.6.camel@edumazet-laptop> <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com> <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com> <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com> <1326234230.2614.15.camel@edumazet-laptop> <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
In-Reply-To: <CA+55aFwYmX7q4MZc-xOStZB2ZQjVt_Jca6qDP+0cPKekz8yL+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/10/2012 04:44 PM, Linus Torvalds wrote:
> Anybody? Any ideas? Clearly there can be a merge problem that doesn't
> actually show as a real data conflict, just some semantic conflict,
> but I don't see what such issues would be brouht in by the scheduler
> merge anyway.

This is really easy to reproduce in a KVM hosted VM.

Using the gdb stub one cpu is spinning here:

(gdb) bt
#0  try_to_wake_up (p=0xf529b200, state=<optimized out>, wake_flags=1)
    at /mnt/sw/kernel-2.6.git/kernel/sched/core.c:1575
#1  0xc0470ab0 in default_wake_function (curr=<optimized out>,
mode=<optimized out>,
    wake_flags=<optimized out>, key=0xc3) at
/mnt/sw/kernel-2.6.git/kernel/sched/core.c:3364

So basically:
    while (p->on_cpu) {
...
        cpu_relax();
    }


And the other vcpu is here:

#0  tg_load_down (tg=0xf55b9c00, data=<optimized out>) at
/mnt/sw/kernel-2.6.git/kernel/sched/fair.c:3351
#1  0xc0470049 in walk_tg_tree_from (from=0xc0ba5400, down=0xc04753c0
<tg_load_down>, up=0xc046a3b0 <tg_nop>,
    data=0x0) at /mnt/sw/kernel-2.6.git/kernel/sched/core.c:664
#2  0xc04793f7 in walk_tg_tree (data=<optimized out>, up=<optimized
out>, down=0xc04753c0 <tg_load_down>)
    at /mnt/sw/kernel-2.6.git/kernel/sched/sched.h:175
#3  update_h_load (cpu=<optimized out>) at
/mnt/sw/kernel-2.6.git/kernel/sched/fair.c:3361
#4  load_balance_fair (lb_flags=<synthetic pointer>,
idle=CPU_NEWLY_IDLE, sd=0xf5c30800, max_load_move=278,
    busiest=0xf6607d00, this_cpu=1, this_rq=0xf6707d00) at
/mnt/sw/kernel-2.6.git/kernel/sched/fair.c:3374
#5  move_tasks (lb_flags=<synthetic pointer>, idle=CPU_NEWLY_IDLE,
sd=0xf5c30800, max_load_move=278,
    busiest=<optimized out>, this_cpu=1, this_rq=0xf6707d00)
    at /mnt/sw/kernel-2.6.git/kernel/sched/fair.c:3444
#6  load_balance (this_cpu=1, this_rq=0xf6707d00, sd=0xf5c30800,
idle=CPU_NEWLY_IDLE, balance=0xf5217cb4)
    at /mnt/sw/kernel-2.6.git/kernel/sched/fair.c:4496
#7  0xc0479be2 in idle_balance (this_cpu=1, this_rq=0xf6707d00)
    at /mnt/sw/kernel-2.6.git/kernel/sched/fair.c:4640


Based on the file in question (sched/fair.c) I took a stab at guessing
the commit: without a195f004 I was not able to lock it up. With the
patch the VM spins after a few hackbench iterations.

I don't have time for a proper bisect tonight. I can do that in the a.m.
if I am not totally off base here. Peter: any chance this commit could
explain the spinning cpus / system freeze?

David
