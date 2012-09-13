Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2IMGgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:36:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61545 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab2IMGgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:36:39 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120913060412.GB5085@bbox>
References: <CA+icZUVEQNPGL7_BbLA-urgP6rFvdOh0SUtYESUv6ZJc+w78Nw@mail.gmail.com>
	<CA+icZUXqzV=YFjHT=5QxUf1_WHwS1-DhuXkhN8QAhn1t9+-PYA@mail.gmail.com>
	<20120913060412.GB5085@bbox>
Date: Thu, 13 Sep 2012 08:36:36 +0200
Message-ID: <CA+icZUUF=vTwSoNrs-+F08H7LAO0RUwztJ3M1_iyNR28TsrFMw@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 12 (kernel-panic after pressing any key
 at X login)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Ping Cheng <pingc@wacom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 8:04 AM, Minchan Kim <minchan@kernel.org> wrote:
> On Thu, Sep 13, 2012 at 07:29:32AM +0200, Sedat Dilek wrote:
>> On Thu, Sep 13, 2012 at 5:18 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> > On Wed, Sep 12, 2012 at 10:46 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >> Hi all,
>> >>
>> >> Changes since 201209011:
>> >>
>> >> The pci tree lost its build failure.
>> >>
>> >> The mfd tree gained a conflict against Linus' tree.
>> >>
>> >> The omap_dss2 tree lost its conflict.
>> >>
>> >> The trivial tree gained a conflict against the mfd tree.
>> >>
>> >> The kvm tree gained a conflict against Linus' tree.
>> >>
>> >> The workqueues tree gained a conflict against the omap_dss2 tree.
>> >>
>> >> The usb tree gained conflicts against the usb.current tree.
>> >>
>> >> The staging tree gained a conflict against the thermal tree and a build
>> >> failure for which I applied a merge fix patch.
>> >>
>> >> The tegra tree gained conflicts against the usb and arm-perf trees.
>> >>
>> >> ----------------------------------------------------------------------------
>> >>
>> >
>> > Hi,
>> >
>> > this weeks linux-next seems to bring new and new issues, yay :-)!
>> >
>> > I have taken a photo, but can't say what can have caused.
>> > The issue is reproducible...
>> > Immediately, after pressing any key (when X-display-manager (lightdm)
>> > and X-greeter are up) my machine panics and is no more usable (cold
>> > rough brutal killer restart).
>> > Note: Using upstart or systemd does not matter.
>> >
>> > Any pointer to an area where to dig into or any feedback in general is welcome!
>> >
>> > Kind Regards,
>> > - Sedat -
>>
>> [ CC Dmitry Torokhov (linux-input maintainer) plus linux-input ML ]
>>
>> By looking at my screenshot, someone could imagine that there is a
>> problem coming from the input GIT branch(es) merges:
>>
>> input_to_handler()
>> input_pass_values()
>> input_handle_event()
>> input_event()
>>
>> Unfortunately, with those 3 revert-patches I see the same kernel-panic.
>>
>> Dimitry, any idea what can cause this kernel-panic?
>
> Today, I met similar problem in mmotm-2012-09-12-17-36 on my KVM.
> It's hard to reproduce in my mahcine but I confirmed following as
> Hoping it helps you.
>

[ CC more input developers/testers ]

Hi Minchan,

Hey, cool. Thanks for the pointer in the source-code and the call-trace!
I had reverted [1], but anyway input folks should look at this.

Kind Regards,
- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=b276fc1e875a51e4a9dc3322ed008bf4ae481baf

> static unsigned int input_to_handler(struct input_handle *handle,
>                         struct input_value *vals, unsigned int count)
> {
>         ...
>         ...
>         if (handler->events)
>                 handler->events(handle, vals, count);
>         else
>                 for (v = vals; v != end; v++)
>                         handler->event(...); <-- handler->event is *ZERO*.
>
>         return count;
> }
>
>
> [   34.667212] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [   34.668320] IP: [<          (null)>]           (null)
> [   34.669095] PGD 1fe47c067 PUD 1fe47b067 PMD 0
> [   34.669808] Oops: 0010 [#1] SMP
> [   34.670316] Modules linked in: i2c_piix4
> [   34.670618] CPU 6
> [   34.670618] Pid: 0, comm: swapper/6 Not tainted 3.6.0-rc5-mm1-alloc-enhance+ #60 Bochs Bochs[   34.670618] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
> [   34.670618] RSP: 0018:ffff88021fd83c20  EFLAGS: 00010082
> [   34.670618] RAX: 0000000000000010 RBX: 0000000000000002 RCX: 000000000000000f
> [   34.670618] RDX: 0000000000000004 RSI: 0000000000000004 RDI: ffff8802145b4c00
> [   34.670618] RBP: ffff88021fd83c68 R08: 0000000000000000 R09: 0000000000000000
> [   34.670618] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880215c21070
> [   34.670618] R13: ffff880215c21068 R14: ffffffff81a8bfe0 R15: ffff8802145b4c00
> [   34.670618] FS:  0000000000000000(0000) GS:ffff88021fd80000(0000) knlGS:0000000000000000
> [   34.670618] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   34.670618] CR2: 0000000000000000 CR3: 00000001fe46f000 CR4: 00000000000006e0
> [   34.670618] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   34.670618] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   34.670618] Process swapper/6 (pid: 0, threadinfo ffff88021611e000, task ffff880216128000)
> [   34.670618] Stack:
> [   34.670618]  ffffffff81480a5d 0000000000000000 ffff880215c21060 0000000000000000
> [   34.670618]  ffff880215c21060 0000000000000002 ffff8802161ca800 ffff8802145b4c00
> [   34.670618]  ffff8802161cadb0 ffff88021fd83cc8 ffffffff81482caf ffffffff81482b28
> [   34.670618] Call Trace:
> [   34.670618]  <IRQ>
> [   34.670618]  [<ffffffff81480a5d>] ? input_to_handler+0xdd/0xf0
> [   34.670618]  [<ffffffff81482caf>] input_pass_values+0x1cf/0x1e0
> [   34.670618]  [<ffffffff81482b28>] ? input_pass_values+0x48/0x1e0
> [   34.670618]  [<ffffffff8148320e>] input_handle_event+0xce/0x540
> [   34.670618]  [<ffffffff8148380c>] input_event+0x6c/0x80
> [   34.670618]  [<ffffffff8148acf6>] atkbd_interrupt+0x4f6/0x660
> [   34.670618]  [<ffffffff812e6b94>] ? do_raw_spin_lock+0x54/0x120
> [   34.670618]  [<ffffffff8147dd52>] serio_interrupt+0x52/0xa0
> [   34.670618]  [<ffffffff8147ece3>] i8042_interrupt+0x193/0x3b0
> [   34.670618]  [<ffffffff810e4de5>] handle_irq_event_percpu+0x75/0x270
> [   34.670618]  [<ffffffff812e6cfd>] ? do_raw_spin_unlock+0x5d/0xb0
> [   34.670618]  [<ffffffff810e5028>] handle_irq_event+0x48/0x70
> [   34.670618]  [<ffffffff810e79d7>] handle_edge_irq+0x77/0x110
> [   34.670618]  [<ffffffff81016192>] handle_irq+0x22/0x40
> [   34.670618]  [<ffffffff81591c3a>] do_IRQ+0x5a/0xe0
> [   34.670618]  [<ffffffff8158786f>] common_interrupt+0x6f/0x6f
> [   34.670618]  <EOI>
> [   34.670618]  [<ffffffff810422e6>] ? native_safe_halt+0x6/0x10
> [   34.670618]  [<ffffffff810b027d>] ? trace_hardirqs_on+0xd/0x10
> [   34.670618]  [<ffffffff8101c5d8>] default_idle+0x58/0x270
> [   34.670618]  [<ffffffff8101d669>] cpu_idle+0xe9/0x130
> [   34.670618]  [<ffffffff815734fc>] start_secondary+0x200/0x207
> [   34.670618] Code:  Bad RIP value.
> [   34.670618] RIP  [<          (null)>]           (null)
> [   34.670618]  RSP <ffff88021fd83c20>
> [   34.670618] CR2: 0000000000000000
> [   34.670618] ---[ end trace 11a3b8aa65519925 ]---
> [   34.670618] Kernel panic - not syncing: Fatal exception in interrupt
>
> --
> Kind regards,
> Minchan Kim
