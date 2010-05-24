Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab0EXXZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:25:31 -0400
Received: from kroah.org ([198.145.64.141]:59523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab0EXXX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:56 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:16 2010
Message-Id: <20100524231816.515721694@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [37/39] nilfs2: fix sync silent failure
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit 973bec34bfc1bc2465646181653d67f767d418c8 upstream.

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
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -746,6 +746,7 @@ nilfs_fill_super(struct super_block *sb,
 	sb->s_export_op = &nilfs_export_ops;
 	sb->s_root = NULL;
 	sb->s_time_gran = 1;
+	sb->s_bdi = nilfs->ns_bdi;
 
 	err = load_nilfs(nilfs, sbi);
 	if (err)


