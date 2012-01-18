Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2ARNgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:36:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35466 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab2ARNga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:36:30 -0500
Date: Wed, 18 Jan 2012 16:32:36 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
Message-ID: <20120118133236.GA3878@swordfish.minsk.epam.com>
References: <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com>
 <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
 <4F10BDF7.8030306@linux.vnet.ibm.com>
 <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
 <4F10EB5B.5060804@linux.vnet.ibm.com>
 <1326766892.16150.21.camel@sbsiddha-desk.sc.intel.com>
 <4F1544EA.5060907@linux.vnet.ibm.com>
 <1326856624.5291.20.camel@sbsiddha-mobl2>
 <4F16C60B.4030903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F16C60B.4030903@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/18/12 18:45), Srivatsa S. Bhat wrote:
> Date: Wed, 18 Jan 2012 18:45:55 +0530
> From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> 
> > On Tue, 2012-01-17 at 15:22 +0530, Srivatsa S. Bhat wrote:
> >> Thanks for the patch, but unfortunately it doesn't fix the problem!
> >> Exactly the same stack traces are seen during a CPU Hotplug stress test.
> >> (I didn't even have to stress it - it is so fragile that just a script
> >> to offline all cpus except the boot cpu was good enough to reproduce the
> >> problem easily.)
> > 
> > hmm, that's weird. with the patch, sched_ilb_notifier() should have
> > cleared the cpu going offline from the nohz.idle_cpus_mask. And this
> > should have happened after that cpu is removed from active mask. So
> > no-one else should add that cpu back to the nohz.idle_cpus_mask and this
> > should prevent the issue from happening.
> > 
Just a small note, since you're talking about removing CPU from nohz.idle_cpus_mask, 
that I'm able to reproduce this problem not only when offlining CPU, but during
onlininig as well (kernel 3.3):

[   67.587942] CPU1 is up
[   67.589710] Call Trace:
[   67.589719]  <IRQ>  [<ffffffff81030092>] warn_slowpath_common+0x7e/0x96
[   67.589745]  [<ffffffff810300bf>] warn_slowpath_null+0x15/0x17
[   67.589762]  [<ffffffff81018ff7>] native_smp_send_reschedule+0x25/0x56
[   67.589783]  [<ffffffff81067ffe>] trigger_load_balance+0x6ac/0x72e
[   67.589802]  [<ffffffff81067bfd>] ? trigger_load_balance+0x2ab/0x72e
[   67.589823]  [<ffffffff8105f05c>] scheduler_tick+0xe2/0xeb
[   67.589842]  [<ffffffff8103f6ac>] update_process_times+0x60/0x70
[   67.589863]  [<ffffffff8107c1e1>] tick_sched_timer+0x6d/0x96
[   67.589882]  [<ffffffff81053b3b>] __run_hrtimer+0x1c2/0x3a1
[   67.589900]  [<ffffffff8107c174>] ? tick_nohz_handler+0xdf/0xdf
[   67.589918]  [<ffffffff81054721>] hrtimer_interrupt+0xe6/0x1b0
[   67.589937]  [<ffffffff81019bdd>] smp_apic_timer_interrupt+0x80/0x93
[   67.589958]  [<ffffffff814a2f73>] apic_timer_interrupt+0x73/0x80
[   67.589975]  <EOI>  [<ffffffff81087bf1>] ? generic_exec_single+0x73/0x8a
[   67.590000]  [<ffffffff81087bea>] ? generic_exec_single+0x6c/0x8a
[   67.590019]  [<ffffffff81017f8b>] ? get_fixed_ranges.constprop.5+0x10b/0x10b
[   67.590039]  [<ffffffff81087d2c>] smp_call_function_single+0x124/0x15c
[   67.590059]  [<ffffffff81017f8b>] ? get_fixed_ranges.constprop.5+0x10b/0x10b
[   67.590081]  [<ffffffff8101696d>] mtrr_save_state+0x19/0x1b
[   67.590100]  [<ffffffff8148bf67>] native_cpu_up+0xa1/0x138
[   67.590117]  [<ffffffff8148d192>] _cpu_up+0x92/0xfc
[   67.590134]  [<ffffffff8147f3eb>] enable_nonboot_cpus+0x48/0xad
[   67.590154]  [<ffffffff8106f080>] suspend_devices_and_enter+0x21a/0x407
[   67.590173]  [<ffffffff8106f391>] enter_state+0x124/0x169
[   67.590191]  [<ffffffff8106e01b>] state_store+0xb7/0x101
[   67.590212]  [<ffffffff8126c82f>] kobj_attr_store+0x17/0x19
[   67.590230]  [<ffffffff8117e20c>] sysfs_write_file+0x103/0x13f
[   67.590249]  [<ffffffff8111f018>] vfs_write+0xad/0x13d
[   67.590266]  [<ffffffff8111f293>] sys_write+0x45/0x6c
[   67.590282]  [<ffffffff814a2439>] system_call_fastpath+0x16/0x1b


	Sergey

> > I could reproduce the problem easily with out the patch but when I
> > applied the patch I couldn't recreate the issue. Srivatsa, can you
> > please re-check the kernel you tested indeed has the fix?
> > 
> > re-Reviewing the code/patch also doesn't give me a hint.
> > 
> >> I have a few questions regarding the synchronization with CPU Hotplug.
> >> What guarantees that the code which selects and IPIs the new ilb is totally
> >> race-free with respect to CPU hotplug and we will never IPI an offline CPU?
> > 
> > So, nohz_balancer_kick() gets called only from interrupts disabled.
> > During that time (from selecting the ilb_cpu to sending the IPI), no cpu
> > can go offline. As the offline happens from the stop-machine process
> > context with interrupts disabled.
> > 
> > Only thing we need to make sure is the offlined cpu shouldn't be part of
> > the nohz.idle_cpus_mask and for post 3.2 code, posted patch ensures
> > that.
> > 
> > For 3.2 and before, when a cpu exits tickless idle, it gets removed from
> > the nohz.idle_cpus_mask (and also from the nohz.load_balancer). And if
> > the cpu is not in the active mask (while going offline), subsequent
> > calls to select_nohz_load_balancer() ensures that the cpu going down
> > doesn't update the nohz structures. So I thought 3.2 shouldn't exhibit
> > this problem.
> > 
> > 
> >> (As demonstrated above, this issue is in 3.2-rc7
> >> as well.)
> > 
> > hmm, don't think we ran into this before 3.2. So, what am I missing from
> > the above? I will try to reproduce it on 3.2 too.
> > 
> 
> 
> I tested again on 3.2. I didn't hit those warnings (IPI to offline cpus).
> It happens only in the post-3.2 kernel.
> 
> Regards,
> Srivatsa S. Bhat
> IBM Linux Technology Center
> 
