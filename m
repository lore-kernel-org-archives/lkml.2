Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab1C3E0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 00:26:02 -0400
Received: from sh.osrg.net ([192.16.179.4]:44880 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab1C3E0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 00:26:00 -0400
Date: Wed, 30 Mar 2011 13:25:55 +0900 (JST)
Message-Id: <20110330.132555.158630340.ryusuke@osrg.net>
To: linux-nilfs <linux-nilfs@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] nilfs2: fix oops due to a bad aops initialization
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 30 Mar 2011 13:25:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've found a regression of nilfs2 file system in 2.6.39-rc1.

The recent per-queue plugging removal patch causes kernel oopses in
nilfs.  The following patch will fix this.

I'll send it to Linus along with other bug-fixes.

Thanks,
Ryusuke Konishi
--
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

nilfs2: fix oops due to a bad aops initialization

Nilfs in 2.6.39-rc1 hit the following oops:

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
 IP: [<ffffffff810ac235>] try_to_release_page+0x2a/0x3d
 PGD 234cb6067 PUD 234c72067 PMD 0
 Oops: 0000 [#1] SMP
 <snip>
 Process truncate (pid: 10995, threadinfo ffff8802353c2000, task ffff880234cfa000)
 Stack:
  ffff8802333c77b8 ffffffff810b64b0 0000000000003802 ffffffffa0052cca
  0000000000000000 ffff8802353c3b58 0000000000000000 ffff8802353c3b58
  0000000000000001 0000000000000000 ffffea0007b92308 ffffea0007b92308
 Call Trace:
  [<ffffffff810b64b0>] ? invalidate_inode_pages2_range+0x15f/0x273
  [<ffffffffa0052cca>] ? nilfs_palloc_get_block+0x2d/0xaf [nilfs2]
  [<ffffffff810589e7>] ? bit_waitqueue+0x14/0xa1
  [<ffffffff81058ab1>] ? wake_up_bit+0x10/0x20
  [<ffffffffa00433fd>] ? nilfs_forget_buffer+0x66/0x7a [nilfs2]
  [<ffffffffa00467b8>] ? nilfs_btree_concat_left+0x5c/0x77 [nilfs2]
  [<ffffffffa00471fc>] ? nilfs_btree_delete+0x395/0x3cf [nilfs2]
  [<ffffffffa00449a3>] ? nilfs_bmap_do_delete+0x6e/0x79 [nilfs2]
  [<ffffffffa0045845>] ? nilfs_btree_last_key+0x14b/0x15e [nilfs2]
  [<ffffffffa00449dd>] ? nilfs_bmap_truncate+0x2f/0x83 [nilfs2]
  [<ffffffffa0044ab2>] ? nilfs_bmap_last_key+0x35/0x62 [nilfs2]
  [<ffffffffa003e99b>] ? nilfs_truncate_bmap+0x6b/0xc7 [nilfs2]
  [<ffffffffa003ee4a>] ? nilfs_truncate+0x79/0xe4 [nilfs2]
  [<ffffffff810b6c00>] ? vmtruncate+0x33/0x3b
  [<ffffffffa003e8f1>] ? nilfs_setattr+0x4d/0x8c [nilfs2]
  [<ffffffff81026106>] ? do_page_fault+0x31b/0x356
  [<ffffffff810f9d61>] ? notify_change+0x17d/0x262
  [<ffffffff810e5046>] ? do_truncate+0x65/0x80
  [<ffffffff810e52af>] ? sys_ftruncate+0xf1/0xf6
  [<ffffffff8132c012>] ? system_call_fastpath+0x16/0x1b
 Code: c3 48 83 ec 08 48 8b 17 48 8b 47 18 80 e2 01 75 04 0f 0b eb fe 48 8b 17 80 e6 20 74 05 31 c0 41 59 c3 48 85 c0 74 11 48 8b 40 58
  8b 40 48 48 85 c0 74 04 41 58 ff e0 59 e9 b1 b5 05 00 41 54
 RIP  [<ffffffff810ac235>] try_to_release_page+0x2a/0x3d
  RSP <ffff8802353c3b08>
 CR2: 0000000000000048

This oops was brought in by the change "block: remove per-queue
plugging" (commit: 7eaceaccab5f40bb).  It initializes mapping->a_ops
with a NULL pointer for some pages in nilfs (e.g. btree node pages),
but mm code doesn't NULL pointer checks against mapping->a_ops. (the
check is done for each callback function)

This corrects the aops initialization and fixes the oops.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Jens Axboe <jaxboe@fusionio.com>
---
 fs/nilfs2/page.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 4d2a1ee..9d2dc6b 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -495,12 +495,14 @@ unsigned nilfs_page_count_clean_buffers(struct page *page,
 void nilfs_mapping_init(struct address_space *mapping,
 			struct backing_dev_info *bdi)
 {
+	static const struct address_space_operations empty_aops;
+
 	mapping->host = NULL;
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	mapping->assoc_mapping = NULL;
 	mapping->backing_dev_info = bdi;
-	mapping->a_ops = NULL;
+	mapping->a_ops = &empty_aops;
 }
 
 /*
-- 
1.7.3.5

