Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0ERQw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:52:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:36118 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467Ab0ERQww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:52:52 -0400
Date: Wed, 19 May 2010 01:47:41 +0900 (JST)
Message-Id: <20100519.014741.220046229.ryusuke@osrg.net>
To: stable <stable@kernel.org>
Cc: linux-nilfs@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] nilfs2: fix sync silent failure
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20100519.012423.218986668.ryusuke@osrg.net>
References: <20100519.012423.218986668.ryusuke@osrg.net>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 19 May 2010 01:47:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 01:24:23 +0900 (JST), Ryusuke Konishi wrote:
> Please consider commit 973bec34bfc1bc2465646181653d67f767d418c8 for
> inclusion in 2.6.33.y and 2.6.32.y.
> 
> Here is the commit message.  It fixes a grave regression since 2.6.32,
> which makes "sync" operation nonfunctional, and leading to unexpected
> user's data loss.
> 
> I have tested the patch, and confirmed that it restores the function
> of "sync" for both 2.6.33.y and 2.6.32.y.  Unfortunetaly, the patch
> didn't apply to 2.6.32.y as is (3-way merge was required).
> 
> To make sure, I will later post an adjusted patch against 2.6.32.y.

Here is the patch for 2.6.32.y.

Thanks,
Ryusuke Konishi

--
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Mon, 3 May 2010 21:00:48 +0900
Subject: [PATCH] nilfs2: fix sync silent failure

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
---
 fs/nilfs2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 644e667..63e7b10 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -781,6 +781,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 	sb->s_export_op = &nilfs_export_ops;
 	sb->s_root = NULL;
 	sb->s_time_gran = 1;
+	sb->s_bdi = nilfs->ns_bdi;
 
 	if (!nilfs_loaded(nilfs)) {
 		err = load_nilfs(nilfs, sbi);
-- 
1.5.6.5

