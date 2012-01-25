Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2AYQtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:49:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46513 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab2AYQtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:49:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAC9WiBgzg-dD5Sba9Cd_uvsfMxqQib+vsXXDyMSMSR_Y7P_CCw@mail.gmail.com>
References: <CAC9WiBgpBCWZVjAQkJWSpXhC_dK1KKPfAHZvxVgaLV8BUsc41Q@mail.gmail.com>
	<4F1FBAA9.4040405@broadcom.com>
	<CAC9WiBjpsLuJhzw+vZsPC2bA73mad444Gq32DRL_gCri2MqaMw@mail.gmail.com>
	<4F1FD2AA.9020708@broadcom.com>
	<CA+5PVA73WHfnurWiyY4w9f4_mw=vUdpaNmAavHZtt+xYfo8Kcw@mail.gmail.com>
	<CAC9WiBgzg-dD5Sba9Cd_uvsfMxqQib+vsXXDyMSMSR_Y7P_CCw@mail.gmail.com>
Date: Wed, 25 Jan 2012 11:49:12 -0500
Message-ID: <CA+5PVA4Cq5BRfKEa1uckVbtCGKhKmuw1tujQ19T3wk3c5CcsAQ@mail.gmail.com>
Subject: Re: kernel 3.2.1: BUG: scheduling while atomic: swapper/0/0/0x10000100
From: Josh Boyer <jwboyer@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 11:37 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> On Wed, Jan 25, 2012 at 1:11 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>
>> We've had a few similar issues reported in Fedora yesterday after we
>> rebased to 3.2.1.
>
> From which kernel did you rebase to 3.2.1 ?

Fedora 16 went from 3.1.9 to 3.2.1 earlier this week.  We hadn't been getting
reports like this until 3.2.1 showed up.  I asked one of the reporters to try
3.2.0 and they say it recreates there still, so it seems the issue showed up
with the 3.2 release.  One user managed to capture the trace below using a
kernel with a variety of debug options turned on.  It isn't the same backtrace
but it might be related.

backtrace:
:BUG: sleeping function called from invalid context at
drivers/base/power/runtime.c:785
:in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
:1 lock held by swapper/0/0:
: #0:  (&chip->rts51x_suspend_timer){+.-...}, at: [<ffffffff8108d711>]
run_timer_softirq+0x111/0x600
:Pid: 0, comm: swapper/0 Tainted: G        W    3.2.0-2.fc17.x86_64.debug #1
:Call Trace:
: <IRQ>  [<ffffffff8105ee7a>] __might_sleep+0x13a/0x1f0
: [<ffffffffa00180b0>] ? rts51x_modi_suspend_timer+0x50/0x50 [ums_realtek]
: [<ffffffff813fdee3>] __pm_runtime_idle+0xa3/0xb0
: [<ffffffffa00180b0>] ? rts51x_modi_suspend_timer+0x50/0x50 [ums_realtek]
: [<ffffffff8146ed30>] usb_autopm_put_interface+0x30/0x40
: [<ffffffffa0018125>] rts51x_suspend_timer_fn+0x75/0x80 [ums_realtek]
: [<ffffffff8108d7a6>] run_timer_softirq+0x1a6/0x600
: [<ffffffff8108d711>] ? run_timer_softirq+0x111/0x600
: [<ffffffff81084700>] __do_softirq+0xe0/0x370
: [<ffffffff8101fcc3>] ? native_sched_clock+0x13/0x80
: [<ffffffff8167f27c>] call_softirq+0x1c/0x30
: [<ffffffff8101a3e5>] do_softirq+0xa5/0xe0
: [<ffffffff81084d15>] irq_exit+0xe5/0xf0
: [<ffffffff8167fc3e>] smp_apic_timer_interrupt+0x6e/0x99
: [<ffffffff8167daf3>] apic_timer_interrupt+0x73/0x80
: <EOI>  [<ffffffff8101fd39>] ? sched_clock+0x9/0x10
: [<ffffffff81363f9b>] ? intel_idle+0xfb/0x160
: [<ffffffff81363f97>] ? intel_idle+0xf7/0x160
: [<ffffffff814fa7f3>] cpuidle_idle_call+0xb3/0x520
: [<ffffffff81017265>] cpu_idle+0xe5/0x130
: [<ffffffff8164aff3>] rest_init+0xd7/0xe4
: [<ffffffff8164af1c>] ? csum_partial_copy_generic+0x16c/0x16c
: [<ffffffff81f60c39>] start_kernel+0x3ec/0x3f9
: [<ffffffff81f60347>] x86_64_start_reservations+0x132/0x136
: [<ffffffff81f6044b>] x86_64_start_kernel+0x100/0x10f

Not sure if that is a common trend yet or not.

josh

https://bugzilla.redhat.com/show_bug.cgi?id=784345
https://bugzilla.redhat.com/show_bug.cgi?id=784414
