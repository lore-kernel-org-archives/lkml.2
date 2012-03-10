Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2CJOrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 09:47:47 -0500
Received: from sh.osrg.net ([192.16.179.4]:54451 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab2CJOrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 09:47:25 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] nilfs2: fix NULL pointer dereference in nilfs_load_super_block()
Date: Sat, 10 Mar 2012 23:35:30 +0900
Message-Id: <1331390130-7286-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1331390130-7286-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1331390130-7286-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Sat, 10 Mar 2012 23:47:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the report from Slicky Devil, nilfs caused kernel oops at
nilfs_load_super_block function during mount after he shrank the
partition without resizing the filesystem:

 BUG: unable to handle kernel NULL pointer dereference at 00000048
 IP: [<d0d7a08e>] nilfs_load_super_block+0x17e/0x280 [nilfs2]
 *pde = 00000000
 Oops: 0000 [#1] PREEMPT SMP
 ...
 Call Trace:
  [<d0d7a87b>] init_nilfs+0x4b/0x2e0 [nilfs2]
  [<d0d6f707>] nilfs_mount+0x447/0x5b0 [nilfs2]
  [<c01f33a4>] ? pcpu_alloc+0x714/0x810
  [<c02d2add>] ? ida_get_new_above+0x1ad/0x230
  [<c02d2add>] ? ida_get_new_above+0x1ad/0x230
  [<c0226636>] mount_fs+0x36/0x180
  [<c01f34af>] ? __alloc_percpu+0xf/0x20
  [<c023d961>] vfs_kern_mount+0x51/0xa0
  [<c023ddae>] do_kern_mount+0x3e/0xe0
  [<c023f189>] do_mount+0x169/0x700
  [<c01eeb29>] ? strndup_user+0x49/0x70
  [<c023fa9b>] sys_mount+0x6b/0xa0
  [<c04abd1f>] sysenter_do_call+0x12/0x28
 Code: 53 18 8b 43 20 89 4b 18 8b 4b 24 89 53 1c 89 43 24 89 4b 20 8b 43
 20 c7 43 2c 00 00 00 00 23 75 e8 8b 50 68 89 53 28 8b 54 b3 20 <8b> 72
 48 8b 7a 4c 8b 55 08 89 b3 84 00 00 00 89 bb 88 00 00 00
 EIP: [<d0d7a08e>] nilfs_load_super_block+0x17e/0x280 [nilfs2] SS:ESP 0068:ca9bbdcc
 CR2: 0000000000000048

This turned out due to a defect in an error path which runs if the
calculated location of the secondary super block was invalid.

This patch fixes it and eliminates the reported oops.

Reported-by: Slicky Devil <slicky.dvl@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Slicky Devil <slicky.dvl@gmail.com>
Cc: <stable@vger.kernel.org> # 2.6.30+
---
 fs/nilfs2/the_nilfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 8a75901..501b7f8 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -521,6 +521,7 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 		brelse(sbh[1]);
 		sbh[1] = NULL;
 		sbp[1] = NULL;
+		valid[1] = 0;
 		swp = 0;
 	}
 	if (!valid[swp]) {
-- 
1.7.7.4

