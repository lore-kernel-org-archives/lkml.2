Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2KGNrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:47:36 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37877 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2KGNre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:47:34 -0500
Message-ID: <509A665C.3030603@gmail.com>
Date: Wed, 07 Nov 2012 08:47:08 -0500
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings
References: <50899507.1040900@oracle.com> <20121026143754.50277bd8@pyramind.ukuu.org.uk> <CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com> <20121105175937.26f31d2a@pyramind.ukuu.org.uk> <5097FEA9.2090603@oracle.com> <alpine.LNX.2.00.1211051106590.1709@eggly.anvils> <20121105201507.79fe47d7@pyramind.ukuu.org.uk> <alpine.LNX.2.00.1211051231070.21645@eggly.anvils> <20121106161100.216c6d79@pyramind.ukuu.org.uk> <20121106164214.GA18246@redhat.com> <20121106173845.4a50d661@pyramind.ukuu.org.uk>
In-Reply-To: <20121106173845.4a50d661@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 12:38 PM, Alan Cox wrote:
>>  > The root
>>  > cause is loading two different framebuffers with one taking over from
>>  > another - that should be an obscure corner case and once the fuzz testing
>>  > can avoid.
>>  > 
>>  > I had a semi-informed poke at this and came up with a possible patch (not very tested)
>>
>> If this fixes the real problems we've been seeing, I'll dance a jig.
> 
> Youtube...

+1

> At this point my bigger concern is that it'll just make something else
> warn instead. The underlying problem is that fbcon layer implements a
> single threaded notifier whose locking semantics are at best random. It's
> not calld with a specific set of locks each time. Possibly it sohuld be
> two notifiers (one for fb stuff, one for console layer stuff) but the
> entire layer is horrible. I live in home the KMS guys will rip out the
> useful bits and build a straight kms fb layer with refcounting and the
> like 8)
> 
> Testing certainly needed and if it's still blowing up then hopefully
> further traces will help fix up the other cases we don't know about.

So the good news are that the original lockdep splat I've reported is gone.

The semi-bad news are that there's a new one. It happens less frequently
but I assume it's not a new splat either, but was well hidden behind the
other splat.

[ 1885.997312] ======================================================
[ 1885.997312] [ INFO: possible circular locking dependency detected ]
[ 1885.997316] 3.7.0-rc4-next-20121106-sasha-00008-g353b62f #117 Tainted: G        W
[ 1885.997316] -------------------------------------------------------
[ 1885.997319] trinity-child26/7820 is trying to acquire lock:
[ 1885.997330]  (&fb_info->lock){+.+.+.}, at: [<ffffffff81a665d1>] lock_fb_info+0x21/0x50
[ 1885.997331]
[ 1885.997331] but task is already holding lock:
[ 1885.997336]  (console_lock){+.+.+.}, at: [<ffffffff81a6c469>] store_modes+0x59/0x100
[ 1885.997337]
[ 1885.997337] which lock already depends on the new lock.
[ 1885.997337]
[ 1885.997338]
[ 1885.997338] the existing dependency chain (in reverse order) is:
[ 1885.997341]
[ 1885.997341] -> #1 (console_lock){+.+.+.}:
[ 1885.997347]        [<ffffffff8118536a>] lock_acquire+0x1aa/0x240
[ 1885.997351]        [<ffffffff8110b618>] console_lock+0x68/0x70
[ 1885.997354]        [<ffffffff81a689b2>] register_framebuffer+0x242/0x2a0
[ 1885.997359]        [<ffffffff8390e4bc>] vga16fb_probe+0x1c0/0x227
[ 1885.997364]        [<ffffffff81e6b472>] platform_drv_probe+0x12/0x20
[ 1885.997369]        [<ffffffff81e69e95>] driver_probe_device+0x155/0x340
[ 1885.997372]        [<ffffffff81e6a15e>] __device_attach+0x2e/0x50
[ 1885.997375]        [<ffffffff81e682d6>] bus_for_each_drv+0x56/0xa0
[ 1885.997379]        [<ffffffff81e69a88>] device_attach+0x88/0xc0
[ 1885.997382]        [<ffffffff81e68516>] bus_probe_device+0x36/0xd0
[ 1885.997385]        [<ffffffff81e6639f>] device_add+0x4df/0x750
[ 1885.997388]        [<ffffffff81e6bda8>] platform_device_add+0x1e8/0x280
[ 1885.997393]        [<ffffffff85b0f35a>] vga16fb_init+0x8d/0xbb
[ 1885.997399]        [<ffffffff85acccb2>] do_one_initcall+0x7a/0x135
[ 1885.997402]        [<ffffffff838db8d9>] kernel_init+0x299/0x470
[ 1885.997406]        [<ffffffff83a98fbc>] ret_from_fork+0x7c/0xb0
[ 1885.997409]
[ 1885.997409] -> #0 (&fb_info->lock){+.+.+.}:
[ 1885.997413]        [<ffffffff811825af>] __lock_acquire+0x14df/0x1ca0
[ 1885.997416]        [<ffffffff8118536a>] lock_acquire+0x1aa/0x240
[ 1885.997421]        [<ffffffff83a944d9>] __mutex_lock_common+0x59/0x5a0
[ 1885.997425]        [<ffffffff83a94a5f>] mutex_lock_nested+0x3f/0x50
[ 1885.997427]        [<ffffffff81a665d1>] lock_fb_info+0x21/0x50
[ 1885.997430]        [<ffffffff81a68b95>] fb_new_modelist+0xf5/0x140
[ 1885.997433]        [<ffffffff81a6c4ac>] store_modes+0x9c/0x100
[ 1885.997436]        [<ffffffff81e65013>] dev_attr_store+0x13/0x20
[ 1885.997440]        [<ffffffff812f820a>] sysfs_write_file+0xfa/0x150
[ 1885.997444]        [<ffffffff8127a220>] vfs_write+0xb0/0x180
[ 1885.997447]        [<ffffffff8127a3e0>] sys_write+0x50/0xa0
[ 1885.997450]        [<ffffffff83a99298>] tracesys+0xe1/0xe6
[ 1885.997451]
[ 1885.997451] other info that might help us debug this:
[ 1885.997451]
[ 1885.997452]  Possible unsafe locking scenario:
[ 1885.997452]
[ 1885.997453]        CPU0                    CPU1
[ 1885.997454]        ----                    ----
[ 1885.997456]   lock(console_lock);
[ 1885.997458]                                lock(&fb_info->lock);
[ 1885.997460]                                lock(console_lock);
[ 1885.997462]   lock(&fb_info->lock);
[ 1885.997463]
[ 1885.997463]  *** DEADLOCK ***
[ 1885.997463]
[ 1885.997464] 3 locks held by trinity-child26/7820:
[ 1885.997470]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff812f8153>] sysfs_write_file+0x43/0x150
[ 1885.997475]  #1:  (s_active#388){.+.+.+}, at: [<ffffffff812f81f2>] sysfs_write_file+0xe2/0x150
[ 1885.997481]  #2:  (console_lock){+.+.+.}, at: [<ffffffff81a6c469>] store_modes+0x59/0x100
[ 1885.997481]
[ 1885.997481] stack backtrace:
[ 1885.997484] Pid: 7820, comm: trinity-child26 Tainted: G        W    3.7.0-rc4-next-20121106-sasha-00008-g353b62f #117
[ 1885.997485] Call Trace:
[ 1885.997492]  [<ffffffff83a3c736>] print_circular_bug+0x1fb/0x20c
[ 1885.997496]  [<ffffffff811825af>] __lock_acquire+0x14df/0x1ca0
[ 1885.997499]  [<ffffffff81a01dc3>] ? debug_smp_processor_id+0x23/0x120
[ 1885.997504]  [<ffffffff810a3da6>] ? kvm_clock_read+0x46/0x80
[ 1885.997508]  [<ffffffff81152fa5>] ? sched_clock_local+0x25/0xa0
[ 1885.997511]  [<ffffffff8118536a>] lock_acquire+0x1aa/0x240
[ 1885.997514]  [<ffffffff81a665d1>] ? lock_fb_info+0x21/0x50
[ 1885.997517]  [<ffffffff83a944d9>] __mutex_lock_common+0x59/0x5a0
[ 1885.997520]  [<ffffffff81a665d1>] ? lock_fb_info+0x21/0x50
[ 1885.997523]  [<ffffffff81180d3a>] ? __lock_is_held+0x5a/0x80
[ 1885.997526]  [<ffffffff81a665d1>] ? lock_fb_info+0x21/0x50
[ 1885.997531]  [<ffffffff8125d4dd>] ? kfree+0x20d/0x330
[ 1885.997534]  [<ffffffff83a94a5f>] mutex_lock_nested+0x3f/0x50
[ 1885.997537]  [<ffffffff81a665d1>] lock_fb_info+0x21/0x50
[ 1885.997539]  [<ffffffff81a68b95>] fb_new_modelist+0xf5/0x140
[ 1885.997543]  [<ffffffff81a6c4ac>] store_modes+0x9c/0x100
[ 1885.997546]  [<ffffffff81e65013>] dev_attr_store+0x13/0x20
[ 1885.997553]  [<ffffffff812f820a>] sysfs_write_file+0xfa/0x150
[ 1885.997556]  [<ffffffff8127a220>] vfs_write+0xb0/0x180
[ 1885.997558]  [<ffffffff8127a3e0>] sys_write+0x50/0xa0
[ 1885.997561]  [<ffffffff83a99298>] tracesys+0xe1/0xe6
[ 1885.990746] irq event stamp: 35487
[ 1885.990746] hardirqs last  enabled at (35487): [<ffffffff83a977fb>] _raw_spin_unlock_irq+0x2b/0x80
[ 1885.990746] hardirqs last disabled at (35486): [<ffffffff83a975da>] _raw_spin_lock_irq+0x2a/0x90
[ 1885.990746] softirqs last  enabled at (34856): [<ffffffff811139a2>] __do_softirq+0x372/0x440
[ 1885.990746] softirqs last disabled at (34831): [<ffffffff83a9a4fc>] call_softirq+0x1c/0x30

