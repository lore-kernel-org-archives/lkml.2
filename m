Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1JaIf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 04:35:56 -0400
Received: from mailout09.t-online.de ([194.25.134.84]:57801 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab1JaIfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 04:35:55 -0400
Message-ID: <4EAE5DE3.2020205@t-online.de>
Date: Mon, 31 Oct 2011 09:35:47 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: reiserfs-devel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@suse.de>
Subject: [BUG] kernel 3.1.0 possible circular locking dependency detected
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: EG+E4GZpghiETuroFrxrImlzZ9lmAMFZP3dYmoV0dUUC3MNGs9WxxxP-YHPLc6-wXU
X-TOI-MSGID: fca47991-86b7-4d19-aa04-38669df422ad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a " rm -r /verybigdir" (about 12G on a 25G reiserfs 3.6partition)
I found the following report about a circular locking dependency in
kernel 3.1.0

[  337.064044]
[  337.064046] =======================================================
[  337.064059] [ INFO: possible circular locking dependency detected ]
[  337.064069] 3.1.0-main #18
[  337.064074] -------------------------------------------------------
[  337.064083] rm/4340 is trying to acquire lock:
[  337.064090]  (&sb->s_type->i_mutex_key#12/2){+.+.+.}, at: [<c01f73d7>] xattr_unlink+0x3a/0x6d
[  337.064114]
[  337.064115] but task is already holding lock:
[  337.064123]  (&sb->s_type->i_mutex_key#12/3){+.+.+.}, at: [<c01f7884>] reiserfs_for_each_xattr+0x9e/0x224
[  337.064143]
[  337.064144] which lock already depends on the new lock.
[  337.064146]
[  337.064156]
[  337.064157] the existing dependency chain (in reverse order) is:
[  337.064167]
[  337.064168] -> #1 (&sb->s_type->i_mutex_key#12/3){+.+.+.}:
[  337.064184]        [<c0149c32>] lock_acquire+0x47/0x5e
[  337.064195]        [<c04360df>] mutex_lock_nested+0x35/0x26f
[  337.064208]        [<c01f7603>] open_xa_dir+0x3d/0x150
[  337.064218]        [<c01f772a>] xattr_lookup+0x14/0xd0
[  337.064228]        [<c01f7f50>] reiserfs_xattr_get+0x4c/0x21b
[  337.064238]        [<c01f88f4>] security_get+0x3e/0x46
[  337.064248]        [<c01f817c>] reiserfs_getxattr+0x5d/0x7a
[  337.064258]        [<c02414e8>] cap_inode_need_killpriv+0x1e/0x2d
[  337.064272]        [<c024264c>] security_inode_need_killpriv+0xf/0x11
[  337.064284]        [<c016dc16>] file_remove_suid+0x27/0x71
[  337.064296]        [<c01ae38b>] generic_file_splice_write+0x86/0x121
[  337.064310]        [<c01adfa9>] do_splice_from+0x58/0x62
[  337.064320]        [<c01adfca>] direct_splice_actor+0x17/0x1c
[  337.064331]        [<c01ae256>] splice_direct_to_actor+0xbf/0x16e
[  337.064342]        [<c01af16c>] do_splice_direct+0x4b/0x62
[  337.064353]        [<c0192e02>] do_sendfile+0x159/0x1f1
[  337.064365]        [<c01938d7>] sys_sendfile64+0x3f/0x80
[  337.064375]        [<c043b10c>] sysenter_do_call+0x12/0x32
[  337.064388]
[  337.064389] -> #0 (&sb->s_type->i_mutex_key#12/2){+.+.+.}:
[  337.064404]        [<c01492ca>] __lock_acquire+0xee6/0x1472
[  337.064416]        [<c0149c32>] lock_acquire+0x47/0x5e
[  337.064426]        [<c04360df>] mutex_lock_nested+0x35/0x26f
[  337.064436]        [<c01f73d7>] xattr_unlink+0x3a/0x6d
[  337.064446]        [<c01f7499>] delete_one_xattr+0x8f/0x99
[  337.064456]        [<c01f78cf>] reiserfs_for_each_xattr+0xe9/0x224
[  337.064467]        [<c01f7a1f>] reiserfs_delete_xattrs+0x15/0x3f
[  337.064477]        [<c01dfba5>] reiserfs_evict_inode+0x7f/0x115
[  337.064490]        [<c01a4f27>] evict+0x85/0x126
[  337.064500]        [<c01a5109>] iput+0x141/0x146
[  337.064509]        [<c019d6d9>] do_unlinkat+0xf1/0x136
[  337.064520]        [<c019df1f>] sys_unlinkat+0x2b/0x32
[  337.064530]        [<c043b10c>] sysenter_do_call+0x12/0x32
[  337.064541]
[  337.064542] other info that might help us debug this:
[  337.064544]
[  337.064570]  Possible unsafe locking scenario:
[  337.064572]
[  337.064588]        CPU0                    CPU1
[  337.064599]        ----                    ----
[  337.064609]   lock(&sb->s_type->i_mutex_key);
[  337.064623]                                lock(&sb->s_type->i_mutex_key);
[  337.064638]                                lock(&sb->s_type->i_mutex_key);
[  337.064654]   lock(&sb->s_type->i_mutex_key);
[  337.064667]
[  337.064668]  *** DEADLOCK ***
[  337.064669]
[  337.064690] 1 lock held by rm/4340:
[  337.064700]  #0:  (&sb->s_type->i_mutex_key#12/3){+.+.+.}, at: [<c01f7884>] reiserfs_for_each_xattr+0x9e/0x224
[  337.064725]
[  337.064726] stack backtrace:
[  337.064743] Pid: 4340, comm: rm Not tainted 3.1.0-main #18
[  337.064755] Call Trace:
[  337.064767]  [<c0434964>] ? printk+0xf/0x13
[  337.064781]  [<c014732b>] print_circular_bug+0x215/0x222
[  337.064796]  [<c01492ca>] __lock_acquire+0xee6/0x1472
[  337.064811]  [<c0144a54>] ? tick_dev_program_event+0x24/0x105
[  337.064826]  [<c0149c32>] lock_acquire+0x47/0x5e
[  337.064839]  [<c01f73d7>] ? xattr_unlink+0x3a/0x6d
[  337.064853]  [<c01f73d7>] ? xattr_unlink+0x3a/0x6d
[  337.064867]  [<c04360df>] mutex_lock_nested+0x35/0x26f
[  337.064881]  [<c01f73d7>] ? xattr_unlink+0x3a/0x6d
[  337.064894]  [<c01f73d7>] xattr_unlink+0x3a/0x6d
[  337.064908]  [<c01f7499>] delete_one_xattr+0x8f/0x99
[  337.064921]  [<c01f78cf>] reiserfs_for_each_xattr+0xe9/0x224
[  337.064936]  [<c01f740a>] ? xattr_unlink+0x6d/0x6d
[  337.064950]  [<c0439a6f>] ? sub_preempt_count+0x81/0x8e
[  337.064965]  [<c04362fe>] ? mutex_lock_nested+0x254/0x26f
[  337.064980]  [<c01f7a1f>] reiserfs_delete_xattrs+0x15/0x3f
[  337.064994]  [<c01dfba5>] reiserfs_evict_inode+0x7f/0x115
[  337.065009]  [<c0120da4>] ? get_parent_ip+0xb/0x31
[  337.065023]  [<c0439a6f>] ? sub_preempt_count+0x81/0x8e
[  337.065037]  [<c01a4f27>] evict+0x85/0x126
[  337.065050]  [<c01a5109>] iput+0x141/0x146
[  337.065063]  [<c019d6d9>] do_unlinkat+0xf1/0x136
[  337.065078]  [<c01bb261>] ? dnotify_flush+0x2c/0xa6
[  337.065092]  [<c043b13b>] ? sysenter_exit+0xf/0x16
[  337.065107]  [<c019df1f>] sys_unlinkat+0x2b/0x32
[  337.065120]  [<c043b10c>] sysenter_do_call+0x12/0x32

