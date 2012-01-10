Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2AJGAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 01:00:03 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53074 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2AJGAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 01:00:00 -0500
MIME-Version: 1.0
In-Reply-To: <CADDb1s2-Tsnns8qndpbS79cPAw2X_ORXqMsqWR=AuBoLCDneMg@mail.gmail.com>
References: <CAH9JG2XniMv5dVf1DixGNaQAJk-sZjnV9HfYeihEJP3JDyC4+Q@mail.gmail.com>
	<CADDb1s2-Tsnns8qndpbS79cPAw2X_ORXqMsqWR=AuBoLCDneMg@mail.gmail.com>
Date: Tue, 10 Jan 2012 14:59:59 +0900
X-Google-Sender-Auth: RRDmUXJzAuPl-hyfldhzQElO7AY
Message-ID: <CAH9JG2XKo+5kkdh3kjhvO2yiFXgZnbNMp1qkZjSrGX0tb1BvzA@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at include/linux/freezer.h:45
From: Kyungmin Park <kmpark@infradead.org>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/12, Amit Sahrawat <amit.sahrawat83@gmail.com> wrote:
> On Tue, Jan 10, 2012 at 9:57 AM, Kyungmin Park <kmpark@infradead.org> wrote:
>> Dear all
>>
>> with the latest kernel. I got the below bug message.
>> It calls the sleep function. Does it intended operation?
>>
>> static inline bool try_to_freeze(void)
>> {
>>        might_sleep();
>>        if (likely(!freezing(current)))
>>                return false;
>>        return __refrigerator(false);
>> }
> this change is part of this GIT:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=a0acae0e886d44bd5ce6d2f173c1ace0fcf0d9f6
>
>>
>> # poweroff
>> [    6.852523] BUG: sleeping function called from invalid context at
>> include/linux/freezer.h:45
>> [    6.859489] in_atomic(): 0, irqs_disabled(): 128, pid: 1, name: init
>> [    6.865846] [<c0013508>] (unwind_backtrace+0x0/0xec) from
>> [<c0010124>] (do_signal+0x88/0x588)
>> [    6.874337] [<c0010124>] (do_signal+0x88/0x588) from [<c001063c>]
>> (do_notify_resume+0x18/0x38)
>> [    6.882928] [<c001063c>] (do_notify_resume+0x18/0x38) from
>> [<c000dc18>] (work_pending+0x24/0x28)
> is this the complete backtrace...?
yes
> The above backtrace shows that freezing was called from a context
> wherein - IRQs are disabled - which resulted in this error.
> How about checking ...
> BUG_ON(irqs_disabled()); in try_to_freeze()...
> not sure though... please check and update me also...
Here's update trace with BUG_ON(irqs_disabled())

# poweroff
[    8.147056] ------------[ cut here ]------------
[    8.150205] kernel BUG at include/linux/freezer.h:45!
[    8.155236] Internal error: Oops - undefined instruction: 0 [#1] PREEMPT SMP
[    8.162266] Modules linked in:
[    8.165306] CPU: 1    Not tainted  (3.2.0+ #97)
[    8.169830] PC is at do_signal+0x84/0x598
[    8.173814] LR is at do_notify_resume+0x18/0x38
[    8.178327] pc : [<c0010120>]    lr : [<c001064c>]    psr: 20000093
[    8.178333] sp : df849ed0  ip : 00100100  fp : 00000000
[    8.189781] r10: b6cd089c  r9 : df848000  r8 : 00000000
[    8.194991] r7 : c000dd44  r6 : fffffe00  r5 : b6cd08a0  r4 : df849fb0
[    8.201500] r3 : ffffffff  r2 : 00000080  r1 : c000dd44  r0 : df849fb0
[    8.208011] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment use
r
[    8.215215] Control: 10c53c7d  Table: 5f9c004a  DAC: 00000015
[    8.220945] Process init (pid: 1, stack limit = 0xdf8482f0)
[    8.226498] Stack: (0xdf849ed0 to 0xdf84a000)
[    8.230840] 9ec0:                                     df848000 00000000 00000
000 c0042b18
[    8.239001] 9ee0: df849f30 c0269028 0000c350 00000001 bee6fc08 df849f30 0000c
350 0000c350
[    8.247161] 9f00: 00000000 3b9aca00 00000001 df84a00c 00000001 00000001 df849
f2c c004bc18
[    8.255320] 9f20: df849f60 df848000 00000000 c026aa60 df849f60 c0025890 df849
f60 df844168
[    8.263478] 9f40: 00000004 00000003 00000000 00000000 00000000 df848000 00000
000 c0025960
[    8.271637] 9f60: 00000003 00000004 00000000 00000000 00000000 00000000 00000
000 df844000
[    8.279797] 9f80: c0024468 00000001 00000000 00000000 00000072 00000000 df848
000 00000000
[    8.287956] 9fa0: 00000000 c001064c b6f0fa88 c000dc18 ffffffff 00000000 00000
000 00000000
[    8.296115] 9fc0: b6f0fa88 00000000 00000000 00000072 ffffffff 00000000 00000
2fe 00000000
[    8.304275] 9fe0: b6d73000 bee6fc18 b6ed2c8c b6cd089c 60000010 ffffffff fffff
fff ffffffff
[    8.312442] [<c0010120>] (do_signal+0x84/0x598) from [<c001064c>] (do_notify_
resume+0x18/0x38)
[    8.321032] [<c001064c>] (do_notify_resume+0x18/0x38) from [<c000dc18>] (work
_pending+0x24/0x28)
[    8.329795] Code: e5843000 e10f2000 e2122080 0a000001 (e7f001f2)
[    8.335894] ---[ end trace 036b1d3292ef9478 ]---
# [    8.340671] Kernel panic - not syncing: Attempted to kill init!
[    8.346579] [<c0013508>] (unwind_backtrace+0x0/0xec) from [<c0267eac>] (panic
+0x5c/0x1a0)
[    8.354724] [<c0267eac>] (panic+0x5c/0x1a0) from [<c0025b54>] (do_exit+0xa0/0
x6d4)
[    8.362279] [<c0025b54>] (do_exit+0xa0/0x6d4) from [<c0011534>] (die+0x1c4/0x
1f0)
[    8.369735] [<c0011534>] (die+0x1c4/0x1f0) from [<c0008368>] (do_undefinstr+0
x164/0x188)
[    8.377806] [<c0008368>] (do_undefinstr+0x164/0x188) from [<c000d868>] (__und
_svc+0x48/0x60)
[    8.386221] Exception stack(0xdf849e88 to 0xdf849ed0)
[    8.391256] 9e80:                   df849fb0 c000dd44 00000080 ffffffff df849
fb0 b6cd08a0
[    8.399416] 9ea0: fffffe00 c000dd44 00000000 df848000 b6cd089c 00000000 00100
100 df849ed0
[    8.407571] 9ec0: c001064c c0010120 20000093 ffffffff
[    8.412612] [<c000d868>] (__und_svc+0x48/0x60) from [<c0010120>] (do_signal+0
x84/0x598)
[    8.420598] [<c0010120>] (do_signal+0x84/0x598) from [<c001064c>] (do_notify_
resume+0x18/0x38)
[    8.429190] [<c001064c>] (do_notify_resume+0x18/0x38) from [<c000dc18>] (work
_pending+0x24/0x28)
[    8.437952] CPU0: stopping
[    8.440645] [<c0013508>] (unwind_backtrace+0x0/0xec) from [<c0012524>] (handl
e_IPI+0xec/0x168)
[    8.449234] [<c0012524>] (handle_IPI+0xec/0x168) from [<c0008558>] (gic_handl
e_irq+0xa0/0xac)
[    8.457740] [<c0008558>] (gic_handle_irq+0xa0/0xac) from [<c000d7c0>] (__irq_
svc+0x40/0x70)
[    8.466066] Exception stack(0xc036df40 to 0xc036df88)
[    8.471106] df40: 0006542c 00001f40 00000008 18b8ce13 c0801318 00000000 c036c
000 c03859d4
[    8.479264] df60: c03a6538 412fc091 00000000 00000000 18b8cdfb c036df88 c0058
f6c c001da9c
[    8.487419] df80: 20000013 ffffffff
[    8.490904] [<c000d7c0>] (__irq_svc+0x40/0x70) from [<c001da9c>] (exynos4_ent
er_idle+0x2c/0x5c)
[    8.499583] [<c001da9c>] (exynos4_enter_idle+0x2c/0x5c) from [<c021c3e4>] (cp
uidle_idle_call+0x1a0/0x340)
[    8.509128] [<c021c3e4>] (cpuidle_idle_call+0x1a0/0x340) from [<c000ed24>] (c
pu_idle+0x74/0xe0)
[    8.517810] [<c000ed24>] (cpu_idle+0x74/0xe0) from [<c034a858>] (start_kernel
+0x32c/0x384)
[    8.526049] Rebooting in 1 seconds..
>>
>> commit e4e11180dfa545233e5145919b75b7fac88638df
>> Merge: 37cfc3f adc0e91
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Mon Jan 9 17:37:37 2012 -0800
>>
>>    Merge branch 'for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/vi
>>
>> Thank you,
>> Kyungmin Park
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
