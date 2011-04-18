Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1DROVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:21:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60329 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754078Ab1DROVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:21:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+TGE0jj/mTtMD7o8MX0MqsszUo2nCxm7QKtPSzFp
	IaIp5otAXqbaS0
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
References: <1302170153.12304.31.camel@marge.simson.net>
	 <4DA50430.8020701@cn.fujitsu.com>
	 <1302664313.7407.29.camel@marge.simson.net>
	 <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 16:21:34 +0200
Message-ID: <1303136494.7542.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 15:16 +0200, Paul Menage wrote:

> Also, I'd be concerned that subsystems might get confused by the fact
> that a new group called 'foo' could be created before the old 'foo'
> has been cleaned up?

Decided to try beating on that without my hack.  Seems these patches...
     patches/cgroup-Set-CGRP_RELEASABLE-when-adding-to-a-group
     patches/cgroup-Remove-call-to-synchronize_rcu-in-cgroup_attach_task
...either introduced a bug, or made an existing one easier to hit.  With
only those two applied, and several tasks doing - create, attach,
detach, fork off a rmdir - all for the same cgroup, box griped.

With my hack on top, I'd either see rcu workers explode, or list
corruption in cgroup_attach_task(), depending on phase-of-moon.

(hohum, maybe it'll turn out to be a defenseless _baby_ dragon..)

v2.6.39-rc2

[ 5009.808292] general protection fault: 0000 [#1] SMP 
[ 5009.812007] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[ 5009.812007] CPU 2 
[ 5009.812007] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfsd lockd nfs_acl auth_rpcgss sunrpc parport_pc parport bridge stp cpufreq_conservative cpufreq_ondemand microcode cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf nls_iso8859_1 nls_cp437 vfat fat fuse ext3 jbd dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm sr_mod sg usb_storage usbmouse cdrom snd_timer usbhid hid firewire_ohci firewire_core snd usb_libusual i2c_i801 soundcore snd_page_alloc e1000e crc_itu_t button ext4 mbcache jbd2 crc16 uhci_hcd ehci_hcd sd_mod rtc_cmos usbcore rtc_core rtc_lib ahci libahci libata scsi_mod fan processor thermal
[ 5009.812007] 
[ 5009.812007] Pid: 21021, comm: rmdir Not tainted 2.6.39-smpx #1906 MEDIONPC MS-7502/MS-7502
[ 5009.812007] RIP: 0010:[<ffffffff81079bb5>]  [<ffffffff81079bb5>] cgroup_css_sets_empty+0x25/0x50
[ 5009.812007] RSP: 0018:ffff88017dfe5dd8  EFLAGS: 00010246
[ 5009.812007] RAX: dead000000100100 RBX: 0000000000000000 RCX: ffff880228c8ce50
[ 5009.812007] RDX: dead000000100100 RSI: ffff88022db9b900 RDI: ffff880228c8cc00
[ 5009.812007] RBP: ffff88017dfe5dd8 R08: 0000000000000005 R09: ffff88022db9b93c
[ 5009.812007] R10: ffff88017dfe5d18 R11: ffff88017dfe5c84 R12: ffff880228c8cc00
[ 5009.812007] R13: ffff88017dfe5df8 R14: ffff880228c8cc20 R15: ffff8802161cd240
[ 5009.812007] FS:  00007fefea0a1700(0000) GS:ffff88022fd00000(0000) knlGS:0000000000000000
[ 5009.812007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5009.955702] CR2: 00007fefe9c1acb0 CR3: 000000019107c000 CR4: 00000000000006e0
[ 5009.955702] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5009.955702] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5009.955702] Process rmdir (pid: 21021, threadinfo ffff88017dfe4000, task ffff8802161cd240)
[ 5009.955702] Stack:
[ 5009.955702]  ffff88017dfe5e58 ffffffff8107a514 ffff88022db9b9a0 ffff88022db9badc
[ 5009.955702]  0000000000000000 ffff8802161cd240 ffffffff81057ee0 ffff88017dfe5e10
[ 5009.955702]  ffff88017dfe5e10 0000000000000000 0000000000000001 ffff88022db9b900
[ 5009.955702] Call Trace:
[ 5009.955702]  [<ffffffff8107a514>] cgroup_rmdir+0x64/0x510
[ 5009.955702]  [<ffffffff81057ee0>] ? wake_up_bit+0x40/0x40
[ 5009.955702]  [<ffffffff810d46c6>] vfs_rmdir+0x96/0xe0
[ 5009.955702]  [<ffffffff810d6313>] do_rmdir+0x103/0x120
[ 5009.955702]  [<ffffffff810d6e21>] sys_rmdir+0x11/0x20
[ 5009.955702]  [<ffffffff8134db7b>] system_call_fastpath+0x16/0x1b
[ 5009.955702] Code: 84 00 00 00 00 00 55 48 8b 87 50 02 00 00 48 89 e5 48 8d 8f 50 02 00 00 eb 11 0f 1f 40 00 48 8b 40 28 8b 00 85 c0 7f 1e 48 89 d0 
[ 5009.955702]  8b 10 48 39 c8 0f 18 0a 75 e8 b8 01 00 00 00 c9 c3 66 0f 1f 
[ 5009.955702] RIP  [<ffffffff81079bb5>] cgroup_css_sets_empty+0x25/0x50
[ 5009.955702]  RSP <ffff88017dfe5dd8>
[ 5010.075058] hpet1: lost 12 rtc interrupts
[ 5010.079153] ---[ end trace df95d1af02295a25 ]---

(gdb) list *cgroup_css_sets_empty+0x25
0xffffffff81079df5 is in cgroup_css_sets_empty (kernel/cgroup.c:3589).
3584     * Must be called with css_set_lock held */
3585    static int cgroup_css_sets_empty(struct cgroup *cgrp)
3586    {
3587            struct cg_cgroup_link *link;
3588
3589            list_for_each_entry(link, &cgrp->css_sets, cgrp_link_list) {
3590                    struct css_set *cg = link->cg;
3591                    if (atomic_read(&cg->refcount) > 0)
3592                            return 0;
3593            }
(gdb)


