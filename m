Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab1DNH0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:26:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45009 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752960Ab1DNH0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:26:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX199dDRuuTJ94LkX6q8co0lvK88eIsEs7BEDDNyhZJ
	ma2YIiTvVTLial
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1302713819.7448.22.camel@marge.simson.net>
References: <1302170153.12304.31.camel@marge.simson.net>
	 <4DA50430.8020701@cn.fujitsu.com>
	 <1302664313.7407.29.camel@marge.simson.net>
	 <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
	 <1302713819.7448.22.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 09:26:39 +0200
Message-ID: <1302765999.8042.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 18:56 +0200, Mike Galbraith wrote:
> On Wed, 2011-04-13 at 15:16 +0200, Paul Menage wrote:
> > On Wed, Apr 13, 2011 at 5:11 AM, Mike Galbraith <efault@gmx.de> wrote:
> > > If the user _does_ that rmdir(), it's more or less back to square one.
> > > RCU grace periods should not impact userland, but if you try to do
> > > create/attach/detach/destroy, you run into the same bottleneck, as does
> > > any asynchronous GC, though that's not such a poke in the eye.  I tried
> > > a straight forward move to schedule_work(), and it seems to work just
> > > fine.  rmdir() no longer takes ~30ms on my box, but closer to 20us.
> > 
> > > +       /*
> > > +        * Release the subsystem state objects.
> > > +        */
> > > +       for_each_subsys(cgrp->root, ss)
> > > +               ss->destroy(ss, cgrp);
> > > +
> > > +       cgrp->root->number_of_cgroups--;
> > > +       mutex_unlock(&cgroup_mutex);
> > > +
> > > +       /*
> > > +        * Drop the active superblock reference that we took when we
> > > +        * created the cgroup
> > > +        */
> > > +       deactivate_super(cgrp->root->sb);
> > > +
> > > +       /*
> > > +        * if we're getting rid of the cgroup, refcount should ensure
> > > +        * that there are no pidlists left.
> > > +        */
> > > +       BUG_ON(!list_empty(&cgrp->pidlists));
> > > +
> > > +       kfree(cgrp);
> > 
> > We might want to punt this through RCU again, in case the subsystem
> > destroy() callbacks left anything around that was previously depending
> > on the RCU barrier.
> > 
> > Also, I'd be concerned that subsystems might get confused by the fact
> > that a new group called 'foo' could be created before the old 'foo'
> > has been cleaned up? (And do any subsystems rely on being able to
> > access the cgroup dentry up until the point when destroy() is called?
> 
> Yeah, I already have head scratching sessions planned for these, why I
> used 'seems' to work fine, and Not-signed-off-by: :)

Definitely-not-signed-off-by: /me

Multiple threads...

[  155.009282] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  155.009286] IP: [<ffffffff810511fb>] process_one_work+0x3b/0x370
[  155.009293] PGD 22c5f7067 PUD 22980c067 PMD 0 
[  155.009296] Oops: 0000 [#1] SMP 
[  155.009298] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[  155.009301] CPU 0 
[  155.009302] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfsd lockd nfs_acl auth_rpcgss sunrpc parport_pc parport bridge stp cpufreq_conservative microcode cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf nls_iso8859_1 nls_cp437 vfat fat fuse ext3 jbd dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm sr_mod usbmouse usbhid usb_storage sg hid firewire_ohci cdrom e1000e snd_timer usb_libusual firewire_core i2c_i801 snd soundcore snd_page_alloc crc_itu_t button ext4 mbcache jbd2 crc16 uhci_hcd ehci_hcd sd_mod rtc_cmos usbcore rtc_core rtc_lib ahci libahci libata scsi_mod fan processor thermal
[  155.009331] 
[  155.009333] Pid: 7924, comm: kworker/0:14 Not tainted 2.6.39-smpxx #1905 MEDIONPC MS-7502/MS-7502
[  155.009336] RIP: 0010:[<ffffffff810511fb>]  [<ffffffff810511fb>] process_one_work+0x3b/0x370
[  155.009340] RSP: 0018:ffff880228ae5e00  EFLAGS: 00010003
[  155.009341] RAX: ffff8802295ece48 RBX: ffff880229881500 RCX: 0000000000000000
[  155.009343] RDX: 07fffc40114af672 RSI: ffff8802295ece48 RDI: 001ffff100452bd9
[  155.009345] RBP: ffff880228ae5e50 R08: ffff88022a0b9e50 R09: ffff88022a0baab0
[  155.009346] R10: dead000000200200 R11: 0000000000000001 R12: ffff88022fc0d980
[  155.009348] R13: 0000000000000000 R14: ffffffff8107bc40 R15: 0000000000011d00
[  155.009350] FS:  0000000000000000(0000) GS:ffff88022fc00000(0000) knlGS:0000000000000000
[  155.009352] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  155.009354] CR2: 0000000000000000 CR3: 0000000228f61000 CR4: 00000000000006f0
[  155.009355] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  155.009357] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  155.009359] Process kworker/0:14 (pid: 7924, threadinfo ffff880228ae4000, task ffff8801e6895240)
[  155.009360] Stack:
[  155.009361]  ffff880228ae5e50 ffffffff81051758 ffffffff00000000 0000000100000082
[  155.009364]  0000000000000000 ffff880229881500 ffff88022fc0d980 ffff880229881520
[  155.009366]  ffff88022fc0d988 0000000000011d00 ffff880228ae5ee0 ffffffff81051911
[  155.009371] Call Trace:
[  155.009374]  [<ffffffff81051758>] ? manage_workers+0x1e8/0x240
[  155.009377]  [<ffffffff81051911>] worker_thread+0x161/0x330
[  155.009380]  [<ffffffff8102a129>] ? __wake_up_common+0x59/0x90
[  155.009384]  [<ffffffff8105c8cf>] ? switch_task_namespaces+0x1f/0x60
[  155.009386]  [<ffffffff810517b0>] ? manage_workers+0x240/0x240
[  155.009389]  [<ffffffff81057a26>] kthread+0x96/0xa0
[  155.009392]  [<ffffffff8134e894>] kernel_thread_helper+0x4/0x10
[  155.009394]  [<ffffffff81057990>] ? kthread_worker_fn+0x190/0x190
[  155.009397]  [<ffffffff8134e890>] ? gs_change+0xb/0xb
[  155.009399] Code: 41 54 53 48 89 fb 48 83 ec 28 48 89 f7 48 8b 16 4c 8b 76 18 48 89 d1 30 c9 83 e2 04 48 89 f2 4c 0f 45 e9 48 c1 ea 05 48 c1 ef 0b <4d> 8b 65 00 48 01 d7 49 8b 55 08 83 e7 3f 8b 12 4d 8b 44 fc 38 
[  155.009416] RIP  [<ffffffff810511fb>] process_one_work+0x3b/0x370
[  155.009418]  RSP <ffff880228ae5e00>
[  155.009419] CR2: 0000000000000000
[  155.009422] ---[ end trace ee5a315197a1a60e ]---

....dead box

