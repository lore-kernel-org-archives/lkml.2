Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab0HLMCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:02:11 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:32900 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab0HLMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:02:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: neilb@suse.de
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH] MD: raid1, fix BUG caused by flags handling
Date: Thu, 12 Aug 2010 14:01:05 +0200
Message-Id: <1281614465-2816-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 74450be1 (block: unify flags for struct bio and struct request)
added direct test of flags in the & form:
  const bool do_sync = (bio->bi_rw & REQ_SYNC);
But this doesn't fit into bool with my compiler (gcc 4.5). So change
the type to ulong to avoid the bug.

The BUG looks like:
EXT3-fs (md1): using internal journal
------------[ cut here ]------------
kernel BUG at drivers/scsi/scsi_lib.c:1113!
...
Pid: 879, comm: md3_raid1 Tainted: G        W   2.6.35-rc5-mm1_64+ #1265
RIP: 0010:[<ffffffff813312d6>]  [<ffffffff813312d6>] scsi_setup_fs_cmnd+0x96/0xd0
Process md3_raid1 (pid: 879, threadinfo ffff8801c4716000, task ffff8801cbd5a6a0)
...
Call Trace:
 [<ffffffff81339a78>] sd_prep_fn+0xa8/0x800
 [<ffffffff812252e9>] ? cfq_dispatch_request+0x49/0xb0
 [<ffffffff8121a24a>] blk_peek_request+0xca/0x1a0
 [<ffffffff81330a56>] scsi_request_fn+0x56/0x400
 [<ffffffff81219dad>] __generic_unplug_device+0x2d/0x40
 [<ffffffff8121a059>] generic_unplug_device+0x29/0x40
 [<ffffffff81217682>] blk_unplug+0x12/0x20
 [<ffffffff813f14c8>] unplug_slaves+0x78/0xc0
 [<ffffffff813f3ecb>] raid1d+0x37b/0x420
 [<ffffffff813fb6e3>] md_thread+0x53/0x120
...
Code: e8 d0 fe ff ff 5b 41 5c c9 c3 0f 1f 00 4c 89 e7 be 20 00 00 00 e8 db 9f ff ff 48 89 c7 48 85 c0 74 35 48 89 83 c8 00 00 00 eb a3 <0f> 0b 48 8b 00 48 85 c0 74 83 48 8b 40 48 48 85 c0 0f 84 76 ff
RIP  [<ffffffff813312d6>] scsi_setup_fs_cmnd+0x96/0xd0

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
---

Neil, did you expect me to send a patch for this? It's 2 weeks since
the cause is known, but it is not in the -next tree yet.

 drivers/md/raid1.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 73cc74f..ebb81b0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -787,8 +787,8 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	struct bio_list bl;
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
-	const bool do_sync = (bio->bi_rw & REQ_SYNC);
-	bool do_barriers;
+	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
+	unsigned long do_barriers;
 	mdk_rdev_t *blocked_rdev;
 
 	/*
-- 
1.7.2.1


