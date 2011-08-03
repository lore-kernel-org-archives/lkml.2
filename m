Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1HCKa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:30:58 -0400
Received: from service87.mimecast.com ([94.185.240.25]:35712 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753528Ab1HCKax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:30:53 -0400
Date: Wed, 3 Aug 2011 11:30:33 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@elte.hu>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
Message-ID: <20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org>
In-Reply-To: <CA+55aFx+JOeDoNzs+1wfdK3kpNPyS9wpU1OT=VAwvWPXfMVuDQ@mail.gmail.com>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
	<CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
	<20110802124530.GA2543@albatros>
	<20110802135512.b49c9de1.akpm@linux-foundation.org>
	<d844457bba74be419d2434c533fdb4e1@localhost>
	<CA+55aFx+JOeDoNzs+1wfdK3kpNPyS9wpU1OT=VAwvWPXfMVuDQ@mail.gmail.com>
Organization: ARM Ltd
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
X-OriginalArrivalTime: 03 Aug 2011 10:30:44.0011 (UTC) FILETIME=[66650FB0:01CC51C8]
X-MC-Unique: 111080311304801501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011 09:19:24 +0100
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Aug 2, 2011 at 10:05 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> >
> > Reordering the initcalls seems the easiest solution, but it is still very
> > fragile...
> 
> So that's what I tried to do, by making it a "pure_initcall()". Even
> that didn't seem to be enough according to Manuel.
> 
> Can you try my patch (that makes just that ipc ns init be a
> pure_initcall(), together with your hack on top of Andrew's? What is
> it that happens so early that even pure_initcall() hasn't been done
> yet?

Here you go:

SMP: Total of 4 processors activated (334.95 BogoMIPS).
[<c0014754>] (unwind_backtrace+0x0/0xf4) from [<c003ed78>] (call_usermodehelper_exec+0x108/0x118)
[<c003ed78>] (call_usermodehelper_exec+0x108/0x118) from [<c01760ac>] (kobject_uevent_env+0x40c/0x450)
[<c01760ac>] (kobject_uevent_env+0x40c/0x450) from [<c01754e8>] (kset_register+0x3c/0x44)
[<c01754e8>] (kset_register+0x3c/0x44) from [<c01c2ed0>] (bus_register+0xac/0x28c)
[<c01c2ed0>] (bus_register+0xac/0x28c) from [<c042227c>] (platform_bus_init+0x20/0x40)
[<c042227c>] (platform_bus_init+0x20/0x40) from [<c04222f4>] (driver_init+0x18/0x24)
[<c04222f4>] (driver_init+0x18/0x24) from [<c040e270>] (kernel_init+0x84/0x13c)
[<c040e270>] (kernel_init+0x84/0x13c) from [<c000f630>] (kernel_thread_exit+0x0/0x8)
[<c0014754>] (unwind_backtrace+0x0/0xf4) from [<c003ed78>] (call_usermodehelper_exec+0x108/0x118)
[<c003ed78>] (call_usermodehelper_exec+0x108/0x118) from [<c01760ac>] (kobject_uevent_env+0x40c/0x450)
[<c01760ac>] (kobject_uevent_env+0x40c/0x450) from [<c01754e8>] (kset_register+0x3c/0x44)
[<c01754e8>] (kset_register+0x3c/0x44) from [<c01c1f0c>] (sysdev_class_register+0x60/0x8c)
[<c01c1f0c>] (sysdev_class_register+0x60/0x8c) from [<c040e270>] (kernel_init+0x84/0x13c)
[<c040e270>] (kernel_init+0x84/0x13c) from [<c000f630>] (kernel_thread_exit+0x0/0x8)
NET: Registered protocol family 16
L2x0 series cache controller enabled

driver_init() is called from do_basic_setup(), before any initcall...

	M.
-- 
I'm the slime oozin' out from your TV set...

