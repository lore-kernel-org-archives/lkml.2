Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0G0XLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:11:51 -0400
Received: from mail.candelatech.com ([208.74.158.172]:44492 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0G0XLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:11:49 -0400
Message-ID: <4C4F67B3.50101@candelatech.com>
Date: Tue, 27 Jul 2010 16:11:47 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.34.1+hacks:  kernel deadlock related to file-IO?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE:  This is from a hacked 2.6.34.1 kernel, with
a module of my own devising loaded and in active use.

But, we cannot reproduce this problem on .31 kernel (with our
same module loaded), so I think there is a chance this is a
general problem.  I'm working on setting up a test case
with the standard kernel now.

In the meantime, here are
the pertinent kernel logs and lockdep output.  Note that
lockdep doesn't print any actual lockdep warnings when
the deadlock occurs.

The scenario is lots of network traffic being routed around
the kernel using VETH interfaces.  The generated traffic is
100 TCP connections sending-to-self.

The OS is Fedora 11, 64-bit.

The trigger for the bug appears to be file-io.  In this case,
it ran fine for a while until I tried to un-tar a new kernel
(over nfs).  This lockup is quite repeatable, and it's not
always related to un-tarring files.


[root@simech2 /]# tar -xzf /mnt/dthome/ct2.6.34.1.x64.tar.gz
INFO: task jbd2/dm-0-8:154 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/dm-0-8   DJul 27 15:25:17  00000001000820cf localhost kernel    0   154      2 0x00000000
  ffff88007b011fd8ffff88007b011b102/dm-0-8:154 blo 0000000000000046cked for more th ffff880000000000an 120 seconds.
                  Jul 27 15:25:17
  localhost kerne ffff88007b75e120l: "echo 0 > /pr 0000000000013ec0oc/sys/kernel/hu ffff88007b011fd8ng_task_timeout_ 0000000000013ec0secs" disables t
his message.
Ju 0000000000013ec0l 27 15:25:17 lo 0000000000013ec0calhost kernel:  ffff88007d7b6120jbd2/dm-0-8   D  ffff88007b75e12000000001000820cf
      0   154    Call Trace:
   2 0x00000000
  [<ffffffff810a0295>] ? sync_page+0x0/0x48
Jul 27 15:25:17  [<ffffffff810a0295>] ? sync_page+0x0/0x48
localhost kernel [<ffffffff813e673d>] io_schedule+0x3d/0x57
: ffff88007b011b [<ffffffff810a02d9>] sync_page+0x44/0x48
10 0000000000000 [<ffffffff813e6b08>] __wait_on_bit+0x43/0x76
046 ffff88000000 [<ffffffff810a0487>] wait_on_page_bit+0x6d/0x74
0000 ffff88007b0 [<ffffffff81056b53>] ? wake_bit_function+0x0/0x2e
11fd8
Jul 27 15 [<ffffffff810a85e8>] ? pagevec_lookup_tag+0x20/0x29
:25:18 localhost [<ffffffff810a0d6e>] filemap_fdatawait_range+0x9f/0x179
  kernel: ffff880 [<ffffffff811792df>] ? spin_lock+0x9/0xb
07b75e120 000000 [<ffffffff810a0e64>] filemap_fdatawait+0x1c/0x1e
0000013ec0 ffff8 [<ffffffff81179f38>] jbd2_journal_commit_transaction+0x9d9/0x12ed
8007b011fd8 0000 [<ffffffff81066551>] ? trace_hardirqs_on+0xd/0xf
000000013ec0
Ju [<ffffffff8104c367>] ? try_to_del_timer_sync+0x7b/0x87
l 27 15:25:18 lo [<ffffffff8104c774>] ? del_timer_sync+0x0/0xa1
calhost kernel:  [<ffffffff8117e814>] kjournald2+0x142/0x375
0000000000013ec0 [<ffffffff81056b1f>] ? autoremove_wake_function+0x0/0x34
  0000000000013ec [<ffffffff8117e6d2>] ? kjournald2+0x0/0x375
0 ffff88007d7b61 [<ffffffff81056727>] kthread+0x7a/0x82
20 ffff88007b75e [<ffffffff8100a924>] kernel_thread_helper+0x4/0x10
120
Jul 27 15:2 [<ffffffff813e8e54>] ? restore_args+0x0/0x30
5:18 localhost k [<ffffffff810566ad>] ? kthread+0x0/0x82
ernel: Call Trac [<ffffffff8100a920>] ? kernel_thread_helper+0x0/0x10
no locks held by jbd2/dm-0-8/154.
INFO: task btserver:2814 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btserver      D 0000000100081026     0  2814   2701 0x00000080
  ffff88006fad3ae8 0000000000000046 ffff880000000000 ffff88006fad3fd8
  ffff8800709c9030 0000000000013ec0 ffff88006fad3fd8 0000000000013ec0
  0000000000013ec0 0000000000013ec0 ffff88007d7db090 ffff8800709c9030
Call Trace:
  [<ffffffff811588f6>] ? ext4_orphan_add+0x22b/0x23d
  [<ffffffff813e716b>] __mutex_lock_common+0x2dd/0x4a7
  [<ffffffff811588f6>] ? ext4_orphan_add+0x22b/0x23d
  [<ffffffff8117910b>] ? jbd2_journal_start+0x5f/0xe2
  [<ffffffff813e73db>] mutex_lock_nested+0x34/0x39
  [<ffffffff811588f6>] ext4_orphan_add+0x22b/0x23d
  [<ffffffff8117915d>] ? jbd2_journal_start+0xb1/0xe2
  [<ffffffff8115415c>] ext4_setattr+0x1a8/0x2fa
  [<ffffffff810f2cfa>] notify_change+0x189/0x2a3
  [<ffffffff810de2e1>] do_truncate+0x67/0x84
  [<ffffffff810e6e36>] ? get_write_access+0x41/0x48
  [<ffffffff810e93e8>] do_last+0x5b4/0x5b9
  [<ffffffff810e982a>] do_filp_open+0x1f3/0x601
  [<ffffffff813e871b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff810f3964>] ? alloc_fd+0x153/0x165
  [<ffffffff810dd652>] do_sys_open+0x5e/0x10a
  [<ffffffff810dd727>] sys_open+0x1b/0x1d
  [<ffffffff81009a82>] system_call_fastpath+0x16/0x1b
4 locks held by btserver/2814:
  #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810de2d5>] do_truncate+0x5b/0x84
  #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2cdd>] notify_change+0x16c/0x2a3
  #2:  (jbd2_handle){+.+...}, at: [<ffffffff81178f0c>] start_this_handle+0x4d7/0x539
  #3:  (&sbi->s_orphan_lock){+.+...}, at: [<ffffffff811588f6>] ext4_orphan_add+0x22b/0x23d
INFO: task sh:22252 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sh            D 000000010007e482     0 22252  22251 0x00000080
  ffff880062baf9a8 0000000000000046 ffff880000000000 ffff880062baffd8
  ffff88005ab0c0c0 0000000000013ec0 ffff880062baffd8 0000000000013ec0
  0000000000013ec0 0000000000013ec0 ffff88007d7b2060 ffff88005ab0c0c0
Call Trace:
  [<ffffffff810a0295>] ? sync_page+0x0/0x48
  [<ffffffff810a0295>] ? sync_page+0x0/0x48
  [<ffffffff813e673d>] io_schedule+0x3d/0x57
  [<ffffffff810a02d9>] sync_page+0x44/0x48
  [<ffffffff813e6b08>] __wait_on_bit+0x43/0x76
  [<ffffffff810a0487>] wait_on_page_bit+0x6d/0x74
  [<ffffffff81056b53>] ? wake_bit_function+0x0/0x2e
  [<ffffffff810a91c5>] wait_on_page_writeback+0x16/0x18
  [<ffffffff810a9a62>] truncate_inode_pages_range+0x2e7/0x351
  [<ffffffff813e871b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff810b3dfd>] ? spin_unlock+0x9/0xb
  [<ffffffff810b608c>] ? unmap_mapping_range+0x106/0x115
  [<ffffffff810a9ad9>] truncate_inode_pages+0xd/0xf
  [<ffffffff810a9b16>] truncate_pagecache+0x3b/0x55
  [<ffffffff810a9b62>] vmtruncate+0x32/0x52
  [<ffffffff810f2a77>] inode_setattr+0x2b/0x125
  [<ffffffff8115422e>] ext4_setattr+0x27a/0x2fa
  [<ffffffff810f2cfa>] notify_change+0x189/0x2a3
  [<ffffffff810de2e1>] do_truncate+0x67/0x84
  [<ffffffff810e6e36>] ? get_write_access+0x41/0x48
  [<ffffffff810e93e8>] do_last+0x5b4/0x5b9
  [<ffffffff810e982a>] do_filp_open+0x1f3/0x601
  [<ffffffff813e871b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff810f3964>] ? alloc_fd+0x153/0x165
  [<ffffffff810dd652>] do_sys_open+0x5e/0x10a
  [<ffffffff810dd727>] sys_open+0x1b/0x1d
  [<ffffffff81009a82>] system_call_fastpath+0x16/0x1b
2 locks held by sh/22252:
  #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810de2d5>] do_truncate+0x5b/0x84
  #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2cdd>] notify_change+0x16c/0x2a3
INFO: task sh:22263 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sh            D 00000001000810d4     0 22263  22260 0x00000080
  ffff880064f99a98 0000000000000046 0000000000000000 ffff880064f99fd8
  ffff88005cc92060 0000000000013ec0 ffff880064f99fd8 0000000000013ec0
  0000000000013ec0 0000000000013ec0 ffff88007d7f0000 ffff88005cc92060
Call Trace:
  [<ffffffff811782d6>] do_get_write_access+0x22d/0x422
  [<ffffffff81066519>] ? trace_hardirqs_on_caller+0x119/0x144
  [<ffffffff81056b53>] ? wake_bit_function+0x0/0x2e
  [<ffffffff8117cee4>] ? bit_spin_unlock+0x39/0x44
  [<ffffffff811785ca>] jbd2_journal_get_write_access+0x26/0x3c
  [<ffffffff811659a9>] __ext4_journal_get_write_access+0x50/0x5a
  [<ffffffff8115874b>] ext4_orphan_add+0x80/0x23d
  [<ffffffff8117915d>] ? jbd2_journal_start+0xb1/0xe2
  [<ffffffff8115415c>] ext4_setattr+0x1a8/0x2fa
  [<ffffffff810f2cfa>] notify_change+0x189/0x2a3
  [<ffffffff810de2e1>] do_truncate+0x67/0x84
  [<ffffffff810e6e36>] ? get_write_access+0x41/0x48
  [<ffffffff810e93e8>] do_last+0x5b4/0x5b9
  [<ffffffff810e982a>] do_filp_open+0x1f3/0x601
  [<ffffffff813e871b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff810f3964>] ? alloc_fd+0x153/0x165
  [<ffffffff810dd652>] do_sys_open+0x5e/0x10a
  [<ffffffff810dd727>] sys_open+0x1b/0x1d
  [<ffffffff81009a82>] system_call_fastpath+0x16/0x1b
4 locks held by sh/22263:
  #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810de2d5>] do_truncate+0x5b/0x84
  #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2cdd>] notify_change+0x16c/0x2a3
  #2:  (jbd2_handle){+.+...}, at: [<ffffffff81178f0c>] start_this_handle+0x4d7/0x539
  #3:  (&sbi->s_orphan_lock){+.+...}, at: [<ffffffff811588f6>] ext4_orphan_add+0x22b/0x23d
e:
Jul 27 15:25:18 localhost kernel: [<ffffffff810a0295>] ? sync_page+0x0/0x48
Jul 27 15:25:18 localhost kernel: [<ffffffff810a0295>] ? sync_page+0x0/0x48
Jul 27 15:25:18 localhost kernel: [<ffffffff813e673d>] io_schedule+0x3d/0x57
Jul 27 15:25:18 localhost kernel: [<ffffffff810a02d9>] sync_page+0x44/0x48
Jul 27 15:25:18 localhost kernel: [<ffffffff813e6b08>] __wait_on_bit+0x43/0x76
Jul 27 15:25:18 localhost kernel: [<ffffffff810a0487>] wait_on_page_bit+0x6d/0x74
Jul 27 15:25:18 localhost kernel: [<ffffffff81056b53>] ? wake_bit_function+0x0/0x2e
Jul 27 15:25:18 localhost kernel: [<ffffffff810a85e8>] ? pagevec_lookup_tag+0x20/0x29
Jul 27 15:25:18 localhost kernel: [<ffffffff810a0d6e>] filemap_fdatawait_range+0x9f/0x179
Jul 27 15:25:18 localhost kernel: [<ffffffff811792df>] ? spin_lock+0x9/0xb
Jul 27 15:25:18 localhost kernel: [<ffffffff810a0e64>] filemap_fdatawait+0x1c/0x1e
Jul 27 15:25:18 localhost kernel: [<ffffffff81179f38>] jbd2_journal_commit_transaction+0x9d9/0x12ed
Jul 27 15:25:18 localhost kernel: [<ffffffff81066551>] ? trace_hardirqs_on+0xd/0xf
Jul 27 15:25:18 localhost kernel: [<ffffffff8104c367>] ? try_to_del_timer_sync+0x7b/0x87
Jul 27 15:25:18 localhost kernel: [<ffffffff8104c774>] ? del_timer_sync+0x0/0xa1
Jul 27 15:25:18 localhost kernel: [<ffffffff8117e814>] kjournald2+0x142/0x375
Jul 27 15:25:18 localhost kernel: [<ffffffff81056b1f>] ? autoremove_wake_function+0x0/0x34
Jul 27 15:25:18 localhost kernel: [<ffffffff8117e6d2>] ? kjournald2+0x0/0x375
Jul 27 15:25:18 localhost kernel: [<ffffffff81056727>] kthread+0x7a/0x82
Jul 27 15:25:18 localhost kernel: [<ffffffff8100a924>] kernel_thread_helper+0x4/0x10
Jul 27 15:25:18 localhost kernel: [<ffffffff813e8e54>] ? restore_args+0x0/0x30
Jul 27 15:25:18 localhost kernel: [<ffffffff810566ad>] ? kthread+0x0/0x82
Jul 27 15:25:18 localhost kernel: [<ffffffff8100a920>] ? kernel_thread_helper+0x0/0x10
Jul 27 15:25:18 localhost kernel: no locks held by jbd2/dm-0-8/154.
Jul 27 15:25:18 localhost kernel: INFO: task btserver:2814 blocked for more than 120 seconds.
Jul 27 15:25:18 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 27 15:25:18 localhost kernel: btserver      D 0000000100081026     0  2814   2701 0x00000080
Jul 27 15:25:18 localhost kernel: ffff88006fad3ae8 0000000000000046 ffff880000000000 ffff88006fad3fd8
Jul 27 15:25:18 localhost kernel: ffff8800709c9030 0000000000013ec0 ffff88006fad3fd8 0000000000013ec0
Jul 27 15:25:18 localhost kernel: 0000000000013ec0 0000000000013ec0 ffff88007d7db090 ffff8800709c9030
Jul 27 15:25:18 localhost kernel: Call Trace:
Jul 27 15:25:18 localhost kernel: [<ffffffff811588f6>] ? ext4_orphan_add+0x22b/0x23d
Jul 27 15:25:18 localhost kernel: [<ffffffff813e716b>] __mutex_lock_common+0x2dd/0x4a7
Jul 27 15:25:18 localhost kernel: [<ffffffff811588f6>] ? ext4_orphan_add+0x22b/0x23d
Jul 27 15:25:18 localhost kernel: [<ffffffff8117910b>] ? jbd2_journal_start+0x5f/0xe2
Jul 27 15:25:18 localhost kernel: [<ffffffff813e73db>] mutex_lock_nested+0x34/0x39
Jul 27 15:25:18 localhost kernel: [<ffffffff811588f6>] ext4_orphan_add+0x22b/0x23d
Jul 27 15:25:18 localhost kernel: [<ffffffff8117915d>] ? jbd2_journal_start+0xb1/0xe2
Jul 27 15:25:18 localhost kernel: [<ffffffff8115415c>] ext4_setattr+0x1a8/0x2fa
Jul 27 15:25:18 localhost kernel: [<ffffffff810f2cfa>] notify_change+0x189/0x2a3
Jul 27 15:25:18 localhost kernel: [<ffffffff810de2e1>] do_truncate+0x67/0x84
Jul 27 15:25:18 localhost kernel: [<ffffffff810e6e36>] ? get_write_access+0x41/0x48
Jul 27 15:25:18 localhost kernel: [<ffffffff810e93e8>] do_last+0x5b4/0x5b9
Jul 27 15:25:18 localhost kernel: [<ffffffff810e982a>] do_filp_open+0x1f3/0x601
Jul 27 15:25:18 localhost kernel: [<ffffffff813e871b>] ? _raw_spin_unlock+0x45/0x52
Jul 27 15:25:18 localhost kernel: [<ffffffff810f3964>] ? alloc_fd+0x153/0x165
Jul 27 15:25:18 localhost kernel: [<ffffffff810dd652>] do_sys_open+0x5e/0x10a
Jul 27 15:25:18 localhost kernel: [<ffffffff810dd727>] sys_open+0x1b/0x1d
Jul 27 15:25:18 localhost kernel: [<ffffffff81009a82>] system_call_fastpath+0x16/0x1b
Jul 27 15:25:18 localhost kernel: 4 locks held by btserver/2814:
Jul 27 15:25:18 localhost kernel: #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810de2d5>] do_truncate+0x5b/0x84
Jul 27 15:25:18 localhost kernel: #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2cdd>] notify_change+0x16c/0x2a3
Jul 27 15:25:18 localhost kernel: #2:  (jbd2_handle){+.+...}, at: [<ffffffff81178f0c>] start_this_handle+0x4d7/0x539
Jul 27 15:25:18 localhost kernel: #3:  (&sbi->s_orphan_lock){+.+...}, at: [<ffffffff811588f6>] ext4_orphan_add+0x22b/0x23d
Jul 27 15:25:18 localhost kernel: INFO: task sh:22252 blocked for more than 120 seconds.
Jul 27 15:25:18 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 27 15:25:18 localhost kernel: sh            D 000000010007e482     0 22252  22251 0x00000080
Jul 27 15:25:18 localhost kernel: ffff880062baf9a8 0000000000000046 ffff880000000000 ffff880062baffd8
Jul 27 15:25:18 localhost kernel: ffff88005ab0c0c0 0000000000013ec0 ffff880062baffd8 0000000000013ec0
Jul 27 15:25:18 localhost kernel: 0000000000013ec0 0000000000013ec0 ffff88007d7b2060 ffff88005ab0c0c0
Jul 27 15:25:18 localhost kernel: Call Trace:
Jul 27 15:25:18 localhost kernel: [<ffffffff810a0295>] ? sync_page+0x0/0x48
Jul 27 15:25:18 localhost kernel: [<ffffffff810a0295>] ? sync_page+0x0/0x48
Jul 27 15:25:18 localhost kernel: [<ffffffff813e673d>] io_schedule+0x3d/0x57
Jul 27 15:25:18 localhost kernel: [<ffffffff810a02d9>] sync_page+0x44/0x48
Jul 27 15:25:18 localhost kernel: [<ffffffff813e6b08>] __wait_on_bit+0x43/0x76
Jul 27 15:25:18 localhost kernel: [<ffffffff810a0487>] wait_on_page_bit+0x6d/0x74
Jul 27 15:25:18 localhost kernel: [<ffffffff81056b53>] ? wake_bit_function+0x0/0x2e
Jul 27 15:25:18 localhost kernel: [<ffffffff810a91c5>] wait_on_page_writeback+0x16/0x18
Jul 27 15:25:18 localhost kernel: [<ffffffff810a9a62>] truncate_inode_pages_range+0x2e7/0x351
Jul 27 15:25:18 localhost kernel: [<ffffffff813e871b>] ? _raw_spin_unlock+0x45/0x52
Jul 27 15:25:18 localhost kernel: [<ffffffff810b3dfd>] ? spin_unlock+0x9/0xb
Jul 27 15:25:18 localhost kernel: [<ffffffff810b608c>] ? unmap_mapping_range+0x106/0x115
Jul 27 15:25:18 localhost kernel: [<ffffffff810a9ad9>] truncate_inode_pages+0xd/0xf
Jul 27 15:25:18 localhost kernel: [<ffffffff810a9b16>] truncate_pagecache+0x3b/0x55
Jul 27 15:25:18 localhost kernel: [<ffffffff810a9b62>] vmtruncate+0x32/0x52
Jul 27 15:25:18 localhost kernel: [<ffffffff810f2a77>] inode_setattr+0x2b/0x125
Jul 27 15:25:18 localhost kernel: [<ffffffff8115422e>] ext4_setattr+0x27a/0x2fa
Jul 27 15:25:18 localhost kernel: [<ffffffff810f2cfa>] notify_change+0x189/0x2a3
Jul 27 15:25:18 localhost kernel: [<ffffffff810de2e1>] do_truncate+0x67/0x84
Jul 27 15:25:18 localhost kernel: [<ffffffff810e6e36>] ? get_write_access+0x41/0x48
Jul 27 15:25:18 localhost kernel: [<ffffffff810e93e8>] do_last+0x5b4/0x5b9
Jul 27 15:25:18 localhost kernel: [<ffffffff810e982a>] do_filp_open+0x1f3/0x601
Jul 27 15:25:18 localhost kernel: [<ffffffff813e871b>] ? _raw_spin_unlock+0x45/0x52
Jul 27 15:25:18 localhost kernel: [<ffffffff810f3964>] ? alloc_fd+0x153/0x165
Jul 27 15:25:18 localhost kernel: [<ffffffff810dd652>] do_sys_open+0x5e/0x10a
Jul 27 15:25:18 localhost kernel: [<ffffffff810dd727>] sys_open+0x1b/0x1d
Jul 27 15:25:18 localhost kernel: [<ffffffff81009a82>] system_call_fastpath+0x16/0x1b
Jul 27 15:25:18 localhost kernel: 2 locks held by sh/22252:
Jul 27 15:25:18 localhost kernel: #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810de2d5>] do_truncate+0x5b/0x84
Jul 27 15:25:18 localhost kernel: #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2cdd>] notify_change+0x16c/0x2a3
Jul 27 15:25:18 localhost kernel: INFO: task sh:22263 blocked for more than 120 seconds.
Jul 27 15:25:18 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 27 15:25:18 localhost kernel: sh            D 00000001000810d4     0 22263  22260 0x00000080
Jul 27 15:25:18 localhost kernel: ffff880064f99a98 0000000000000046 0000000000000000 ffff880064f99fd8
Jul 27 15:25:18 localhost kernel: ffff88005cc92060 0000000000013ec0 ffff880064f99fd8 0000000000013ec0
Jul 27 15:25:18 localhost kernel: 0000000000013ec0 0000000000013ec0 ffff88007d7f0000 ffff88005cc92060
Jul 27 15:25:18 localhost kernel: Call Trace:
Jul 27 15:25:18 localhost kernel: [<ffffffff811782d6>] do_get_write_access+0x22d/0x422
Jul 27 15:25:18 localhost kernel: [<ffffffff81066519>] ? trace_hardirqs_on_caller+0x119/0x144
Jul 27 15:25:18 localhost kernel: [<ffffffff81056b53>] ? wake_bit_function+0x0/0x2e
Jul 27 15:25:18 localhost kernel: [<ffffffff8117cee4>] ? bit_spin_unlock+0x39/0x44
Jul 27 15:25:18 localhost kernel: [<ffffffff811785ca>] jbd2_journal_get_write_access+0x26/0x3c
Jul 27 15:25:18 localhost kernel: [<ffffffff811659a9>] __ext4_journal_get_write_access+0x50/0x5a
Jul 27 15:25:18 localhost kernel: [<ffffffff8115874b>] ext4_orphan_add+0x80/0x23d
Jul 27 15:25:18 localhost kernel: [<ffffffff8117915d>] ? jbd2_journal_start+0xb1/0xe2
Jul 27 15:25:18 localhost kernel: [<ffffffff8115415c>] ext4_setattr+0x1a8/0x2fa
Jul 27 15:25:18 localhost kernel: [<ffffffff810f2cfa>] notify_change+0x189/0x2a3
Jul 27 15:25:18 localhost kernel: [<ffffffff810de2e1>] do_truncate+0x67/0x84
Jul 27 15:25:18 localhost kernel: [<ffffffff810e6e36>] ? get_write_access+0x41/0x48
Jul 27 15:25:18 localhost kernel: [<ffffffff810e93e8>] do_last+0x5b4/0x5b9
Jul 27 15:25:18 localhost kernel: [<ffffffff810e982a>] do_filp_open+0x1f3/0x601
Jul 27 15:25:18 localhost kernel: [<ffffffff813e871b>] ? _raw_spin_unlock+0x45/0x52
Jul 27 15:25:18 localhost kernel: [<ffffffff810f3964>] ? alloc_fd+0x153/0x165
Jul 27 15:25:18 localhost kernel: [<ffffffff810dd652>] do_sys_open+0x5e/0x10a
Jul 27 15:25:18 localhost kernel: [<ffffffff810dd727>] sys_open+0x1b/0x1d
Jul 27 15:25:18 localhost kernel: [<ffffffff81009a82>] system_call_fastpath+0x16/0x1b
Jul 27 15:25:18 localhost kernel: 4 locks held by sh/22263:
Jul 27 15:25:18 localhost kernel: #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810de2d5>] do_truncate+0x5b/0x84
Jul 27 15:25:18 localhost kernel: #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2cdd>] notify_change+0x16c/0x2a3
Jul 27 15:25:18 localhost kernel: #2:  (jbd2_handle){+.+...}, at: [<ffffffff81178f0c>] start_this_handle+0x4d7/0x539
Jul 27 15:25:18 localhost kernel: #3:  (&sbi->s_orphan_lock){+.+...}, at: [<ffffffff811588f6>] ext4_orphan_add+0x22b/0x23d


## sysrq d

Showing all locks held in the system:
3 locks held by flush-253:0/764:
  #0:  (&type->s_umount_key#19){++++..}, at: [<ffffffff810faa52>] writeback_inodes_wb+0x275/0x553
  #1:  (jbd2_handle){+.+...}, at: [<ffffffff81178f0c>] start_this_handle+0x4d7/0x539
  #2:  (&ei->i_data_sem){++++..}, at: [<ffffffff81152029>] ext4_get_blocks+0xe4/0x1bb
2 locks held by rsyslogd/22271:
  #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810a1341>] generic_file_aio_write+0x47/0xa8
  #1:  (jbd2_handle){+.+...}, at: [<ffffffff81178f0c>] start_this_handle+0x4d7/0x539
4 locks held by btserver/2814:
  #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810de2d5>] do_truncate+0x5b/0x84
  #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2cdd>] notify_change+0x16c/0x2a3
  #2:  (jbd2_handle){+.+...}, at: [<ffffffff81178f0c>] start_this_handle+0x4d7/0x539
  #3:  (&sbi->s_orphan_lock){+.+...}, at: [<ffffffff811588f6>] ext4_orphan_add+0x22b/0x23d
1 lock held by bash/2818:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124ddfc>] n_tty_read+0x27c/0x785
1 lock held by bash/2829:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124ddfc>] n_tty_read+0x27c/0x785
1 lock held by mingetty/2950:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124ddfc>] n_tty_read+0x27c/0x785
1 lock held by mingetty/2951:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124ddfc>] n_tty_read+0x27c/0x785
1 lock held by mingetty/2952:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124ddfc>] n_tty_read+0x27c/0x785
1 lock held by mingetty/2953:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124ddfc>] n_tty_read+0x27c/0x785
1 lock held by mingetty/2954:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124ddfc>] n_tty_read+0x27c/0x785
1 lock held by mingetty/2955:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124ddfc>] n_tty_read+0x27c/0x785
1 lock held by bash/4982:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8124ddfc>] n_tty_read+0x27c/0x785
2 locks held by sh/22252:
  #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810de2d5>] do_truncate+0x5b/0x84
  #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2cdd>] notify_change+0x16c/0x2a3
4 locks held by sh/22263:
  #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff810de2d5>] do_truncate+0x5b/0x84
  #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff810f2cdd>] notify_change+0x16c/0x2a3
  #2:  (jbd2_handle){+.+...}, at: [<ffffffff81178f0c>] start_this_handle+0x4d7/0x539
  #3:  (&sbi->s_orphan_lock){+.+...}, at: [<ffffffff811588f6>] ext4_orphan_add+0x22b/0x23d
1 lock held by bash/22265:
  #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<ffffffff810e40e0>] prepare_bprm_creds+0x24/0x55

=============================================

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

