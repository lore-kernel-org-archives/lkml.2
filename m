Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab1CBSM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:12:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36250 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab1CBSM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:12:26 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=nZ6mVOVMA-0A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=CjDJIO3gzgOIPYHx6TkA:9 a=lvnZLYfDRnO9JwEY-54A:7 a=YVg9Ox3Ww-XZ34ujO3iNUdPUQ2sA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 2 Mar 2011 13:12:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: (WARNING) possible deadlock in del_timer_sync, called from
 fbcon_del_cursor_timer
Message-ID: <20110302181223.GD9288@home.goodmis.org>
References: <4D6BB403.9000908@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6BB403.9000908@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 03:41:07PM +0100, Clemens Ladisch wrote:
> While using the FB console, I tried to change the console log level
> with SysRq, and got this warning that del_timer_sync() is used in
> an interrupt handler:

Ug, del_timer_sync() can be called from interrupt context:

printk -> vt_console_print -> hide_cursor -> fbcon_cursor
-> fbcon_del_cursor_time -> del_timer_sync()

printk is allowed to be called from interrupt context. This is indeed a
true bug.

-- Steve

> 
> SysRq :
> ------------[ cut here ]------------
> WARNING: at kernel/timer.c:983 del_timer_sync+0x93/0xae()
> Hardware name: System Product Name
> Modules linked in: soundcore firewire_ohci firewire_core ohci_hcd ehci_hcd
> Pid: 0, comm: kworker/0:1 Not tainted 2.6.38-rc6+ #235
> Call Trace:
>  <IRQ>  [<ffffffff8103a6df>] ? warn_slowpath_common+0x80/0x98
>  [<ffffffff8103a70c>] ? warn_slowpath_null+0x15/0x17
>  [<ffffffff810452a7>] ? del_timer_sync+0x93/0xae
>  [<ffffffff81045214>] ? del_timer_sync+0x0/0xae
>  [<ffffffff8120725a>] ? fbcon_del_cursor_timer+0x32/0x3d
>  [<ffffffff812077f0>] ? fbcon_cursor+0x9a/0x152
>  [<ffffffff8125fd84>] ? hide_cursor+0x2c/0x7d
>  [<ffffffff8126022b>] ? vt_console_print+0xd9/0x2f7
>  [<ffffffff8103a891>] ? __call_console_drivers+0x67/0x79
>  [<ffffffff8103a8fc>] ? _call_console_drivers+0x59/0x5d
>  [<ffffffff8103ae3e>] ? console_unlock+0x160/0x1ce
>  [<ffffffff8103b44a>] ? vprintk+0x358/0x38e
>  [<ffffffff81466199>] ? printk+0x3c/0x3e
>  [<ffffffff812594ce>] ? __handle_sysrq+0x23/0x157
>  [<ffffffff812594f0>] ? __handle_sysrq+0x45/0x157
>  [<ffffffff81259758>] ? sysrq_filter+0x116/0x17b
>  [<ffffffff8139b9c5>] ? input_pass_event+0xbe/0x111
>  [<ffffffff8139b907>] ? input_pass_event+0x0/0x111
>  [<ffffffff8139cfb4>] ? input_handle_event+0x42a/0x439
>  [<ffffffff8139d0e9>] ? input_event+0x5b/0x7a
>  [<ffffffff813a37f3>] ? atkbd_interrupt+0x50f/0x5e0
>  [<ffffffff8139735c>] ? serio_interrupt+0x40/0x7c
>  [<ffffffff81398647>] ? i8042_interrupt+0x289/0x2a3
>  [<ffffffff8107ae98>] ? handle_IRQ_event+0x20/0xa8
>  [<ffffffff8107cd68>] ? handle_edge_irq+0x103/0x14f
>  [<ffffffff81004a2b>] ? handle_irq+0x83/0x8c
>  [<ffffffff81004067>] ? do_IRQ+0x48/0xaf
>  [<ffffffff81469a93>] ? ret_from_intr+0x0/0x13
>  <EOI>  [<ffffffff8105d49e>] ? tick_broadcast_oneshot_control+0x1a/0xfb
>  [<ffffffff810098cc>] ? default_idle+0x27/0x43
>  [<ffffffff810098ce>] ? default_idle+0x29/0x43
>  [<ffffffff810098cc>] ? default_idle+0x27/0x43
>  [<ffffffff81009a33>] ? c1e_idle+0xcd/0xf4
>  [<ffffffff810012e5>] ? cpu_idle+0x5f/0x96
>  [<ffffffff81462b7c>] ? start_secondary+0x1e3/0x1e5
> ---[ end trace 80565a42945fc993 ]---
> Changing Loglevel
> Loglevel set to 3
> 
> 
> To add insult to injury, my cursor is configured not to blink.
> 
> 
> Regards,
> Clemens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
