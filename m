Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1GXOkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 10:40:31 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:38152 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1GXOk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 10:40:26 -0400
Message-ID: <4E2C2ED6.4040904@gmail.com>
Date: Sun, 24 Jul 2011 16:40:22 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt3
References: <alpine.LFD.2.02.1107241223560.2702@ionos>
In-Reply-To: <alpine.LFD.2.02.1107241223560.2702@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2011 12:33 PM, Thomas Gleixner wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.0-rt3 release.
>
> Changes versus 3.0-rt2:
>
>   * Fix earlyprintk really
>
>   * AMD NB fix for allocation in smp function call, reported by Ed
>
>   * Disabled a few config options on RT which have known issues
>
> Patch against 3.0 can be found here:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt3.patch.bz2
>
> The split quilt queue is available at:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0-rt3.tar.bz2
Oprofile seems to be upset at me, I swear I'm innocent!

[   46.460786] oprofile: using NMI interrupt.
[   47.492263] BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
[   47.492265] in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: kworker/0:1
[   47.492267] Pid: 0, comm: kworker/0:1 Tainted: G         C  3.0.0-rt3-patser+ #39
[   47.492269] Call Trace:
[   47.492270]  <IRQ>  [<ffffffff8103fc0a>] __might_sleep+0xca/0xf0
[   47.492279]  [<ffffffff8160d424>] rt_spin_lock+0x24/0x40
[   47.492282]  [<ffffffff811476c7>] __kmalloc+0xc7/0x370
[   47.492287]  [<ffffffffa0275c85>] ? ppro_setup_ctrs+0x215/0x260 [oprofile]
[   47.492291]  [<ffffffffa0273de0>] ? oprofile_cpu_notifier+0x60/0x60 [oprofile]
[   47.492295]  [<ffffffffa0275c85>] ppro_setup_ctrs+0x215/0x260 [oprofile]
[   47.492305]  [<ffffffffa0273de0>] ? oprofile_cpu_notifier+0x60/0x60 [oprofile]
[   47.492307]  [<ffffffffa0273de0>] ? oprofile_cpu_notifier+0x60/0x60 [oprofile]
[   47.492308]  [<ffffffffa0273ea4>] nmi_cpu_setup+0xc4/0x110 [oprofile]
[   47.492310]  [<ffffffff81094455>] generic_smp_call_function_interrupt+0x95/0x190
[   47.492313]  [<ffffffff8101df77>] smp_call_function_interrupt+0x27/0x40
[   47.492315]  [<ffffffff81615093>] call_function_interrupt+0x13/0x20
[   47.492316]  <EOI>  [<ffffffff8131d0c4>] ? plist_check_head+0x54/0xc0
[   47.492321]  [<ffffffff81371fe8>] ? intel_idle+0xc8/0x120
[   47.492322]  [<ffffffff81371fc7>] ? intel_idle+0xa7/0x120
[   47.492324]  [<ffffffff814a57b0>] cpuidle_idle_call+0xb0/0x230
[   47.492326]  [<ffffffff810011db>] cpu_idle+0x8b/0xe0
[   47.492328]  [<ffffffff815fc82f>] start_secondary+0x1d3/0x1d8

Also not sure where this one came from:
[   37.456688] BUG: spinlock bad magic on CPU#3, threaded-ml/1619
[   37.456690]  lock: ffff8801fdc74d50, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[   37.456692] Pid: 1619, comm: threaded-ml Tainted: G         C  3.0.0-rt3-patser+ #39
[   37.456693] Call Trace:
[   37.456697]  [<ffffffff81607a78>] spin_bug+0xa0/0xa8
[   37.456699]  [<ffffffff8132b412>] do_raw_spin_lock+0xa2/0x170
[   37.456702]  [<ffffffff8104a201>] ? get_parent_ip+0x11/0x50
[   37.456704]  [<ffffffff8160d783>] _raw_spin_lock+0x23/0x30
[   37.456706]  [<ffffffff810931ce>] rt_mutex_start_proxy_lock+0x2e/0xd0
[   37.456708]  [<ffffffff8109093a>] futex_requeue+0x47a/0x850
[   37.456710]  [<ffffffff8109138e>] do_futex+0xae/0xb00
[   37.456712]  [<ffffffff81157dcd>] ? fget_light+0x6d/0x110
[   37.456714]  [<ffffffff810b77b7>] ? audit_syscall_entry+0x2e7/0x310
[   37.456715]  [<ffffffff814c9375>] ? sys_recvmsg+0x75/0x90
[   37.456717]  [<ffffffff810923e6>] compat_sys_futex+0xf6/0x190
[   37.456719]  [<ffffffff8100e864>] ? syscall_trace_enter+0x184/0x210
[   37.456721]  [<ffffffff816158b3>] ia32_do_call+0x13/0x13

Running linux 3.0rt3 with (drm-preempt patched) nouveau out of tree.
