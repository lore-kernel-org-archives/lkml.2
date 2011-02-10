Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1BJC5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:57:03 -0500
Received: from smtp1.onthe.net.au ([203.22.196.249]:56266 "EHLO
	smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab1BJC47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:56:59 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Feb 2011 21:56:59 EST
Date: Thu, 10 Feb 2011 13:50:53 +1100
From: Chris Dunlop <chris@onthe.net.au>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdev@soemail.rutgers.edu, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>,
        Yehuda Sadeh Weinraub <yehudasa@gmail.com>
Subject: Linux 2.6.38-rc4 (ceph unlink NULL pointer dereference)
Message-ID: <20110210025053.GA26813@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day,

On virgin rc4 (commit 100b33c), unlinking a file on the ceph file
system (still) produces the BUG below. For further reference, see
the thread leading up to:

http://thread.gmane.org/gmane.linux.kernel/1068841/focus=1826

For what it's worth, the cherry-pick mentioned in the thread above
(commit 9c3db35 from git://ceph.newdream.net/git/ceph-client.git)
also fixes it for me, but it's noted to be "just a temporary
workaround".

Cheers,

Chris.


[   65.116362] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[   65.116385] IP: [<ffffffffa00f5331>] ceph_dentry_release+0x18/0x97 [ceph]
[   65.116407] PGD 7be41067 PUD 7b88b067 PMD 0 
[   65.116421] Oops: 0000 [#1] SMP 
[   65.116431] last sysfs file: /sys/module/aoe/parameters/aoe_iflist
[   65.116440] CPU 0 
[   65.116444] Modules linked in: ceph libceph crc32c libcrc32c aoe xen_netfront ext4 mbcache jbd2 crc16 xen_blkfront thermal_sys
[   65.116484] 
[   65.116492] Pid: 1130, comm: kworker/0:2 Not tainted 2.6.38-rc4-otn1-00001-gab96fc0 #15 /
[   65.116503] RIP: e030:[<ffffffffa00f5331>]  [<ffffffffa00f5331>] ceph_dentry_release+0x18/0x97 [ceph]
[   65.116522] RSP: e02b:ffff88007be09ad0  EFLAGS: 00010286
[   65.116530] RAX: 0000000000000000 RBX: ffff88007ced6300 RCX: 0000000000000002
[   65.116541] RDX: 0000000000000040 RSI: 0000000000000001 RDI: ffff88007ced6300
[   65.116550] RBP: ffff88007ceda870 R08: ffff88007b8a0690 R09: 000000000000e030
[   65.116560] R10: 00000003000c12d0 R11: 0000000000000040 R12: ffff88007ced6300
[   65.116570] R13: ffff88007cefd5f0 R14: 0000000000000042 R15: ffff88007c8e9400
[   65.116586] FS:  00007f2b2acf46e0(0000) GS:ffff88007ffcd000(0000) knlGS:0000000000000000
[   65.116597] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[   65.116606] CR2: 0000000000000030 CR3: 000000007b8bc000 CR4: 0000000000002660
[   65.116616] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   65.116626] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   65.116637] Process kworker/0:2 (pid: 1130, threadinfo ffff88007be08000, task ffff88007bf32d10)
[   65.116647] Stack:
[   65.116653]  ffff88007ced6300 ffff88007ceda870 ffff88007ced6c00 ffff88007c8e9408
[   65.116670]  0000000000000042 ffffffff810f14fa ffff88007ced6300 ffffffff810f274b
[   65.116687]  ffff88007b8a0660 ffff88007b8a0400 ffff88007bd46000 ffffffffa010523b
[   65.116704] Call Trace:
[   65.116716]  [<ffffffff810f14fa>] ? d_free+0x2a/0x4b
[   65.116727]  [<ffffffff810f274b>] ? dput+0x211/0x223
[   65.116742]  [<ffffffffa010523b>] ? ceph_mdsc_release_request+0xbf/0x140 [ceph]
[   65.116758]  [<ffffffffa010517c>] ? ceph_mdsc_release_request+0x0/0x140 [ceph]
[   65.116772]  [<ffffffff81160e43>] ? kref_put+0x41/0x4c
[   65.116786]  [<ffffffffa0104934>] ? dispatch+0xb3f/0xf4f [ceph]
[   65.116800]  [<ffffffff810063b5>] ? xen_force_evtchn_callback+0x9/0xa
[   65.116812]  [<ffffffff8121ce0e>] ? kernel_recvmsg+0x35/0x42
[   65.116827]  [<ffffffffa00d3774>] ? ceph_tcp_recvmsg+0x43/0x48 [libceph]
[   65.116841]  [<ffffffffa00d3774>] ? ceph_tcp_recvmsg+0x43/0x48 [libceph]
[   65.116855]  [<ffffffffa00d4a5b>] ? con_work+0x1088/0x2045 [libceph]
[   65.116868]  [<ffffffff81108e33>] ? init_once+0x64/0x7b
[   65.116880]  [<ffffffff810da5d2>] ? cache_grow+0x1f7/0x253
[   65.116893]  [<ffffffff81037b37>] ? dequeue_task_fair+0x4b/0x1c6
[   65.116905]  [<ffffffff8100696f>] ? xen_restore_fl_direct_end+0x0/0x1
[   65.116918]  [<ffffffff8129252c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
[   65.116930]  [<ffffffff8104ec0c>] ? mod_timer+0x1ef/0x1fe
[   65.116942]  [<ffffffff810565bc>] ? process_one_work+0x22c/0x3a5
[   65.116956]  [<ffffffffa00d39d3>] ? con_work+0x0/0x2045 [libceph]
[   65.116966]  [<ffffffff81056a88>] ? worker_thread+0x1d5/0x353
[   65.116977]  [<ffffffff810568b3>] ? worker_thread+0x0/0x353
[   65.116988]  [<ffffffff8105b4d0>] ? kthread+0x7e/0x86
[   65.116999]  [<ffffffff8100a764>] ? kernel_thread_helper+0x4/0x10
[   65.117010]  [<ffffffff81009b73>] ? int_ret_from_sys_call+0x7/0x1b
[   65.117022]  [<ffffffff812929e1>] ? retint_restore_args+0x5/0x6
[   65.117033]  [<ffffffff8100a760>] ? kernel_thread_helper+0x0/0x10
[   65.117041] Code: 4d 28 ff 8b f8 01 00 00 fe 83 e4 01 00 00 5b 5d 41 5c c3 41 56 41 55 41 54 49 89 fc 55 53 48 8b 47 18 4c 8b 6f 78 48 39 c7 74 43 <48> 8b 58 30 48 85 db 74 3a 4c 8b b3 08 fd ff ff 49 83 fe ff 74 
[   65.117162] RIP  [<ffffffffa00f5331>] ceph_dentry_release+0x18/0x97 [ceph]
[   65.117178]  RSP <ffff88007be09ad0>
[   65.117185] CR2: 0000000000000030
[   65.117193] ---[ end trace 042631beba16e920 ]---
[   65.117239] BUG: unable to handle kernel paging request at fffffffffffffff8
[   65.117253] IP: [<ffffffff8105b147>] kthread_data+0x7/0xc
[   65.117265] PGD 13b7067 PUD 13b8067 PMD 0 
[   65.117278] Oops: 0000 [#2] SMP 
[   65.117288] last sysfs file: /sys/module/aoe/parameters/aoe_iflist
[   65.117296] CPU 0 
[   65.117300] Modules linked in: ceph libceph crc32c libcrc32c aoe xen_netfront ext4 mbcache jbd2 crc16 xen_blkfront thermal_sys
[   65.117337] 
[   65.117344] Pid: 1130, comm: kworker/0:2 Tainted: G      D     2.6.38-rc4-otn1-00001-gab96fc0 #15 /
[   65.117356] RIP: e030:[<ffffffff8105b147>]  [<ffffffff8105b147>] kthread_data+0x7/0xc
[   65.117371] RSP: e02b:ffff88007be095d0  EFLAGS: 00010002
[   65.117379] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000012b80
[   65.117389] RDX: ffff88007bf32d10 RSI: 0000000000000000 RDI: ffff88007bf32d10
[   65.117399] RBP: ffff88007bf32d10 R08: ffff88007c853968 R09: dead000000200200
[   65.117409] R10: 0000000000000000 R11: ffff88007ce7c2c0 R12: ffff88007be09778
[   65.117419] R13: ffff88007ffdfb80 R14: ffff88007bf32e98 R15: 0000000000000001
[   65.117433] FS:  00007f2b2acf46e0(0000) GS:ffff88007ffcd000(0000) knlGS:0000000000000000
[   65.117444] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[   65.117453] CR2: fffffffffffffff8 CR3: 000000007b8bc000 CR4: 0000000000002660
[   65.117463] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   65.117473] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   65.117483] Process kworker/0:2 (pid: 1130, threadinfo ffff88007be08000, task ffff88007bf32d10)
[   65.117494] Stack:
[   65.117499]  ffffffff81058a34 ffff88007be09fd8 ffffffff8129090b ffff88007be09718
[   65.117517]  0000000000000000 ffff88007d33b801 ffff88007be08010 0000000000012b80
[   65.117534]  ffff88007be09fd8 ffff88007be09fd8 0000000000012b80 0000000000012b80
[   65.117551] Call Trace:
[   65.117559]  [<ffffffff81058a34>] ? wq_worker_sleeping+0x8/0x84
[   65.117573]  [<ffffffff8129090b>] ? schedule+0x196/0x82f
[   65.117583]  [<ffffffff8100122a>] ? hypercall_page+0x22a/0x1001
[   65.117595]  [<ffffffff810063b5>] ? xen_force_evtchn_callback+0x9/0xa
[   65.117606]  [<ffffffff81006982>] ? check_events+0x12/0x20
[   65.117617]  [<ffffffff81006982>] ? check_events+0x12/0x20
[   65.117628]  [<ffffffff8100696f>] ? xen_restore_fl_direct_end+0x0/0x1
[   65.117641]  [<ffffffff81087548>] ? __call_rcu+0x11d/0x125
[   65.117652]  [<ffffffff81044608>] ? release_task+0x391/0x3a9
[   65.117664]  [<ffffffff81045a8e>] ? do_exit+0x713/0x721
[   65.117675]  [<ffffffff8100d499>] ? oops_end+0xae/0xb3
[   65.117687]  [<ffffffff8102a192>] ? no_context+0x1f2/0x201
[   65.117698]  [<ffffffff810477ce>] ? local_bh_enable+0x22/0x8c
[   65.117710]  [<ffffffff8102a341>] ? __bad_area_nosemaphore+0x1a0/0x1c4
[   65.117722]  [<ffffffff810063b5>] ? xen_force_evtchn_callback+0x9/0xa
[   65.117733]  [<ffffffff81006982>] ? check_events+0x12/0x20
[   65.117744]  [<ffffffff8100696f>] ? xen_restore_fl_direct_end+0x0/0x1
[   65.117755]  [<ffffffff8102a691>] ? do_page_fault+0x18c/0x383
[   65.117767]  [<ffffffff8121f754>] ? release_sock+0x19/0x103
[   65.117779]  [<ffffffff81254a03>] ? tcp_recvmsg+0x94a/0xa50
[   65.117790]  [<ffffffff81292c55>] ? page_fault+0x25/0x30
[   65.117804]  [<ffffffffa00f5331>] ? ceph_dentry_release+0x18/0x97 [ceph]
[   65.117815]  [<ffffffff810f14fa>] ? d_free+0x2a/0x4b
[   65.117825]  [<ffffffff810f274b>] ? dput+0x211/0x223
[   65.117839]  [<ffffffffa010523b>] ? ceph_mdsc_release_request+0xbf/0x140 [ceph]
[   65.117855]  [<ffffffffa010517c>] ? ceph_mdsc_release_request+0x0/0x140 [ceph]
[   65.117867]  [<ffffffff81160e43>] ? kref_put+0x41/0x4c
[   65.117881]  [<ffffffffa0104934>] ? dispatch+0xb3f/0xf4f [ceph]
[   65.117892]  [<ffffffff810063b5>] ? xen_force_evtchn_callback+0x9/0xa
[   65.117903]  [<ffffffff8121ce0e>] ? kernel_recvmsg+0x35/0x42
[   65.117917]  [<ffffffffa00d3774>] ? ceph_tcp_recvmsg+0x43/0x48 [libceph]
[   65.117931]  [<ffffffffa00d3774>] ? ceph_tcp_recvmsg+0x43/0x48 [libceph]
[   65.117945]  [<ffffffffa00d4a5b>] ? con_work+0x1088/0x2045 [libceph]
[   65.117957]  [<ffffffff81108e33>] ? init_once+0x64/0x7b
[   65.117967]  [<ffffffff810da5d2>] ? cache_grow+0x1f7/0x253
[   65.117978]  [<ffffffff81037b37>] ? dequeue_task_fair+0x4b/0x1c6
[   65.117990]  [<ffffffff8100696f>] ? xen_restore_fl_direct_end+0x0/0x1
[   65.118001]  [<ffffffff8129252c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
[   65.118012]  [<ffffffff8104ec0c>] ? mod_timer+0x1ef/0x1fe
[   65.118023]  [<ffffffff810565bc>] ? process_one_work+0x22c/0x3a5
[   65.118037]  [<ffffffffa00d39d3>] ? con_work+0x0/0x2045 [libceph]
[   65.118047]  [<ffffffff81056a88>] ? worker_thread+0x1d5/0x353
[   65.118058]  [<ffffffff810568b3>] ? worker_thread+0x0/0x353
[   65.118068]  [<ffffffff8105b4d0>] ? kthread+0x7e/0x86
[   65.118079]  [<ffffffff8100a764>] ? kernel_thread_helper+0x4/0x10
[   65.118089]  [<ffffffff81009b73>] ? int_ret_from_sys_call+0x7/0x1b
[   65.118100]  [<ffffffff812929e1>] ? retint_restore_args+0x5/0x6
[   65.118111]  [<ffffffff8100a760>] ? kernel_thread_helper+0x0/0x10
[   65.118119] Code: 74 23 00 48 83 c4 18 5b 5d 41 5c 41 5d c3 90 90 65 48 8b 04 25 40 cc 00 00 48 8b 80 28 02 00 00 8b 40 f0 c3 48 8b 87 28 02 00 00 <48> 8b 40 f8 c3 48 8d 47 08 c7 07 00 00 00 00 48 c7 47 18 00 00 
[   65.118240] RIP  [<ffffffff8105b147>] kthread_data+0x7/0xc
[   65.118253]  RSP <ffff88007be095d0>
[   65.118259] CR2: fffffffffffffff8
[   65.118267] ---[ end trace 042631beba16e921 ]---
[   65.118274] Fixing recursive fault but reboot is needed!
