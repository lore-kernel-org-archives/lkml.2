Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab2CUVQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:16:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61339 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab2CUVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:16:34 -0400
Message-Id: <20120321211448.316064855@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 21 Mar 2012 14:14:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Slicky Devil <slicky.dvl@gmail.com>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [ 1/8] nilfs2: fix NULL pointer dereference in nilfs_load_super_block()
In-Reply-To: <20120321211522.GA28233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit d7178c79d9b7c5518f9943188091a75fc6ce0675 upstream.

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
  [<c0226636>] mount_fs+0x36/0x180
  [<c023d961>] vfs_kern_mount+0x51/0xa0
  [<c023ddae>] do_kern_mount+0x3e/0xe0
  [<c023f189>] do_mount+0x169/0x700
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nilfs2/the_nilfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -515,6 +515,7 @@ static int nilfs_load_super_block(struct
 		brelse(sbh[1]);
 		sbh[1] = NULL;
 		sbp[1] = NULL;
+		valid[1] = 0;
 		swp = 0;
 	}
 	if (!valid[swp]) {


