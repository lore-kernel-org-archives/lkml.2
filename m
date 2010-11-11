Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab0KKT0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:26:00 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:39289 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab0KKTZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:25:56 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: mmotm 2010-11-09 - lockdep splat in ext4/quota code
In-Reply-To: Your message of "Tue, 09 Nov 2010 15:31:15 PST."
             <201011100003.oAA03O3c015222@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201011100003.oAA03O3c015222@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1289503541_5030P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Nov 2010 14:25:41 -0500
Message-ID: <19688.1289503541@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4CDC4335.01E4,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1289503541_5030P
Content-Type: text/plain; charset=us-ascii

On Tue, 09 Nov 2010 15:31:15 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-11-09-15-31 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Still seeing this just after quotas get turned on ext4. First seen in
2.6.36-mmotm1022, but problem has apparently been there since
2.6.36-rc5-mmotm0922 (oldest kernel I have lying around).

The last few relevant commands from rc.sysinit:

/sbin/quotaon -aug
dd if=/dev/urandom of=/var/lib/random-seed count=1 bs=512   <- this triggers the trace

[   48.967833] =======================================================
[   48.968162] [ INFO: possible circular locking dependency detected ]
[   48.968411] 2.6.37-rc1-mmotm1109 #1
[   48.968553] -------------------------------------------------------
[   48.968592] dd/3253 is trying to acquire lock:
[   48.968592]  (&s->s_dquot.dqio_mutex){+.+...}, at: [<ffffffff81141b0a>] dquot_commit+0x26/0xda
[   48.968592] 
[   48.968592] but task is already holding lock:
[   48.968592]  (&s->s_dquot.dqptr_sem){++++..}, at: [<ffffffff81143e70>] __dquot_free_space+0x66/0x16b
[   48.968592] 
[   48.968592] which lock already depends on the new lock.
[   48.968592] 
[   48.968592] 
[   48.968592] the existing dependency chain (in reverse order) is:
[   48.968592] 
[   48.968592] -> #2 (&s->s_dquot.dqptr_sem){++++..}:
[   48.968592]        [<ffffffff8106b441>] lock_acquire+0x100/0x126
[   48.968592]        [<ffffffff81565615>] down_read+0x42/0x51
[   48.968592]        [<ffffffff81143e70>] __dquot_free_space+0x66/0x16b
[   48.968592]        [<ffffffff81199a70>] dquot_free_block+0x19/0x2a
[   48.968592]        [<ffffffff8119fc4f>] ext4_free_blocks+0x75b/0x810
[   48.968592]        [<ffffffff81196f0f>] ext4_ext_truncate+0x3af/0x853
[   48.968592]        [<ffffffff8117a02e>] ext4_truncate+0x98/0x51a
[   48.968592]        [<ffffffff810c46a4>] vmtruncate+0x3f/0x4b
[   48.968592]        [<ffffffff8117af55>] ext4_setattr+0x305/0x3a7
[   48.968592]        [<ffffffff8110c6d9>] notify_change+0x1a1/0x2a1
[   48.968592]        [<ffffffff810f49fa>] do_truncate+0x67/0x84
[   48.968592]        [<ffffffff811029f5>] do_last+0x4ce/0x5b2
[   48.968592]        [<ffffffff81102d21>] do_filp_open+0x248/0x64a
[   48.968592]        [<ffffffff810f5481>] do_sys_open+0x60/0xfb
[   48.968592]        [<ffffffff810f5537>] sys_open+0x1b/0x1d
[   48.968592]        [<ffffffff810027eb>] system_call_fastpath+0x16/0x1b
[   48.968592] 
[   48.968592] -> #1 (&ei->i_data_sem){++++..}:
[   48.968592]        [<ffffffff8106b441>] lock_acquire+0x100/0x126
[   48.968592]        [<ffffffff81565615>] down_read+0x42/0x51
[   48.968592]        [<ffffffff81179383>] ext4_map_blocks+0x3e/0x20e
[   48.968592]        [<ffffffff81179e0b>] ext4_getblk+0x71/0x19b
[   48.968592]        [<ffffffff81179f46>] ext4_bread+0x11/0x61
[   48.968592]        [<ffffffff8118b297>] ext4_quota_read+0x86/0xf0
[   48.968592]        [<ffffffff81145131>] v2_read_header+0x1e/0x4f
[   48.968592]        [<ffffffff811455de>] v2_read_file_info+0x20/0x2ae
[   48.968592]        [<ffffffff81144423>] vfs_load_quota_inode+0x292/0x448
[   48.968592]        [<ffffffff8114480e>] dquot_quota_on_path+0x4c/0x55
[   48.968592]        [<ffffffff8118bc97>] ext4_quota_on+0x123/0x175
[   48.968592]        [<ffffffff81146cf2>] do_quotactl+0x1d1/0x465
[   48.968592]        [<ffffffff81147083>] sys_quotactl+0xfd/0x11a
[   48.968592]        [<ffffffff810027eb>] system_call_fastpath+0x16/0x1b
[   48.968592] 
[   48.968592] -> #0 (&s->s_dquot.dqio_mutex){+.+...}:
[   48.968592]        [<ffffffff8106ac2d>] __lock_acquire+0xa4c/0xd4e
[   48.968592]        [<ffffffff8106b441>] lock_acquire+0x100/0x126
[   48.968592]        [<ffffffff81564bbf>] __mutex_lock_common+0x5d/0x56c
[   48.968592]        [<ffffffff81565174>] mutex_lock_nested+0x34/0x39
[   48.968592]        [<ffffffff81141b0a>] dquot_commit+0x26/0xda
[   48.968592]        [<ffffffff8118d622>] ext4_write_dquot+0x65/0x87
[   48.968592]        [<ffffffff8118d682>] ext4_mark_dquot_dirty+0x3e/0x49
[   48.968592]        [<ffffffff81141790>] mark_all_dquot_dirty+0x22/0x48
[   48.968592]        [<ffffffff81143f43>] __dquot_free_space+0x139/0x16b
[   48.968592]        [<ffffffff81199a70>] dquot_free_block+0x19/0x2a
[   48.968592]        [<ffffffff8119fc4f>] ext4_free_blocks+0x75b/0x810
[   48.968592]        [<ffffffff81196f0f>] ext4_ext_truncate+0x3af/0x853
[   48.968592]        [<ffffffff8117a02e>] ext4_truncate+0x98/0x51a
[   48.968592]        [<ffffffff810c46a4>] vmtruncate+0x3f/0x4b
[   48.968592]        [<ffffffff8117af55>] ext4_setattr+0x305/0x3a7
[   48.968592]        [<ffffffff8110c6d9>] notify_change+0x1a1/0x2a1
[   48.968592]        [<ffffffff810f49fa>] do_truncate+0x67/0x84
[   48.968592]        [<ffffffff811029f5>] do_last+0x4ce/0x5b2
[   48.968592]        [<ffffffff81102d21>] do_filp_open+0x248/0x64a
[   48.968592]        [<ffffffff810f5481>] do_sys_open+0x60/0xfb
[   48.968592]        [<ffffffff810f5537>] sys_open+0x1b/0x1d
[   48.968592]        [<ffffffff810027eb>] system_call_fastpath+0x16/0x1b
[   48.968592] 
[   48.968592] other info that might help us debug this:
[   48.968592] 
[   49.458584] 5 locks held by dd/3253:
[   49.458584]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff810f49ee>] do_truncate+0x5b/0x84
[   49.458584]  #1:  (&sb->s_type->i_alloc_sem_key#5){+.+...}, at: [<ffffffff8110c6c1>] notify_change+0x189/0x2a1
[   49.458584]  #2:  (jbd2_handle){+.+...}, at: [<ffffffff811ad5b4>] start_this_handle+0x57a/0x605
[   49.458584]  #3:  (&ei->i_data_sem){++++..}, at: [<ffffffff81196bf1>] ext4_ext_truncate+0x91/0x853
[   49.458584]  #4:  (&s->s_dquot.dqptr_sem){++++..}, at: [<ffffffff81143e70>] __dquot_free_space+0x66/0x16b
[   49.458584] 
[   49.458584] stack backtrace:
[   49.458584] Pid: 3253, comm: dd Not tainted 2.6.37-rc1-mmotm1109 #1
[   49.458584] Call Trace:
[   49.458584]  [<ffffffff81069591>] print_circular_bug+0xa8/0xb7
[   49.458584]  [<ffffffff8106ac2d>] __lock_acquire+0xa4c/0xd4e
[   49.458584]  [<ffffffff81141b0a>] ? dquot_commit+0x26/0xda
[   49.458584]  [<ffffffff8106b441>] lock_acquire+0x100/0x126
[   49.458584]  [<ffffffff81141b0a>] ? dquot_commit+0x26/0xda
[   49.458584]  [<ffffffff81564bbf>] __mutex_lock_common+0x5d/0x56c
[   49.458584]  [<ffffffff81141b0a>] ? dquot_commit+0x26/0xda
[   49.458584]  [<ffffffff81141ef2>] ? dquot_mark_dquot_dirty+0x27/0x7a
[   49.458584]  [<ffffffff81141b0a>] ? dquot_commit+0x26/0xda
[   49.458584]  [<ffffffff81565174>] mutex_lock_nested+0x34/0x39
[   49.458584]  [<ffffffff81141b0a>] dquot_commit+0x26/0xda
[   49.458584]  [<ffffffff8118d622>] ext4_write_dquot+0x65/0x87
[   49.458584]  [<ffffffff8118d682>] ext4_mark_dquot_dirty+0x3e/0x49
[   49.458584]  [<ffffffff81141790>] mark_all_dquot_dirty+0x22/0x48
[   49.458584]  [<ffffffff81143f43>] __dquot_free_space+0x139/0x16b
[   49.458584]  [<ffffffff81199a70>] dquot_free_block+0x19/0x2a
[   49.458584]  [<ffffffff8119fc4f>] ext4_free_blocks+0x75b/0x810
[   49.458584]  [<ffffffff811ada1d>] ? jbd2_journal_extend+0x5d/0xb8
[   49.458584]  [<ffffffff81196f0f>] ext4_ext_truncate+0x3af/0x853
[   49.458584]  [<ffffffff810a5759>] ? trace_preempt_on+0x15/0x28
[   49.458584]  [<ffffffff810d63f6>] ? unmap_mapping_range+0x279/0x288
[   49.458584]  [<ffffffff8117a02e>] ext4_truncate+0x98/0x51a
[   49.458584]  [<ffffffff810d63f6>] ? unmap_mapping_range+0x279/0x288
[   49.458584]  [<ffffffff8106b861>] ? trace_hardirqs_on_caller+0x117/0x13b
[   49.458584]  [<ffffffff8106b892>] ? trace_hardirqs_on+0xd/0xf
[   49.458584]  [<ffffffff810c46a4>] vmtruncate+0x3f/0x4b
[   49.458584]  [<ffffffff8117af55>] ext4_setattr+0x305/0x3a7
[   49.458584]  [<ffffffff8110c6d9>] notify_change+0x1a1/0x2a1
[   49.458584]  [<ffffffff810f49fa>] do_truncate+0x67/0x84
[   49.458584]  [<ffffffff810ff92d>] ? get_write_access+0x49/0x50
[   49.458584]  [<ffffffff81566794>] ? _raw_spin_unlock+0x30/0x69
[   49.458584]  [<ffffffff8156a040>] ? sub_preempt_count+0x35/0x48
[   49.458584]  [<ffffffff811e0833>] ? security_path_truncate+0x48/0x4d
[   49.458584]  [<ffffffff811029f5>] do_last+0x4ce/0x5b2
[   49.458584]  [<ffffffff81102d21>] do_filp_open+0x248/0x64a
[   49.458584]  [<ffffffff810a5759>] ? trace_preempt_on+0x15/0x28
[   49.458584]  [<ffffffff8110d8ce>] ? alloc_fd+0x17c/0x18e
[   49.458584]  [<ffffffff81566794>] ? _raw_spin_unlock+0x30/0x69
[   49.458584]  [<ffffffff8156a040>] ? sub_preempt_count+0x35/0x48
[   49.458584]  [<ffffffff8110d8ce>] ? alloc_fd+0x17c/0x18e
[   49.458584]  [<ffffffff810f5481>] do_sys_open+0x60/0xfb
[   49.458584]  [<ffffffff81565fde>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   49.458584]  [<ffffffff810f5537>] sys_open+0x1b/0x1d
[   49.458584]  [<ffffffff810027eb>] system_call_fastpath+0x16/0x1b



--==_Exmh_1289503541_5030P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM3EM1cC3lWbTT17ARAhyTAKDT/oRwSNtd9wWEV9C4zd9NINmnDwCgliVG
wGA+PRVx1xsHD2iymQ95y0M=
=n9I2
-----END PGP SIGNATURE-----

--==_Exmh_1289503541_5030P--

