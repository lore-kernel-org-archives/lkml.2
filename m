Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1CVI7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:59:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55238 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1CVI71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:59:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=l6V7dPbWaI9FstOwZM8WP/lS6VAbIAsjXXT3/87TtCJ7+V83azt+7734HqQqvLCOtM
         MorRPr4twy44cq3YPM29iek6bgpWjUXc315dJXELQwTA7h7N1cahRgMg7KuTVr+sU+ah
         WyAssk7G9lHvpzj1bNW9U59ClK8vIvh1+Yeew=
MIME-Version: 1.0
Reply-To: ben@iagu.net
In-Reply-To: <1300777760.2837.38.camel@edumazet-laptop>
References: <AANLkTikZZ4MXZjx_+6u-vKVSgxULQo2BkQKRO6K_vzFy@mail.gmail.com>
	<20110318123031.GB6066@8bytes.org>
	<AANLkTin2k1ZSLa0NG6pKBvHYnKEV21t8pEqzeJWNn_rR@mail.gmail.com>
	<4D871F6C.40207@redhat.com>
	<AANLkTintxnKRQ4rD4Wo8_MHU4yJVzYaRhR=GjnDMGwNj@mail.gmail.com>
	<AANLkTin8ZoUAVR2ajoV6cBFiUSe_Dof0_k60dcAGW3r-@mail.gmail.com>
	<4D875842.9050308@redhat.com>
	<AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>
	<4D8773AA.8030408@redhat.com>
	<AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
	<1300726498.2884.493.camel@edumazet-laptop>
	<4D8784A9.8040303@redhat.com>
	<1300727545.2884.513.camel@edumazet-laptop>
	<AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
	<1300746429.2837.20.camel@edumazet-laptop>
	<1300777760.2837.38.camel@edumazet-laptop>
Date: Tue, 22 Mar 2011 14:44:27 +0545
X-Google-Sender-Auth: NkfxDVGMROVK9fmyFTrZyZJxg2U
Message-ID: <AANLkTik-Rt-Fy-2fKQTr2JBB9f7U2cbc0FmTZOoXc1+5@mail.gmail.com>
Subject: Re: [PATCH] posix-timers: RCU conversion
From: Ben Nagy <ben@iagu.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Richard Cochran <richard.cochran@omicron.at>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 12:54 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Ben Nagy reported a scalability problem with KVM/QEMU that hit very hard
> a single spinlock (idr_lock) in posix-timers code, on its 48 core
> machine.

Hi all,

Thanks a lot for all the help so far. We've tested with Eric's patch.

First up, here's our version of the patch for the current ubuntu
kernel from git:
http://paste.ubuntu.com/583668/

Here's top with 96 idle guests running:
op - 16:47:53 up  1:09,  3 users,  load average: 0.00, 0.01, 0.05
Tasks: 499 total,   3 running, 496 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.9%us,  3.2%sy,  0.0%ni, 95.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:  99068656k total, 13121096k used, 85947560k free,    22192k buffers
Swap:  2438140k total,        0k used,  2438140k free,  3597860k cached
 (much better!)

Start of perf top:

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   PerfTop:   10318 irqs/sec  kernel:97.4%  exact:  0.0% [1000Hz
cycles],  (all, 48 CPUs)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

             samples  pcnt function                    DSO
             _______ _____ ___________________________
___________________________________________________________

            95444.00 59.3% __ticket_spin_lock
[kernel.kallsyms]
            12937.00  8.0% native_safe_halt
[kernel.kallsyms]
             6149.00  3.8% kvm_get_cs_db_l_bits
/lib/modules/2.6.38-7-server/kernel/arch/x86/kvm/kvm.ko
             5105.00  3.2% tg_load_down
[kernel.kallsyms]
             5088.00  3.2% svm_vcpu_run
/lib/modules/2.6.38-7-server/kernel/arch/x86/kvm/kvm-amd.ko
             4807.00  3.0% kvm_set_pfn_dirty
/lib/modules/2.6.38-7-server/kernel/arch/x86/kvm/kvm.ko
             2855.00  1.8% ktime_get
[kernel.kallsyms]
             1535.00  1.0% find_busiest_group
[kernel.kallsyms]
             1386.00  0.9% find_next_bit
[kernel.kallsyms]


Start of perf report -g
    55.26%            kvm  [kernel.kallsyms]     [k] __ticket_spin_lock
                      |
                      --- __ticket_spin_lock
                         |
                         |--94.68%-- _raw_spin_lock
                         |          |
                         |          |--97.55%-- double_rq_lock
                         |          |          load_balance
                         |          |          idle_balance
                         |          |          schedule
                         |          |          |
                         |          |          |--60.56%--
schedule_hrtimeout_range_clock
                         |          |          |
schedule_hrtimeout_range
                         |          |          |          poll_schedule_timeout
                         |          |          |          do_select
                         |          |          |          core_sys_select
                         |          |          |          sys_select
                         |          |          |          system_call_fastpath


Here is the perf.data from the unpatched (non debug) kernel
http://www.coseinc.com/woigbfwr32/perf.data

Here is the perf.data from the patched (non debug) kernel
http://www.coseinc.com/woigbfwr32/perf_patched.data

I think we're certainly in 'it's going to be useable' territory now,
but any further improvements or patches to test would of course be
gratefully received! Next step from my end is to test the guests under
load, unless there are any other suggestions.

I'm extremely impressed by the speed and professionalism of the
response to this problem, both from those on #kvm and the widening
circle of those on this email thread.

Many thanks!

Cheers,

ben
