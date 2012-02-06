Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab2BFUot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:44:49 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47814 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754989Ab2BFUor convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:44:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120206154700.GA13478@elte.hu>
References: <CABPqkBTutb5TuNVXZ4o+MzXczVSwk3NtsJh73KZS58xmrd=tbg@mail.gmail.com>
	<20120204135110.GA6437@elte.hu>
	<CABPqkBTvoNBBdzvS-njoFk+SrTf-BKQSvP54C05un+m7RA+nBg@mail.gmail.com>
	<CABPqkBQdRwKKAvgK339Po0-WBW-MJkgcmpWqS=OOgepn3_XiRw@mail.gmail.com>
	<1328523130.2220.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBQLn+5fYtOjhpKjXSzvKesuo+YRXxaawyTGUTQuZ6AjYw@mail.gmail.com>
	<1328526691.2220.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CABPqkBQnDToQczbgW4dCXiu3x2ZTXjAuKS_q_hJ=28Pu_2HexQ@mail.gmail.com>
	<20120206143844.GA23807@elte.hu>
	<CABPqkBR2nydKxU91NUaoKSUX2w+hN4ZFCi1khHPvMLB+Rid33A@mail.gmail.com>
	<20120206154700.GA13478@elte.hu>
Date: Mon, 6 Feb 2012 21:44:45 +0100
Message-ID: <CABPqkBQPYvEu58TDPwDNV-ydpooe-yY924w4FnsEiK9DKEdJ2Q@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I fixed the problem this time but in further testing I uncovered
another issue:


while true; do perf record -a -g hackbench 10 thread 4000; done &
while true; do perf record -a -g hackbench 10 thread 4000; done &

We hit:

[  765.034354] WARNING: at arch/x86/kernel/cpu/perf_event_intel.c:1029
intel_pmu_handle_irq+0x1df/0x2c0()
[  765.034356] Hardware name: System Product Name
[  765.034358] Modules linked in: binfmt_misc psmouse serio_raw
asus_atk0110 usbhid hid ahci pata_jmicron libahci r8169
[  765.034369] Pid: 8903, comm: hackbench Tainted: G        W
3.3.0-rc2-tip #35
[  765.034371] Call Trace:
[  765.034373]  <NMI>  [<ffffffff8104c15f>] warn_slowpath_common+0x7f/0xc0
[  765.034381]  [<ffffffff8104c1ba>] warn_slowpath_null+0x1a/0x20
[  765.034384]  [<ffffffff81027a0f>] intel_pmu_handle_irq+0x1df/0x2c0
[  765.034388]  [<ffffffff8148a606>] ? sock_aio_write+0x6/0x170
[  765.034392]  [<ffffffff81559171>] perf_event_nmi_handler+0x21/0x30
[  765.034395]  [<ffffffff81558a29>] do_nmi+0x129/0x3a0
[  765.034398]  [<ffffffff81557f7d>] restart_nmi+0x1a/0x1e
[  765.034402]  [<ffffffff8103abea>] ? native_write_msr_safe+0xa/0x10
[  765.034405]  [<ffffffff8103abea>] ? native_write_msr_safe+0xa/0x10
[  765.034408]  [<ffffffff8103abea>] ? native_write_msr_safe+0xa/0x10
[  765.034410]  <<EOE>>  <IRQ>  [<ffffffff81027447>]
intel_pmu_disable_event+0x87/0x100
[  765.034416]  [<ffffffff81022a16>] x86_pmu_stop+0x86/0xe0
[  765.034420]  [<ffffffff8110bc3b>]
perf_adjust_freq_unthr_context.part.67+0xeb/0x180
[  765.034423]  [<ffffffff8110bf50>] perf_event_task_tick+0x280/0x300
[  765.034427]  [<ffffffff8107f36f>] scheduler_tick+0xdf/0x150
[  765.034431]  [<ffffffff8105d66e>] update_process_times+0x6e/0x90
[  765.034435]  [<ffffffff810a0a34>] tick_sched_timer+0x64/0xc0
[  765.034438]  [<ffffffff81073286>] __run_hrtimer+0x76/0x1f0
[  765.034441]  [<ffffffff810a09d0>] ? tick_nohz_handler+0xf0/0xf0
[  765.034447]  [<ffffffff8101a3b9>] ? read_tsc+0x9/0x20
[  765.034450]  [<ffffffff81073b93>] hrtimer_interrupt+0xe3/0x200
[  765.034454]  [<ffffffff81560bdc>] ? call_softirq+0x1c/0x30
[  765.034457]  [<ffffffff81561529>] smp_apic_timer_interrupt+0x69/0x99
[  765.034461]  [<ffffffff815601de>] apic_timer_interrupt+0x6e/0x80
[  765.034462]  <EOI>  [<ffffffff811af082>] ? fsnotify+0x1d2/0x2b0
[  765.034470]  [<ffffffff81171085>] ? rw_verify_area+0x75/0xf0
[  765.034473]  [<ffffffff81171071>] ? rw_verify_area+0x61/0xf0
[  765.034475]  [<ffffffff811713a8>] vfs_write+0x88/0x180
[  765.034478]  [<ffffffff811716fa>] sys_write+0x4a/0x90
[  765.034481]  [<ffffffff8155f729>] system_call_fastpath+0x16/0x1b


Which is pointing to the Intel specific:

intel_pmu_handle_irq()
again:
        intel_pmu_ack_status(status);
        if (++loops > 100) {
                WARN_ONCE(1, "perfevents: irq loop stuck!\n");
                perf_event_print_debug();
                intel_pmu_reset();
                goto done;
        }

We are in a constant interrupt loop for a reason I don't yet understand.
Sure we have two counters going, bu given the callstack, one is being
stopped.

I know we talked about that a couple of weeks back, but after all, it may
be that it is not possible to run the frequency adjustment code without
stopping the entire PMU because of risk of interrupts. But it is not clear
to me what's causing this at this point.

I suggest we still apply my patch to fix the x86_pmu_start() first, then
I will submit a second patch to fix that one. Agreed?

On Mon, Feb 6, 2012 at 4:47 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Mon, Feb 6, 2012 at 3:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Stephane Eranian <eranian@google.com> wrote:
>> >
>> >> Ok, I found the problem!
>> >>
>> >> it comes from perf_adjust_freq_unthr_context() vs perf_adjust_period().
>> >> The latter can under certain condition stop and restart the event. So we
>> >> had:
>> >>
>> >>       stop()
>> >>       if (delta > 0) {
>> >>            perf_adjust_period() {
>> >>                if (period > 8*...) {
>> >>                    stop()
>> >>                    ...
>> >>                    start()
>> >>                }
>> >>            }
>> >>        }
>> >>        start()
>> >>
>> >> Could have a double stop() and double start(), thus triggering the warning in
>> >> x86_pmu_start().
>> >>
>> >> Will post a patch shortly to fix this.
>> >
>> > Please send a patch against tip:master (or perf/urgent), on top
>> > of:
>> >
>> >  84f2b9b2edc0: perf: Remove deprecated WARN_ON_ONCE()
>> >
>> > Note that I updated that patch to removed one more WARN_ON()
>> > than you originally sent - please add it back as appropriate, in
>> > the delta fix patch.
>> >
>> I have already added the warning back. Will send against tip:master
>
> Great - thanks!
>
>        Ingo
