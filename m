Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1FFX0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:26:30 -0400
Received: from mail.candelatech.com ([208.74.158.172]:39195 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab1FFX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:26:28 -0400
Message-ID: <4DED6221.1060806@candelatech.com>
Date: Mon, 06 Jun 2011 16:26:25 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        barnes@virtuousgeek.org, keithp@keithp.com
Subject: Re: 3.0.0-rc2 fails to boot on Atom appliance (bisected, drm/i915)
References: <4DED33DF.8000201@candelatech.com>
In-Reply-To: <4DED33DF.8000201@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2011 01:09 PM, Ben Greear wrote:
> Anyone seen something like this?  For what it's worth, it seems
> that -rc1 had the same problem. I'll start bisecting soon if
> the problem isn't already resolved somehow...

I bisected this problem down to this commit:


[greearb@build-32 linux-2.6]$ git bisect bad
6067aaeadb5b3df26f27ac827256b1ef01e674f5 is the first bad commit
commit 6067aaeadb5b3df26f27ac827256b1ef01e674f5
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Apr 28 15:04:31 2011 -0700

     drm/i915: split clock gating init into per-chipset functions

     This helps contain the mess to init_display() instead.

     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
     Reviewed-by: Keith Packard <keithp@keithp.com>
     Signed-off-by: Keith Packard <keithp@keithp.com>

:040000 040000 9f53568fc450a9a53b1fe749142dd9c8f2707881 a3c2031ba7d5ea9c4190279315c436131b6cf922 M	drivers


Full dmesg from a working boot (2.6.38.7) is here:

http://www.candelatech.com/~greearb/misc/fw7535-dmesg.txt

I'm happy to test patches...

Thanks,
Ben


>
> OS is 32-bit Fedora 13.
>
> udevd (96): /proc/96/oom_adj is deprecated, please use
> /proc/96/oom_score_adj instead.
> [drm] Initialized drm 1.1.0 20060810
> i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [drm] Driver supports precise vblank timestamp query.
> vgaarb: device changed decodes:
> PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> dracut:
> dracut: udevadm settle - timeout of 30 seconds reached, the event queue
> contains:
> dracut: /sys/devices/pci0000:00/0000:00:02.0 (885)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/drm/controlD64 (965)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/drm/card0 (966)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/i2c-0 (967)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/i2c-1 (968)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/i2c-2 (969)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/i2c-3 (970)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/i2c-4 (971)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/i2c-5 (972)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/i2c-6 (973)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/i2c-7 (974)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1 (975)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/drm/card0 (976)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-VGA-1 (977)
> dracut: /sys/devices/pci0000:00/0000:00:02.0/drm/card0 (978)
> dracut: Starting plymouth daemon
> Gdracut: rd_NO_DM: removing DM RAID activation
> dracut: rd_NO_MD: removing MD RAID activation
> Gudevd[96]: worker [99] unexpectedly returned with status 0x0100
>
> udevd[96]: worker [99] failed while handling
> '/devices/pci0000:00/0000:00:02.0'
>
>
> udevadm settle - timeout of 180 seconds reached, the event queue contains:
> /sys/devices/pci0000:00/0000:00:02.0/drm/controlD64 (965)
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0 (966)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-0 (967)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-1 (968)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-2 (969)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-3 (970)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-4 (971)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-5 (972)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-6 (973)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-7 (974)
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1 (975)
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0 (976)
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-VGA-1 (977)
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0 (978)
> /sys/devices/pci0000:00/0000:00:02.0 (1053)
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0 (1054)
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1 (1055)
> /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-VGA-1 (1056)
> /sys/devices/pci0000:00/0000:00:02.0/drm/controlD64 (1057)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-0 (1058)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-1 (1059)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-2 (1060)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-3 (1061)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-4 (1062)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-5 (1063)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-6 (1064)
> /sys/devices/pci0000:00/0000:00:02.0/i2c-7 (1065)
> INFO: task modprobe:263 blocked for more than 180 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> modprobe D f26ebeec 0 263 1 0x00000000
> f26ebf58 00000046 00000006 f26ebeec c0b1fc00 f261d280 c0b1fc00 c0b1fc00
> f261d4fc c0b1fc00 7bff03b0 00000032 00000000 00000032 f261d280 00000000
> 00000007 f261d280 c07fc13c 00000002 f26ebf28 c04619c3 c0a6bb34 00000246
> Call Trace:
> [<c07fc13c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
> [<c04619c3>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c04619ef>] ? trace_hardirqs_on+0xb/0xd
> [<c045153c>] ? prepare_to_wait+0x56/0x5c
> [<c067e89b>] wait_for_device_probe+0x5d/0x76
> [<c0451360>] ? wake_up_bit+0x60/0x60
> [<f8563008>] wait_scan_init+0x8/0x11 [scsi_wait_scan]
> [<c040115e>] do_one_initcall+0x76/0x126
> [<f8563000>] ? 0xf8562fff
> [<c046b929>] sys_init_module+0x7c/0x1a8
> [<c0801d98>] sysenter_do_call+0x12/0x38
> no locks held by modprobe/263.
> INFO: task modprobe:263 blocked for more than 180 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> modprobe D f26ebeec 0 263 1 0x00000000
> f26ebf58 00000046 00000006 f26ebeec c0b1fc00 f261d280 c0b1fc00 c0b1fc00
> f261d4fc c0b1fc00 7bff03b0 00000032 00000000 00000032 f261d280 00000000
> 00000007 f261d280 c07fc13c 00000002 f26ebf28 c04619c3 c0a6bb34 00000246
> Call Trace:
> [<c07fc13c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
> [<c04619c3>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c04619ef>] ? trace_hardirqs_on+0xb/0xd
> [<c045153c>] ? prepare_to_wait+0x56/0x5c
> [<c067e89b>] wait_for_device_probe+0x5d/0x76
> [<c0451360>] ? wake_up_bit+0x60/0x60
> [<f8563008>] wait_scan_init+0x8/0x11 [scsi_wait_scan]
> [<c040115e>] do_one_initcall+0x76/0x126
> [<f8563000>] ? 0xf8562fff
> [<c046b929>] sys_init_module+0x7c/0x1a8
> [<c0801d98>] sysenter_do_call+0x12/0x38
> no locks held by modprobe/263.
> INFO: task modprobe:263 blocked for more than 180 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> modprobe D f26ebeec 0 263 1 0x00000000
> f26ebf58 00000046 00000006 f26ebeec c0b1fc00 f261d280 c0b1fc00 c0b1fc00
> f261d4fc c0b1fc00 7bff03b0 00000032 00000000 00000032 f261d280 00000000
> 00000007 f261d280 c07fc13c 00000002 f26ebf28 c04619c3 c0a6bb34 00000246
> Call Trace:
> [<c07fc13c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
> [<c04619c3>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c04619ef>] ? trace_hardirqs_on+0xb/0xd
> [<c045153c>] ? prepare_to_wait+0x56/0x5c
> [<c067e89b>] wait_for_device_probe+0x5d/0x76
> [<c0451360>] ? wake_up_bit+0x60/0x60
> [<f8563008>] wait_scan_init+0x8/0x11 [scsi_wait_scan]
> [<c040115e>] do_one_initcall+0x76/0x126
> [<f8563000>] ? 0xf8562fff
> [<c046b929>] sys_init_module+0x7c/0x1a8
> [<c0801d98>] sysenter_do_call+0x12/0x38
> no locks held by modprobe/263.
> INFO: task modprobe:263 blocked for more than 180 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> modprobe D f26ebeec 0 263 1 0x00000000
> f26ebf58 00000046 00000006 f26ebeec c0b1fc00 f261d280 c0b1fc00 c0b1fc00
> f261d4fc c0b1fc00 7bff03b0 00000032 00000000 00000032 f261d280 00000000
> 00000007 f261d280 c07fc13c 00000002 f26ebf28 c04619c3 c0a6bb34 00000246
> Call Trace:
> [<c07fc13c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
> [<c04619c3>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c04619ef>] ? trace_hardirqs_on+0xb/0xd
> [<c045153c>] ? prepare_to_wait+0x56/0x5c
> [<c067e89b>] wait_for_device_probe+0x5d/0x76
> [<c0451360>] ? wake_up_bit+0x60/0x60
> [<f8563008>] wait_scan_init+0x8/0x11 [scsi_wait_scan]
> [<c040115e>] do_one_initcall+0x76/0x126
> [<f8563000>] ? 0xf8562fff
> [<c046b929>] sys_init_module+0x7c/0x1a8
> [<c0801d98>] sysenter_do_call+0x12/0x38
> no locks held by modprobe/263.
> INFO: task modprobe:263 blocked for more than 180 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> modprobe D f26ebeec 0 263 1 0x00000000
> f26ebf58 00000046 00000006 f26ebeec c0b1fc00 f261d280 c0b1fc00 c0b1fc00
> f261d4fc c0b1fc00 7bff03b0 00000032 00000000 00000032 f261d280 00000000
> 00000007 f261d280 c07fc13c 00000002 f26ebf28 c04619c3 c0a6bb34 00000246
> Call Trace:
> [<c07fc13c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
> [<c04619c3>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c04619ef>] ? trace_hardirqs_on+0xb/0xd
> [<c045153c>] ? prepare_to_wait+0x56/0x5c
> [<c067e89b>] wait_for_device_probe+0x5d/0x76
> [<c0451360>] ? wake_up_bit+0x60/0x60
> [<f8563008>] wait_scan_init+0x8/0x11 [scsi_wait_scan]
> [<c040115e>] do_one_initcall+0x76/0x126
> [<f8563000>] ? 0xf8562fff
> [<c046b929>] sys_init_module+0x7c/0x1a8
> [<c0801d98>] sysenter_do_call+0x12/0x38
> no locks held by modprobe/263.
> INFO: task modprobe:263 blocked for more than 180 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> modprobe D f26ebeec 0 263 1 0x00000000
> f26ebf58 00000046 00000006 f26ebeec c0b1fc00 f261d280 c0b1fc00 c0b1fc00
> f261d4fc c0b1fc00 7bff03b0 00000032 00000000 00000032 f261d280 00000000
> 00000007 f261d280 c07fc13c 00000002 f26ebf28 c04619c3 c0a6bb34 00000246
> Call Trace:
> [<c07fc13c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
> [<c04619c3>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c04619ef>] ? trace_hardirqs_on+0xb/0xd
> [<c045153c>] ? prepare_to_wait+0x56/0x5c
> [<c067e89b>] wait_for_device_probe+0x5d/0x76
> [<c0451360>] ? wake_up_bit+0x60/0x60
> [<f8563008>] wait_scan_init+0x8/0x11 [scsi_wait_scan]
> [<c040115e>] do_one_initcall+0x76/0x126
> [<f8563000>] ? 0xf8562fff
> [<c046b929>] sys_init_module+0x7c/0x1a8
> [<c0801d98>] sysenter_do_call+0x12/0x38
> no locks held by modprobe/263.
> INFO: task modprobe:263 blocked for more than 180 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> modprobe D f26ebeec 0 263 1 0x00000000
> f26ebf58 00000046 00000006 f26ebeec c0b1fc00 f261d280 c0b1fc00 c0b1fc00
> f261d4fc c0b1fc00 7bff03b0 00000032 00000000 00000032 f261d280 00000000
> 00000007 f261d280 c07fc13c 00000002 f26ebf28 c04619c3 c0a6bb34 00000246
> Call Trace:
> [<c07fc13c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
> [<c04619c3>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c04619ef>] ? trace_hardirqs_on+0xb/0xd
> [<c045153c>] ? prepare_to_wait+0x56/0x5c
> [<c067e89b>] wait_for_device_probe+0x5d/0x76
> [<c0451360>] ? wake_up_bit+0x60/0x60
> [<f8563008>] wait_scan_init+0x8/0x11 [scsi_wait_scan]
> [<c040115e>] do_one_initcall+0x76/0x126
> [<f8563000>] ? 0xf8562fff
> [<c046b929>] sys_init_module+0x7c/0x1a8
> [<c0801d98>] sysenter_do_call+0x12/0x38
> no locks held by modprobe/263.
> INFO: task modprobe:263 blocked for more than 180 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> modprobe D f26ebeec 0 263 1 0x00000000
> f26ebf58 00000046 00000006 f26ebeec c0b1fc00 f261d280 c0b1fc00 c0b1fc00
> f261d4fc c0b1fc00 7bff03b0 00000032 00000000 00000032 f261d280 00000000
> 00000007 f261d280 c07fc13c 00000002 f26ebf28 c04619c3 c0a6bb34 00000246
> Call Trace:
> [<c07fc13c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
> [<c04619c3>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c04619ef>] ? trace_hardirqs_on+0xb/0xd
> [<c045153c>] ? prepare_to_wait+0x56/0x5c
> [<c067e89b>] wait_for_device_probe+0x5d/0x76
> [<c0451360>] ? wake_up_bit+0x60/0x60
> [<f8563008>] wait_scan_init+0x8/0x11 [scsi_wait_scan]
> [<c040115e>] do_one_initcall+0x76/0x126
> [<f8563000>] ? 0xf8562fff
> [<c046b929>] sys_init_module+0x7c/0x1a8
> [<c0801d98>] sysenter_do_call+0x12/0x38
> no locks held by modprobe/263.
> INFO: task modprobe:263 blocked for more than 180 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> modprobe D f26ebeec 0 263 1 0x00000000
> f26ebf58 00000046 00000006 f26ebeec c0b1fc00 f261d280 c0b1fc00 c0b1fc00
> f261d4fc c0b1fc00 7bff03b0 00000032 00000000 00000032 f261d280 00000000
> 00000007 f261d280 c07fc13c 00000002 f26ebf28 c04619c3 c0a6bb34 00000246
> Call Trace:
> [<c07fc13c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
> [<c04619c3>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c04619ef>] ? trace_hardirqs_on+0xb/0xd
> [<c045153c>] ? prepare_to_wait+0x56/0x5c
> [<c067e89b>] wait_for_device_probe+0x5d/0x76
> [<c0451360>] ? wake_up_bit+0x60/0x60
> [<f8563008>] wait_scan_init+0x8/0x11 [scsi_wait_scan]
> [<c040115e>] do_one_initcall+0x76/0x126
> [<f8563000>] ? 0xf8562fff
> [<c046b929>] sys_init_module+0x7c/0x1a8
> [<c0801d98>] sysenter_do_call+0x12/0x38
> no locks held by modprobe/263.
> INFO: task modprobe:263 blocked for more than 180 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> modprobe D f26ebeec 0 263 1 0x00000000
> f26ebf58 00000046 00000006 f26ebeec c0b1fc00 f261d280 c0b1fc00 c0b1fc00
> f261d4fc c0b1fc00 7bff03b0 00000032 00000000 00000032 f261d280 00000000
> 00000007 f261d280 c07fc13c 00000002 f26ebf28 c04619c3 c0a6bb34 00000246
> Call Trace:
> [<c07fc13c>] ? _raw_spin_unlock_irqrestore+0x41/0x4d
> [<c04619c3>] ? trace_hardirqs_on_caller+0x10e/0x12f
> [<c04619ef>] ? trace_hardirqs_on+0xb/0xd
> [<c045153c>] ? prepare_to_wait+0x56/0x5c
> [<c067e89b>] wait_for_device_probe+0x5d/0x76
> [<c0451360>] ? wake_up_bit+0x60/0x60
> [<f8563008>] wait_scan_init+0x8/0x11 [scsi_wait_scan]
> [<c040115e>] do_one_initcall+0x76/0x126
> [<f8563000>] ? 0xf8562fff
> [<c046b929>] sys_init_module+0x7c/0x1a8
> [<c0801d98>] sysenter_do_call+0x12/0x38
> no locks held by modprobe/263.
> SysRq : Show Locks Held
>
> Showing all locks held in the system:
> 7 locks held by modprobe/100:
> #0: (&__lockdep_no_validate__){+.+.+.}, at: [<c067e724>]
> __driver_attach+0x31/0x6b
> #1: (&__lockdep_no_validate__){+.+.+.}, at: [<c067e730>]
> __driver_attach+0x3d/0x6b
> #2: (drm_global_mutex){+.+.+.}, at: [<f810a024>]
> drm_get_pci_dev+0xad/0x21b [drm]
> #3: (&(&i->lock)->rlock){-.-...}, at: [<c066a101>]
> serial8250_interrupt+0x23/0xe9
> #4: (&port_lock_key){-.-...}, at: [<c0669e59>]
> serial8250_handle_port+0x15/0x29a
> #5: (sysrq_key_table_lock){-.....}, at: [<c065a4cc>]
> __handle_sysrq+0x1d/0x115
> #6: (tasklist_lock){.+.+..}, at: [<c0461000>]
> debug_show_all_locks+0x41/0x16b
>
> =============================================
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

