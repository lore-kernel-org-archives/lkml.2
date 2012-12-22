Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab2LVR5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 12:57:22 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37499 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2LVR5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 12:57:17 -0500
Subject: Re: Regression in 3.8-rc1:  "BUG: sleeping function called from
 invalid context"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <50D5E9D9.3070904@lwfinger.net>
References: <50D5E9D9.3070904@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Dec 2012 09:57:14 -0800
Message-ID: <1356199034.21834.8457.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-22 at 11:11 -0600, Larry Finger wrote:
> With kernel 3.8-rc1, I get 2 "BUG: sleeping function called from invalid 
> context" reports. These have been present got some time in the 3.7-git versions 
> and I have tried twice to bisect the problem. Both times, I ended up at a merge 
> commit. The most recent found commit a11da7d as the bad one, and commit d7460f4 
> as the last good one. I have not had time to make a third try.
> 
> My system is x86_64 running on an HP laptop with a dual-core AMD CPU. My 
> configuration file is attached.
> 
> The logged details are as follows:
> 
> [   31.715016] BUG: sleeping function called from invalid context at mm/slub.c:925
> [   31.715022] in_atomic(): 1, irqs_disabled(): 0, pid: 2129, name: udevd
> [   31.715025] 2 locks held by udevd/2129:
> [   31.715028]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81386382>] 
> rtnl_lock+0x12/0x20
> [   31.715041]  #1:  (devnet_rename_seq){+.+.+.}, at: [<ffffffff81376033>] 
> dev_change_name+0x43/0x260
> [   31.715053] Pid: 2129, comm: udevd Not tainted 3.8.0-rc1 #56
> [   31.715056] Call Trace:
> [   31.715063]  [<ffffffff81076ca2>] __might_sleep+0x152/0x250
> [   31.715068]  [<ffffffff8114a353>] __kmalloc_track_caller+0x103/0x280
> [   31.715073]  [<ffffffff812d595d>] ? device_rename+0x4d/0xf0
> [   31.715078]  [<ffffffff8111d675>] kstrdup+0x35/0x70
> [   31.715082]  [<ffffffff812d595d>] device_rename+0x4d/0xf0
> [   31.715086]  [<ffffffff813760ca>] dev_change_name+0xda/0x260
> [   31.715091]  [<ffffffff81377f51>] dev_ifsioc+0x241/0x3a0
> [   31.715095]  [<ffffffff81378410>] dev_ioctl+0x360/0x830
> [   31.715101]  [<ffffffff810a54cd>] ? trace_hardirqs_on+0xd/0x10
> [   31.715106]  [<ffffffff8135b711>] sock_do_ioctl.constprop.41+0x41/0x50
> [   31.715109]  [<ffffffff8135b9c6>] sock_ioctl+0x66/0x2b0
> [   31.715115]  [<ffffffff811637b7>] do_vfs_ioctl+0x97/0x580
> [   31.715119]  [<ffffffff8116f27a>] ? fget_light+0x3da/0x4d0
> [   31.715124]  [<ffffffff81422a55>] ? sysret_check+0x22/0x5d
> [   31.715128]  [<ffffffff81163ceb>] sys_ioctl+0x4b/0x90
> [   31.715133]  [<ffffffff8121a69e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   31.715136]  [<ffffffff81422a29>] system_call_fastpath+0x16/0x1b
> [   31.715764] BUG: scheduling while atomic: udevd/2129/0x00000002
> [   31.715768] 2 locks held by udevd/2129:
> [   31.715769]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81386382>] 
> rtnl_lock+0x12/0x20
> [   31.715779]  #1:  (devnet_rename_seq){+.+.+.}, at: [<ffffffff81376033>] 
> dev_change_name+0x43/0x260
> [   31.715787] Modules linked in: b43 arc4 rtl8723ae rtlwifi mac80211 
> snd_hda_codec_conexant snd_hda_intel snd_hda_codec cfg80211 powernow_k8 kvm_amd 
> snd_pcm_oss kvm snd_pcm snd_seq bcma rng_core ssb snd_timer mmc_core 
> snd_seq_device pcmcia rfkill snd sr_mod cdrom soundcore ehci_pci battery 
> pcmcia_core sg k8temp ac i2c_nforce2 hwmon forcedeth video snd_page_alloc 
> serio_raw i2c_core joydev wmi button ipv6 autofs4 ext4 mbcache jbd2 crc16 
> ohci_hcd ehci_hcd usbcore usb_common thermal processor scsi_dh_rdac scsi_dh_alua 
> scsi_dh_emc scsi_dh_hp_sw scsi_dh ata_generic pata_amd
> [   31.715867] Pid: 2129, comm: udevd Not tainted 3.8.0-rc1 #56
> [   31.715868] Call Trace:
> [   31.715874]  [<ffffffff8141987c>] __schedule_bug+0x62/0x70
> [   31.715878]  [<ffffffff81420160>] __schedule+0x730/0xa30
> [   31.715883]  [<ffffffff810a3982>] ? __lock_acquire+0x12d2/0x1c50
> [   31.715888]  [<ffffffff81420744>] schedule+0x24/0x70
> [   31.715893]  [<ffffffff8141dc5c>] schedule_timeout+0x18c/0x2f0
> [   31.715897]  [<ffffffff810a52ac>] ? mark_held_locks+0x8c/0x110
> [   31.715902]  [<ffffffff81421b9b>] ? _raw_spin_unlock_irq+0x2b/0x50
> [   31.715906]  [<ffffffff810a5435>] ? trace_hardirqs_on_caller+0x105/0x190
> [   31.715911]  [<ffffffff810a54cd>] ? trace_hardirqs_on+0xd/0x10
> [   31.715915]  [<ffffffff814205d5>] wait_for_common+0xe5/0x180
> [   31.715919]  [<ffffffff8107d010>] ? try_to_wake_up+0x2d0/0x2d0
> [   31.715924]  [<ffffffff81420718>] wait_for_completion+0x18/0x20
> [   31.715929]  [<ffffffff8105f48c>] call_usermodehelper_exec+0x19c/0x1d0
> [   31.715935]  [<ffffffff8105f592>] call_usermodehelper_fns+0xd2/0x100
> [   31.715941]  [<ffffffff8121211d>] kobject_uevent_env+0x47d/0x4b0
> [   31.715946]  [<ffffffff812110df>] kobject_rename+0x12f/0x140
> [   31.715951]  [<ffffffff812d59db>] device_rename+0xcb/0xf0
> [   31.715955]  [<ffffffff813760ca>] dev_change_name+0xda/0x260
> [   31.715960]  [<ffffffff81377f51>] dev_ifsioc+0x241/0x3a0
> [   31.715965]  [<ffffffff81378410>] dev_ioctl+0x360/0x830
> [   31.715969]  [<ffffffff810a54cd>] ? trace_hardirqs_on+0xd/0x10
> [   31.715974]  [<ffffffff8135b711>] sock_do_ioctl.constprop.41+0x41/0x50
> [   31.715978]  [<ffffffff8135b9c6>] sock_ioctl+0x66/0x2b0
> [   31.715982]  [<ffffffff811637b7>] do_vfs_ioctl+0x97/0x580
> [   31.715987]  [<ffffffff8116f27a>] ? fget_light+0x3da/0x4d0
> [   31.715991]  [<ffffffff81422a55>] ? sysret_check+0x22/0x5d
> [   31.716092]  [<ffffffff81163ceb>] sys_ioctl+0x4b/0x90
> [   31.716097]  [<ffffffff8121a69e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   31.716102]  [<ffffffff81422a29>] system_call_fastpath+0x16/0x1b

Thanks for the report

Fix is in David tree : 

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commitdiff;h=30e6c9fa93cf3dbc7cc6df1d748ad25e4264545a



