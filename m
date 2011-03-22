Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1CVKgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:36:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1CVKgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:36:14 -0400
Message-ID: <4D887B6A.2020102@redhat.com>
Date: Tue, 22 Mar 2011 12:35:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: ben@iagu.net
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] posix-timers: RCU conversion
References: <AANLkTikZZ4MXZjx_+6u-vKVSgxULQo2BkQKRO6K_vzFy@mail.gmail.com>	<20110318123031.GB6066@8bytes.org>	<AANLkTin2k1ZSLa0NG6pKBvHYnKEV21t8pEqzeJWNn_rR@mail.gmail.com>	<4D871F6C.40207@redhat.com>	<AANLkTintxnKRQ4rD4Wo8_MHU4yJVzYaRhR=GjnDMGwNj@mail.gmail.com>	<AANLkTin8ZoUAVR2ajoV6cBFiUSe_Dof0_k60dcAGW3r-@mail.gmail.com>	<4D875842.9050308@redhat.com>	<AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>	<4D8773AA.8030408@redhat.com>	<AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>	<1300726498.2884.493.camel@edumazet-laptop>	<4D8784A9.8040303@redhat.com>	<1300727545.2884.513.camel@edumazet-laptop>	<AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>	<1300746429.2837.20.camel@edumazet-laptop>	<1300777760.2837.38.camel@edumazet-laptop> <AANLkTik-Rt-Fy-2fKQTr2JBB9f7U2cbc0FmTZOoXc1+5@mail.gmail.com>
In-Reply-To: <AANLkTik-Rt-Fy-2fKQTr2JBB9f7U2cbc0FmTZOoXc1+5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 10:59 AM, Ben Nagy wrote:
> On Tue, Mar 22, 2011 at 12:54 PM, Eric Dumazet<eric.dumazet@gmail.com>  wrote:
> >  Ben Nagy reported a scalability problem with KVM/QEMU that hit very hard
> >  a single spinlock (idr_lock) in posix-timers code, on its 48 core
> >  machine.
>
> Hi all,
>
> Thanks a lot for all the help so far. We've tested with Eric's patch.
>
> First up, here's our version of the patch for the current ubuntu
> kernel from git:
> http://paste.ubuntu.com/583668/
>
> Here's top with 96 idle guests running:
> op - 16:47:53 up  1:09,  3 users,  load average: 0.00, 0.01, 0.05
> Tasks: 499 total,   3 running, 496 sleeping,   0 stopped,   0 zombie
> Cpu(s):  1.9%us,  3.2%sy,  0.0%ni, 95.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:  99068656k total, 13121096k used, 85947560k free,    22192k buffers
> Swap:  2438140k total,        0k used,  2438140k free,  3597860k cached
>   (much better!)
>
> Start of perf top:
>
> ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>     PerfTop:   10318 irqs/sec  kernel:97.4%  exact:  0.0% [1000Hz
> cycles],  (all, 48 CPUs)
> ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>
>               samples  pcnt function                    DSO
>               _______ _____ ___________________________
> ___________________________________________________________
>
>              95444.00 59.3% __ticket_spin_lock
> [kernel.kallsyms]
>              12937.00  8.0% native_safe_halt
> [kernel.kallsyms]
>               6149.00  3.8% kvm_get_cs_db_l_bits
> /lib/modules/2.6.38-7-server/kernel/arch/x86/kvm/kvm.ko
>               5105.00  3.2% tg_load_down
> [kernel.kallsyms]
>               5088.00  3.2% svm_vcpu_run
> /lib/modules/2.6.38-7-server/kernel/arch/x86/kvm/kvm-amd.ko
>               4807.00  3.0% kvm_set_pfn_dirty
> /lib/modules/2.6.38-7-server/kernel/arch/x86/kvm/kvm.ko
>               2855.00  1.8% ktime_get
> [kernel.kallsyms]
>               1535.00  1.0% find_busiest_group
> [kernel.kallsyms]
>               1386.00  0.9% find_next_bit
> [kernel.kallsyms]
>
>
> Start of perf report -g
>      55.26%            kvm  [kernel.kallsyms]     [k] __ticket_spin_lock
>                        |
>                        --- __ticket_spin_lock
>                           |
>                           |--94.68%-- _raw_spin_lock
>                           |          |
>                           |          |--97.55%-- double_rq_lock
>                           |          |          load_balance
>                           |          |          idle_balance
>                           |          |          schedule
>                           |          |          |
>                           |          |          |--60.56%--
> schedule_hrtimeout_range_clock
>                           |          |          |
> schedule_hrtimeout_range
>                           |          |          |          poll_schedule_timeout
>                           |          |          |          do_select
>                           |          |          |          core_sys_select
>                           |          |          |          sys_select
>                           |          |          |          system_call_fastpath
>
>

Looks like the posix-timer issue is completely gone, to be replaced by 
the load balancer.

Copying peterz.

-- 
error compiling committee.c: too many arguments to function

