Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab0ECMBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 08:01:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:50002 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab0ECMBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 08:01:01 -0400
Date: Mon, 03 May 2010 21:00:48 +0900 (JST)
Message-Id: <20100503.210048.267730124.ryusuke@osrg.net>
To: Jens Axboe <Jens.Axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nilfs <linux-nilfs@vger.kernel.org>
Subject: [PATCH] nilfs2: fix sync silent failure
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 03 May 2010 21:00:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another fix for the silent sync failure related to sb->s_bdi.

The commit 5129a469, which was merged to -rc6, let me know this
problem.  I'm sorry that I was late to realize this.

Nilfs uses an own get_sb callback, and needed to set s_bdi for itself.
I confirmed this patch made ->sync_fs() called as intended.

I hope this is sent for 2.6.34.  Please let me know if you have any
comments.

Thanks,
Ryusuke Konishi
---
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

As of 32a88aa1, __sync_filesystem() will return 0 if s_bdi is not set.
And nilfs does not set s_bdi anywhere.  I noticed this problem by the
warning introduced by the recent commit 5129a469 ("Catch filesystem
lacking s_bdi").

 WARNING: at fs/super.c:959 vfs_kern_mount+0xc5/0x14e()
 Hardware name: PowerEdge 2850
 Modules linked in: nilfs2 loop tpm_tis tpm tpm_bios video shpchp pci_hotplug output dcdbas
 Pid: 3773, comm: mount.nilfs2 Not tainted 2.6.34-rc6-debug #38
 Call Trace:
  [<c1028422>] warn_slowpath_common+0x60/0x90
  [<c102845f>] warn_slowpath_null+0xd/0x10
  [<c1095936>] vfs_kern_mount+0xc5/0x14e
  [<c1095a03>] do_kern_mount+0x32/0xbd
  [<c10a811e>] do_mount+0x671/0x6d0
  [<c1073794>] ? __get_free_pages+0x1f/0x21
  [<c10a684f>] ? copy_mount_options+0x2b/0xe2
  [<c107b634>] ? strndup_user+0x48/0x67
  [<c10a81de>] sys_mount+0x61/0x8f
  [<c100280c>] sysenter_do_call+0x12/0x32

This ensures to set s_bdi for nilfs and fixes the sync silent failure.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 0cdbc5e..48145f5 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -749,6 +749,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	sb->s_export_op = &nilfs_export_ops;
 	sb->s_root = NULL;
 	sb->s_time_gran = 1;
+	sb->s_bdi = nilfs->ns_bdi;
 
 	err = load_nilfs(nilfs, sbi);
 	if (err)
-- 
1.6.3.4
