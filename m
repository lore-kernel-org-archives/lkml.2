Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab2ASQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:16:56 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63509 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab2ASQQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:16:50 -0500
MIME-Version: 1.0
In-Reply-To: <1326848525.17534.66.camel@gandalf.stny.rr.com>
References: <CAONaPpFjfGiKKGAzrQNk+MF4k50nRf+wMU8H9491NgHyJrUkyw@mail.gmail.com>
	<201201180053.52617.fzuuzf@googlemail.com>
	<1326848525.17534.66.camel@gandalf.stny.rr.com>
Date: Thu, 19 Jan 2012 17:16:49 +0100
X-Google-Sender-Auth: tpUKDPCDSGaaAT1gboezLrIpTeE
Message-ID: <CAONaPpGHULxDZXBTprkCy9vKPH46gHOiQs6GM_ysfP2znDqqXg@mail.gmail.com>
Subject: Re: rt-kernel 3.0.14-rt31: BUG: sleeping function called from invalid context
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Karsten Wiese <fzuuzf@googlemail.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 2:02 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-01-18 at 00:53 +0100, Karsten Wiese wrote:
>
>> The bug happens because acpi_ev_gpe_detect does
>> raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags) before it calls
>> acpi_ev_gpe_dispatch.
>
> Correct. I believe there's a fix in the 3.2-rt. I'm working on getting
> the updates from it to the stable tree.

I'm testing v3.0.14-rt32-rc1, and it greatly reduced the number of
these, but I still got one during boot.

[   11.938649] BUG: sleeping function called from invalid context at
/home/jkacur/rt.linux.git/kernel/rtmutex.c:645
[   11.938651] in_atomic(): 1, irqs_disabled(): 1, pid: 168, name: irq/9-acpi
[   11.938653] 1 lock held by irq/9-acpi/168:
[   11.938653]  #0:  (acpi_gbl_gpe_lock){......}, at:
[<ffffffff8123881d>] acpi_ev_gpe_detect+0x31/0x110
[   11.938661] irq event stamp: 1148
[   11.938662] hardirqs last  enabled at (1147): [<ffffffff813e4731>]
_raw_spin_unlock_irq+0x30/0x5e
[   11.938667] hardirqs last disabled at (1148): [<ffffffff813e4524>]
_raw_spin_lock_irqsave+0x1e/0x85
[   11.938669] softirqs last  enabled at (0): [<ffffffff81041c88>]
copy_process+0x517/0xfbd
[   11.938673] softirqs last disabled at (0): [<          (null)>]
      (null)
[   11.938676] Pid: 168, comm: irq/9-acpi Not tainted
3.0.14-rt32-rc1-debug-00323-ga86a4da #1
[   11.938677] Call Trace:
[   11.938681]  [<ffffffff81037b06>] __might_sleep+0xf4/0xf9
[   11.938684]  [<ffffffff8107e6b1>] rt_spin_lock_fastlock.clone.0+0x24/0x31
[   11.938687]  [<ffffffff813e3cb3>] rt_spin_lock+0x16/0x40
[   11.938690]  [<ffffffff8107574c>] ? trace_hardirqs_off_caller+0x1f/0x99
[   11.938694]  [<ffffffff8111ac19>] __local_lock_irq+0x29/0x7c
[   11.938696]  [<ffffffff8111ac8c>] __local_lock_irqsave+0x20/0x31
[   11.938698]  [<ffffffff8111dfc1>] kmem_cache_alloc_trace+0x5f/0x14f
[   11.938701]  [<ffffffff81238683>] ? acpi_os_allocate_zeroed+0x2d/0x2d
[   11.938704]  [<ffffffff81227831>] __acpi_os_execute+0x38/0x143
[   11.938706]  [<ffffffff81227969>] acpi_os_execute+0x10/0x12
[   11.938708]  [<ffffffff812385e5>] acpi_ev_gpe_dispatch+0xdf/0x12e
[   11.938710]  [<ffffffff812388a7>] acpi_ev_gpe_detect+0xbb/0x110
[   11.938713]  [<ffffffff81237008>] acpi_ev_sci_xrupt_handler+0x22/0x2b
[   11.938715]  [<ffffffff8122700e>] acpi_irq+0x16/0x31
[   11.938719]  [<ffffffff810ade67>] irq_forced_thread_fn+0x25/0x45
[   11.938721]  [<ffffffff813e4751>] ? _raw_spin_unlock_irq+0x50/0x5e
[   11.938723]  [<ffffffff810adcaa>] irq_thread+0xff/0x1e9
[   11.938725]  [<ffffffff810ade42>] ? exit_irq_thread+0x74/0x74
[   11.938727]  [<ffffffff810adbab>] ? irq_finalize_oneshot+0xaf/0xaf
[   11.938730]  [<ffffffff810adbab>] ? irq_finalize_oneshot+0xaf/0xaf
[   11.938733]  [<ffffffff81062b48>] kthread+0x94/0x9c
[   11.938735]  [<ffffffff813e7633>] ? sub_preempt_count+0xa3/0xb6
[   11.938738]  [<ffffffff813e4751>] ? _raw_spin_unlock_irq+0x50/0x5e
[   11.938741]  [<ffffffff813ebcd4>] kernel_thread_helper+0x4/0x10
[   11.938744]  [<ffffffff8103bec0>] ? finish_task_switch+0x85/0xe2
[   11.938746]  [<ffffffff813e4b04>] ? retint_restore_args+0xe/0xe
[   11.938749]  [<ffffffff81062ab4>] ? kthreadd+0x168/0x168
[   11.938751]  [<ffffffff813ebcd0>] ? gs_change+0xb/0xb
