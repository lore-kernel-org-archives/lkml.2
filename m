Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1GUTJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:09:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59460 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1GUTJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:09:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAN6cQ7kQNcEEd4uDHRA7F+cM57UgjzjY8OP7FsW4D5FjZd+n9g@mail.gmail.com>
References: <CAN6cQ7kQNcEEd4uDHRA7F+cM57UgjzjY8OP7FsW4D5FjZd+n9g@mail.gmail.com>
Date: Thu, 21 Jul 2011 13:09:29 -0600
Message-ID: <CAN6cQ7=8e=ujGm0HshBGGryC1sD_tvXh0vb6jDO8QuvHgVjPCA@mail.gmail.com>
Subject: Re: Kernel Panic on init (powerpc)
From: Brian Szmyd <brian.szmyd@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 3:33 PM, Brian Szmyd <brian.szmyd@gmail.com> wrote:
> Kernel panic - not syncing: Attempted to kill init!
> Call Trace:
> [c781fd30] [c0007964] show_stack+0x48/0x15c (unreliable)
> [c781fd70] [c0291b98] panic+0xb8/0x12c
> [c781fdc0] [c0025bb8] do_exit+0x628/0x67c
> [c781fe10] [c0025eec] do_group_exit+0x44/0xd0
> [c781fe20] [c003277c] get_signal_to_deliver+0x1f4/0x44c
> [c781fe70] [c00084c0] do_signal_pending.constprop.8+0x40/0x248
> [c781ff30] [c0008840] do_signal+0x50/0x58
> [c781ff40] [c000fba8] do_user_signal+0x74/0xc4
> Rebooting in 180 seconds...

I've enabled kgdb and using GDB I have the following two back traces
for my issue. The first I set the break point to run_init_process:

#0  kernel_execve () at arch/powerpc/kernel/misc.S:60
#1  0xc026cb18 in run_init_process (init_filename=<value optimized
out>) at init/main.c:820
#2  0xc026cbb4 in init_post () at init/main.c:857
#3  0xc030085c in kernel_init (unused=<value optimized out>) at init/main.c:929
#4  0xc000ee28 in kernel_thread () at arch/powerpc/kernel/misc_32.S:687

After I step arch/powerpc/kernel/misc.S:60 which looks like:

58:_GLOBAL(kernel_execve)
59:   li r0,__NR_execve
60:   sc
61:   bnslr
62:   neg   r3,r3
63:   blr

I get the following:

#0  kgdb_breakpoint (self=0xc0325c08, val=0, data=0xc0347dc4) at
kernel/debug/debug_core.c:968
#1  kgdb_panic_event (self=0xc0325c08, val=0, data=0xc0347dc4) at
kernel/debug/debug_core.c:773
#2  0xc003f328 in notifier_call_chain (val=0, v=0xc0347dc4,
nr_to_call=<value optimized out>, nr_calls=0x0,
    nl=<value optimized out>) at kernel/notifier.c:93
#3  0xc026cee8 in panic (fmt=<value optimized out>) at kernel/panic.c:116
#4  0xc0025be8 in find_new_reaper (code=4) at kernel/exit.c:729
#5  forget_original_parent (code=4) at kernel/exit.c:785
#6  exit_notify (code=4) at kernel/exit.c:828
#7  do_exit (code=4) at kernel/exit.c:1010
#8  0xc0025e6c in do_group_exit (exit_code=4) at kernel/exit.c:1095
#9  0xc0031338 in get_signal_to_deliver (info=0xc781fe8c,
return_ka=0xc781fe78, regs=0xc781ff50,
    cookie=<value optimized out>) at kernel/signal.c:1994
#10 0xc00081f4 in do_signal_pending (regs=0xc781ff50,
oldset=0xc781c33c) at arch/powerpc/kernel/signal.c:128
#11 0xc0008510 in do_signal (regs=<value optimized out>,
thread_info_flags=<value optimized out>)
    at arch/powerpc/kernel/signal.c:192
#12 0xc000f934 in do_user_signal () at arch/powerpc/kernel/entry_32.S:1189

I'm no where near experienced enough to understand what the assembly
is trying to do and what the expected outcome is. Any ideas? Thanks in
advance, and again if I could be CC'd on the response.
