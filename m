Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0HTTcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 15:32:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36912 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab0HTTcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 15:32:14 -0400
Date: Fri, 20 Aug 2010 12:32:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.36-rc1 hangs during XFS barrier test for /
Message-ID: <20100820193211.GE2447@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTim1PXibiY98GUdMj-UZLTav+n7GAnJ0Mjn6_5a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim1PXibiY98GUdMj-UZLTav+n7GAnJ0Mjn6_5a3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 05:08:17PM +0200, Torsten Kaiser wrote:
> Hello,
> 
> after installing 2.6.36-rc1 my system gets stuck during "Mounting root..."
> 
> I'm using an initramfs to mount the root fs, because I'm using a
> stacked setup with md (raid1) -> dm-crypt -> xfs.
> 
> Strange side effect: sometimes the cursor stops blinking for a few
> seconds, but then resumes blinking. Each of these blinking stalls are
> accompanied by a RCU stall message.

This indicates that you have a "longer than average loop", probably
with interrupts disabled across the loop.  Documentation/RCU/stallwarn.txt
has more information on this condition.

							Thanx, Paul

> >From the serial console:
> [    8.039603] Freeing unused kernel memory: 564k freed
> [    8.049070] Write protecting the kernel read-only data: 10240k
> [    8.059173] Freeing unused kernel memory: 604k freed
> [    8.068930] Freeing unused kernel memory: 1732k freed
> [   40.364439] SysRq : Changing Loglevel
> [   40.371605] Loglevel set to 6
> [   56.760017] INFO: rcu_sched_state detected stalls on CPUs/tasks: {
> 2} (detected by 0, t=4004 jiffies)
> [   86.780016] INFO: rcu_sched_state detected stalls on CPUs/tasks: {
> 2} (detected by 0, t=7006 jiffies)
> [  116.800018] INFO: rcu_sched_state detected stalls on CPUs/tasks: {
> 2} (detected by 0, t=10008 jiffies)
> [  146.820018] INFO: rcu_sched_state detected stalls on CPUs/tasks: {
> 2} (detected by 0, t=13010 jiffies)
> [  159.135015] SysRq : Show Blocked State
> [  159.142014]  ffff88007f7449f0 0000000000000046 ffff8800071abd10
> ffff880000000000
> [  159.145007]  ffff88007ff4f770 0000000000012740 ffff8800071abfd8
> 0000000000012740
> [  159.145007]  ffff8800071abfd8 ffff88007f744c50 ffff8800071abfd8
> ffff88007f744c48
> [  159.145007] Call Trace:
> [  159.145007]  [<ffffffff8143ef40>] ? dm_wq_work+0x0/0x1a0
> [  159.145007]  [<ffffffff8155e7fd>] ? io_schedule+0x3d/0x60
> [  159.145007]  [<ffffffff8143e13a>] ? dm_wait_for_completion+0xba/0x150
> [  159.145007]  [<ffffffff81035870>] ? default_wake_function+0x0/0x20
> [  159.145007]  [<ffffffff8143ef40>] ? dm_wq_work+0x0/0x1a0
> [  159.145007]  [<ffffffff8143ef40>] ? dm_wq_work+0x0/0x1a0
> [  159.230029]  [<ffffffff8143ef82>] ? dm_wq_work+0x42/0x1a0
> [  159.230029]  [<ffffffff8104d21b>] ? process_one_work+0xfb/0x370
> [  159.230029]  [<ffffffff8104ed7c>] ? worker_thread+0x16c/0x360
> [  159.230029]  [<ffffffff8104ec10>] ? worker_thread+0x0/0x360
> [  159.230029]  [<ffffffff8104ec10>] ? worker_thread+0x0/0x360
> [  159.230029]  [<ffffffff81052926>] ? kthread+0x96/0xa0
> [  159.230029]  [<ffffffff81003194>] ? kernel_thread_helper+0x4/0x10
> [  159.230029]  [<ffffffff81052890>] ? kthread+0x0/0xa0
> [  159.230029]  [<ffffffff81003190>] ? kernel_thread_helper+0x0/0x10
> [  159.230029]  ffff88011eda5b00 0000000000000086 0000000000012740
> ffffffff00000000
> [  159.230029]  ffffffff81a0d020 0000000000012740 ffff88011ed33fd8
> 0000000000012740
> [  159.230029]  ffff88011ed33fd8 ffff88011eda5d60 ffff88011ed33fd8
> ffff88011eda5d58
> [  159.230029] Call Trace:
> [  159.230029]  [<ffffffff8155eae5>] ? schedule_timeout+0x1c5/0x220
> [  159.230029]  [<ffffffff8102d6c0>] ? __wake_up_common+0x50/0x80
> [  159.230029]  [<ffffffff8155df7d>] ? wait_for_common+0x11d/0x190
> [  159.230029]  [<ffffffff81035870>] ? default_wake_function+0x0/0x20
> [  159.230029]  [<ffffffff811b0e6a>] ? xfs_buf_iowait+0x1a/0x60
> [  159.230029]  [<ffffffff811b97d2>] ? xfs_barrier_test+0x42/0x90
> [  159.230029]  [<ffffffff811b9874>] ? xfs_mountfs_check_barriers+0x54/0x70
> [  159.230029]  [<ffffffff811b9b1d>] ? xfs_fs_fill_super+0x28d/0x2f0
> [  159.230029]  [<ffffffff810c1511>] ? get_sb_bdev+0x1a1/0x1e0
> [  159.230029]  [<ffffffff811b9890>] ? xfs_fs_fill_super+0x0/0x2f0
> [  159.230029]  [<ffffffff810c0b83>] ? vfs_kern_mount+0x83/0x1f0
> [  159.230029]  [<ffffffff810c0d63>] ? do_kern_mount+0x53/0x120
> [  159.230029]  [<ffffffff810d8aba>] ? do_mount+0x28a/0x890
> [  159.230029]  [<ffffffff8109211f>] ? memdup_user+0x3f/0x80
> [  159.230029]  [<ffffffff810d915a>] ? sys_mount+0x9a/0x100
> [  159.230029]  [<ffffffff8100246b>] ? system_call_fastpath+0x16/0x1b
> [  161.529671] SysRq : Emergency Sync
> [  164.016470] SysRq : Emergency Remount R/O
> [  166.492523] SysRq : Emergency Sync
> [  168.415529] SysRq : Resetting
> 
> The system is stuck at this point, with just the RCU messages
> repeating until I reboot.
> I did not see any OOPS or other error messages in the dmesg before this point.
> 
> 
> Unrelated additional problem: On bootup with 2.6.36-rc1 I get ~800
> bytes of random binary garbage via early_printk=serial. This does not
> happen with 2.6.35 and earlier kernels.
> 
> Restart with earlier kernel:
> [ 7816.426238] Restarting system.
> [    0.000000] Linux version 2.6.34-rc7 (root@treogen) (gcc version
> 4.4.3 (Gentoo 4.4.3-r2 p1.2) ) #1 SMP Mon May 10 19:45:19 CEST 2010
> [    0.000000] Command line: fastboot earlyprintk=serial,ttyS0,115200
> console=ttyS0,115200 console=tty1 crypt_root=/dev/md3 radeon.modeset=1
> video=1280x1024
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000dffd0000 (usable)
> [    0.000000]  BIOS-e820: 00000000dffd0000 - 00000000dffde000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000dffde000 - 00000000e0000000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI present.
> 
> Restart with 2.6.36-rc1:
> [202944.603598] Restarting system.
> {~800 byte of binary garbage}000100000 - 00000000dffd0000 (usable)
> [    0.000000]  BIOS-e820: 00000000dffd0000 - 00000000dffde000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000dffde000 - 00000000e0000000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI present.
> [    0.000000] No AGP bridge found
> [    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> 
> The later repeat is OK (even on 2.6.36-rc1), so I suspect some problem
> during the early init of the serial console, not some corruption of
> the dmesg itself:
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty1] enabled, bootconsole disabled
> [    0.000000] Linux version 2.6.36-rc1 (root@treogen) (gcc version
> 4.4.4 (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) ) #1 SMP Thu Aug 19 21:58:14
> CEST 2010
> [    0.000000] Command line: fastboot earlyprintk=serial,ttyS0,115200
> console=ttyS0,115200 console=tty1 crypt_root=/dev/md3 radeon.modeset=1
> video=1280x1024
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000dffd0000 (usable)
> [    0.000000]  BIOS-e820: 00000000dffd0000 - 00000000dffde000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000dffde000 - 00000000e0000000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI present.
> [    0.000000] No AGP bridge found
> [    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> 
> 
> Thanks for looking at this.
> 
> Torsten
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
