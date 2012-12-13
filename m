Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2LMUzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 15:55:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756391Ab2LMUz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 15:55:29 -0500
Date: Thu, 13 Dec 2012 15:55:22 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Subject: XFS corruption on post 3.7 tree.
Message-ID: <20121213205522.GA28455@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
	xfs@oss.sgi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing a kernel build while running on a 3.7+ tree from last night and I hit this...


[22637.787422] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 163 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa070086a

[22637.788130] Pid: 507, comm: xfsaild/sda6 Not tainted 3.7.0+ #13
[22637.788447] Call Trace:
[22637.788609]  [<ffffffffa06cb0ef>] xfs_error_report+0x3f/0x50 [xfs]
[22637.788953]  [<ffffffffa070086a>] ? xfs_dir2_block_verify+0x7a/0x90 [xfs]
[22637.789314]  [<ffffffffa06fcff4>] ? xfs_default_hashname+0x14/0x20 [xfs]
[22637.789698]  [<ffffffffa07027fa>] __xfs_dir2_data_check+0x3ca/0x4a0 [xfs]
[22637.790070]  [<ffffffffa06c95d5>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs]
[22637.790405]  [<ffffffffa070086a>] xfs_dir2_block_verify+0x7a/0x90 [xfs]
[22637.790784]  [<ffffffffa070088e>] xfs_dir2_block_write_verify+0xe/0x10 [xfs]
[22637.791169]  [<ffffffffa06c912e>] _xfs_buf_ioapply+0x5e/0x370 [xfs]
[22637.791495]  [<ffffffff8107e280>] ? try_to_wake_up+0x2d0/0x2d0
[22637.791820]  [<ffffffffa06c95d5>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs]
[22637.792146]  [<ffffffffa06c951a>] xfs_buf_iorequest+0x4a/0xa0 [xfs]
[22637.792482]  [<ffffffffa06c95d5>] xfs_bdstrat_cb+0x65/0xd0 [xfs]
[22637.792820]  [<ffffffffa06c97b1>] __xfs_buf_delwri_submit+0x171/0x1e0 [xfs]
[22637.793200]  [<ffffffffa06ca0f0>] ? xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
[22637.793585]  [<ffffffffa0723001>] ? xfs_trans_ail_cursor_done+0x21/0x30 [xfs]
[22637.793977]  [<ffffffffa06ca0f0>] xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
[22637.794375]  [<ffffffffa07232e1>] xfsaild+0x221/0x5d0 [xfs]
[22637.794719]  [<ffffffffa07230c0>] ? xfs_trans_ail_cursor_first+0xb0/0xb0 [xfs]
[22637.795106]  [<ffffffff8106c2b0>] kthread+0xc0/0xd0
[22637.795381]  [<ffffffff8106c1f0>] ? kthread_create_on_node+0x120/0x120
[22637.795737]  [<ffffffff815d41ac>] ret_from_fork+0x7c/0xb0
[22637.796029]  [<ffffffff8106c1f0>] ? kthread_create_on_node+0x120/0x120
[22637.796357] ffff88006b0ee000: 58 44 32 42 0d d0 00 60 0b f0 00 58 05 e0 00 40  XD2B...`...X...@
[22637.796831] XFS (sda6): Internal error xfs_dir2_block_verify at line 71 of file fs/xfs/xfs_dir2_block.c.  Caller 0xffffffffa070088e

[22637.797543] Pid: 507, comm: xfsaild/sda6 Not tainted 3.7.0+ #13
[22637.797862] Call Trace:
[22637.798012]  [<ffffffffa06cb0ef>] xfs_error_report+0x3f/0x50 [xfs]
[22637.798373]  [<ffffffffa070088e>] ? xfs_dir2_block_write_verify+0xe/0x10 [xfs]
[22637.798786]  [<ffffffffa06cb15e>] xfs_corruption_error+0x5e/0x90 [xfs]
[22637.799158]  [<ffffffffa06c95d5>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs]
[22637.799510]  [<ffffffffa0700841>] xfs_dir2_block_verify+0x51/0x90 [xfs]
[22637.799894]  [<ffffffffa070088e>] ? xfs_dir2_block_write_verify+0xe/0x10 [xfs]
[22637.800300]  [<ffffffffa070088e>] xfs_dir2_block_write_verify+0xe/0x10 [xfs]
[22637.800711]  [<ffffffffa06c912e>] _xfs_buf_ioapply+0x5e/0x370 [xfs]
[22637.801071]  [<ffffffff8107e280>] ? try_to_wake_up+0x2d0/0x2d0
[22637.801408]  [<ffffffffa06c95d5>] ? xfs_bdstrat_cb+0x65/0xd0 [xfs]
[22637.801772]  [<ffffffffa06c951a>] xfs_buf_iorequest+0x4a/0xa0 [xfs]
[22637.802127]  [<ffffffffa06c95d5>] xfs_bdstrat_cb+0x65/0xd0 [xfs]
[22637.802438]  [<ffffffffa06c97b1>] __xfs_buf_delwri_submit+0x171/0x1e0 [xfs]
[22637.802827]  [<ffffffffa06ca0f0>] ? xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
[22637.803256]  [<ffffffffa0723001>] ? xfs_trans_ail_cursor_done+0x21/0x30 [xfs]
[22637.803667]  [<ffffffffa06ca0f0>] xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
[22637.804071]  [<ffffffffa07232e1>] xfsaild+0x221/0x5d0 [xfs]
[22637.804391]  [<ffffffffa07230c0>] ? xfs_trans_ail_cursor_first+0xb0/0xb0 [xfs]
[22637.804804]  [<ffffffff8106c2b0>] kthread+0xc0/0xd0
[22637.805084]  [<ffffffff8106c1f0>] ? kthread_create_on_node+0x120/0x120
[22637.805448]  [<ffffffff815d41ac>] ret_from_fork+0x7c/0xb0
[22637.805748]  [<ffffffff8106c1f0>] ? kthread_create_on_node+0x120/0x120
[22637.806111] XFS (sda6): Corruption detected. Unmount and run xfs_repair
[22637.806465] XFS (sda6): xfs_do_force_shutdown(0x8) called from line 1340 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffffa06c9401
[22637.987005] XFS (sda6): Corruption of in-memory data detected.  Shutting down filesystem
[22637.987459] XFS (sda6): Please umount the filesystem and rectify the problem(s)
[22637.987906] XFS (sda6): metadata I/O error: block 0x8c5f4f0 ("xfs_trans_read_buf_map") error 5 numblks 16
[22637.987916] XFS (sda6): metadata I/O error: block 0x8c8ce48 ("xfs_trans_read_buf_map") error 5 numblks 8
[22637.988019] XFS (sda6): metadata I/O error: block 0xc477e70 ("xfs_trans_read_buf_map") error 5 numblks 8
[22637.988269] XFS (sda6): metadata I/O error: block 0x118acc80 ("xfs_trans_read_buf_map") error 5 numblks 16
[22637.988271] XFS (sda6): xfs_do_force_shutdown(0x1) called from line 367 of file fs/xfs/xfs_trans_buf.c.  Return address = 0xffffffffa072452a
[22637.988273] XFS (sda6): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[22637.989176] XFS (sda6): metadata I/O error: block 0x16e502b8 ("xfs_trans_read_buf_map") error 5 numblks 8
[22637.991621] XFS (sda6): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[22637.992030] XFS (sda6): xfs_iunlink_remove: xfs_imap_to_bp returned error 5.
[22638.038920] XFS (sda6): xfs_log_force: error 5 returned.
[22650.762320] XFS (sda6): xfs_log_force: error 5 returned.
[22680.765389] XFS (sda6): xfs_log_force: error 5 returned.
[22710.768427] XFS (sda6): xfs_log_force: error 5 returned.
[22740.771440] XFS (sda6): xfs_log_force: error 5 returned.
[22770.774493] XFS (sda6): xfs_log_force: error 5 returned.
[22800.777515] XFS (sda6): xfs_log_force: error 5 returned.
[22830.780562] XFS (sda6): xfs_log_force: error 5 returned.
[22860.783586] XFS (sda6): xfs_log_force: error 5 returned.
[22890.786626] XFS (sda6): xfs_log_force: error 5 returned.
[22920.789653] XFS (sda6): xfs_log_force: error 5 returned.

