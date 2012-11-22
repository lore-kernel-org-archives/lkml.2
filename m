Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab2KVWxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:53:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab2KVWxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:53:04 -0500
Date: Thu, 22 Nov 2012 23:53:01 +0100
From: Jan Kara <jack@suse.cz>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Unbalanced unlock with sysrq+SUB
Message-ID: <20121122225301.GC20326@quack.suse.cz>
References: <50AEA7C8.6070102@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <50AEA7C8.6070102@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Thu 22-11-12 23:31:36, Zdenek Kabelac wrote:
> For some time - when I reboot via  'sysrq + SUB' I get this BUG: message
> My system is running rawhide (systemd) on ext4 filesystem.
> systemd-195-7.fc18.x86_64
  Thanks for report. Looks like my problem. Attached patch should fix it.

								Honza
  
> SysRq : Emergency Remount R/O
> 
> =====================================
> [ BUG: bad unlock balance detected! ]
> 3.7.0-rc6-00028-g88e75b6 #101 Not tainted
> -------------------------------------
> kworker/1:2/79 is trying to release lock (sb_writers) at:
> [<ffffffff811b33b4>] mnt_drop_write+0x24/0x30
> but there are no more locks to release!
> 
> other info that might help us debug this:
> 4 locks held by kworker/1:2/79:
>  #0:  (events){.+.+.+}, at: [<ffffffff81064a79>] process_one_work+0x149/0x750
>  #1:  ((work)#3){+.+...}, at: [<ffffffff81064a79>] process_one_work+0x149/0x750
>  #2:  (&type->s_umount_key#19){+++++.}, at: [<ffffffff81194140>]
> do_emergency_remount+0x80/0x120
>  #3:  (files_lglock){.+.+..}, at: [<ffffffff8119202b>] mark_files_ro+0x2b/0x100
> 
> stack backtrace:
> Pid: 79, comm: kworker/1:2 Not tainted 3.7.0-rc6-00028-g88e75b6 #101
> Call Trace:
>  [<ffffffff811b33b4>] ? mnt_drop_write+0x24/0x30
>  [<ffffffff810ae52e>] print_unlock_inbalance_bug+0xfe/0x110
>  [<ffffffff810b10fe>] lock_release_non_nested+0x21e/0x320
>  [<ffffffff8113c9a5>] ? pagevec_lookup_tag+0x25/0x40
>  [<ffffffff811b33b4>] ? mnt_drop_write+0x24/0x30
>  [<ffffffff810b1297>] lock_release+0x97/0x300
>  [<ffffffff811926b1>] __sb_end_write+0x81/0x90
>  [<ffffffff811b33b4>] mnt_drop_write+0x24/0x30
>  [<ffffffff811b33d2>] mnt_drop_write_file+0x12/0x20
>  [<ffffffff811920f7>] mark_files_ro+0xf7/0x100
>  [<ffffffff81193f6d>] do_remount_sb+0x13d/0x1b0
>  [<ffffffff81194140>] ? do_emergency_remount+0x80/0x120
>  [<ffffffff811941dc>] do_emergency_remount+0x11c/0x120
>  [<ffffffff81064add>] process_one_work+0x1ad/0x750
>  [<ffffffff81064a79>] ? process_one_work+0x149/0x750
>  [<ffffffff8106550b>] ? worker_thread+0x21b/0x450
>  [<ffffffff81557219>] ? _raw_spin_lock_irq+0x19/0x80
>  [<ffffffff811940c0>] ? mount_single+0xe0/0xe0
>  [<ffffffff8106544d>] worker_thread+0x15d/0x450
>  [<ffffffff810652f0>] ? rescuer_thread+0x230/0x230
>  [<ffffffff8106f50b>] kthread+0xdb/0xe0
>  [<ffffffff8106f430>] ? kthread_create_on_node+0x140/0x140
>  [<ffffffff8155fe1c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8106f430>] ? kthread_create_on_node+0x140/0x140
> EXT4-fs (sda2): re-mounted. Opts: (null)
> EXT4-fs (sda5): re-mounted. Opts: (null)
> Emergency Remount complete
> systemd[1]: Stopping Sendmail Mail Transport Client...
> systemd[1]: Stopping Sendmail Mail Transport Agent...
> systemd[1]: Starting Sendmail Mail Transport Agent...
> systemd[1]: Started Sendmail Mail Transport Agent.
> systemd[1]: Starting Sendmail Mail Transport Client...
> systemd[1]: Started Sendmail Mail Transport Client.
> SysRq : Resetting
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--nFreZHaLTZJo0R7j
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-fs-Fix-imbalance-in-freeze-protection-in-mark_files_.patch"

>From fd6469756345146cb925766f0798187800c6c89c Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 22 Nov 2012 23:44:01 +0100
Subject: [PATCH] fs: Fix imbalance in freeze protection in mark_files_ro()

File descriptors (even those for writing) do not hold freeze protection.
Thus mark_files_ro() must call __mnt_drop_write() to only drop protection
against remount read-only. Calling mnt_drop_write_file() as we do now
results in:

[ BUG: bad unlock balance detected! ]
3.7.0-rc6-00028-g88e75b6 #101 Not tainted
-------------------------------------
kworker/1:2/79 is trying to release lock (sb_writers) at:
[<ffffffff811b33b4>] mnt_drop_write+0x24/0x30
but there are no more locks to release!

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
CC: stable@vger.kernel.org # >= 3.6
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/file_table.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index a72bf9d..de9e965 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -458,8 +458,8 @@ void mark_files_ro(struct super_block *sb)
 		spin_unlock(&f->f_lock);
 		if (file_check_writeable(f) != 0)
 			continue;
+		__mnt_drop_write(f->f_path.mnt);
 		file_release_write(f);
-		mnt_drop_write_file(f);
 	} while_file_list_for_each_entry;
 	lg_global_unlock(&files_lglock);
 }
-- 
1.7.1


--nFreZHaLTZJo0R7j--
