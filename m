Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1CHJHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:07:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46734 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab1CHJG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:06:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FY+h/PYQVg7uIoXYFyzgNsy7+sxzhiBEnYQ78NxGxX4YLx3djSxSHnNY7yURS9K6XN
         KjuJTPEIGusBqP0nEqsYxHp6GIg3I8hnOs8dPMd31elhgROsdWSxgrFf7f6vGGDX6XXU
         Y1GC4uccys/3L6dGAKsVXAtp971swKxoVIX1M=
MIME-Version: 1.0
In-Reply-To: <AANLkTikupmQqgVd5Y6Tg0Cj-0TGUvzko8-VPs6_n_pKE@mail.gmail.com>
References: <AANLkTikupmQqgVd5Y6Tg0Cj-0TGUvzko8-VPs6_n_pKE@mail.gmail.com>
Date: Tue, 8 Mar 2011 17:06:56 +0800
Message-ID: <AANLkTi=7S60UjieW0_ZhX7F5gm39+c28Bdv=dRhPd=tQ@mail.gmail.com>
Subject: Re: mce.c related WARNING: at kernel/timer.c:983 del_timer_sync
From: Yong Zhang <yong.zhang0@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Yong Zhang <yong.zhang@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 9:31 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> With latest git kernel, I see the below WARN_ON at boot, once for each CPU.
>
> [   26.806429] ------------[ cut here ]------------
> [   26.806434] WARNING: at kernel/timer.c:983 del_timer_sync+0x39/0x4d()
> [   26.806437] Hardware name: MCP55
> [   26.806438] Modules linked in: tg3 forcedeth sata_mv powernow_k8
> freq_table processor mperf msr cpuid ipv6 genrtc
> [   26.806447] Pid: 0, comm: swapper Tainted: G        W
> 2.6.38-smp-linus.22280 #23
> [   26.806449] Call Trace:
> [   26.806450]  <IRQ>  [<ffffffff8106e8ea>] ? warn_slowpath_common+0x85/0x9d
> [   26.806456]  [<ffffffff8106e91c>] ? warn_slowpath_null+0x1a/0x1c
> [   26.806459]  [<ffffffff8107ac48>] ? del_timer_sync+0x39/0x4d
> [   26.806462]  [<ffffffff81047a44>] ? mce_cpu_restart+0x1e/0x54
> [   26.806466]  [<ffffffff81099b22>] ?
> generic_smp_call_function_single_interrupt+0xd1/0xf3
> [   26.806469]  [<ffffffff8104c188>] ?
> smp_call_function_single_interrupt+0x18/0x27
> [   26.806473]  [<ffffffff810375f3>] ? call_function_single_interrupt+0x13/0x20
> [   26.806475]  <EOI>  [<ffffffff8103da93>] ? default_idle+0x4d/0x7f
> [   26.806479]  [<ffffffff8103da73>] ? default_idle+0x2d/0x7f
> [   26.806482]  [<ffffffff8103dbad>] ? c1e_idle+0xe8/0xef
> [   26.806485]  [<ffffffff8145bc62>] ? atomic_notifier_call_chain+0x18/0x1a
> [   26.806488]  [<ffffffff81035cc7>] ? cpu_idle+0x5f/0x96
> [   26.806491]  [<ffffffff8144af7e>] ? rest_init+0x72/0x74
> [   26.806495]  [<ffffffff818edcfe>] ? start_kernel+0x37b/0x386
> [   26.806498]  [<ffffffff818ed2a4>] ? x86_64_start_reservations+0xb4/0xb8
> [   26.806502]  [<ffffffff818ed39a>] ? x86_64_start_kernel+0xf2/0xf9
> [   26.806504] ---[ end trace 69a4de56993e518a ]---
>
> Looks like WARN_ON was after this change
> commit 466bd3030973910118ca601da8072be97a1e2209
> Author: Yong Zhang <yong.zhang@windriver.com>
> Date:   Wed Oct 20 15:57:33 2010 -0700
>
>    timer: Warn when del_timer_sync() is called in hardirq context

Even if without the WARN_ON(), lockdep will shout on it :)

>
> But, the actual reason is likely some MCE parameter change at boot causing
> mce_restart() which in turn calls on_each_cpu mce_cpu_restart() which calls
> del_timer_sync().

Seems we found a real bug.

And usage of del_timer_sync() in arch/x86/kernel/cpu/mcheck/mce.c
break two restriction:
1) del_timer_sync() must not be used in interrupt context;
2) The timer's handler must not call add_timer_on();

Thanks,
Yong

-- 
Only stand for myself
