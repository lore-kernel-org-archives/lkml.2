Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2KGE3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 23:29:47 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52074 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2KGE3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 23:29:42 -0500
Date: Tue, 6 Nov 2012 20:29:38 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Sasha Levin <sasha.levin@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, linux-fbdev@vger.kernel.org,
        florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings
In-Reply-To: <20121106161100.216c6d79@pyramind.ukuu.org.uk>
Message-ID: <alpine.LNX.2.00.1211061950020.1712@eggly.anvils>
References: <50899507.1040900@oracle.com> <20121026143754.50277bd8@pyramind.ukuu.org.uk> <CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com> <20121105175937.26f31d2a@pyramind.ukuu.org.uk> <5097FEA9.2090603@oracle.com>
 <alpine.LNX.2.00.1211051106590.1709@eggly.anvils> <20121105201507.79fe47d7@pyramind.ukuu.org.uk> <alpine.LNX.2.00.1211051231070.21645@eggly.anvils> <20121106161100.216c6d79@pyramind.ukuu.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Alan Cox wrote:
> On Mon, 5 Nov 2012 12:34:44 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> > On Mon, 5 Nov 2012, Alan Cox wrote:
> > > > The fbdev potential for deadlock may be years old, but the warning
> > > > (and consequent disabling of lockdep from that point on - making it
> > > > useless to everybody else in need of it) is new, and comes from the
> > > > commit below in linux-next.
> > > > 
> > > > I revert it in my own testing: if there is no quick fix to the
> > > > fbdev issue on the way, Daniel, please revert it from your tree.
> > > 
> > > If you revert it you swap it for a different deadlock - and one that
> > > happens more often I would expect. Not very useful.
> > 
> > But a deadlock we have lived with for years.  Without reverting,
> > we're prevented from discovering all the new deadlocks we're adding.
> 
> We lived with it locking boxes up on users but not knowing why. The root
> cause is loading two different framebuffers with one taking over from
> another - that should be an obscure corner case and once the fuzz testing
> can avoid.

I'm bemused, but at least I now understand why we disagreed on this.

You thought it was a lockdep splat I got in the course of fuzz testing,
or doing some other obscure test: no, I thought I got it in booting up
the laptop, so it was in the way of doing useful testing thereafter.

I'd swear that I saw it two or three times, on each boot of 3.7.0-rc3-mm1;
then lost patience and deleted all the console_lock_dep_map lines from
kernel/printk.c, after which no problem.

But /var/log/messages calls me a liar, shows only one instance, and that
10 minutes after booting: that splat appended below in case it tells you
anything new; but I've no idea what triggered iti.  (The "W" taint comes
from my using a "numa=fake=2" boot option, which surprised smpboot.c to
find smt-siblings on different nodes: not related to the console, I hope).

>  
> > That would be ideal - thanks.
> 
> 
> I had a semi-informed poke at this and came up with a possible patch (not very tested)

Many thanks for your effort.

> 
> commit f4fa6c739ecc367dbb98f5be1ff626d9b2750878
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Tue Nov 6 15:33:18 2012 +0000
> 
>     fb: Rework locking to fix lock ordering on takeover
>     
>     Adjust the console layer to allow a take over call where the caller already
>     holds the locks. Make the fb layer lock in order.
>     
>     This s partly a band aid, the fb layer is terminally confused about the
>     locking rules it uses for its notifiers it seems.
>     
>     Signed-off-by: Alan Cox <alan@linux.intel.com>

So I went to test this, but first tried to reproduce the orginal lockdep
splat that had irritated me so, and was utterly unsuccessful.  So although
I am now running happily with your patch applied, no ill effects observed,
this gives no confidence because I cannot reproduce the condition anyway.

Sorry to be so unhelpful, original splat without your patch below.

Ah, now I actually scan through it, I see references to blank screen:
I'll try taking off your patch and seeing if it came up at screen
blanking time, then put on your patch back on and try again.
I'll report back in an hour or two.

Hugh

======================================================
[ INFO: possible circular locking dependency detected ]
3.7.0-rc3-mm1 #2 Tainted: G        W   
-------------------------------------------------------
kworker/0:1/30 is trying to acquire lock:
ACPI: Invalid Power Resource to register!
 ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff81080ed0>] __blocking_notifier_call_chain+0x6b/0xa2

but task is already holding lock:
 (console_lock){+.+.+.}, at: [<ffffffff812877df>] console_callback+0xc/0xf7

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (console_lock){+.+.+.}:
       [<ffffffff810a517a>] __lock_acquire+0x7fc/0x8bb
       [<ffffffff810a561c>] lock_acquire+0x57/0x6d
       [<ffffffff8106074d>] console_lock+0x67/0x69
       [<ffffffff8128599a>] register_con_driver+0x36/0x128
       [<ffffffff81285e60>] take_over_console+0x21/0x2b7
       [<ffffffff81237014>] fbcon_takeover+0x56/0x98
       [<ffffffff8123a7dd>] fbcon_event_notify+0x3bb/0x6ee
       [<ffffffff81080c32>] notifier_call_chain+0xa7/0xd4
       [<ffffffff81080ee6>] __blocking_notifier_call_chain+0x81/0xa2
       [<ffffffff81080f16>] blocking_notifier_call_chain+0xf/0x11
       [<ffffffff8122f7aa>] fb_notifier_call_chain+0x16/0x18
       [<ffffffff81231523>] register_framebuffer+0x20c/0x270
       [<ffffffff81297357>] drm_fb_helper_single_fb_probe+0x1ce/0x270
       [<ffffffff812975c3>] drm_fb_helper_initial_config+0x1ca/0x1e1
       [<ffffffff812e80bd>] intel_fbdev_init+0x76/0x89
       [<ffffffff812b430a>] i915_driver_load+0xb20/0xcf7
       [<ffffffff812a346e>] drm_get_pci_dev+0x162/0x25b
       [<ffffffff8150f1b8>] i915_pci_probe+0x60/0x69
       [<ffffffff812269cf>] local_pci_probe+0x12/0x16
       [<ffffffff812274a1>] pci_device_probe+0xbe/0xeb
       [<ffffffff812f783d>] driver_probe_device+0x91/0x19e
       [<ffffffff812f79a7>] __driver_attach+0x5d/0x80
       [<ffffffff812f5fac>] bus_for_each_dev+0x52/0x84
       [<ffffffff812f74ed>] driver_attach+0x19/0x1b
       [<ffffffff812f701f>] bus_add_driver+0xe7/0x20c
       [<ffffffff812f7f1b>] driver_register+0x8e/0x114
       [<ffffffff81227590>] __pci_register_driver+0x5a/0x5f
       [<ffffffff812a35e7>] drm_pci_init+0x80/0xe5
       [<ffffffff818c1229>] i915_init+0x66/0x68
       [<ffffffff81000231>] do_one_initcall+0x7a/0x131
       [<ffffffff81508129>] kernel_init+0x106/0x26d
       [<ffffffff81529cac>] ret_from_fork+0x7c/0xb0

-> #0 ((fb_notifier_list).rwsem){.+.+.+}:
       [<ffffffff810a3e14>] validate_chain.isra.21+0x7b0/0xd45
       [<ffffffff810a517a>] __lock_acquire+0x7fc/0x8bb
       [<ffffffff810a561c>] lock_acquire+0x57/0x6d
       [<ffffffff81526df5>] down_read+0x42/0x57
       [<ffffffff81080ed0>] __blocking_notifier_call_chain+0x6b/0xa2
       [<ffffffff81080f16>] blocking_notifier_call_chain+0xf/0x11
       [<ffffffff8122f7aa>] fb_notifier_call_chain+0x16/0x18
       [<ffffffff8122fe47>] fb_blank+0x36/0x85
       [<ffffffff81237ceb>] fbcon_blank+0x129/0x269
       [<ffffffff8128589b>] do_blank_screen+0x18a/0x253
       [<ffffffff8128789f>] console_callback+0xcc/0xf7
       [<ffffffff81076a5e>] process_one_work+0x20e/0x3a2
       [<ffffffff81076e0a>] worker_thread+0x1ee/0x2cb
       [<ffffffff8107b90a>] kthread+0xd0/0xd8
       [<ffffffff81529cac>] ret_from_fork+0x7c/0xb0

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(console_lock);
                               lock((fb_notifier_list).rwsem);
                               lock(console_lock);
  lock((fb_notifier_list).rwsem);

 *** DEADLOCK ***

3 locks held by kworker/0:1/30:
 #0:  (events){.+.+.+}, at: [<ffffffff810769f6>] process_one_work+0x1a6/0x3a2
 #1:  (console_work){+.+.+.}, at: [<ffffffff810769f6>] process_one_work+0x1a6/0x3a2
 #2:  (console_lock){+.+.+.}, at: [<ffffffff812877df>] console_callback+0xc/0xf7

stack backtrace:
Pid: 30, comm: kworker/0:1 Tainted: G        W    3.7.0-rc3-mm1 #2
Call Trace:
 [<ffffffff8151e443>] print_circular_bug+0x28d/0x29e
 [<ffffffff810a3e14>] validate_chain.isra.21+0x7b0/0xd45
 [<ffffffff8107928b>] ? __kernel_text_address+0x22/0x41
 [<ffffffff810a517a>] __lock_acquire+0x7fc/0x8bb
 [<ffffffff810a561c>] lock_acquire+0x57/0x6d
 [<ffffffff81080ed0>] ? __blocking_notifier_call_chain+0x6b/0xa2
 [<ffffffff81526df5>] down_read+0x42/0x57
 [<ffffffff81080ed0>] ? __blocking_notifier_call_chain+0x6b/0xa2
 [<ffffffff81080ed0>] __blocking_notifier_call_chain+0x6b/0xa2
 [<ffffffff81080f16>] blocking_notifier_call_chain+0xf/0x11
 [<ffffffff8122f7aa>] fb_notifier_call_chain+0x16/0x18
 [<ffffffff8122fe47>] fb_blank+0x36/0x85
 [<ffffffff81237ceb>] fbcon_blank+0x129/0x269
 [<ffffffff8152910b>] ? _raw_spin_unlock_irqrestore+0x3a/0x64
 [<ffffffff810a5dbf>] ? trace_hardirqs_on_caller+0x114/0x170
 [<ffffffff810a5e28>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff81529117>] ? _raw_spin_unlock_irqrestore+0x46/0x64
 [<ffffffff8106bc00>] ? try_to_del_timer_sync+0x48/0x54
 [<ffffffff8106bc77>] ? del_timer_sync+0x6b/0xb4
 [<ffffffff8106bc9a>] ? del_timer_sync+0x8e/0xb4
 [<ffffffff8106bc0c>] ? try_to_del_timer_sync+0x54/0x54
 [<ffffffff8128589b>] do_blank_screen+0x18a/0x253
 [<ffffffff8128789f>] console_callback+0xcc/0xf7
 [<ffffffff810769f6>] ? process_one_work+0x1a6/0x3a2
 [<ffffffff81076a5e>] process_one_work+0x20e/0x3a2
 [<ffffffff810769f6>] ? process_one_work+0x1a6/0x3a2
 [<ffffffff812877d3>] ? poke_blanked_console+0xc9/0xc9
 [<ffffffff81076e0a>] worker_thread+0x1ee/0x2cb
 [<ffffffff81076c1c>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8107b90a>] kthread+0xd0/0xd8
 [<ffffffff8152915d>] ? _raw_spin_unlock_irq+0x28/0x50
 [<ffffffff8107b83a>] ? __init_kthread_worker+0x55/0x55
 [<ffffffff81529cac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107b83a>] ? __init_kthread_worker+0x55/0x55
