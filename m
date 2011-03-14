Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1CNM2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:28:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab1CNM2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:28:15 -0400
Date: Mon, 14 Mar 2011 12:27:46 +0000
From: Mel Gorman <mgorman@suse.de>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: swap: Unlock swapfile inode mutex before closing file on
 bad swapfiles
Message-ID: <20110314122746.GA32408@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an administrator tries to swapon a file backed by NFS, the inode mutex is
taken (as it is for any swapfile) but later identified to be a bad swapfile
due to the lack of bmap and tries to cleanup. During cleanup, an attempt is
made to close the file but with inode->i_mutex still held. Closing an NFS
file syncs it which tries to acquire the inode mutex leading to deadlock. If
lockdep is enabled the following appears on the console;

[  120.968832] =============================================
[  120.972757] [ INFO: possible recursive locking detected ]
[  120.972757] 2.6.38-rc8-autobuild #1
[  120.972757] ---------------------------------------------
[  120.972757] swapon/2192 is trying to acquire lock:
[  120.972757]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81130652>] vfs_fsync_range+0x47/0x7c
[  120.972757]
[  120.972757] but task is already holding lock:
[  120.972757]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff810f9405>] sys_swapon+0x28d/0xae7
[  120.972757]
[  120.972757] other info that might help us debug this:
[  120.972757] 1 lock held by swapon/2192:
[  120.972757]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff810f9405>] sys_swapon+0x28d/0xae7
[  120.972757]
[  120.972757] stack backtrace:
[  120.972757] Pid: 2192, comm: swapon Not tainted 2.6.38-rc8-autobuild #1
[  120.972757] Call Trace:
[  120.972757]  [<ffffffff81075ca8>] ? __lock_acquire+0x2eb/0x1623
[  120.972757]  [<ffffffff810cd5ad>] ? find_get_pages_tag+0x14a/0x174
[  120.972757]  [<ffffffff810d6d01>] ? pagevec_lookup_tag+0x25/0x2e
[  120.972757]  [<ffffffff81130652>] ? vfs_fsync_range+0x47/0x7c
[  120.972757]  [<ffffffff810770b3>] ? lock_acquire+0xd3/0x100
[  120.972757]  [<ffffffff81130652>] ? vfs_fsync_range+0x47/0x7c
[  120.972757]  [<ffffffffa03df8ab>] ? nfs_flush_one+0x0/0xdf [nfs]
[  120.972757]  [<ffffffff81309cdf>] ? mutex_lock_nested+0x40/0x2b1
[  120.972757]  [<ffffffff81130652>] ? vfs_fsync_range+0x47/0x7c
[  120.972757]  [<ffffffff81130652>] ? vfs_fsync_range+0x47/0x7c
[  120.972757]  [<ffffffff811306e6>] ? vfs_fsync+0x1c/0x1e
[  120.972757]  [<ffffffffa03d0c87>] ? nfs_file_flush+0x64/0x69 [nfs]
[  120.972757]  [<ffffffff811097c9>] ? filp_close+0x43/0x72
[  120.972757]  [<ffffffff810f9bb1>] ? sys_swapon+0xa39/0xae7
[  120.972757]  [<ffffffff81002b7a>] ? sysret_check+0x2e/0x69
[  120.972757]  [<ffffffff81002b42>] ? system_call_fastpath+0x16/0x1b

This patch releases the mutex if its held before calling filep_close()
so swapon fails as expected without deadlock when the swapfile is backed
by NFS.  If accepted for 2.6.39, it should also be considered a -stable
candidate for 2.6.38 and 2.6.37.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/swapfile.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0341c57..6d6d28c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2149,8 +2149,13 @@ bad_swap_2:
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
-	if (swap_file)
+	if (swap_file) {
+		if (did_down) {
+			mutex_unlock(&inode->i_mutex);
+			did_down = 0;
+		}
 		filp_close(swap_file, NULL);
+	}
 out:
 	if (page && !IS_ERR(page)) {
 		kunmap(page);
