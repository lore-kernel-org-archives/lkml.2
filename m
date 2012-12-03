Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab2LCFgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:36:20 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33805 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2LCFgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:36:19 -0500
Date: Mon, 3 Dec 2012 06:36:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [patch] Re: [RFC GIT PULL] scheduler fix for autogroups
Message-ID: <20121203053614.GB27014@gmail.com>
References: <20121201111609.GA18679@gmail.com>
 <CA+55aFx_yJbonbEC5AYteyNv+qWbG-H=yj_=YaiJHwKyu4FH3Q@mail.gmail.com>
 <20121201214438.GA6544@gmail.com>
 <1354436468.7048.35.camel@marge.simpson.net>
 <20121202192733.GA19824@gmail.com>
 <CA+55aFxcoLuVcrxmRQ8E2d6hXQZLrg8_rzmdSL2Qn3w8VthfSg@mail.gmail.com>
 <1354512325.7203.12.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354512325.7203.12.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > Willing to write a changelog with the pointer to the actual 
> > oops that happens due to this issue?
> 
> I don't have a link, so reproduced/captured it.  With 
> systemd-sysvinit (bleh) installed, it's trivial to reproduce:
> 
> Add echo 0 > /proc/sys/kernel/sched_autogroup_enabled to /root/.bashrc
> (or wherever), boot box, type reboot, box explodes.
> 
> revert 800d4d30 sched, autogroup: Stop going ahead if autogroup is disabled
> 
> Between 8323f26ce and 800d4d30, autogroup is a wreck.  With both

Slightly decoded, for our human readers:

 8323f26ce342 ("sched: Fix race in task_group()")

:-)

> applied, all you have to do to crash a box is disable autogroup
> during boot up, then reboot.. boom, NULL pointer dereference due
> to 800d4d30 not allowing autogroup to move things, and 8323f26ce
> making that the only way to switch runqueues.
>     
> [  202.187747] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  202.191644] IP: [<ffffffff81063ac0>] effective_load.isra.43+0x50/0x90
> [  202.191644] PGD 220a74067 PUD 220402067 PMD 0 
> [  202.191644] Oops: 0000 [#1] SMP 
> [  202.191644] Modules linked in: nfs nfsd fscache lockd nfs_acl auth_rpcgss sunrpc exportfs bridge stp cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf ext3 jbd fuse nls_iso8859_1 snd_hda_codec_realtek nls_cp437 snd_hda_intel vfat fat snd_hda_codec e1000e sr_mod snd_hwdep cdrom snd_pcm sg snd_timer usb_storage snd firewire_ohci usb_libusual firewire_core soundcore uas snd_page_alloc i2c_i801 coretemp edd microcode hid_generic button crc_itu_t ipv6 autofs4 ext4 mbcache jbd2 crc16 usbhid hid sd_mod uhci_hcd ahci libahci libata rtc_cmos ehci_hcd scsi_mod thermal fan usbcore processor usb_common
> [  202.191644] CPU 0 
> [  202.191644] Pid: 7047, comm: systemd-user-se Not tainted 3.6.8-smp #7 MEDIONPC MS-7502/MS-7502
> [  202.191644] RIP: 0010:[<ffffffff81063ac0>]  [<ffffffff81063ac0>] effective_load.isra.43+0x50/0x90
> [  202.191644] RSP: 0018:ffff880221ddfbd8  EFLAGS: 00010086
> [  202.191644] RAX: 0000000000000400 RBX: ffff88022621d880 RCX: 0000000000000000
> [  202.191644] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff880220a363a0
> [  202.191644] RBP: ffff880221ddfbd8 R08: 0000000000000400 R09: 00000000000115c0
> [  202.191644] R10: 0000000000000000 R11: 0000000000000400 R12: ffff8802214ed180
> [  202.191644] R13: 00000000000003fd R14: 0000000000000000 R15: 0000000000000003
> [  202.191644] FS:  00007f174a81c7a0(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
> [  202.191644] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  202.191644] CR2: 0000000000000000 CR3: 0000000221fad000 CR4: 00000000000007f0
> [  202.191644] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  202.191644] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  202.191644] Process systemd-user-se (pid: 7047, threadinfo ffff880221dde000, task ffff88022618b3a0)
> [  202.191644] Stack:
> [  202.191644]  ffff880221ddfc88 ffffffff81063d55 0000000000000400 00000000000115c0
> [  202.191644]  ffff88022235c218 ffffffff814ef9e8 ffffea0000000000 ffff88022621d880
> [  202.191644]  ffff880227007200 ffffffff00000003 0000000000000010 0000000000018f38
> [  202.191644] Call Trace:
> [  202.191644]  [<ffffffff81063d55>] select_task_rq_fair+0x255/0x780
> [  202.191644]  [<ffffffff810607e6>] try_to_wake_up+0x156/0x2c0
> [  202.191644]  [<ffffffff8106098b>] wake_up_state+0xb/0x10
> [  202.191644]  [<ffffffff81044f88>] signal_wake_up+0x28/0x40
> [  202.191644]  [<ffffffff81045406>] complete_signal+0x1d6/0x250
> [  202.191644]  [<ffffffff810455f0>] __send_signal+0x170/0x310
> [  202.191644]  [<ffffffff810457d0>] send_signal+0x40/0x80
> [  202.191644]  [<ffffffff81046257>] do_send_sig_info+0x47/0x90
> [  202.191644]  [<ffffffff8104649a>] group_send_sig_info+0x4a/0x70
> [  202.191644]  [<ffffffff810465ba>] kill_pid_info+0x3a/0x60
> [  202.191644]  [<ffffffff81047ac7>] sys_kill+0x97/0x1a0
> [  202.191644]  [<ffffffff810ebc10>] ? vfs_read+0x120/0x160
> [  202.191644]  [<ffffffff810ebc95>] ? sys_read+0x45/0x90
> [  202.191644]  [<ffffffff8134bde2>] system_call_fastpath+0x16/0x1b
> [  202.191644] Code: 49 0f af 41 50 31 d2 49 f7 f0 48 83 f8 01 48 0f 46 c6 48 2b 07 48 8b bf 40 01 00 00 48 85 ff 74 3a 45 31 c0 48 8b 8f 50 01 00 00 <48> 8b 11 4c 8b 89 80 00 00 00 49 89 d2 48 01 d0 45 8b 59 58 4c 
> [  202.191644] RIP  [<ffffffff81063ac0>] effective_load.isra.43+0x50/0x90
> [  202.191644]  RSP <ffff880221ddfbd8>
> [  202.191644] CR2: 0000000000000000
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Yong Zhang <yong.zhang0@gmail.com>
> Cc: stable@vger.kernel.org

Thanks Mike!

Acked-by: Ingo Molnar <mingo@kernel.org>

	Ingo
