Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0GHKWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 06:22:16 -0400
Received: from mx4.sophos.com ([74.202.89.161]:34784 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab0GHKWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 06:22:15 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 06:22:14 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: BUG: Securityfs and bind mounts (2.6.34)
Date: Thu, 8 Jul 2010 11:12:41 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
CC: <greg@kroah.com>, Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Message-ID: <201007081112.41252.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/07/2010 11:12:41,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/07/2010 11:12:41,
	Serialize complete at 08/07/2010 11:12:41
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi guys,

If I overlay a file in securityfs using mount --bind with a file from a regular filesystem, should I be allowed to rmmod the module which registered
the overlaid securityfs file? I was able to do that, then I unmounted the bind mount, and then when attempting to unmount securityfs hit a BUG at
fs/dcache.c:676 (see below). It would have made more sense to first umount the overlay file and then remove the module which registered with
securityfs, nevertheless should kernel crash in this case?

Jul  8 10:33:46 deuteros kernel: [2486427.077574] BUG: Dentry ffff880102684f00{i=cb6e217,n=talpa} still in use (2) [unmount of securityfs
securityfs]
Jul  8 10:33:46 deuteros kernel: [2486427.077610] ------------[ cut here ]------------
Jul  8 10:33:46 deuteros kernel: [2486427.077618] kernel BUG at fs/dcache.c:676!
Jul  8 10:33:46 deuteros kernel: [2486427.077625] invalid opcode: 0000 [#1] PREEMPT SMP
Jul  8 10:33:46 deuteros kernel: [2486427.077634] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
Jul  8 10:33:46 deuteros kernel: [2486427.077642] CPU 0
Jul  8 10:33:46 deuteros kernel: [2486427.077645] Modules linked in: cpufreq_stats snd_seq_dummy sysprof_module nls_utf8 cifs snd_pcm_oss
snd_mixer_oss snd_seq snd_seq_device edd n
fs nfsd fscache lockd nfs_acl sunrpc exportfs af_packet radeon ttm drm_kms_helper drm i2c_algo_bit bridge stp llc cpufreq_conservative
cpufreq_userspace cpufreq_powersave acpi_cpuf
req fuse loop snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm dcdbas iTCO_wdt iTCO_vendor_support kvm_intel snd_timer tg3 snd
kvm intel_agp snd_page_alloc broad
com sr_mod cdrom button libphy pcspkr sg ext4 jbd2 crc16 linear raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx
raid1 raid0 dm_snapshot dm_mod fan p
rocessor thermal thermal_sys [last unloaded: talpa_syscallhook]
Jul  8 10:33:46 deuteros kernel: [2486427.077756]
Jul  8 10:33:46 deuteros kernel: [2486427.077763] Pid: 5328, comm: umount Not tainted 2.6.34 #3 0F0TGN/OptiPlex 380
Jul  8 10:33:46 deuteros kernel: [2486427.077771] RIP: 0010:[<ffffffff811085c8>]  [<ffffffff811085c8>] shrink_dcache_for_umount_subtree+0x268/0x270
Jul  8 10:33:46 deuteros kernel: [2486427.077787] RSP: 0018:ffff8800140f7de8  EFLAGS: 00010296
Jul  8 10:33:46 deuteros kernel: [2486427.077794] RAX: 000000000000007b RBX: ffff880102684f00 RCX: 0000000000000000
Jul  8 10:33:46 deuteros kernel: [2486427.077802] RDX: ffff880001800000 RSI: 0000000000000046 RDI: ffffffff81661e90
Jul  8 10:33:46 deuteros kernel: [2486427.077810] RBP: ffff8800140f7e18 R08: 0000000000000000 R09: 0000000000000005
Jul  8 10:33:46 deuteros kernel: [2486427.077818] R10: 0000000000000000 R11: 00000000000000be R12: 0000000000000002
Jul  8 10:33:46 deuteros kernel: [2486427.077826] R13: ffff880102684f00 R14: ffff8800173678a0 R15: ffff880129aa2be0
Jul  8 10:33:46 deuteros kernel: [2486427.077835] FS:  00007fdaa0dd8730(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
Jul  8 10:33:46 deuteros kernel: [2486427.077843] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jul  8 10:33:46 deuteros kernel: [2486427.077851] CR2: 00007fdaa06b3170 CR3: 0000000011fa9000 CR4: 00000000000406f0
Jul  8 10:33:46 deuteros kernel: [2486427.077859] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul  8 10:33:46 deuteros kernel: [2486427.077867] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul  8 10:33:46 deuteros kernel: [2486427.077876] Process umount (pid: 5328, threadinfo ffff8800140f6000, task ffff880129aa2be0)
Jul  8 10:33:46 deuteros kernel: [2486427.077884] Stack:
Jul  8 10:33:46 deuteros kernel: [2486427.077889]  ffff880129072e68 ffffffff810ece32 ffff880129072c00 ffffffff81406940
Jul  8 10:33:46 deuteros kernel: [2486427.077897] <0> ffffffff815cea40 ffff880129072c00 ffff8800140f7e38 ffffffff81108601
Jul  8 10:33:46 deuteros kernel: [2486427.077907] <0> 0000000000000000 ffff880129072c00 ffff8800140f7e58 ffffffff810f72ba
Jul  8 10:33:46 deuteros kernel: [2486427.077921] Call Trace:
Jul  8 10:33:46 deuteros kernel: [2486427.077930]  [<ffffffff810ece32>] ? add_partial+0x52/0x80
Jul  8 10:33:46 deuteros kernel: [2486427.077938]  [<ffffffff81108601>] shrink_dcache_for_umount+0x31/0x50
Jul  8 10:33:46 deuteros kernel: [2486427.077948]  [<ffffffff810f72ba>] generic_shutdown_super+0x1a/0x100
Jul  8 10:33:46 deuteros kernel: [2486427.077958]  [<ffffffff810f7401>] kill_anon_super+0x11/0x60
Jul  8 10:33:46 deuteros kernel: [2486427.077967]  [<ffffffff810f7472>] kill_litter_super+0x22/0x30
Jul  8 10:33:46 deuteros kernel: [2486427.077975]  [<ffffffff810f8730>] deactivate_super+0x70/0xa0
Jul  8 10:33:46 deuteros kernel: [2486427.077985]  [<ffffffff81110726>] mntput_no_expire+0xa6/0xf0
Jul  8 10:33:46 deuteros kernel: [2486427.077994]  [<ffffffff81110a63>] sys_umount+0x73/0x3b0
Jul  8 10:33:46 deuteros kernel: [2486427.078003]  [<ffffffff810026eb>] system_call_fastpath+0x16/0x1b
Jul  8 10:33:46 deuteros kernel: [2486427.078003] Code: 0a 48 8b 4b 38 31 d2 48 85 f6 74 04 48 8b 56 40 48 05 68 02 00 00 48 89 de 48 89 04 24 48 c7
c7 f8 f1 50 81 31 c0 e8 8e 6e 2d 00 <0f> 0b eb fe 0f 0b eb fe 55 48 89 e5 53 48 89 fb 48 83 ec 08 48
Jul  8 10:33:46 deuteros kernel: [2486427.078003] RIP  [<ffffffff811085c8>] shrink_dcache_for_umount_subtree+0x268/0x270
Jul  8 10:33:46 deuteros kernel: [2486427.078003]  RSP <ffff8800140f7de8>
Jul  8 10:33:46 deuteros kernel: [2486427.078504] ---[ end trace 289722301befe423 ]---


Following that I could not sync are reboot because it looks some mutex was left locked:

Jul  8 10:36:02 deuteros kernel: [2486562.304208] SysRq : Show Blocked State
Jul  8 10:36:02 deuteros kernel: [2486562.304220]   task                        PC stack   pid father
Jul  8 10:36:02 deuteros kernel: [2486562.304247] shutdown      D 00000001943089cb     0  5475   2001 0x00000000
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  ffff88012a341e30 0000000000000086 ffff88012b824bb0 ffffffff00000000
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  ffff88012a340000 ffff88012a341fd8 0000000000013500 ffff88012a341fd8
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  ffff88012a341fd8 ffff8800140c0000 ffff88012a340000 ffff88012a340000
Jul  8 10:36:02 deuteros kernel: [2486562.304251] Call Trace:
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff810396f4>] ? try_to_wake_up+0x334/0x420
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff813e1f45>] rwsem_down_failed_common+0x95/0x200
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff813e2106>] rwsem_down_read_failed+0x26/0x30
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff811c8574>] call_rwsem_down_read_failed+0x14/0x30
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff813e12c2>] ? down_read+0x12/0x20
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff8111b450>] sync_filesystems+0xb0/0x130
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff8111b522>] sys_sync+0x12/0x40
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff810026eb>] system_call_fastpath+0x16/0x1b
Jul  8 10:36:02 deuteros kernel: [2486562.304251] sync          D 0000000194310777     0  5534   5493 0x00000000
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  ffff88012a5ebea8 0000000000000082 ffff88012a5ebe38 ffffffff00000000
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  ffff88012a5ea000 ffff88012a5ebfd8 0000000000013500 ffff88012a5ebfd8
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  ffff88012a5ebfd8 ffff88011fe5d7c0 ffff88012a5ea000 ffff88012a5ea000
Jul  8 10:36:02 deuteros kernel: [2486562.304251] Call Trace:
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff813e0cd7>] __mutex_lock_slowpath+0x127/0x1e0
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff813e082e>] mutex_lock+0x1e/0x40
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff8111b3bc>] sync_filesystems+0x1c/0x130
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff8111b522>] sys_sync+0x12/0x40
Jul  8 10:36:02 deuteros kernel: [2486562.304251]  [<ffffffff810026eb>] system_call_fastpath+0x16/0x1b


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
